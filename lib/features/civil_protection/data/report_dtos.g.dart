// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportMonumentDto _$ReportMonumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportMonumentDto', json, ($checkedConvert) {
      final val = ReportMonumentDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
        district: $checkedConvert('district', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReportMonumentDtoToJson(ReportMonumentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'district': instance.district,
    };

ReportPhotoDto _$ReportPhotoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportPhotoDto', json, ($checkedConvert) {
      final val = ReportPhotoDto(
        id: $checkedConvert('id', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String),
        thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String),
        width: $checkedConvert('width', (v) => (v as num).toInt()),
        height: $checkedConvert('height', (v) => (v as num).toInt()),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReportPhotoDtoToJson(ReportPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
      'description': instance.description,
    };

LocationCheckDto _$LocationCheckDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LocationCheckDto', json, ($checkedConvert) {
      final val = LocationCheckDto(
        verification: $checkedConvert('verification', (v) => v as String),
        distanceMeters: $checkedConvert(
          'distanceMeters',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LocationCheckDtoToJson(LocationCheckDto instance) =>
    <String, dynamic>{
      'verification': instance.verification,
      'distanceMeters': instance.distanceMeters,
    };

ReportLocationDto _$ReportLocationDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportLocationDto', json, ($checkedConvert) {
      final val = ReportLocationDto(
        latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
        accuracyMeters: $checkedConvert(
          'accuracyMeters',
          (v) => (v as num).toDouble(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReportLocationDtoToJson(ReportLocationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracyMeters': instance.accuracyMeters,
    };

StaffActorDto _$StaffActorDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffActorDto', json, ($checkedConvert) {
      final val = StaffActorDto(
        id: $checkedConvert('id', (v) => v as String),
        displayName: $checkedConvert('displayName', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$StaffActorDtoToJson(StaffActorDto instance) =>
    <String, dynamic>{'id': instance.id, 'displayName': instance.displayName};

ReportHistoryDto _$ReportHistoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportHistoryDto', json, ($checkedConvert) {
      final val = ReportHistoryDto(
        status: $checkedConvert('status', (v) => v as String),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        note: $checkedConvert('note', (v) => v as String?),
        internalNote: $checkedConvert('internalNote', (v) => v as String?),
        actor: $checkedConvert(
          'actor',
          (v) => v == null
              ? null
              : StaffActorDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReportHistoryDtoToJson(ReportHistoryDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'at': instance.at.toIso8601String(),
      'note': instance.note,
      'internalNote': instance.internalNote,
      'actor': instance.actor?.toJson(),
    };

EvidenceReasonDto _$EvidenceReasonDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EvidenceReasonDto', json, ($checkedConvert) {
      final val = EvidenceReasonDto(
        code: $checkedConvert('code', (v) => v as String),
        effect: $checkedConvert('effect', (v) => v as String),
        value: $checkedConvert('value', (v) => (v as num?)?.toDouble()),
        detail: $checkedConvert('detail', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$EvidenceReasonDtoToJson(EvidenceReasonDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'effect': instance.effect,
      'value': instance.value,
      'detail': instance.detail,
    };

EvidenceDto _$EvidenceDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EvidenceDto', json, ($checkedConvert) {
      final val = EvidenceDto(
        level: $checkedConvert('level', (v) => v as String),
        reasons: $checkedConvert(
          'reasons',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) =>
                        EvidenceReasonDto.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const [],
        ),
        version: $checkedConvert('version', (v) => v as String?),
        scoredAt: $checkedConvert(
          'scoredAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EvidenceDtoToJson(EvidenceDto instance) =>
    <String, dynamic>{
      'level': instance.level,
      'reasons': instance.reasons.map((e) => e.toJson()).toList(),
      'version': instance.version,
      'scoredAt': instance.scoredAt?.toIso8601String(),
    };

StaffReportDto _$StaffReportDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StaffReportDto', json, ($checkedConvert) {
  final val = StaffReportDto(
    id: $checkedConvert('id', (v) => v as String),
    referenceCode: $checkedConvert('referenceCode', (v) => v as String),
    monument: $checkedConvert(
      'monument',
      (v) => ReportMonumentDto.fromJson(v as Map<String, dynamic>),
    ),
    category: $checkedConvert('category', (v) => v as String),
    urgency: $checkedConvert('urgency', (v) => v as String),
    description: $checkedConvert('description', (v) => v as String),
    photos: $checkedConvert(
      'photos',
      (v) => (v as List<dynamic>)
          .map((e) => ReportPhotoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    locationCheck: $checkedConvert(
      'locationCheck',
      (v) => LocationCheckDto.fromJson(v as Map<String, dynamic>),
    ),
    status: $checkedConvert('status', (v) => v as String),
    allowedTransitions: $checkedConvert(
      'allowedTransitions',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    history: $checkedConvert(
      'history',
      (v) => (v as List<dynamic>)
          .map((e) => ReportHistoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    anonymized: $checkedConvert('anonymized', (v) => v as bool),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
    location: $checkedConvert(
      'location',
      (v) => v == null
          ? null
          : ReportLocationDto.fromJson(v as Map<String, dynamic>),
    ),
    evidence: $checkedConvert(
      'evidence',
      (v) => v == null ? null : EvidenceDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$StaffReportDtoToJson(StaffReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceCode': instance.referenceCode,
      'monument': instance.monument.toJson(),
      'category': instance.category,
      'urgency': instance.urgency,
      'description': instance.description,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'locationCheck': instance.locationCheck.toJson(),
      'location': instance.location?.toJson(),
      'status': instance.status,
      'allowedTransitions': instance.allowedTransitions,
      'history': instance.history.map((e) => e.toJson()).toList(),
      'anonymized': instance.anonymized,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'evidence': instance.evidence?.toJson(),
    };
