import 'package:boxch/start/cubit/start_states.dart';
import 'package:boxch/models/wallet.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;

class StartCubit extends Cubit<StartStates> {
  var box = Hive.box(walletBox);

  StartCubit({state})
      : super((Hive.box(walletBox).isNotEmpty)
            ? AuthScreenStartState()
            : FirstScreenStartState());

  Future<void> replaceCreateWallet() async {
    final String mnemonic = bip39.generateMnemonic();
    emit(CreateWalletStartState(mnemonic: mnemonic));
  }

  Future<void> replaceRestoreWallet() async {
    emit(RestoreWalletStartState());
  }

  Future<void> backFirstScreen() async {
    emit(FirstScreenStartState());
  }

  Future signInCreateWallet({required String mnemonic}) async {
      var keyPair = await Ed25519HDKeyPair.fromMnemonic(mnemonic.trim());

      List<LocalWallet> localWallets = (box.get(boxWalletsKey) == null) ? <LocalWallet>[] : box.get(boxWalletsKey);
          var current = LocalWallet(
        network: "solana",
        publicKey: keyPair.publicKey.toBase58(), 
        secretKey: mnemonic);

      localWallets.add(current);
      box.put(boxWalletsKey, localWallets);
      box.put(boxCurrentWalletKey, current);
      wallet = keyPair;

      emit(AuthScreenStartState());
    }
}