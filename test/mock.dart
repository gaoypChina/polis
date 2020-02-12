import 'package:mockito/mockito.dart';
import 'package:polis/repository/abstract/signin_repository.dart';
import 'package:polis/repository/abstract/signup_repository.dart';

class MockSigninRepository extends Mock implements SigninRepository {}

class MockSignupRepository extends Mock implements SignupRepository {}