import 'dart:async';
import 'dart:math';
import 'package:boxch/main/cubit/main_states.dart';
import 'package:boxch/main/chains/solana.dart';
import 'package:boxch/models/token.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/walletconnect/utils/wconnect_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

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
          hideBalanceState: hideBalanceState,
          contacts: box.get(boxContactsKey) != null
              ? box.get(boxContactsKey).reversed.toList()
              : []));
    }
  }

  Future<void> replaceMainScreen() async {
    if (allTokens.isEmpty) {
      emit(LoadingMainScreenState());
    } else {
      emit(MainScreenState(
          tokens: balance,
          totalBalance: hideBalanceState ? "*,**" : totalBalance,
          hideBalanceState: hideBalanceState,
          contacts: box.get(boxContactsKey) != null
              ? box.get(boxContactsKey).reversed.toList()
              : []));
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
          hideBalanceState: hideBalanceState,
          contacts: box.get(boxContactsKey) != null
              ? box.get(boxContactsKey).reversed.toList()
              : []));
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
      try {
        var sourceAssociatedTokenAddress =
            await mainnetSolanaClient.getAssociatedTokenAccount(
                owner: Ed25519HDPublicKey.fromBase58(wallet.address),
                mint: Ed25519HDPublicKey.fromBase58(mintAddress));
        var hasAssociatedDestAccount =
            await mainnetSolanaClient.hasAssociatedTokenAccount(
                owner: Ed25519HDPublicKey.fromBase58(address),
                mint: Ed25519HDPublicKey.fromBase58(mintAddress));
        Ed25519HDPublicKey destinationAssociatedTokenAddress;
        if (hasAssociatedDestAccount) {
          var getAccount = await mainnetSolanaClient.getAssociatedTokenAccount(
              owner: Ed25519HDPublicKey.fromBase58(address),
              mint: Ed25519HDPublicKey.fromBase58(mintAddress));
          destinationAssociatedTokenAddress =
              Ed25519HDPublicKey.fromBase58(getAccount!.pubkey);
        } else {
          destinationAssociatedTokenAddress = await findAssociatedTokenAddress(
              owner: Ed25519HDPublicKey.fromBase58(address),
              mint: Ed25519HDPublicKey.fromBase58(mintAddress));
        }

        final message = Message(instructions: [
          if (hasAssociatedDestAccount == false)
            AssociatedTokenAccountInstruction.createAccount(
                funder: Ed25519HDPublicKey.fromBase58(wallet.address),
                address: destinationAssociatedTokenAddress,
                owner: Ed25519HDPublicKey.fromBase58(address),
                mint: Ed25519HDPublicKey.fromBase58(mintAddress)),
          TokenInstruction.transfer(
              source: Ed25519HDPublicKey.fromBase58(
                  sourceAssociatedTokenAddress!.pubkey),
              destination: destinationAssociatedTokenAddress,
              owner: Ed25519HDPublicKey.fromBase58(wallet.address),
              amount: int.parse(
                  (amount * pow(10, decimal.decimals)).toStringAsFixed(0)))
        ]);
        var signature = await mainnetSolanaClient.rpcClient
            .signAndSendTransaction(message, [
          wallet,
        ]);
        await mainnetSolanaClient.waitForSignatureStatus(signature,
            status: Commitment.confirmed);
      } catch (_) {
        return false;
      }
    }
  }

  void hideBalance() {
    hideBalanceState = !hideBalanceState;
    box.put(boxHideKey, hideBalanceState);
    emit(MainScreenState(
        tokens: balance,
        totalBalance: hideBalanceState ? "*,**" : totalBalance,
        hideBalanceState: hideBalanceState,
        contacts: box.get(boxContactsKey) != null
            ? box.get(boxContactsKey).reversed.toList()
            : []));
  }

  Future<void> addContact(
      {required String name,
      required String address,
      required String imageUrl}) async {
    if (box.get(boxContactsKey) == null) {
      box.put(boxContactsKey, [
        {"image": imageUrl, "name": name, "address": address}
      ]);
      emit(MainScreenState(
          contacts: [
            {"image": imageUrl, "name": name, "address": address}
          ],
          tokens: balance,
          totalBalance: hideBalanceState ? "*,**" : totalBalance,
          hideBalanceState: hideBalanceState));
    } else {
      var list = box.get(boxContactsKey);
      list.add({"image": imageUrl, "name": name, "address": address});
      box.put(boxContactsKey, list);
      emit(MainScreenState(
          contacts: list.reversed.toList(),
          tokens: balance,
          totalBalance: hideBalanceState ? "*,**" : totalBalance,
          hideBalanceState: hideBalanceState));
    }
  }

  Future<void> deleteContact({required String name, required List list}) async {
    for (var i = 0; i < list.length; i++) {
      if (list[i]['name'] == name) {
        list.removeAt(i);
      }
    }
    box.put(boxContactsKey, list);
    emit(MainScreenState(
        contacts: list.reversed.toList(),
        tokens: balance,
        totalBalance: hideBalanceState ? "*,**" : totalBalance,
        hideBalanceState: hideBalanceState));
  }

  void saveNewShape({required contactsList}) {
    box.put(boxContactsKey, contactsList);
    emit(MainScreenState(
        contacts: contactsList.reversed.toList(),
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
              var userApproved =
                  await signTransactionDialog(context, args: args);
              if (userApproved) {
                // Returned value must by a primitive, or a JSON serializable object: Map, List, etc.
                print(parametrs['signatures'][0]['instructions']);
                // List instructions = parameters['signatures']['instructions'];
                // instructions.forEach((element) {
                //     Instruction(programId: element['programId'], accounts: accounts, data: data)
                // })

                var signature = await wallet.sign(ByteArray.fromString(parametrs['signatures']));

                return { "signature": signature.toBase58() };
              } else {
                throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
              }
            });

        wcClient.registerRequestHandler(
          chainId: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
          method: "solana_signMessage",
          handler: (String topic, dynamic parametrs) async {
            var userApproved = await signTransactionDialog(context, args: args);
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
}
