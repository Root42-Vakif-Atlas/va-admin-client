import 'package:vakif_atlas_admin/core/utils/list_equality.dart';

/// Rapor durumu (sunucu: `ReportStatus`). Bilinmeyen değer `inReview`
/// gösterilir (sözleşme).
enum ReportStatus {
  received('received'),
  inReview('inReview'),
  forwarded('forwarded'),
  resolved('resolved'),
  closed('closed');

  const ReportStatus(this.wireName);

  final String wireName;

  bool get isOpen => this == received || this == inReview || this == forwarded;

  static ReportStatus fromWire(String value) => values.firstWhere(
    (status) => status.wireName == value,
    orElse: () => inReview,
  );
}

enum ReportUrgency {
  critical('critical'),
  high('high'),
  medium('medium'),
  low('low');

  const ReportUrgency(this.wireName);

  final String wireName;

  static ReportUrgency fromWire(String value) =>
      values.firstWhere((u) => u.wireName == value, orElse: () => medium);
}

enum ReportCategory {
  structuralDamage('structuralDamage'),
  collapseRisk('collapseRisk'),
  vandalism('vandalism'),
  theft('theft'),
  fireOrWater('fireOrWater'),
  unauthorizedWork('unauthorizedWork'),
  other('other');

  const ReportCategory(this.wireName);

  final String wireName;

  static ReportCategory fromWire(String value) =>
      values.firstWhere((c) => c.wireName == value, orElse: () => other);
}

enum LocationVerification { notProvided, onSite, distant }

/// YZ kanıt etiketi (kök ADR 35; yalnızca VGM paneli): kanıtın gücü, raporun
/// doğruluğu değil. Durumu değiştirmez, vatandaşa gösterilmez. [pending]:
/// henüz skorlanmadı (sunucuda alan `null`, süzgeçte `pending`).
enum EvidenceLevel {
  strong('strong'),
  unverified('unverified'),
  suspicious('suspicious'),
  pending('pending');

  const EvidenceLevel(this.wireName);

  final String wireName;

  /// Bilinmeyen değer "doğrulanamadı" sayılır (olumlu/olumsuz iddia etmez).
  static EvidenceLevel fromWire(String value) =>
      values.firstWhere((l) => l.wireName == value, orElse: () => unverified);
}

/// Gerekçenin etkisi: destekler, zayıflatır veya yalnızca bilgi.
enum EvidenceEffect {
  supports('supports'),
  undermines('undermines'),
  neutral('neutral');

  const EvidenceEffect(this.wireName);

  final String wireName;

  static EvidenceEffect fromWire(String value) =>
      values.firstWhere((e) => e.wireName == value, orElse: () => neutral);
}

/// Gerekçe kodları (sunucu: `EvidenceCode`). [unknown]: yeni sunucu kodu;
/// ham kod [EvidenceReason.rawCode]'da gösterilir.
enum EvidenceReasonCode {
  /// Değer: mesafe (m).
  locationOnSite('location.onSite'),
  locationDistant('location.distant'),
  locationNotProvided('location.notProvided'),

  /// Değer: başka hesap sayısı.
  corroborated('corroborated'),

  /// Değer: en yüksek esere benzerlik.
  photoMatchesMonument('photo.matchesMonument'),
  photoLowSimilarity('photo.lowSimilarity'),
  photoNone('photo.none'),

  /// Değer: okunamayan fotoğraf sayısı.
  photoUnreadable('photo.unreadable'),
  photoCatalogCopy('photo.catalogCopy'),
  photoNsfw('photo.nsfw'),
  textDescribesDamage('text.describesDamage'),
  textWeakDamage('text.weakDamage'),
  textNotDamage('text.notDamage'),
  textAbusive('text.abusive'),

  /// Ayrıntı: eşleşen spam kuralları (`contact,promotion,scam`).
  textSpam('text.spam'),
  textContact('text.contact'),

  /// Ayrıntı: önerilen hasar türü.
  categorySuggested('category.suggested'),

  /// Ayrıntı: aciliyet.
  urgencyUnsupported('urgency.unsupported'),
  unknown('');

  const EvidenceReasonCode(this.wireName);

  final String wireName;

  static EvidenceReasonCode fromWire(String value) =>
      values.firstWhere((c) => c.wireName == value, orElse: () => unknown);
}

final class EvidenceReason {
  const EvidenceReason({
    required this.code,
    required this.rawCode,
    required this.effect,
    this.value,
    this.detail,
  });

  final EvidenceReasonCode code;
  final String rawCode;
  final EvidenceEffect effect;

  /// Koda göre anlam taşır: skor (0–1), mesafe (m) veya sayı.
  final double? value;
  final String? detail;

  @override
  bool operator ==(Object other) =>
      other is EvidenceReason &&
      other.rawCode == rawCode &&
      other.effect == effect &&
      other.value == value &&
      other.detail == detail;

  @override
  int get hashCode => Object.hash(rawCode, effect, value, detail);
}

/// Bildirimin YZ kanıt değerlendirmesi.
final class ReportEvidence {
  const ReportEvidence({
    required this.level,
    required this.reasons,
    this.version,
    this.scoredAt,
  });

  final EvidenceLevel level;
  final List<EvidenceReason> reasons;

  /// Model / politika sürümü.
  final String? version;
  final DateTime? scoredAt;

  Iterable<EvidenceReason> withEffect(EvidenceEffect effect) =>
      reasons.where((reason) => reason.effect == effect);

  @override
  bool operator ==(Object other) =>
      other is ReportEvidence &&
      other.level == level &&
      other.version == version &&
      other.scoredAt == scoredAt &&
      elementsEqual(other.reasons, reasons);

  @override
  int get hashCode => Object.hash(level, version, scoredAt, reasons.length);
}

final class ReportMonument {
  const ReportMonument({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
  });

  final String id;
  final String name;
  final String city;
  final String district;

  @override
  bool operator ==(Object other) =>
      other is ReportMonument &&
      other.id == id &&
      other.name == name &&
      other.city == city &&
      other.district == district;

  @override
  int get hashCode => Object.hash(id, name, city, district);
}

final class ReportPhoto {
  const ReportPhoto({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    this.description,
  });

  final String id;

  /// Kısa ömürlü (15 dk) ön imzalı adres: ayrıntı yeniden yüklenince yenilenir.
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;
  final String? description;

  @override
  bool operator ==(Object other) => other is ReportPhoto && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Bildirenin ham konumu (yalnızca personel; KVKK açık rıza, rapor
/// kapandıktan 90 gün sonra silinir).
final class ReportLocation {
  const ReportLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;

  @override
  bool operator ==(Object other) =>
      other is ReportLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.accuracyMeters == accuracyMeters;

  @override
  int get hashCode => Object.hash(latitude, longitude, accuracyMeters);

  /// Koordinat loglanmaz.
  @override
  String toString() => 'ReportLocation(…)';
}

final class StaffActor {
  const StaffActor({required this.id, this.displayName});

  final String id;
  final String? displayName;

  @override
  bool operator ==(Object other) =>
      other is StaffActor && other.id == id && other.displayName == displayName;

  @override
  int get hashCode => Object.hash(id, displayName);
}

final class ReportHistoryEntry {
  const ReportHistoryEntry({
    required this.status,
    required this.at,
    this.note,
    this.internalNote,
    this.actor,
  });

  final ReportStatus status;
  final DateTime at;

  /// Vatandaşa gösterilen not.
  final String? note;

  /// Yalnızca personelin gördüğü not.
  final String? internalNote;

  /// Geçişi yapan personel; sistem/vatandaş adımında `null`.
  final StaffActor? actor;

  @override
  bool operator ==(Object other) =>
      other is ReportHistoryEntry &&
      other.status == status &&
      other.at == at &&
      other.note == note &&
      other.internalNote == internalNote &&
      other.actor == actor;

  @override
  int get hashCode => Object.hash(status, at, note, internalNote, actor);
}

/// Hasar bildirimi (VGM görünümü).
final class DamageReport {
  const DamageReport({
    required this.id,
    required this.referenceCode,
    required this.monument,
    required this.category,
    required this.urgency,
    required this.description,
    required this.photos,
    required this.verification,
    required this.status,
    required this.allowedTransitions,
    required this.history,
    required this.anonymized,
    required this.createdAt,
    required this.updatedAt,
    this.distanceMeters,
    this.location,
    this.evidence,
  });

  final String id;
  final String referenceCode;
  final ReportMonument monument;
  final ReportCategory category;
  final ReportUrgency urgency;
  final String description;
  final List<ReportPhoto> photos;
  final LocationVerification verification;
  final int? distanceMeters;
  final ReportLocation? location;
  final ReportStatus status;

  /// Sunucunun izin verdiği sonraki durumlar (panelde yalnızca bunlar).
  final List<ReportStatus> allowedTransitions;
  final List<ReportHistoryEntry> history;

  /// Bildiren hesabını sildi (kişiyle bağ kaldırıldı).
  final bool anonymized;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// YZ kanıt etiketi; `null`: henüz değerlendirilmedi veya kapalı.
  final ReportEvidence? evidence;

  EvidenceLevel get evidenceLevel => evidence?.level ?? EvidenceLevel.pending;

  @override
  bool operator ==(Object other) =>
      other is DamageReport &&
      other.id == id &&
      other.status == status &&
      other.updatedAt == updatedAt &&
      other.evidence == evidence &&
      elementsEqual(other.history, history) &&
      elementsEqual(other.photos, photos);

  @override
  int get hashCode => Object.hash(id, status, updatedAt, history.length);

  @override
  String toString() => 'DamageReport($id, $status)';
}

/// [evidence]: önce aciliyet, aynı aciliyette güçlü kanıt önce, şüpheli
/// sonda (kanıt aciliyeti ezmez).
enum ReportSort { newest, oldest, urgency, evidence }

/// Kuyruk süzgeci. [statuses] boşsa tüm durumlar; [openOnly] açık durumlar.
final class ReportFilter {
  const ReportFilter({
    this.openOnly = false,
    this.statuses = const {},
    this.urgencies = const {},
    this.categories = const {},
    this.evidence = const {},
    this.query = '',
    this.sort = ReportSort.newest,
  });

  final bool openOnly;
  final Set<ReportStatus> statuses;
  final Set<ReportUrgency> urgencies;
  final Set<ReportCategory> categories;
  final Set<EvidenceLevel> evidence;

  /// Kayıt numarası (`SK-2026-…`) öneki.
  final String query;
  final ReportSort sort;

  bool get isDefault =>
      !openOnly &&
      statuses.isEmpty &&
      urgencies.isEmpty &&
      categories.isEmpty &&
      evidence.isEmpty &&
      query.isEmpty &&
      sort == ReportSort.newest;

  ReportFilter copyWith({
    bool? openOnly,
    Set<ReportStatus>? statuses,
    Set<ReportUrgency>? urgencies,
    Set<ReportCategory>? categories,
    Set<EvidenceLevel>? evidence,
    String? query,
    ReportSort? sort,
  }) => ReportFilter(
    openOnly: openOnly ?? this.openOnly,
    statuses: statuses ?? this.statuses,
    urgencies: urgencies ?? this.urgencies,
    categories: categories ?? this.categories,
    evidence: evidence ?? this.evidence,
    query: query ?? this.query,
    sort: sort ?? this.sort,
  );

  @override
  bool operator ==(Object other) =>
      other is ReportFilter &&
      other.openOnly == openOnly &&
      setEquals(other.statuses, statuses) &&
      setEquals(other.urgencies, urgencies) &&
      setEquals(other.categories, categories) &&
      setEquals(other.evidence, evidence) &&
      other.query == query &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
    openOnly,
    Object.hashAllUnordered(statuses),
    Object.hashAllUnordered(urgencies),
    Object.hashAllUnordered(categories),
    Object.hashAllUnordered(evidence),
    query,
    sort,
  );
}
