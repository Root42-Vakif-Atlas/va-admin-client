import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/sign_in.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';

part 'auth_dtos.g.dart';

/// `auth/staff/me` ve oturum yanıtlarındaki personel.
@JsonSerializable()
class StaffUserDto {
  const StaffUserDto({
    required this.id,
    required this.displayName,
    required this.email,
    required this.roles,
    this.mfaEnrolledAt,
    this.lastLoginAt,
    this.recoveryCodesRemaining = 0,
  });

  factory StaffUserDto.fromJson(Map<String, dynamic> json) =>
      _$StaffUserDtoFromJson(json);

  factory StaffUserDto.fromDomain(StaffUser user) => StaffUserDto(
    id: user.id,
    displayName: user.displayName,
    email: user.email,
    roles: [for (final role in user.roles) role.wireName],
    mfaEnrolledAt: user.mfaEnrolledAt,
    lastLoginAt: user.lastLoginAt,
    recoveryCodesRemaining: user.recoveryCodesRemaining,
  );

  final String id;
  final String displayName;
  final String email;
  final List<String> roles;
  final DateTime? mfaEnrolledAt;
  final DateTime? lastLoginAt;
  final int recoveryCodesRemaining;

  Map<String, dynamic> toJson() => _$StaffUserDtoToJson(this);

  /// Bilinmeyen (yeni sürümde eklenmiş) roller yok sayılır.
  StaffUser toDomain() => StaffUser(
    id: id,
    displayName: displayName,
    email: email,
    roles: {for (final role in roles) ?StaffRole.fromWire(role)},
    mfaEnrolledAt: mfaEnrolledAt,
    lastLoginAt: lastLoginAt,
    recoveryCodesRemaining: recoveryCodesRemaining,
  );
}

/// `auth/staff/login` → ikinci adım bileti.
@JsonSerializable()
class MfaChallengeDto {
  const MfaChallengeDto({
    required this.mfa,
    required this.mfaToken,
    required this.expiresIn,
  });

  factory MfaChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$MfaChallengeDtoFromJson(json);

  /// `required` veya `enrollmentRequired`.
  final String mfa;
  final String mfaToken;
  final int expiresIn;

  Map<String, dynamic> toJson() => _$MfaChallengeDtoToJson(this);

  MfaChallenge toDomain(DateTime issuedAt) => MfaChallenge(
    token: mfaToken,
    step: mfa == 'enrollmentRequired' ? MfaStep.enroll : MfaStep.verify,
    expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
  );
}

/// Oturum açan yanıt (`mfa/verify`, `mfa/totp/confirm`).
@JsonSerializable()
class StaffSessionDto {
  const StaffSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    this.recoveryCodes,
  });

  factory StaffSessionDto.fromJson(Map<String, dynamic> json) =>
      _$StaffSessionDtoFromJson(json);

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final StaffUserDto user;
  final List<String>? recoveryCodes;

  Map<String, dynamic> toJson() => _$StaffSessionDtoToJson(this);
}

/// `auth/refresh`, `auth/staff/password/change`.
@JsonSerializable()
class TokensDto {
  const TokensDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokensDto.fromJson(Map<String, dynamic> json) =>
      _$TokensDtoFromJson(json);

  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  Map<String, dynamic> toJson() => _$TokensDtoToJson(this);
}

@JsonSerializable()
class TotpEnrollmentDto {
  const TotpEnrollmentDto({
    required this.secret,
    required this.otpauthUri,
    required this.issuer,
    required this.account,
  });

  factory TotpEnrollmentDto.fromJson(Map<String, dynamic> json) =>
      _$TotpEnrollmentDtoFromJson(json);

  final String secret;
  final String otpauthUri;
  final String issuer;
  final String account;

  Map<String, dynamic> toJson() => _$TotpEnrollmentDtoToJson(this);

  TotpEnrollment toDomain() => TotpEnrollment(
    secret: secret,
    otpauthUri: otpauthUri,
    issuer: issuer,
    account: account,
  );
}

@JsonSerializable()
class RecoveryCodesDto {
  const RecoveryCodesDto({required this.recoveryCodes});

  factory RecoveryCodesDto.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCodesDtoFromJson(json);

  final List<String> recoveryCodes;

  Map<String, dynamic> toJson() => _$RecoveryCodesDtoToJson(this);
}
