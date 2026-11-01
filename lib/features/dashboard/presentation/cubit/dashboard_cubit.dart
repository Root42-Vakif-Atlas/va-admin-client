import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/router/routes.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vakif_atlas_admin/features/dashboard/domain/repositories/dashboard_repository.dart';

part 'dashboard_cubit.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(DashboardSummary()) DashboardSummary summary,
    @Default(false) bool loading,
    @Default(<StaffPermission>{}) Set<StaffPermission> permissions,

    /// Yanıt vermeyen bölümler (diğerleri yine gösterilir).
    @Default(<StaffPermission, Failure>{})
    Map<StaffPermission, Failure> failures,
    DateTime? updatedAt,
  }) = _DashboardState;

  const DashboardState._();

  /// Kenar çubuğu rozetleri: bölüm kökü → bekleyen iş.
  Map<String, int> get badges => {
    if (summary.reports case final reports?) AppRoutes.reports: reports.open,
    if (summary.moderation case final moderation?)
      AppRoutes.moderation: moderation.actionable,
    if (summary.feedback case final feedback?)
      AppRoutes.feedback: feedback.newCount,
  };
}

/// Kabuk seviyesinde tek örnek: pano kartları ve kenar çubuğu rozetleri aynı
/// özeti okur. Yalnızca rolün açtığı bölümler istenir; özet 2 dakikada bir
/// ve personel bir kayıt üzerinde işlem yaptıktan sonra yenilenir.
@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  static const Duration refreshInterval = Duration(minutes: 2);

  final DashboardRepository _repository;
  Timer? _timer;

  Future<void> start(Set<StaffPermission> permissions) async {
    if (permissions != state.permissions) {
      emit(DashboardState(permissions: permissions));
    }
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) => unawaited(refresh()));
    await refresh();
  }

  Future<void> refresh() async {
    if (state.loading || isClosed) {
      return;
    }
    emit(state.copyWith(loading: true));
    final allowed = state.permissions;
    final failures = <StaffPermission, Failure>{};

    Future<T?> load<T>(
      StaffPermission permission,
      ResultFuture<T> Function() call,
    ) async {
      if (!allowed.contains(permission)) {
        return null;
      }
      final result = await call();
      return result.fold((failure) {
        failures[permission] = failure;
        return null;
      }, (value) => value);
    }

    final (reports, moderation, feedback, catalog) = await (
      load(StaffPermission.civilProtection, _repository.reports),
      load(StaffPermission.memories, _repository.moderation),
      load(StaffPermission.feedback, _repository.feedback),
      load(StaffPermission.catalog, _repository.catalog),
    ).wait;
    if (isClosed) {
      return;
    }
    emit(
      state.copyWith(
        loading: false,
        failures: failures,
        updatedAt: DateTime.now(),
        summary: DashboardSummary(
          reports: reports ?? state.summary.reports,
          moderation: moderation ?? state.summary.moderation,
          feedback: feedback ?? state.summary.feedback,
          catalog: catalog ?? state.summary.catalog,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
