import 'package:dio/dio.dart';
import 'package:vakif_atlas_admin/core/error/error_mapper.dart';
import 'package:vakif_atlas_admin/core/error/exceptions.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';

/// Kimlik doğrulama uçlarının makine okunur kodlarını [AuthFailure]'a çevirir;
/// diğer hatalar genel tabloya (`ErrorMapper`) düşer. Kod durum kodundan
/// bağımsız okunur (ör. `401 invalid_credentials`, `400 invalid_mfa_code`).
abstract final class AuthErrorMapper {
  static Failure toFailure(Object error) {
    final exception = error is DioException
        ? ErrorMapper.exceptionFromDio(error)
        : error;
    final code = exception is ServerException ? exception.errorCode : null;
    final reason = switch (code) {
      'invalid_credentials' => AuthFailureReason.invalidCredentials,
      'invalid_mfa_code' => AuthFailureReason.invalidMfaCode,
      'mfa_expired' || 'mfa_not_enrolled' => AuthFailureReason.mfaExpired,
      'invalid_code' => AuthFailureReason.invalidVerificationCode,
      'code_expired' => AuthFailureReason.verificationCodeExpired,
      'weak_password' => AuthFailureReason.weakPassword,
      'invalid_current_password' => AuthFailureReason.invalidCurrentPassword,
      _ => null,
    };
    return reason == null ? ErrorMapper.toFailure(error) : AuthFailure(reason);
  }
}
