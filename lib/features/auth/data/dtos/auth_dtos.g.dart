// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserDto _$StaffUserDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUserDto', json, ($checkedConvert) {
      final val = StaffUserDto(
        id: $checkedConvert('id', (v) => v as String),
        displayName: $checkedConvert('displayName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        roles: $checkedConvert(
          'roles',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        mfaEnrolledAt: $checkedConvert(
          'mfaEnrolledAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        lastLoginAt: $checkedConvert(
          'lastLoginAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        recoveryCodesRemaining: $checkedConvert(
          'recoveryCodesRemaining',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserDtoToJson(StaffUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'email': instance.email,
      'roles': instance.roles,
      'mfaEnrolledAt': instance.mfaEnrolledAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'recoveryCodesRemaining': instance.recoveryCodesRemaining,
    };

MfaChallengeDto _$MfaChallengeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MfaChallengeDto', json, ($checkedConvert) {
      final val = MfaChallengeDto(
        mfa: $checkedConvert('mfa', (v) => v as String),
        mfaToken: $checkedConvert('mfaToken', (v) => v as String),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MfaChallengeDtoToJson(MfaChallengeDto instance) =>
    <String, dynamic>{
      'mfa': instance.mfa,
      'mfaToken': instance.mfaToken,
      'expiresIn': instance.expiresIn,
    };

StaffSessionDto _$StaffSessionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffSessionDto', json, ($checkedConvert) {
      final val = StaffSessionDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
        user: $checkedConvert(
          'user',
          (v) => StaffUserDto.fromJson(v as Map<String, dynamic>),
        ),
        recoveryCodes: $checkedConvert(
          'recoveryCodes',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffSessionDtoToJson(StaffSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'user': instance.user.toJson(),
      'recoveryCodes': instance.recoveryCodes,
    };

TokensDto _$TokensDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokensDto', json, ($checkedConvert) {
      final val = TokensDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$TokensDtoToJson(TokensDto instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
};

TotpEnrollmentDto _$TotpEnrollmentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TotpEnrollmentDto', json, ($checkedConvert) {
      final val = TotpEnrollmentDto(
        secret: $checkedConvert('secret', (v) => v as String),
        otpauthUri: $checkedConvert('otpauthUri', (v) => v as String),
        issuer: $checkedConvert('issuer', (v) => v as String),
        account: $checkedConvert('account', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TotpEnrollmentDtoToJson(TotpEnrollmentDto instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'otpauthUri': instance.otpauthUri,
      'issuer': instance.issuer,
      'account': instance.account,
    };

RecoveryCodesDto _$RecoveryCodesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RecoveryCodesDto', json, ($checkedConvert) {
      final val = RecoveryCodesDto(
        recoveryCodes: $checkedConvert(
          'recoveryCodes',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RecoveryCodesDtoToJson(RecoveryCodesDto instance) =>
    <String, dynamic>{'recoveryCodes': instance.recoveryCodes};
