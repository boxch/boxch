import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';

abstract class WalletConnectStates {}

class WalletConnectScreenState extends WalletConnectStates {
  final List<SessionData?> session;
  WalletConnectScreenState({required this.session});
}