import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas_admin/core/network/api_guard.dart';
import 'package:vakif_atlas_admin/core/network/network_constants.dart';
import 'package:vakif_atlas_admin/core/network/preconditions.dart';
import 'package:vakif_atlas_admin/core/utils/paged.dart';
import 'package:vakif_atlas_admin/core/utils/typedefs.dart';
import 'package:vakif_atlas_admin/core/utils/versioned.dart';
import 'package:vakif_atlas_admin/features/auth/domain/entities/staff_role.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_member.dart';
import 'package:vakif_atlas_admin/features/staff/domain/staff_repository.dart';

@LazySingleton(as: StaffRepository)
class StaffRepositoryImpl implements StaffRepository {
  StaffRepositoryImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  static const String _base = 'auth/admin/staff';

  static StaffMember parse(Map<String, dynamic> json) => StaffMember(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    email: json['email'] as String,
    roles: {
      for (final role in json['roles'] as List<dynamic>)
        ?StaffRole.fromWire(role as String),
    },
    disabled: json['disabled'] as bool,
    mfaEnrolledAt: json['mfaEnrolledAt'] == null
        ? null
        : DateTime.parse(json['mfaEnrolledAt'] as String),
    lastLoginAt: json['lastLoginAt'] == null
        ? null
        : DateTime.parse(json['lastLoginAt'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Versioned<StaffMember> _versioned(Response<Map<String, dynamic>> response) =>
      Versioned(parse(response.data!), Preconditions.etagOf(response));

  String _path(String id, [String suffix = '']) =>
      '$_base/${Uri.encodeComponent(id)}$suffix';

  @override
  ResultFuture<Paged<StaffMember>> list(StaffFilter filter, {String? cursor}) =>
      guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          _base,
          queryParameters: {
            if (filter.query.isNotEmpty) 'q': filter.query,
            'role': ?filter.role?.wireName,
            if (filter.status != StaffStatusFilter.all)
              'status': filter.status.name,
            'cursor': ?cursor,
          },
        );
        final json = response.data!;
        return Paged(
          items: [
            for (final item in json['items'] as List<dynamic>)
              parse(item as Map<String, dynamic>),
          ],
          total: json['total'] as int,
          nextCursor: json['nextCursor'] as String?,
        );
      });

  @override
  ResultFuture<Versioned<StaffMember>> get(String id) => guardApi(
    () async => _versioned(await _dio.get<Map<String, dynamic>>(_path(id))),
  );

  @override
  ResultFuture<Versioned<StaffMember>> invite(StaffInvitation invitation) =>
      guardApi(
        () async => _versioned(
          await _dio.post<Map<String, dynamic>>(
            _base,
            data: {
              'email': invitation.email.trim(),
              'displayName': invitation.displayName.trim(),
              'roles': [for (final role in invitation.roles) role.wireName],
            },
            options: Preconditions.idempotent(invitation.idempotencyKey),
          ),
        ),
      );

  @override
  ResultFuture<Versioned<StaffMember>> setRoles(
    String id, {
    required String etag,
    required Set<StaffRole> roles,
  }) => guardApi(
    () async => _versioned(
      await _dio.put<Map<String, dynamic>>(
        _path(id, '/roles'),
        data: {
          'roles': [for (final role in roles) role.wireName],
        },
        options: Preconditions.ifMatch(etag),
      ),
    ),
  );

  @override
  ResultFuture<Versioned<StaffMember>> setDisabled(
    String id, {
    required String etag,
    required bool disabled,
  }) => guardApi(
    () async => _versioned(
      await _dio.post<Map<String, dynamic>>(
        _path(id, disabled ? '/disable' : '/enable'),
        options: Preconditions.ifMatch(etag),
      ),
    ),
  );

  @override
  ResultFuture<Versioned<StaffMember>> resetMfa(
    String id, {
    required String etag,
  }) => guardApi(
    () async => _versioned(
      await _dio.post<Map<String, dynamic>>(
        _path(id, '/mfa-reset'),
        options: Preconditions.ifMatch(etag),
      ),
    ),
  );

  @override
  ResultFuture<Versioned<StaffMember>> revokeSessions(String id) => guardApi(
    () async => _versioned(
      await _dio.post<Map<String, dynamic>>(_path(id, '/sessions/revoke')),
    ),
  );
}
