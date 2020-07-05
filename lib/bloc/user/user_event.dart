part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class StoreUser extends UserEvent {
  StoreUser(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class Logout extends UserEvent {
  @override
  List<Object> get props => [];
}

class UpdateCurrentUser extends UserEvent {
  UpdateCurrentUser(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class ChangeUserConfig extends UserEvent {
  ChangeUserConfig({this.user, this.config});

  final UserModel user;
  final Configuracao config;

  @override
  List<Object> get props => [user, config];
}

class SetUserPickedTheme extends UserEvent {
  SetUserPickedTheme(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}
