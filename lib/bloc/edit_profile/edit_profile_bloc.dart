import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/models.dart';
import '../../repository/abstract/edit_profile_repository.dart';
import '../blocs.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({@required this.repository, @required this.userBloc})
      : assert(repository != null),
        assert(userBloc != null);

  final EditProfileRepository repository;
  final UserBloc userBloc;

  @override
  EditProfileState get initialState => InitialEditProfileState();

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is UpdateUserInfo) {
      yield UpdatingUser();
      try {
        final userUpdated = await repository.updateUserInfo(
          currentUser: event.currentUser,
          name: event.name,
          email: event.email,
          pickedPhoto: event.pickedPhoto,
        );
        userBloc.add(UpdateCurrentUser(userUpdated));
        yield UserUpdateSuccess();
      } on Exception {
        yield UserUpdateFailed();
      }
    }
  }
}
