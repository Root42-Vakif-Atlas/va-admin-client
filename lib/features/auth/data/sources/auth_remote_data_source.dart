import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/features/auth/data/dtos/auth_dtos.dart';

/// `auth/staff/*` ve paylaşılan şifre sıfırlama uçları. Giriş adımları
/// Bearer taşımaz (`skipAuth`); hatalar `DioException` olarak fırlatılır.
abstract interface class AuthRemoteDataSource {
  Future<MfaChallengeDto> login({
    required String email,
    required String password,
  });

  Future<StaffSessionDto> verifyMfa({
    required String mfaToken,
    String? code,
    String? recoveryCode,
  });

  Future<TotpEnrollmentDto> enroll({required String mfaToken});

  Future<StaffSessionDto> confirmEnrollment({
    required String mfaToken,
    required String code,
  });

  Future<StaffUserDto> me();

  Future<void> logout({required String refreshToken});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<TokensDto> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<RecoveryCodesDto> regenerateRecoveryCodes({required String code});
}

/// Yenileme isteği auth interceptor'ı olmayan istemciyle yapılır (ADR 9).
abstract interface class AuthTokenRemoteDataSource {
  Future<TokensDto> refresh({required String refreshToken});
}

abstract final class AuthEndpoints {
  static const String login = 'auth/staff/login';
  static const String verify = 'auth/staff/mfa/verify';
  static const String enroll = 'auth/staff/mfa/totp/enroll';
  static const String confirm = 'auth/staff/mfa/totp/confirm';
  static const String me = 'auth/staff/me';
  static const String recoveryCodes = 'auth/staff/recovery-codes';
  static const String changePassword = 'auth/staff/password/change';
  static const String refresh = 'auth/refresh';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/password/forgot';
  static const String resetPassword = 'auth/password/reset';
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static final Options _anonymous = Options(
    extra: const {RequestExtras.skipAuth: true},
  );

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    bool anonymous = true,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: anonymous ? _anonymous : null,
    );
    return response.data!;
  }

  @override
  Future<MfaChallengeDto> login({
    required String email,
    required String password,
  }) async => MfaChallengeDto.fromJson(
    await _post(AuthEndpoints.login, {'email': email, 'password': password}),
  );

  @override
  Future<StaffSessionDto> verifyMfa({
    required String mfaToken,
    String? code,
    String? recoveryCode,
  }) async => StaffSessionDto.fromJson(
    await _post(AuthEndpoints.verify, {
      'mfaToken': mfaToken,
      'code': ?code,
      'recoveryCode': ?recoveryCode,
    }),
  );

  @override
  Future<TotpEnrollmentDto> enroll({required String mfaToken}) async =>
      TotpEnrollmentDto.fromJson(
        await _post(AuthEndpoints.enroll, {'mfaToken': mfaToken}),
      );

  @override
  Future<StaffSessionDto> confirmEnrollment({
    required String mfaToken,
    required String code,
  }) async => StaffSessionDto.fromJson(
    await _post(AuthEndpoints.confirm, {'mfaToken': mfaToken, 'code': code}),
  );

  @override
  Future<StaffUserDto> me() async {
    final response = await _dio.get<Map<String, dynamic>>(AuthEndpoints.me);
    return StaffUserDto.fromJson(response.data!);
  }

  @override
  Future<void> logout({required String refreshToken}) => _dio.post<void>(
    AuthEndpoints.logout,
    data: {'refreshToken': refreshToken},
    options: _anonymous,
  );

  @override
  Future<void> forgotPassword({required String email}) => _dio.post<void>(
    AuthEndpoints.forgotPassword,
    data: {'email': email},
    options: _anonymous,
  );

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _dio.post<void>(
    AuthEndpoints.resetPassword,
    data: {'email': email, 'code': code, 'newPassword': newPassword},
    options: _anonymous,
  );

  @override
  Future<TokensDto> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => TokensDto.fromJson(
    await _post(AuthEndpoints.changePassword, {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    }, anonymous: false),
  );

  @override
  Future<RecoveryCodesDto> regenerateRecoveryCodes({
    required String code,
  }) async => RecoveryCodesDto.fromJson(
    await _post(AuthEndpoints.recoveryCodes, {'code': code}, anonymous: false),
  );
}

@LazySingleton(as: AuthTokenRemoteDataSource)
class AuthTokenRemoteDataSourceImpl implements AuthTokenRemoteDataSource {
  AuthTokenRemoteDataSourceImpl(@Named(DioNames.bare) this._dio);

  final Dio _dio;

  @override
  Future<TokensDto> refresh({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    return TokensDto.fromJson(response.data!);
  }
}
