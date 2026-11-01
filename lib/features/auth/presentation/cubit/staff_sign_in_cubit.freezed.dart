// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_sign_in_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StaffSignInState {

 SignInStep get step; bool get submitting; bool get useRecoveryCode; Failure? get failure; MfaChallenge? get challenge; TotpEnrollment? get enrollment; StaffUser? get enrolledUser; List<String> get recoveryCodes;
/// Create a copy of StaffSignInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffSignInStateCopyWith<StaffSignInState> get copyWith => _$StaffSignInStateCopyWithImpl<StaffSignInState>(this as StaffSignInState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StaffSignInState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffSignInState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.useRecoveryCode, _this.useRecoveryCode) || other.useRecoveryCode == _this.useRecoveryCode)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.challenge, _this.challenge) || other.challenge == _this.challenge)&&(identical(other.enrollment, _this.enrollment) || other.enrollment == _this.enrollment)&&(identical(other.enrolledUser, _this.enrolledUser) || other.enrolledUser == _this.enrolledUser)&&const DeepCollectionEquality().equals(other.recoveryCodes, _this.recoveryCodes));
}


@override
int get hashCode {
  final _this = this as StaffSignInState;
  return Object.hash(runtimeType,_this.step,_this.submitting,_this.useRecoveryCode,_this.failure,_this.challenge,_this.enrollment,_this.enrolledUser,const DeepCollectionEquality().hash(_this.recoveryCodes));
}



}

/// @nodoc
abstract mixin class $StaffSignInStateCopyWith<$Res>  {
  factory $StaffSignInStateCopyWith(StaffSignInState value, $Res Function(StaffSignInState) _then) = _$StaffSignInStateCopyWithImpl;
@useResult
$Res call({
 SignInStep step, bool submitting, bool useRecoveryCode, Failure? failure, MfaChallenge? challenge, TotpEnrollment? enrollment, StaffUser? enrolledUser, List<String> recoveryCodes
});




}
/// @nodoc
class _$StaffSignInStateCopyWithImpl<$Res>
    implements $StaffSignInStateCopyWith<$Res> {
  _$StaffSignInStateCopyWithImpl(this._self, this._then);

  final StaffSignInState _self;
  final $Res Function(StaffSignInState) _then;

/// Create a copy of StaffSignInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? submitting = null,Object? useRecoveryCode = null,Object? failure = freezed,Object? challenge = freezed,Object? enrollment = freezed,Object? enrolledUser = freezed,Object? recoveryCodes = null,}) {
  return _then(StaffSignInState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SignInStep,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,useRecoveryCode: null == useRecoveryCode ? _self.useRecoveryCode : useRecoveryCode // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as MfaChallenge?,enrollment: freezed == enrollment ? _self.enrollment : enrollment // ignore: cast_nullable_to_non_nullable
as TotpEnrollment?,enrolledUser: freezed == enrolledUser ? _self.enrolledUser : enrolledUser // ignore: cast_nullable_to_non_nullable
as StaffUser?,recoveryCodes: null == recoveryCodes ? _self.recoveryCodes : recoveryCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffSignInState].
extension StaffSignInStatePatterns on StaffSignInState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffSignInState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffSignInState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffSignInState value)  $default,){
final _that = this;
switch (_that) {
case _StaffSignInState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffSignInState value)?  $default,){
final _that = this;
switch (_that) {
case _StaffSignInState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SignInStep step,  bool submitting,  bool useRecoveryCode,  Failure? failure,  MfaChallenge? challenge,  TotpEnrollment? enrollment,  StaffUser? enrolledUser,  List<String> recoveryCodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffSignInState() when $default != null:
return $default(_that.step,_that.submitting,_that.useRecoveryCode,_that.failure,_that.challenge,_that.enrollment,_that.enrolledUser,_that.recoveryCodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SignInStep step,  bool submitting,  bool useRecoveryCode,  Failure? failure,  MfaChallenge? challenge,  TotpEnrollment? enrollment,  StaffUser? enrolledUser,  List<String> recoveryCodes)  $default,) {final _that = this;
switch (_that) {
case _StaffSignInState():
return $default(_that.step,_that.submitting,_that.useRecoveryCode,_that.failure,_that.challenge,_that.enrollment,_that.enrolledUser,_that.recoveryCodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SignInStep step,  bool submitting,  bool useRecoveryCode,  Failure? failure,  MfaChallenge? challenge,  TotpEnrollment? enrollment,  StaffUser? enrolledUser,  List<String> recoveryCodes)?  $default,) {final _that = this;
switch (_that) {
case _StaffSignInState() when $default != null:
return $default(_that.step,_that.submitting,_that.useRecoveryCode,_that.failure,_that.challenge,_that.enrollment,_that.enrolledUser,_that.recoveryCodes);case _:
  return null;

}
}

}

/// @nodoc


class _StaffSignInState extends StaffSignInState {
  const _StaffSignInState({this.step = SignInStep.credentials, this.submitting = false, this.useRecoveryCode = false, this.failure, this.challenge, this.enrollment, this.enrolledUser,  List<String> recoveryCodes = const <String>[]}): _recoveryCodes = recoveryCodes,super._();
  

@override@JsonKey() final  SignInStep step;
@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool useRecoveryCode;
@override final  Failure? failure;
@override final  MfaChallenge? challenge;
@override final  TotpEnrollment? enrollment;
@override final  StaffUser? enrolledUser;
 final  List<String> _recoveryCodes;
@override@JsonKey() List<String> get recoveryCodes {
  if (_recoveryCodes is EqualUnmodifiableListView) return _recoveryCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recoveryCodes);
}


/// Create a copy of StaffSignInState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffSignInStateCopyWith<_StaffSignInState> get copyWith => __$StaffSignInStateCopyWithImpl<_StaffSignInState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffSignInState&&(identical(other.step, step) || other.step == step)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.useRecoveryCode, useRecoveryCode) || other.useRecoveryCode == useRecoveryCode)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.challenge, challenge) || other.challenge == challenge)&&(identical(other.enrollment, enrollment) || other.enrollment == enrollment)&&(identical(other.enrolledUser, enrolledUser) || other.enrolledUser == enrolledUser)&&const DeepCollectionEquality().equals(other.recoveryCodes, _recoveryCodes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,submitting,useRecoveryCode,failure,challenge,enrollment,enrolledUser,const DeepCollectionEquality().hash(_recoveryCodes));
}



}

/// @nodoc
abstract mixin class _$StaffSignInStateCopyWith<$Res> implements $StaffSignInStateCopyWith<$Res> {
  factory _$StaffSignInStateCopyWith(_StaffSignInState value, $Res Function(_StaffSignInState) _then) = __$StaffSignInStateCopyWithImpl;
@override @useResult
$Res call({
 SignInStep step, bool submitting, bool useRecoveryCode, Failure? failure, MfaChallenge? challenge, TotpEnrollment? enrollment, StaffUser? enrolledUser, List<String> recoveryCodes
});




}
/// @nodoc
class __$StaffSignInStateCopyWithImpl<$Res>
    implements _$StaffSignInStateCopyWith<$Res> {
  __$StaffSignInStateCopyWithImpl(this._self, this._then);

  final _StaffSignInState _self;
  final $Res Function(_StaffSignInState) _then;

/// Create a copy of StaffSignInState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? submitting = null,Object? useRecoveryCode = null,Object? failure = freezed,Object? challenge = freezed,Object? enrollment = freezed,Object? enrolledUser = freezed,Object? recoveryCodes = null,}) {
  return _then(_StaffSignInState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as SignInStep,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,useRecoveryCode: null == useRecoveryCode ? _self.useRecoveryCode : useRecoveryCode // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as MfaChallenge?,enrollment: freezed == enrollment ? _self.enrollment : enrollment // ignore: cast_nullable_to_non_nullable
as TotpEnrollment?,enrolledUser: freezed == enrolledUser ? _self.enrolledUser : enrolledUser // ignore: cast_nullable_to_non_nullable
as StaffUser?,recoveryCodes: null == recoveryCodes ? _self._recoveryCodes : recoveryCodes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
