import 'dart:async';
import 'package:boxch/walletconnect/cubit/walletconnect_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import '../../utils/config.dart';

class WalletConnectCubit extends Cubit<WalletConnectStates> {
  WalletConnectCubit(initialState) : super(WalletConnectScreenState(session: [])) {
    init();
  }

  List<SessionData> sessions = [];

  Future<void> init() async {
    wcClient.onSessionConnect.subscribe((args) {
      sessions.add(args!.session);
      emit(WalletConnectScreenState(session: sessions));
    });

    wcClient.onSessionDelete.subscribe((args) { 
      sessions.remove(args!.id);
      emit(WalletConnectScreenState(session: sessions));
    });

    sessions = wcClient.sessions.getAll();
    emit(WalletConnectScreenState(session: sessions));
  }

  Future<void> connect({required String wsUrl}) async {
    await wcClient.pair(uri: Uri.parse(wsUrl));
  }

  Future<void> disconnect({required SessionData sessionData}) async {
    await wcClient.disconnectSession(
      topic: sessionData.topic,
      reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
    );
    emit(WalletConnectScreenState(session: wcClient.sessions.getAll()));
  }
}
