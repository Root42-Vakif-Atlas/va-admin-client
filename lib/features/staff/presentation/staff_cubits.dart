import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_member.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_repository.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';

@injectable
class StaffListCubit extends PagedListCubit<StaffMember, StaffFilter> {
  StaffListCubit(this._repository) : super(const StaffFilter());

  final StaffRepository _repository;

  @override
  ResultFuture<Paged<StaffMember>> fetch(StaffFilter filter, String? cursor) =>
      _repository.list(filter, cursor: cursor);

  @override
  String idOf(StaffMember item) => item.id;

  /// Davet edilen personeli listenin başına ekler.
  void prepend(StaffMember member) => emit(
    state.copyWith(items: [member, ...state.items], total: state.total + 1),
  );
}

@injectable
class StaffDetailCubit extends RecordCubit<StaffMember> {
  StaffDetailCubit(this._repository, @factoryParam this.id);

  final StaffRepository _repository;
  final String id;

  @override
  ResultFuture<Versioned<StaffMember>> fetch() => _repository.get(id);

  Future<bool> setRoles(Set<StaffRole> roles) =>
      mutate((etag) => _repository.setRoles(id, etag: etag, roles: roles));

  Future<bool> setDisabled({required bool disabled}) => mutate(
    (etag) => _repository.setDisabled(id, etag: etag, disabled: disabled),
  );

  Future<bool> resetMfa() =>
      mutate((etag) => _repository.resetMfa(id, etag: etag));

  Future<bool> revokeSessions() =>
      mutate((_) => _repository.revokeSessions(id));
}

/// Davet diyaloğunun gönderimi (tekil; tekrar aynı anahtarla).
@injectable
class StaffInviteCubit extends Cubit<({bool sending, Failure? failure})> {
  StaffInviteCubit(this._repository) : super((sending: false, failure: null));

  final StaffRepository _repository;

  Future<StaffMember?> invite(StaffInvitation invitation) async {
    if (state.sending) {
      return null;
    }
    emit((sending: true, failure: null));
    final result = await _repository.invite(invitation);
    return result.fold(
      (failure) {
        emit((sending: false, failure: failure));
        return null;
      },
      (member) {
        emit((sending: false, failure: null));
        return member.value;
      },
    );
  }
}
