import 'package:boxch/start/cubit/start_states.dart';
import 'package:boxch/models/wallet.dart';
import 'package:boxch/services/repository.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:solana/solana.dart';

class StartCubit extends Cubit<StartStates> {
  final SolanaRepository _repository = SolanaRepository();
  var box = Hive.box(walletBox);

  StartCubit({state})
      : super((Hive.box(walletBox).isNotEmpty)
            ? AuthScreenStartState()
            : FirstScreenStartState()) {
              OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
              OneSignal.shared.setAppId("5dbd484f-15f8-4a9f-9b72-fc4bbab1fb3f");
            }

  Future<void> replaceCreateWallet() async {
    final String mnemonic = await _repository.generationMnemonic;
    emit(CreateWalletStartState(mnemonic: mnemonic));
  }

  Future<void> replaceRestoreWallet() async {
    emit(RestoreWalletStartState());
  }

  Future<void> backFirstScreen() async {
    emit(FirstScreenStartState());
  }

  Future signInCreateWallet({required String seed}) async {
    var value = await _repository.createUserWallet(seed.trim());
    List<LocalWallet> localWallets = (box.get(boxWalletsKey) == null) ? <LocalWallet>[] : box.get(boxWalletsKey);
    var current = LocalWallet(
      network: "solana",
      publicKey: value, 
      secretKey: seed.trim());

    localWallets.add(current);
    box.put(boxWalletsKey, localWallets);
    box.put(boxCurrentWalletKey, current);
    wallet = await Wallet.fromMnemonic(current.secretKey);

    emit(AuthScreenStartState());
    }
}