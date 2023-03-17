import 'dart:async';
import 'dart:math';
import 'package:boxch/main/cubit/main_states.dart';
import 'package:boxch/main/cubit/solana.dart';
import 'package:boxch/models/token.dart';
import 'package:boxch/services/repository.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:solana/solana.dart';


class MainCubit extends Cubit<MainStates> {
  final SolanaRepository _repository = SolanaRepository();
  
  MainCubit(initialState) : super(LoadingMainScreenState()) {
    loadWallet();
  }

  var box = Hive.box(mainBox);

  Map allTokens = {};
  List<Token> balance = [];
  var totalBalance = 0.0;
  bool hideBalanceState = false;


  Future<void> loadWallet() async {
    if (box.isNotEmpty) {
      hideBalanceState = box.get(boxHideKey) ?? false;
    }

    allTokens = await SolanaNetwork.getTokensFromBoxchTokenlist();
    balance = await SolanaNetwork.loadBalance(tokens: allTokens);
    
    balance.forEach((element) { 
      num usd = num.parse(element.price.toString()) * num.parse(element.balance.toString());
      element.usdBalance = usd.toStringAsFixed(2);
      totalBalance += usd;
     });

     if (state is MainScreenState || state is LoadingMainScreenState) {
        emit(MainScreenState(tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState, contacts: box.get(boxContactsKey) != null ? box.get(boxContactsKey).reversed.toList() : []));
     } 
  }

  Future<void> replaceMainScreen() async {
    if (allTokens.isEmpty) {
      emit(LoadingMainScreenState());
    } else {
      emit(MainScreenState(tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState, contacts: box.get(boxContactsKey) != null ? box.get(boxContactsKey).reversed.toList() : []));
    }
  }


  Future<void> refreshMain() async {
      totalBalance = 0.0;
     balance = await SolanaNetwork.loadBalance(tokens: allTokens);
      balance.forEach((element) { 
      num usd = double.parse(element.price.toString()) * double.parse(element.balance.toString());
      element.usdBalance = usd.toStringAsFixed(2);
      totalBalance += usd;
     });
      if (state is MainScreenState)
      emit(MainScreenState(tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState, contacts: box.get(boxContactsKey) != null ? box.get(boxContactsKey).reversed.toList() : []));
      
  }


  Future sendTokenTransaction({required String address, required double amount, required String mintAddress, required String symbol}) async {
    if (mintAddress == SOL) {
      try {
        var message = Message.only(SystemInstruction.transfer(fundingAccount: wallet.publicKey, 
      recipientAccount: Ed25519HDPublicKey.fromBase58(address), lamports: int.parse((amount * pow(10, 9)).toStringAsFixed(0))));

    return await mainnetSolanaClient.rpcClient.signAndSendTransaction(message, [wallet]);
      } catch (_) {
        return false;
      }
    } else {
      var decimal = await _repository.getDecimal(address: mintAddress);
        try {
        var send = await _repository.sendTokenTransaction(
            addressdestination: address,
            naxar: int.parse((amount * pow(10, decimal)).toStringAsFixed(0)),
            mint: mintAddress);

          return send;
        } catch (_) {
          return false;
        }
    }
  }
  
  
  void hideBalance() {
    hideBalanceState = !hideBalanceState;
    box.put(boxHideKey, hideBalanceState);
    emit(MainScreenState(tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState, contacts: box.get(boxContactsKey) != null ? box.get(boxContactsKey).reversed.toList() : []));
  }

  Future<void> addContact({required String name, required String address, required String imageUrl}) async {
    if (box.get(boxContactsKey) == null) {
      box.put(boxContactsKey, [{
        "image": imageUrl,
        "name": name,
        "address": address
      }]);
      emit(MainScreenState(contacts: [{
        "image": imageUrl,
        "name": name,
        "address": address
      }], tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState));
    
    } else {
     var list = box.get(boxContactsKey);
     list.add({
       "image": imageUrl,
        "name": name,
        "address": address
      });
      box.put(boxContactsKey, list);
      emit(MainScreenState(contacts: list.reversed.toList(), tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState));
    }
  }

  Future<void> deleteContact({required String name, required List list}) async {
      for (var i = 0; i < list.length; i++) { 
        if (list[i]['name'] == name) {
          list.removeAt(i);
        }
      }
      box.put(boxContactsKey, list);
      emit(MainScreenState(contacts: list.reversed.toList(), tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState));
  }

  void saveNewShape({required contactsList}) {
    box.put(boxContactsKey, contactsList);
    emit(MainScreenState(contacts: contactsList.reversed.toList(), tokens: balance, totalBalance: hideBalanceState ?  "*,**" : totalBalance, hideBalanceState: hideBalanceState));
  }

}
