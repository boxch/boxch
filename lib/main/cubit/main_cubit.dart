import 'dart:async';
import 'dart:math';
import 'package:boxch/main/cubit/main_states.dart';
import 'package:boxch/main/chains/solana.dart';
import 'package:boxch/models/token.dart';
import 'package:boxch/models/transaction.dart';
import 'package:boxch/services/overlayer_api.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/walletconnect/utils/wconnect_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:solana/solana.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

class MainCubit extends Cubit<MainStates> {
  MainCubit(BuildContext context) : super(LoadingMainScreenState()) {
    loadWallet();
    walletConnect(context);
  }

  var box = Hive.box(mainBox);

  Map allTokens = {};
  List<Token> balance = [];
  var totalBalance = 0.0;
  bool hideBalanceState = false;

  final String projectId = 'd1ee7c7da750c228d3b931b7c3313b10';
  var metadata = PairingMetadata(
    name: 'Boxch Wallet',
    description: 'A wallet that can be requested to sign transactions',
    url: 'https://boxch.net',
    icons: [
      'https://raw.githubusercontent.com/boxch/boxch-tokens/main/assets/boxch.png'
    ],
  );
  final walletNamespaces = {
    'solana': Namespace(
      accounts: ['solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ:${wallet.address}'],
      methods: ['solana_signTransaction', 'solana_signMessage'],
      events: [],
    ),
  };

  Future<void> loadWallet() async {
    if (box.isNotEmpty) {
      hideBalanceState = box.get(boxHideKey) ?? false;
    }

    allTokens = await SolanaNetwork.getTokensFromBoxchTokenlist();
    balance = await SolanaNetwork.loadBalance(tokens: allTokens);

    balance.forEach((element) {
      num usd = num.parse(element.price.toString()) *
          num.parse(element.balance.toString());
      element.usdBalance = usd.toStringAsFixed(2);
      totalBalance += usd;
    });

    if (state is MainScreenState || state is LoadingMainScreenState) {
      emit(MainScreenState(
          tokens: balance,
          totalBalance: hideBalanceState ? "*,**" : totalBalance,
          hideBalanceState: hideBalanceState));
    }
  }

  Future<void> refreshMain() async {
    totalBalance = 0.0;
    balance = await SolanaNetwork.loadBalance(tokens: allTokens);
    balance.forEach((element) {
      num usd = double.parse(element.price.toString()) *
          double.parse(element.balance.toString());
      element.usdBalance = usd.toStringAsFixed(2);
      totalBalance += usd;
    });
    if (state is MainScreenState)
      emit(MainScreenState(
          tokens: balance,
          totalBalance: hideBalanceState ? "*,**" : totalBalance,
          hideBalanceState: hideBalanceState));
  }

  Future sendTokenTransaction(
      {required String address,
      required double amount,
      required String mintAddress,
      required String symbol}) async {
    if (mintAddress == SOL) {
      try {
        var message = Message.only(SystemInstruction.transfer(
            fundingAccount: wallet.publicKey,
            recipientAccount: Ed25519HDPublicKey.fromBase58(address),
            lamports: int.parse((amount * pow(10, 9)).toStringAsFixed(0))));

        return await mainnetSolanaClient.rpcClient
            .signAndSendTransaction(message, [wallet]);
      } catch (_) {
        return false;
      }
    } else {
      var decimal = await mainnetSolanaClient.getTokenBalance(
          owner: wallet.publicKey,
          mint: Ed25519HDPublicKey.fromBase58(mintAddress));
      
      return await OverlayerApi.tokenTransfer(source: wallet.address, destination: address, mint: mintAddress, amount: int.parse((amount * pow(10, decimal.decimals)).toStringAsFixed(0)));
    }
  }

  void hideBalance() {
    hideBalanceState = !hideBalanceState;
    box.put(boxHideKey, hideBalanceState);
    emit(MainScreenState(
        tokens: balance,
        totalBalance: hideBalanceState ? "*,**" : totalBalance,
        hideBalanceState: hideBalanceState));
  }

  Future<void> walletConnect(BuildContext context) async {
    wcClient = await Web3Wallet.createInstance(
        projectId: projectId, metadata: metadata);

    wcClient.onSessionProposal.subscribe((SessionProposalEvent? args) async {
      var userConnect = await connectDappDialog(context, args: args!);
      if (userConnect) {
        await wcClient.approveSession(
            id: args.id, namespaces: walletNamespaces);

        wcClient.registerRequestHandler(
            chainId: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
            method: "solana_signTransaction",
            handler: (String topic, dynamic parametrs) async {
              var userApproved = await signTransactionDialog(context,
                  title: "Sign transaction", par: parametrs);
              if (userApproved) {
                // Returned value must by a primitive, or a JSON serializable object: Map, List, etc.

                var message = web3.Message.fromJson(parametrs['_message']);
                var signature = await wallet.sign(message.serialize());

                return {"signature": signature.toBase58()};
              } else {
                throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
              }
            });

        wcClient.registerRequestHandler(
          chainId: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
          method: "solana_signMessage",
          handler: (String topic, dynamic parametrs) async {
            var userApproved = await signTransactionDialog(context,
                title: "Sign message", par: parametrs);
            if (userApproved) {
              print(parametrs);
            } else {
              throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
            }
          },
        );
      }
    });
  }

  Future<List<TransactionHistory>> getTransactionHistory({required String mint}) async {
    return SolanaNetwork.getTransactionHistory(mint: mint);
  }
}
