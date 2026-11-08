import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/network/session_events.dart';
import 'package:vakif_atlas_admin/core/utils/either.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/features/auth/data/dtos/auth_dtos.dart';
import 'package:vakif_atlas_admin/features/auth/data/repositories/auth_error_mapper.dart';
import 'package:vakif_atlas_admin/features/auth/data/sources/auth_local_data_source.dart';
import 'package:vakif_atlas_admin/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/sign_in.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remote,
    this._local,
    SessionEvents sessionEvents, {
    @ignoreParam DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now {
    _expiredSubscription = sessionEvents.onSessionExpired.listen(
      (_) => unawaited(_expire()),
    );
  }

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final DateTime Function() _clock;
  final StreamController<AuthSessionEvent> _events =
      StreamController<AuthSessionEvent>.broadcast();
  late final StreamSubscription<void> _expiredSubscription;

  @override
  Stream<AuthSessionEvent> get sessionEvents => _events.stream;

  Future<void> _expire() async {
    final hadSession = await _local.readRefreshToken() != null;
    await _local.clearSession();
    if (hadSession) {
      _events.add(const SessionExpired());
    }
  }

  ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(AuthErrorMapper.toFailure(error));
    }
  }

  @override
  ResultFuture<StaffUser?> restoreSession() async {
    try {
      final token = await _local.readRefreshToken();
      if (token == null) {
        return const Right(null);
      }
      final user = await _local.readCachedUser();
      if (user == null) {
        await _local.clearSession();
        return const Right(null);
      }
      return Right(user.toDomain());
    } on Exception {
      await _local.clearSession();
      return const Left(CacheFailure());
    }
  }

  @override
  ResultFuture<MfaChallenge> startSignIn({
    required String email,
    required String password,
  }) => _guard(() async {
    final issuedAt = _clock();
    final dto = await _remote.login(email: email.trim(), password: password);
    return dto.toDomain(issuedAt);
  });

  @override
  ResultFuture<SignInResult> verifyMfa(
    MfaChallenge challenge, {
    String? code,
    String? recoveryCode,
  }) => _guard(() async {
    final session = await _remote.verifyMfa(
      mfaToken: challenge.token,
      code: code,
      recoveryCode: recoveryCode,
    );
    return _open(session);
  });

  @override
  ResultFuture<TotpEnrollment> beginEnrollment(MfaChallenge challenge) =>
      _guard(() async {
        final dto = await _remote.enroll(mfaToken: challenge.token);
        return dto.toDomain();
      });

  @override
  ResultFuture<SignInResult> confirmEnrollment(
    MfaChallenge challenge,
    String code,
  ) => _guard(() async {
    final session = await _remote.confirmEnrollment(
      mfaToken: challenge.token,
      code: code,
    );
    return _open(session, announce: false);
  });

  @override
  void completeEnrollment(StaffUser user) => _events.add(SignedIn(user));

  Future<SignInResult> _open(
    StaffSessionDto session, {
    bool announce = true,
  }) async {
    await _local.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      user: session.user,
    );
    final user = session.user.toDomain();
    if (announce) {
      _events.add(SignedIn(user));
    }
    return SignInResult(user: user, recoveryCodes: session.recoveryCodes ?? []);
  }

  @override
  ResultFuture<StaffUser> refreshProfile() => _guard(() async {
    final dto = await _remote.me();
    await _local.saveUser(dto);
    final user = dto.toDomain();
    _events.add(ProfileRefreshed(user));
    return user;
  });

  @override
  ResultFuture<Unit> logout() async {
    try {
      final refreshToken = await _local.readRefreshToken();
      if (refreshToken != null) {
        try {
          await _remote.logout(refreshToken: refreshToken);
        } on Exception {
          // Sunucuya ulaşılamasa da cihazdaki oturum kapanır; yenileme
          // anahtarı 24 saat hareketsizlikte zaten geçersizleşir.
        }
      }
    } finally {
      await _local.clearSession();
      _events.add(const SignedOut());
    }
    return const Right(unit);
  }

  @override
  ResultFuture<Unit> requestPasswordReset(String email) => _guard(() async {
    await _remote.forgotPassword(email: email.trim());
    return unit;
  });

  @override
  ResultFuture<Unit> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _guard(() async {
    await _remote.resetPassword(
      email: email.trim(),
      code: code.trim(),
      newPassword: newPassword,
    );
    return unit;
  });

  @override
  ResultFuture<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _guard(() async {
    final epoch = _local.sessionEpoch;
    final tokens = await _remote.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    await _local.saveRefreshedTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      epoch: epoch,
    );
    return unit;
  });

  @override
  ResultFuture<List<String>> regenerateRecoveryCodes(String code) =>
      _guard(() async {
        final dto = await _remote.regenerateRecoveryCodes(code: code.trim());
        final cached = await _local.readCachedUser();
        if (cached != null) {
          final user = cached.toDomain().copyWith(
            recoveryCodesRemaining: dto.recoveryCodes.length,
          );
          await _local.saveUser(StaffUserDto.fromDomain(user));
          _events.add(ProfileRefreshed(user));
        }
        return dto.recoveryCodes;
      });

  @visibleForTesting
  Future<void> dispose() async {
    await _expiredSubscription.cancel();
    await _events.close();
  }
}

/// Ağ çekirdeğinin `AuthTokenRefresher` sözleşmesi (ADR 51): yenileme anahtarı
/// yoksa veya sunucu reddederse (4xx) `null`; ağ hatası ve 5xx oturumu
/// sonlandırmaz (istisna iletilir, anahtarlar korunur).
@LazySingleton(as: AuthTokenRefresher)
class AuthTokenRefresherImpl implements AuthTokenRefresher {
  AuthTokenRefresherImpl(this._remote, this._local);

  final AuthTokenRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<String?> refreshAccessToken() async {
    final epoch = _local.sessionEpoch;
    final String? refreshToken;
    try {
      refreshToken = await _local.readRefreshToken();
    } on Exception {
      return null;
    }
    if (refreshToken == null) {
      return null;
    }
    try {
      final response = await _remote.refresh(refreshToken: refreshToken);
      final saved = await _local.saveRefreshedTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        epoch: epoch,
      );
      return saved ? response.accessToken : null;
    } on Exception catch (error) {
      final failure = AuthErrorMapper.toFailure(error);
      if (failure is AuthFailure ||
          failure is UnauthorizedFailure ||
          (failure is ServerFailure &&
              failure.kind != ServerFailureKind.unavailable)) {
        return null;
      }
      rethrow;
    }
  }
}
