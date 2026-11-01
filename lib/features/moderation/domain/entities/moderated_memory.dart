import 'package:vakif_atlas_admin/core/utils/list_equality.dart';

enum MemoryStatus {
  approved('approved'),
  pending('pending'),
  rejected('rejected');

  const MemoryStatus(this.wireName);

  final String wireName;

  static MemoryStatus fromWire(String value) =>
      values.firstWhere((s) => s.wireName == value, orElse: () => pending);
}

enum ModerationDecision {
  approve('approve'),
  reject('reject');

  const ModerationDecision(this.wireName);

  final String wireName;
}

/// Bildirim / ret nedeni (sunucu: `MemoryRules.ReportReasons`).
enum ModerationReason {
  offensive('offensive'),
  inappropriate('inappropriate'),
  spam('spam'),
  personalInfo('personalInfo'),
  unrelated('unrelated'),
  other('other');

  const ModerationReason(this.wireName);

  final String wireName;

  static ModerationReason fromWire(String value) =>
      values.firstWhere((r) => r.wireName == value, orElse: () => other);
}

enum ReportResolution { open, upheld, dismissed }

/// YZ moderasyonunun önerisi (ADR 58). `unscored`: servis yanıt vermedi.
enum AiVerdict {
  approve,
  review,
  reject,
  unscored;

  static AiVerdict fromWire(String value) =>
      values.firstWhere((v) => v.name == value, orElse: () => unscored);
}

/// Belirgin kategori: Detoxify çok dilli modelin metin kategorileri (her biri
/// bağımsız 0–1; [textValues]) ve fotoğraf / kural kategorileri ([nsfw]:
/// müstehcen fotoğraf, [unrelated]: eserle ilgisiz, [spam]: spam kuralları).
enum AiCategory {
  toxicity('toxicity'),
  severeToxicity('severe_toxicity'),
  obscene('obscene'),
  identityAttack('identity_attack'),
  insult('insult'),
  threat('threat'),
  sexualExplicit('sexual_explicit'),
  nsfw('nsfw'),
  unrelated('unrelated'),
  spam('spam');

  const AiCategory(this.wireName);

  final String wireName;

  /// [AiAssessment.scores] anahtarları (metin modeli).
  static const List<AiCategory> textValues = [
    toxicity,
    severeToxicity,
    obscene,
    identityAttack,
    insult,
    threat,
    sexualExplicit,
  ];

  static AiCategory? fromWire(String? value) =>
      values.where((c) => c.wireName == value).firstOrNull;
}

/// Anının incelemeye düşme nedeni: ara metin skoru, NSFW şüphesi, iletişim
/// bilgisi (olası spam), esere benzemeyen fotoğraf, eserle bağlamı zayıf
/// metin, desteklenmeyen dil, fotoğraf kuralı ya da skorlanamama.
enum AiReviewCause {
  score,
  nsfw,
  spam,
  unrelated,
  context,
  language,
  photos,
  unscored;

  static AiReviewCause? fromWire(String? value) =>
      values.where((c) => c.name == value).firstOrNull;
}

/// Son kararı kim verdi.
enum DecisionActor { ai, staff }

/// Fotoğraf başına görsel skorlar. [similarity]: eserin katalog
/// görsellerine benzerlik; eserin referansı yoksa `null`.
final class AiImageScore {
  const AiImageScore({
    required this.photoId,
    required this.readable,
    required this.references,
    this.nsfw,
    this.similarity,
  });

  final String photoId;
  final bool readable;
  final double? nsfw;
  final double? similarity;

  /// Karşılaştırılan referans görsel sayısı.
  final int references;
}

/// YZ değerlendirmesi; skor alanları `unscored`'da boştur.
final class AiAssessment {
  const AiAssessment({
    required this.verdict,
    required this.scores,
    required this.lexiconMatched,
    this.score,
    this.topCategory,
    this.reviewCause,
    this.modelVersion,
    this.scoredAt,
    this.nsfw,
    this.similarity,
    this.images = const [],
    this.visionVersion,
    this.spam,
    this.spamSignals = const [],
    this.relevance,
    this.contextVersion,
  });

  final AiVerdict verdict;

  /// Kategorilerin en yükseği; eşiklerle karşılaştırılan değer.
  final double? score;
  final Map<AiCategory, double> scores;
  final AiCategory? topCategory;
  final AiReviewCause? reviewCause;

  /// Türkçe sözlük katmanı skoru yükseltti.
  final bool lexiconMatched;
  final String? modelVersion;
  final DateTime? scoredAt;

  /// Fotoğrafların en yüksek NSFW olasılığı.
  final double? nsfw;

  /// Kurala giren fotoğrafların en düşük esere benzerliği.
  final double? similarity;
  final List<AiImageScore> images;
  final String? visionVersion;

  /// Spam kural skoru (0 / 0,60 / 0,97) ve eşleşen kurallar (`contact` ·
  /// `promotion` · `scam`).
  final double? spam;
  final List<String> spamSignals;

  /// Metnin eserle bağlamı (en ilgili metin); bağlam modeli yoksa `null`.
  final double? relevance;
  final String? contextVersion;
}

final class MemoryPhoto {
  const MemoryPhoto({
    required this.url,
    required this.thumbnailUrl,
    this.description,
  });

  final String url;
  final String thumbnailUrl;
  final String? description;
}

/// Kullanıcı bildirimi (bildirenin kimliği gösterilmez).
final class MemoryReportEntry {
  const MemoryReportEntry({
    required this.reason,
    required this.resolution,
    required this.createdAt,
    this.note,
  });

  final ModerationReason reason;
  final String? note;
  final ReportResolution resolution;
  final DateTime createdAt;
}

final class ModerationInfo {
  const ModerationInfo({
    this.reason,
    this.note,
    this.byName,
    this.at,
    this.decidedBy,
  });

  final ModerationReason? reason;
  final String? note;
  final String? byName;
  final DateTime? at;
  final DecisionActor? decidedBy;
}

/// Anı (moderasyon görünümü).
final class ModeratedMemory {
  const ModeratedMemory({
    required this.id,
    required this.monumentId,
    required this.monumentName,
    required this.monumentCity,
    required this.authorName,
    required this.text,
    required this.photos,
    required this.createdAt,
    required this.memoryDate,
    required this.status,
    required this.publiclyVisible,
    required this.openReports,
    required this.reportReasons,
    required this.moderation,
    required this.allowedDecisions,
    this.ai,
    this.reports,
    this.visitedOn,
  });

  final String id;
  final String monumentId;
  final String monumentName;
  final String monumentCity;

  /// Herkese açık ad ("Ayşe Y.").
  final String authorName;
  final String text;
  final List<MemoryPhoto> photos;
  final DateTime createdAt;
  final String memoryDate;
  final String? visitedOn;
  final MemoryStatus status;
  final bool publiclyVisible;
  final int openReports;
  final Map<ModerationReason, int> reportReasons;
  final ModerationInfo moderation;
  final List<ModerationDecision> allowedDecisions;

  /// YZ moderasyonu kapalıyken paylaşılan anıda boş.
  final AiAssessment? ai;

  /// Son kaldırmayı YZ mi yaptı (geri yükleme bu kararı geri alır).
  bool get removedByAi =>
      status == MemoryStatus.rejected &&
      moderation.decidedBy == DecisionActor.ai;

  /// Yalnızca ayrıntıda dolu.
  final List<MemoryReportEntry>? reports;

  @override
  bool operator ==(Object other) =>
      other is ModeratedMemory &&
      other.id == id &&
      other.status == status &&
      other.openReports == openReports &&
      other.moderation.at == moderation.at &&
      other.ai?.scoredAt == ai?.scoredAt &&
      elementsEqual(other.allowedDecisions, allowedDecisions);

  @override
  int get hashCode =>
      Object.hash(id, status, openReports, moderation.at, ai?.scoredAt);

  /// İçerik loglanmaz.
  @override
  String toString() => 'ModeratedMemory($id, $status)';
}

/// Moderasyon kuyrukları. `autoRejected`: YZ'nin kaldırdıkları (geri
/// yüklenebilir; yanlış pozitifleri yakalamak için).
enum ModerationQueue {
  pending,
  reported,
  autoRejected,
  rejected,
  all;

  static ModerationQueue fromName(String? name) =>
      values.firstWhere((q) => q.name == name, orElse: () => pending);
}

/// Bekleyen kuyruğun sırası: en eski önce (adil bekleme) veya en yüksek YZ
/// skoru önce (en riskli içerik önce).
enum ModerationSort {
  oldest,
  aiScore;

  static ModerationSort fromName(String? name) =>
      values.firstWhere((s) => s.name == name, orElse: () => oldest);
}

final class ModerationFilter {
  const ModerationFilter({
    this.queue = ModerationQueue.pending,
    this.query = '',
    this.sort = ModerationSort.oldest,
  });

  final ModerationQueue queue;
  final String query;
  final ModerationSort sort;

  ModerationFilter copyWith({
    ModerationQueue? queue,
    String? query,
    ModerationSort? sort,
  }) => ModerationFilter(
    queue: queue ?? this.queue,
    query: query ?? this.query,
    sort: sort ?? this.sort,
  );

  @override
  bool operator ==(Object other) =>
      other is ModerationFilter &&
      other.queue == queue &&
      other.query == query &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(queue, query, sort);
}
