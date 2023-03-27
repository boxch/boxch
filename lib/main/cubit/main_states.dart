import 'package:boxch/models/token.dart';

abstract class MainStates {}

class LoadingMainScreenState extends MainStates {}

class MainScreenState extends MainStates {
  var totalBalance;
  final List<Token> tokens;
  final bool hideBalanceState;
  MainScreenState({
    required this.tokens,
    required this.totalBalance,
    required this.hideBalanceState,
  });
}
