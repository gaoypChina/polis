import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_panel/sliding_panel.dart';

import '../../bloc/blocs.dart';
import '../../core/abstract/polis_image_picker.dart';
import '../../i18n/i18n.dart';
import '../../model/models.dart';
import '../../widget/snackbar.dart';
import '../theme/main_theme.dart';

class SignupPage extends StatefulWidget {
  SignupPage({
    @required this.imagePicker,
    @required this.panelController,
  })  : assert(imagePicker != null),
        assert(panelController != null);

  final PolisImagePicker imagePicker;
  final PanelController panelController;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupBloc _signupBloc;
  GlobalKey<FormState> _formKey;
  UserModel _signupUser;
  String _name;
  String _email;
  String _password;
  String _photoUrl;
  File _profilePhoto;

  FocusNode _emailFN;
  FocusNode _passwordFN;
  FocusNode _confirmPasswordFN;

  @override
  void initState() {
    super.initState();
    _signupBloc = context.bloc<SignupBloc>();
    _formKey = GlobalKey<FormState>();
    _signupUser = UserModel();
    _emailFN = FocusNode();
    _passwordFN = FocusNode();
    _confirmPasswordFN = FocusNode();
  }

  @override
  void dispose() {
    _signupBloc.close();
    _emailFN.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _signupBloc,
      listener: (context, state) {
        if (state is UserCreated) {
          Snackbar.success(context, USER_CREATED_WITH_SUCCESS);
          Future.delayed(const Duration(seconds: 1))
              .then((value) => widget.panelController.close());
        } else if (state is UserCreationFailed) {
          Snackbar.error(context, state.statusMessage);
        } else if (state is SignupFailed) {
          Snackbar.error(context, state.errorMessage);
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        bloc: _signupBloc,
        builder: (_, state) {
          if (state is InitialSignup ||
              state is UserCreationFailed ||
              state is SignupFailed ||
              state is UserCreated) {
            return _signupForm();
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 72),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _signupForm() {
    void _validateAndSendForm() {
      final formState = _formKey.currentState;
      if (formState.validate()) {
        formState.save();
        _signupUser = UserModel(
          name: _name,
          email: _email,
          password: _password,
          photoUrl: _photoUrl,
        );
        _signupBloc.add(Signup(
          user: _signupUser,
          profilePhoto: _profilePhoto,
        ));
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              child: Material(
                borderRadius: BorderRadius.circular(60),
                elevation: 1,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  child: Center(
                    key: const ValueKey('profile-container'),
                    child: _profilePhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              _profilePhoto,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.camera,
                                color: theme.accentColor,
                                size: 40,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CHOICE_PHOTO,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.accentColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                  ),
                  onTap: getImage,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('name-field'),
              decoration: const InputDecoration(
                labelText: NAME,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _emailFN.requestFocus(),
              onSaved: (name) => _name = name,
              validator: (name) => name.isEmpty ? REQUIRED_FIELD : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('email-field'),
              focusNode: _emailFN,
              decoration: const InputDecoration(
                labelText: EMAIL,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _passwordFN.requestFocus(),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) => _email = email,
              validator: (email) => email.isEmpty ? REQUIRED_FIELD : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('password-field'),
              focusNode: _passwordFN,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: PASSWORD,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _confirmPasswordFN.requestFocus(),
              onSaved: (password) => _password = password,
              onChanged: (password) => _password = password,
              validator: (password) => password.isEmpty ? REQUIRED_FIELD : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('confirm-password-field'),
              focusNode: _confirmPasswordFN,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: PASSWORD_CONFIRMATION,
              ),
              onEditingComplete: _validateAndSendForm,
              validator: (passwordConfirmation) {
                if (passwordConfirmation.isEmpty) {
                  return REQUIRED_FIELD;
                }
                return _password != passwordConfirmation
                    ? PASSWORD_AND_CONFIRMATION_DONT_MATCH
                    : null;
              },
            ),
            const SizedBox(height: 32),
            Container(
              width: 160,
              child: RaisedButton(
                key: const ValueKey('signup-btn'),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  SIGNUP,
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _validateAndSendForm,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    var image = await widget.imagePicker.getImage();
    setState(() => _profilePhoto = image);
  }
}
