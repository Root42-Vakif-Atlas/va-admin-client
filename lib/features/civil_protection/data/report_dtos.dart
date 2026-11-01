import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';

part 'report_dtos.g.dart';

@JsonSerializable()
class ReportMonumentDto {
  const ReportMonumentDto({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
  });

  factory ReportMonumentDto.fromJson(Map<String, dynamic> json) =>
      _$ReportMonumentDtoFromJson(json);

  final String id;
  final String name;
  final String city;
  final String district;

  Map<String, dynamic> toJson() => _$ReportMonumentDtoToJson(this);
}

@JsonSerializable()
class ReportPhotoDto {
  const ReportPhotoDto({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    this.description,
  });

  factory ReportPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$ReportPhotoDtoFromJson(json);

  final String id;
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;
  final String? description;

  Map<String, dynamic> toJson() => _$ReportPhotoDtoToJson(this);
}

@JsonSerializable()
class LocationCheckDto {
  const LocationCheckDto({required this.verification, this.distanceMeters});

  factory LocationCheckDto.fromJson(Map<String, dynamic> json) =>
      _$LocationCheckDtoFromJson(json);

  final String verification;
  final int? distanceMeters;

  Map<String, dynamic> toJson() => _$LocationCheckDtoToJson(this);
}

@JsonSerializable()
class ReportLocationDto {
  const ReportLocationDto({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  factory ReportLocationDto.fromJson(Map<String, dynamic> json) =>
      _$ReportLocationDtoFromJson(json);

  final double latitude;
  final double longitude;
  final double accuracyMeters;

  Map<String, dynamic> toJson() => _$ReportLocationDtoToJson(this);
}

@JsonSerializable()
class StaffActorDto {
  const StaffActorDto({required this.id, this.displayName});

  factory StaffActorDto.fromJson(Map<String, dynamic> json) =>
      _$StaffActorDtoFromJson(json);

  final String id;
  final String? displayName;

  Map<String, dynamic> toJson() => _$StaffActorDtoToJson(this);
}

@JsonSerializable()
class ReportHistoryDto {
  const ReportHistoryDto({
    required this.status,
    required this.at,
    this.note,
    this.internalNote,
    this.actor,
  });

  factory ReportHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$ReportHistoryDtoFromJson(json);

  final String status;
  final DateTime at;
  final String? note;
  final String? internalNote;
  final StaffActorDto? actor;

  Map<String, dynamic> toJson() => _$ReportHistoryDtoToJson(this);
}

@JsonSerializable()
class EvidenceReasonDto {
  const EvidenceReasonDto({
    required this.code,
    required this.effect,
    this.value,
    this.detail,
  });

  factory EvidenceReasonDto.fromJson(Map<String, dynamic> json) =>
      _$EvidenceReasonDtoFromJson(json);

  final String code;
  final String effect;
  final double? value;
  final String? detail;

  Map<String, dynamic> toJson() => _$EvidenceReasonDtoToJson(this);

  EvidenceReason toDomain() => EvidenceReason(
    code: EvidenceReasonCode.fromWire(code),
    rawCode: code,
    effect: EvidenceEffect.fromWire(effect),
    value: value,
    detail: detail,
  );
}

/// YZ kanıt etiketi (`evidence`; `null`: henüz değerlendirilmedi).
@JsonSerializable()
class EvidenceDto {
  const EvidenceDto({
    required this.level,
    this.reasons = const [],
    this.version,
    this.scoredAt,
  });

  factory EvidenceDto.fromJson(Map<String, dynamic> json) =>
      _$EvidenceDtoFromJson(json);

  final String level;
  final List<EvidenceReasonDto> reasons;
  final String? version;
  final DateTime? scoredAt;

  Map<String, dynamic> toJson() => _$EvidenceDtoToJson(this);

  ReportEvidence toDomain() => ReportEvidence(
    level: EvidenceLevel.fromWire(level),
    reasons: [for (final reason in reasons) reason.toDomain()],
    version: version,
    scoredAt: scoredAt,
  );
}

/// `civil-protection/admin/reports` öğesi ve ayrıntısı.
@JsonSerializable()
class StaffReportDto {
  const StaffReportDto({
    required this.id,
    required this.referenceCode,
    required this.monument,
    required this.category,
    required this.urgency,
    required this.description,
    required this.photos,
    required this.locationCheck,
    required this.status,
    required this.allowedTransitions,
    required this.history,
    required this.anonymized,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.evidence,
  });

  factory StaffReportDto.fromJson(Map<String, dynamic> json) =>
      _$StaffReportDtoFromJson(json);

  final String id;
  final String referenceCode;
  final ReportMonumentDto monument;
  final String category;
  final String urgency;
  final String description;
  final List<ReportPhotoDto> photos;
  final LocationCheckDto locationCheck;
  final ReportLocationDto? location;
  final String status;
  final List<String> allowedTransitions;
  final List<ReportHistoryDto> history;
  final bool anonymized;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EvidenceDto? evidence;

  Map<String, dynamic> toJson() => _$StaffReportDtoToJson(this);

  DamageReport toDomain() => DamageReport(
    id: id,
    referenceCode: referenceCode,
    monument: ReportMonument(
      id: monument.id,
      name: monument.name,
      city: monument.city,
      district: monument.district,
    ),
    category: ReportCategory.fromWire(category),
    urgency: ReportUrgency.fromWire(urgency),
    description: description,
    photos: [
      for (final photo in photos)
        ReportPhoto(
          id: photo.id,
          url: photo.url,
          thumbnailUrl: photo.thumbnailUrl,
          width: photo.width,
          height: photo.height,
          description: photo.description,
        ),
    ],
    verification: switch (locationCheck.verification) {
      'onSite' => LocationVerification.onSite,
      'distant' => LocationVerification.distant,
      _ => LocationVerification.notProvided,
    },
    distanceMeters: locationCheck.distanceMeters,
    location: location == null
        ? null
        : ReportLocation(
            latitude: location!.latitude,
            longitude: location!.longitude,
            accuracyMeters: location!.accuracyMeters,
          ),
    status: ReportStatus.fromWire(status),
    allowedTransitions: [
      for (final transition in allowedTransitions)
        ReportStatus.fromWire(transition),
    ],
    history: [
      for (final entry in history)
        ReportHistoryEntry(
          status: ReportStatus.fromWire(entry.status),
          at: entry.at,
          note: entry.note,
          internalNote: entry.internalNote,
          actor: entry.actor == null
              ? null
              : StaffActor(
                  id: entry.actor!.id,
                  displayName: entry.actor!.displayName,
                ),
        ),
    ],
    anonymized: anonymized,
    createdAt: createdAt,
    updatedAt: updatedAt,
    evidence: evidence?.toDomain(),
  );
}
