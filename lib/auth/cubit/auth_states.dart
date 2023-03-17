abstract class AuthStates {}

class EnterPasswordState extends AuthStates {
  final bool error;

  EnterPasswordState({required this.error});
}

class ValidPasswordState extends AuthStates {}


class CreatePasswordState extends AuthStates {
  final String? message;
  CreatePasswordState({this.message});
}