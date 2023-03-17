import 'package:boxch/controllers/history/history_states.dart';
import 'package:boxch/services/repository.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana/solana.dart';

class HistoryCubit extends Cubit<HistoryStates> {
  HistoryCubit({state}) : super(LoadingHistoryState()) {
    getHistoryTransactions(mint: state);
  }
  final SolanaRepository _repository = SolanaRepository();
  final NoChainApiRepository _noChainApiRepository = NoChainApiRepository();
  
  Future<void> getHistoryTransactions({required String mint}) async {
    var token = mint == SOL ? Ed25519HDPublicKey.fromBase58(SOL) : await findAssociatedTokenAddress(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mint));
    var transactions;
    emit(LoadedHistoryState(dataHistoryTransactions: transactions ?? []));
  }

    Future closeTokenAccount(BuildContext context, {required String tokenAddress}) async {
    processingShowToast(status: 'Close account', message: '${tokenAddress.substring(0, 20)}..');

    var close = await _repository.closeTokenAccount(tokenAddress: tokenAddress);

    if (close.runtimeType == String) {
      okSwapShowToast(tx: close);
    } else {
      errorShowToast(context, message: "Error");
    }

  }

  Future burnAndCloseTokenAccount(BuildContext context, {required String tokenAddress, required double amount}) async {
    processingShowToast(status: 'Close account', message: '${tokenAddress.substring(0, 20)}..');

    var close = await _repository.closeSmallBalanceAccount(mint: tokenAddress, amount: amount);

    if (close.runtimeType == String) {
      okSwapShowToast(tx: close);
    } else {
      errorShowToast(context, message: "Error");
    }
  }



  Future<bool> authenticateUser() async {
    bool isAuthorized = false;
    try {
      
    } on PlatformException catch (_) {
    }

    return isAuthorized;
  }
}