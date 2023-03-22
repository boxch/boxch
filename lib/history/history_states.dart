import 'package:boxch/models/transaction.dart';

abstract class HistoryStates {}

class LoadingHistoryState extends HistoryStates {}

class LoadedHistoryState extends HistoryStates {
  List<TransactionSolscan> dataHistoryTransactions;
  LoadedHistoryState({required this.dataHistoryTransactions});
}

class ErrorHistoryState extends HistoryStates {}