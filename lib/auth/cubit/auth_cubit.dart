import 'package:boxch/auth/cubit/auth_states.dart';
import 'package:boxch/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit({initialState}) : super(Hive.box(boxPassword).isNotEmpty
            ? EnterPasswordState(error: false)
            : CreatePasswordState(message: "Enter a new password")) {
              biometricAuth();
            }

  String _passwordOne = '';
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> createPassword({required String password}) async {
    if (_passwordOne.isEmpty) {
      _passwordOne = password;
      emit(CreatePasswordState(message: "Re-enter the password"));
    } else if (_passwordOne.isNotEmpty) {
      if (_passwordOne == password) {
        await Hive.box(boxPassword).put(boxPasswordKey, password);
        emit(ValidPasswordState());
      } else {
        emit(EnterPasswordState(error: true));
      }
    }
  }

  Future<void> checkPassword({required String password}) async {
    await Hive.box(boxPassword).get(boxPasswordKey) == password ? emit(ValidPasswordState()) : emit(EnterPasswordState(error: true));
  }

  // Future<void> resetPassword({required String privateKey}) async {
  //   final UserWallet currentWalletPrivateKey = await Hive.box(boxWallets).get(boxCurrentWallet);
  //   currentWalletPrivateKey.privateKey == privateKey ? emit(CreatePasswordState()) : emit(InputPasswordState(error: true));
  // }

  Future<void> biometricAuth() async {
    if (state is EnterPasswordState)
    try {
    var authState = await auth.authenticate(localizedReason: '');
    
    if (authState) {
      emit(ValidPasswordState());
    } else {
      EnterPasswordState(error: true);
    }
    } on PlatformException {
        emit(EnterPasswordState(error: true));
    }
  }
  
}