import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_events.dart';

abstract class WalletConnectStates {}

class WalletConnectScreenState extends WalletConnectStates {
  final List<SessionConnect?> session;
  WalletConnectScreenState({required this.session});
}