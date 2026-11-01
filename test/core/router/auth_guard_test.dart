import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/core/router/guards/auth_guard.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_user.dart';
import 'package:vakif_atlas_admin/features/auth/presentation/bloc/auth_bloc.dart';

AuthState signedIn(Set<StaffRole> roles) => AuthState.authenticated(
  StaffUser(
    id: 'usr_1',
    displayName: 'Test',
    email: 't@vgm.gov.tr',
    roles: roles,
  ),
);

void main() {
  String? redirect(AuthState state, String location) =>
      AuthGuard.redirect(state, Uri.parse(location));

  test('oturum yoksa her bölüm girişe yönlenir ve hedef korunur', () {
    expect(
      redirect(const AuthState.guest(), '/moderation?queue=reported'),
      '/sign-in?from=%2Fmoderation%3Fqueue%3Dreported',
    );
    expect(redirect(const AuthState.guest(), '/password-reset'), isNull);
    expect(
      redirect(const AuthState.unknown(), '/catalog'),
      '/splash?from=%2Fcatalog',
    );
  });

  test('girişten sonra hedefe, yetki yoksa panoya gidilir', () {
    final moderator = signedIn({StaffRole.moderator});
    expect(redirect(moderator, '/sign-in?from=%2Fmoderation'), '/moderation');
    expect(redirect(moderator, '/sign-in?from=%2Fcatalog'), '/');
    expect(redirect(moderator, '/catalog/selimiye-camii'), '/');
    expect(redirect(moderator, '/staff'), '/');
    expect(redirect(moderator, '/profile'), isNull);
  });

  test('yönetici tüm bölümlere erişir', () {
    final admin = signedIn({StaffRole.admin});
    for (final path in [
      '/catalog',
      '/civil-protection/rpt_1',
      '/moderation',
      '/feedback',
      '/staff',
      '/audit',
    ]) {
      expect(redirect(admin, path), isNull, reason: path);
    }
  });

  test('dış adrese dönüş hedefi kabul edilmez', () {
    expect(AuthGuard.safeTarget('https://evil.example'), isNull);
    expect(AuthGuard.safeTarget('//evil.example'), isNull);
    expect(AuthGuard.safeTarget('/sign-in'), isNull);
    expect(AuthGuard.safeTarget('/feedback'), '/feedback');
  });
}
