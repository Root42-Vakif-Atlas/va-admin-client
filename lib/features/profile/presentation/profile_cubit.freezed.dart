// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 ProfileAction get running; Failure? get failure; ProfileAction get failed; int get passwordChanges; List<String> get recoveryCodes;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.running, _this.running) || other.running == _this.running)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.passwordChanges, _this.passwordChanges) || other.passwordChanges == _this.passwordChanges)&&const DeepCollectionEquality().equals(other.recoveryCodes, _this.recoveryCodes));
}


@override
int get hashCode {
  final _this = this as ProfileState;
  return Object.hash(runtimeType,_this.running,_this.failure,_this.failed,_this.passwordChanges,const DeepCollectionEquality().hash(_this.recoveryCodes));
}



}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileAction running, Failure? failure, ProfileAction failed, int passwordChanges, List<String> recoveryCodes
});




}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? running = null,Object? failure = freezed,Object? failed = null,Object? passwordChanges = null,Object? recoveryCodes = null,}) {
  return _then(ProfileState(
running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as ProfileAction,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as ProfileAction,passwordChanges: null == passwordChanges ? _self.passwordChanges : passwordChanges // ignore: cast_nullable_to_non_nullable
as int,recoveryCodes: null == recoveryCodes ? _self.recoveryCodes : recoveryCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileAction running,  Failure? failure,  ProfileAction failed,  int passwordChanges,  List<String> recoveryCodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.running,_that.failure,_that.failed,_that.passwordChanges,_that.recoveryCodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileAction running,  Failure? failure,  ProfileAction failed,  int passwordChanges,  List<String> recoveryCodes)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.running,_that.failure,_that.failed,_that.passwordChanges,_that.recoveryCodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileAction running,  Failure? failure,  ProfileAction failed,  int passwordChanges,  List<String> recoveryCodes)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.running,_that.failure,_that.failed,_that.passwordChanges,_that.recoveryCodes);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState extends ProfileState {
  const _ProfileState({this.running = ProfileAction.none, this.failure, this.failed = ProfileAction.none, this.passwordChanges = 0,  List<String> recoveryCodes = const <String>[]}): _recoveryCodes = recoveryCodes,super._();
  

@override@JsonKey() final  ProfileAction running;
@override final  Failure? failure;
@override@JsonKey() final  ProfileAction failed;
@override@JsonKey() final  int passwordChanges;
 final  List<String> _recoveryCodes;
@override@JsonKey() List<String> get recoveryCodes {
  if (_recoveryCodes is EqualUnmodifiableListView) return _recoveryCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recoveryCodes);
}


/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.running, running) || other.running == running)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.passwordChanges, passwordChanges) || other.passwordChanges == passwordChanges)&&const DeepCollectionEquality().equals(other.recoveryCodes, _recoveryCodes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,running,failure,failed,passwordChanges,const DeepCollectionEquality().hash(_recoveryCodes));
}



}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileAction running, Failure? failure, ProfileAction failed, int passwordChanges, List<String> recoveryCodes
});




}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? running = null,Object? failure = freezed,Object? failed = null,Object? passwordChanges = null,Object? recoveryCodes = null,}) {
  return _then(_ProfileState(
running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as ProfileAction,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as ProfileAction,passwordChanges: null == passwordChanges ? _self.passwordChanges : passwordChanges // ignore: cast_nullable_to_non_nullable
as int,recoveryCodes: null == recoveryCodes ? _self._recoveryCodes : recoveryCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
