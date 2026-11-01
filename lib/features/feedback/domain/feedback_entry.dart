import 'package:vakif_atlas_admin/core/utils/list_equality.dart';

enum FeedbackCategory {
  suggestion('suggestion'),
  bug('bug'),
  accessibility('accessibility'),
  content('content'),
  other('other');

  const FeedbackCategory(this.wireName);

  final String wireName;

  static FeedbackCategory fromWire(String value) =>
      values.firstWhere((c) => c.wireName == value, orElse: () => other);
}

enum FeedbackStatus {
  newEntry('new'),
  inProgress('inProgress'),
  done('done'),
  dismissed('dismissed');

  const FeedbackStatus(this.wireName);

  final String wireName;

  static FeedbackStatus fromWire(String value) =>
      values.firstWhere((s) => s.wireName == value, orElse: () => newEntry);
}

/// Vatandaş uygulamasından gelen geri bildirim (metin kişisel veri
/// içerebilir; loglanmaz).
final class FeedbackEntry {
  const FeedbackEntry({
    required this.id,
    required this.category,
    required this.message,
    required this.language,
    required this.fromAccount,
    required this.createdAt,
    required this.status,
    this.rating,
    this.appVersion,
    this.platform,
    this.staffNote,
    this.handledByName,
    this.handledAt,
  });

  final String id;
  final FeedbackCategory category;
  final int? rating;
  final String message;
  final String? appVersion;
  final String? platform;
  final String language;
  final bool fromAccount;
  final DateTime createdAt;
  final FeedbackStatus status;
  final String? staffNote;
  final String? handledByName;
  final DateTime? handledAt;

  @override
  bool operator ==(Object other) =>
      other is FeedbackEntry &&
      other.id == id &&
      other.status == status &&
      other.staffNote == staffNote &&
      other.handledAt == handledAt;

  @override
  int get hashCode => Object.hash(id, status, staffNote, handledAt);

  @override
  String toString() => 'FeedbackEntry($id, $status)';
}

final class FeedbackFilter {
  const FeedbackFilter({
    this.statuses = const {},
    this.categories = const {},
    this.ratings = const {},
    this.query = '',
  });

  final Set<FeedbackStatus> statuses;
  final Set<FeedbackCategory> categories;

  /// 1–5; 0 → puansız.
  final Set<int> ratings;
  final String query;

  bool get isDefault =>
      statuses.isEmpty &&
      categories.isEmpty &&
      ratings.isEmpty &&
      query.isEmpty;

  FeedbackFilter copyWith({
    Set<FeedbackStatus>? statuses,
    Set<FeedbackCategory>? categories,
    Set<int>? ratings,
    String? query,
  }) => FeedbackFilter(
    statuses: statuses ?? this.statuses,
    categories: categories ?? this.categories,
    ratings: ratings ?? this.ratings,
    query: query ?? this.query,
  );

  @override
  bool operator ==(Object other) =>
      other is FeedbackFilter &&
      setEquals(other.statuses, statuses) &&
      setEquals(other.categories, categories) &&
      setEquals(other.ratings, ratings) &&
      other.query == query;

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(statuses),
    Object.hashAllUnordered(categories),
    Object.hashAllUnordered(ratings),
    query,
  );
}
