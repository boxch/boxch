import 'package:boxch/services/notchain_api.dart';



class NoChainApiRepository {
  Future<double> getPrice({required String symbol}) async => await NotChainApi.getTokenPrice(symbol: symbol);
  Future getSignatureInfo({required String txHash}) async => await NotChainApi.getSignatureInfo(txHash: txHash);
}
