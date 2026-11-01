// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStarted value)?  started,TResult Function( AuthLogoutRequested value)?  logoutRequested,TResult Function( AuthIdleTimeout value)?  idleTimeout,TResult Function( AuthSessionChanged value)?  sessionChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthIdleTimeout() when idleTimeout != null:
return idleTimeout(_that);case AuthSessionChanged() when sessionChanged != null:
return sessionChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStarted value)  started,required TResult Function( AuthLogoutRequested value)  logoutRequested,required TResult Function( AuthIdleTimeout value)  idleTimeout,required TResult Function( AuthSessionChanged value)  sessionChanged,}){
final _that = this;
switch (_that) {
case AuthStarted():
return started(_that);case AuthLogoutRequested():
return logoutRequested(_that);case AuthIdleTimeout():
return idleTimeout(_that);case AuthSessionChanged():
return sessionChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStarted value)?  started,TResult? Function( AuthLogoutRequested value)?  logoutRequested,TResult? Function( AuthIdleTimeout value)?  idleTimeout,TResult? Function( AuthSessionChanged value)?  sessionChanged,}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case AuthIdleTimeout() when idleTimeout != null:
return idleTimeout(_that);case AuthSessionChanged() when sessionChanged != null:
return sessionChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  logoutRequested,TResult Function()?  idleTimeout,TResult Function( AuthSessionEvent event)?  sessionChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthIdleTimeout() when idleTimeout != null:
return idleTimeout();case AuthSessionChanged() when sessionChanged != null:
return sessionChanged(_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  logoutRequested,required TResult Function()  idleTimeout,required TResult Function( AuthSessionEvent event)  sessionChanged,}) {final _that = this;
switch (_that) {
case AuthStarted():
return started();case AuthLogoutRequested():
return logoutRequested();case AuthIdleTimeout():
return idleTimeout();case AuthSessionChanged():
return sessionChanged(_that.event);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  logoutRequested,TResult? Function()?  idleTimeout,TResult? Function( AuthSessionEvent event)?  sessionChanged,}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthLogoutRequested() when logoutRequested != null:
return logoutRequested();case AuthIdleTimeout() when idleTimeout != null:
return idleTimeout();case AuthSessionChanged() when sessionChanged != null:
return sessionChanged(_that.event);case _:
  return null;

}
}

}

/// @nodoc


class AuthStarted implements AuthEvent {
  const AuthStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthEvent.started()';
}


}




/// @nodoc


class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class AuthIdleTimeout implements AuthEvent {
  const AuthIdleTimeout();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthIdleTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthEvent.idleTimeout()';
}


}




/// @nodoc


class AuthSessionChanged implements AuthEvent {
  const AuthSessionChanged(this.event);
  

 final  AuthSessionEvent event;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionChangedCopyWith<AuthSessionChanged> get copyWith => _$AuthSessionChangedCopyWithImpl<AuthSessionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionChanged&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode {
    return Object.hash(runtimeType,event);
}

@override
String toString() {
    return 'AuthEvent.sessionChanged(event: $event)';
}


}

/// @nodoc
abstract mixin class $AuthSessionChangedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthSessionChangedCopyWith(AuthSessionChanged value, $Res Function(AuthSessionChanged) _then) = _$AuthSessionChangedCopyWithImpl;
@useResult
$Res call({
 AuthSessionEvent event
});




}
/// @nodoc
class _$AuthSessionChangedCopyWithImpl<$Res>
    implements $AuthSessionChangedCopyWith<$Res> {
  _$AuthSessionChangedCopyWithImpl(this._self, this._then);

  final AuthSessionChanged _self;
  final $Res Function(AuthSessionChanged) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,}) {
  return _then(AuthSessionChanged(
null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as AuthSessionEvent,
  ));
}


}

/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthUnknown value)?  unknown,TResult Function( AuthGuest value)?  guest,TResult Function( AuthAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case AuthGuest() when guest != null:
return guest(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthUnknown value)  unknown,required TResult Function( AuthGuest value)  guest,required TResult Function( AuthAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown():
return unknown(_that);case AuthGuest():
return guest(_that);case AuthAuthenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthUnknown value)?  unknown,TResult? Function( AuthGuest value)?  guest,TResult? Function( AuthAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case AuthGuest() when guest != null:
return guest(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( GuestReason reason)?  guest,TResult Function( StaffUser user)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case AuthGuest() when guest != null:
return guest(_that.reason);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( GuestReason reason)  guest,required TResult Function( StaffUser user)  authenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown():
return unknown();case AuthGuest():
return guest(_that.reason);case AuthAuthenticated():
return authenticated(_that.user);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( GuestReason reason)?  guest,TResult? Function( StaffUser user)?  authenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case AuthGuest() when guest != null:
return guest(_that.reason);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case _:
  return null;

}
}

}

/// @nodoc


class AuthUnknown implements AuthState {
  const AuthUnknown();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AuthState.unknown()';
}


}




/// @nodoc


class AuthGuest implements AuthState {
  const AuthGuest({this.reason = GuestReason.none});
  

@JsonKey() final  GuestReason reason;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthGuestCopyWith<AuthGuest> get copyWith => _$AuthGuestCopyWithImpl<AuthGuest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthGuest&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString() {
    return 'AuthState.guest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AuthGuestCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthGuestCopyWith(AuthGuest value, $Res Function(AuthGuest) _then) = _$AuthGuestCopyWithImpl;
@useResult
$Res call({
 GuestReason reason
});




}
/// @nodoc
class _$AuthGuestCopyWithImpl<$Res>
    implements $AuthGuestCopyWith<$Res> {
  _$AuthGuestCopyWithImpl(this._self, this._then);

  final AuthGuest _self;
  final $Res Function(AuthGuest) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(AuthGuest(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as GuestReason,
  ));
}


}

/// @nodoc


class AuthAuthenticated implements AuthState {
  const AuthAuthenticated(this.user);
  

 final  StaffUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith => _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,user);
}

@override
String toString() {
    return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) = _$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 StaffUser user
});




}
/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthAuthenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as StaffUser,
  ));
}


}

// dart format on
