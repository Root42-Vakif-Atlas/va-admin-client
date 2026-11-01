// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 DashboardSummary get summary; bool get loading; Set<StaffPermission> get permissions;/// Yanıt vermeyen bölümler (diğerleri yine gösterilir).
 Map<StaffPermission, Failure> get failures; DateTime? get updatedAt;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.permissions, _this.permissions)&&const DeepCollectionEquality().equals(other.failures, _this.failures)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as DashboardState;
  return Object.hash(runtimeType,_this.summary,_this.loading,const DeepCollectionEquality().hash(_this.permissions),const DeepCollectionEquality().hash(_this.failures),_this.updatedAt);
}

@override
String toString() {
  final _this = this as DashboardState;
  return 'DashboardState(summary: ${_this.summary}, loading: ${_this.loading}, permissions: ${_this.permissions}, failures: ${_this.failures}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 DashboardSummary summary, bool loading, Set<StaffPermission> permissions, Map<StaffPermission, Failure> failures, DateTime? updatedAt
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? loading = null,Object? permissions = null,Object? failures = null,Object? updatedAt = freezed,}) {
  return _then(DashboardState(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<StaffPermission>,failures: null == failures ? _self.failures : failures // ignore: cast_nullable_to_non_nullable
as Map<StaffPermission, Failure>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardSummary summary,  bool loading,  Set<StaffPermission> permissions,  Map<StaffPermission, Failure> failures,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.summary,_that.loading,_that.permissions,_that.failures,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardSummary summary,  bool loading,  Set<StaffPermission> permissions,  Map<StaffPermission, Failure> failures,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.summary,_that.loading,_that.permissions,_that.failures,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardSummary summary,  bool loading,  Set<StaffPermission> permissions,  Map<StaffPermission, Failure> failures,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.summary,_that.loading,_that.permissions,_that.failures,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState extends DashboardState {
  const _DashboardState({this.summary = const DashboardSummary(), this.loading = false,  Set<StaffPermission> permissions = const <StaffPermission>{},  Map<StaffPermission, Failure> failures = const <StaffPermission, Failure>{}, this.updatedAt}): _permissions = permissions,_failures = failures,super._();
  

@override@JsonKey() final  DashboardSummary summary;
@override@JsonKey() final  bool loading;
 final  Set<StaffPermission> _permissions;
@override@JsonKey() Set<StaffPermission> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}

/// Yanıt vermeyen bölümler (diğerleri yine gösterilir).
 final  Map<StaffPermission, Failure> _failures;
/// Yanıt vermeyen bölümler (diğerleri yine gösterilir).
@override@JsonKey() Map<StaffPermission, Failure> get failures {
  if (_failures is EqualUnmodifiableMapView) return _failures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_failures);
}

@override final  DateTime? updatedAt;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.permissions, _permissions)&&const DeepCollectionEquality().equals(other.failures, _failures)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary,loading,const DeepCollectionEquality().hash(_permissions),const DeepCollectionEquality().hash(_failures),updatedAt);
}

@override
String toString() {
    return 'DashboardState(summary: $summary, loading: $loading, permissions: $permissions, failures: $failures, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 DashboardSummary summary, bool loading, Set<StaffPermission> permissions, Map<StaffPermission, Failure> failures, DateTime? updatedAt
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? loading = null,Object? permissions = null,Object? failures = null,Object? updatedAt = freezed,}) {
  return _then(_DashboardState(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as DashboardSummary,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<StaffPermission>,failures: null == failures ? _self._failures : failures // ignore: cast_nullable_to_non_nullable
as Map<StaffPermission, Failure>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
