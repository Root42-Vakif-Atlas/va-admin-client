/// Personel işlemi (merkezi denetim kaydı; içerik metni ve kişisel veri
/// taşımaz, yalnızca kimlikler ve durum değerleri).
final class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.at,
    required this.actorId,
    required this.service,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.changes,
    this.actorName,
    this.correlationId,
  });

  final String id;
  final DateTime at;
  final String actorId;
  final String? actorName;
  final String service;
  final String action;
  final String targetType;
  final String targetId;
  final Map<String, String?> changes;
  final String? correlationId;
}

final class AuditFilter {
  const AuditFilter({this.service, this.targetId = '', this.from, this.to});

  final String? service;
  final String targetId;
  final DateTime? from;

  /// Hariç üst sınır.
  final DateTime? to;

  bool get isDefault =>
      service == null && targetId.isEmpty && from == null && to == null;

  @override
  bool operator ==(Object other) =>
      other is AuditFilter &&
      other.service == service &&
      other.targetId == targetId &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(service, targetId, from, to);
}

/// Denetim kaydı üreten servisler.
const List<String> auditServices = [
  'identity',
  'catalog',
  'civil-protection',
  'memories',
  'feedback',
];
