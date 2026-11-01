import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/di/injection.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/sign_in.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas_admin/core/storage/secure_storage_service.dart';

import '../../helpers/test_di.dart';
import '../../support/fake_backend.dart';

void main() {
  late FakeBackend backend;
  late TestDependencies deps;
  late AuthRepository repository;

  setUp(() async {
    backend = FakeBackend();
    deps = await TestDependencies.setUp(
      transport: (_) => FakeHttpTransport(backend),
    );
    repository = getIt<AuthRepository>();
  });

  tearDown(resetDependencies);

  test(
    'şifre + TOTP personel oturumunu açar ve anahtarları güvenli depoya yazar',
    () async {
      stubStaffSignIn(backend, roles: ['moderator']);
      final events = <AuthSessionEvent>[];
      final subscription = repository.sessionEvents.listen(events.add);

      final challenge = (await repository.startSignIn(
        email: ' vgm@vakifatlas.dev ',
        password: 'doğru-şifre-1234',
      )).fold((f) => fail('$f'), (c) => c);
      expect(challenge.step, MfaStep.verify);
      expect(
        backend.last('POST', 'auth/staff/login')!.json['email'],
        'vgm@vakifatlas.dev',
      );
      expect(
        backend
            .last('POST', 'auth/staff/login')!
            .headers
            .containsKey('authorization'),
        isFalse,
      );

      final result = await repository.verifyMfa(challenge, code: '123456');
      final user = result.fold((f) => fail('$f'), (r) => r.user);
      expect(user.roles, {StaffRole.moderator});
      expect(user.can(StaffPermission.memories), isTrue);
      expect(user.can(StaffPermission.catalog), isFalse);
      expect(await getIt<SecureStorageService>().getAccessToken(), 'access');
      // Oturum tek keychain öğesindedir (macOS şifre sorusu en çok bir kez).
      expect(deps.secureStorage.values.keys, [SecureStorageService.sessionKey]);
      await Future<void>.delayed(Duration.zero);
      expect(events, [SignedIn(user)]);
      await subscription.cancel();
    },
  );

  test(
    'hatalı şifre ve hatalı kod ayrı kimlik doğrulama hatalarıdır',
    () async {
      stubStaffSignIn(backend);
      final wrong = await repository.startSignIn(
        email: 'vgm@vakifatlas.dev',
        password: 'yanlış',
      );
      expect(
        wrong.fold((f) => f, (_) => null),
        const AuthFailure(AuthFailureReason.invalidCredentials),
      );

      final challenge = (await repository.startSignIn(
        email: 'vgm@vakifatlas.dev',
        password: 'doğru-şifre-1234',
      )).fold((f) => fail('$f'), (c) => c);
      final badCode = await repository.verifyMfa(challenge, code: '000000');
      expect(
        badCode.fold((f) => f, (_) => null),
        const AuthFailure(AuthFailureReason.invalidMfaCode),
      );
    },
  );

  test(
    'kurulumda oturum, kurtarma kodları onaylanana kadar duyurulmaz',
    () async {
      backend
        ..on(
          'POST',
          'auth/staff/login',
          (_) => const FakeResponse(200, {
            'mfa': 'enrollmentRequired',
            'mfaToken': 'mfa-token',
            'expiresIn': 300,
          }),
        )
        ..on(
          'POST',
          'auth/staff/mfa/totp/confirm',
          (_) => FakeResponse(200, {
            'accessToken': 'access',
            'refreshToken': 'refresh',
            'expiresIn': 600,
            'user': staffJson(),
            'recoveryCodes': ['AAAA-BBBB', 'CCCC-DDDD'],
          }),
        );
      final events = <AuthSessionEvent>[];
      final subscription = repository.sessionEvents.listen(events.add);

      final challenge = (await repository.startSignIn(
        email: 'a@b.tr',
        password: 'x',
      )).fold((f) => fail('$f'), (c) => c);
      expect(challenge.step, MfaStep.enroll);
      final enrolled = (await repository.confirmEnrollment(
        challenge,
        '123456',
      )).fold((f) => fail('$f'), (r) => r);
      expect(enrolled.recoveryCodes, hasLength(2));
      await Future<void>.delayed(Duration.zero);
      expect(events, isEmpty);

      repository.completeEnrollment(enrolled.user);
      await Future<void>.delayed(Duration.zero);
      expect(events, [SignedIn(enrolled.user)]);
      await subscription.cancel();
    },
  );

  test('profil yenilenince roller güncellenir', () async {
    stubStaffSignIn(backend);
    final challenge = (await repository.startSignIn(
      email: 'vgm@vakifatlas.dev',
      password: 'doğru-şifre-1234',
    )).fold((f) => fail('$f'), (c) => c);
    await repository.verifyMfa(challenge, code: '123456');
    backend.on(
      'GET',
      'auth/staff/me',
      (_) => FakeResponse(200, staffJson(roles: ['editor'])),
    );

    final user = (await repository.refreshProfile()).fold(
      (f) => fail('$f'),
      (u) => u,
    );
    expect(user.roles, {StaffRole.editor});
    expect(
      backend.last('GET', 'auth/staff/me')!.headers['authorization'],
      'Bearer access',
    );
  });
}
