import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderation_metrics.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/repositories/moderation_repository.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';

@injectable
class ModerationQueueCubit
    extends PagedListCubit<ModeratedMemory, ModerationFilter> {
  ModerationQueueCubit(
    this._repository,
    @factoryParam ModerationFilter? initial,
  ) : super(initial ?? const ModerationFilter());

  final ModerationRepository _repository;

  @override
  ResultFuture<Paged<ModeratedMemory>> fetch(
    ModerationFilter filter,
    String? cursor,
  ) => _repository.list(filter, cursor: cursor);

  @override
  String idOf(ModeratedMemory item) => item.id;
}

@injectable
class MemoryDetailCubit extends RecordCubit<ModeratedMemory> {
  MemoryDetailCubit(this._repository, @factoryParam this.id);

  final ModerationRepository _repository;
  final String id;

  @override
  ResultFuture<Versioned<ModeratedMemory>> fetch() => _repository.get(id);

  Future<bool> decide(
    ModerationDecision decision, {
    ModerationReason? reason,
    String? note,
  }) => mutate(
    (etag) => _repository.decide(
      id,
      etag: etag,
      decision: decision,
      reason: reason,
      note: note,
    ),
  );
}

final class ModerationMetricsState {
  const ModerationMetricsState({
    this.days = 30,
    this.loading = false,
    this.metrics,
    this.failure,
  });

  final int days;
  final bool loading;
  final ModerationMetrics? metrics;
  final Failure? failure;
}

/// YZ moderasyon metrikleri; dönem 7 / 30 / 90 gün. Eski dönemin geç gelen
/// yanıtı yok sayılır.
@injectable
class ModerationMetricsCubit extends Cubit<ModerationMetricsState> {
  ModerationMetricsCubit(this._repository)
    : super(const ModerationMetricsState());

  final ModerationRepository _repository;

  static const List<int> periods = [7, 30, 90];

  Future<void> load([int? days]) async {
    final period = days ?? state.days;
    emit(
      ModerationMetricsState(
        days: period,
        loading: true,
        metrics: period == state.days ? state.metrics : null,
      ),
    );
    final result = await _repository.metrics(period);
    if (isClosed || state.days != period) {
      return;
    }
    result.fold(
      (failure) => emit(
        ModerationMetricsState(
          days: period,
          metrics: state.metrics,
          failure: failure,
        ),
      ),
      (metrics) => emit(ModerationMetricsState(days: period, metrics: metrics)),
    );
  }
}
