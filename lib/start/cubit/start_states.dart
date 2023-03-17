abstract class StartStates {}

class FirstScreenStartState extends StartStates {}

class CreateWalletStartState extends StartStates {
  final String mnemonic;
  CreateWalletStartState({required this.mnemonic});
}

class RestoreWalletStartState extends StartStates {}

class AuthScreenStartState extends StartStates {}
