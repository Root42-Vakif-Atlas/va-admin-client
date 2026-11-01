import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_repository.dart';
import 'package:vakif_atlas_admin/shared/paging/paged_list_cubit.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';

@injectable
class FeedbackListCubit extends PagedListCubit<FeedbackEntry, FeedbackFilter> {
  FeedbackListCubit(this._repository, @factoryParam FeedbackFilter? initial)
    : super(initial ?? const FeedbackFilter());

  final FeedbackRepository _repository;

  @override
  ResultFuture<Paged<FeedbackEntry>> fetch(
    FeedbackFilter filter,
    String? cursor,
  ) => _repository.list(filter, cursor: cursor);

  @override
  String idOf(FeedbackEntry item) => item.id;
}

@injectable
class FeedbackDetailCubit extends RecordCubit<FeedbackEntry> {
  FeedbackDetailCubit(this._repository, @factoryParam this.id);

  final FeedbackRepository _repository;
  final String id;

  @override
  ResultFuture<Versioned<FeedbackEntry>> fetch() => _repository.get(id);

  Future<bool> triage(FeedbackStatus status, {String? note}) => mutate(
    (etag) => _repository.triage(id, etag: etag, status: status, note: note),
  );
}
