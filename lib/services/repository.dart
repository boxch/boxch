import 'package:boxch/services/notchain_api.dart';



class NoChainApiRepository {
  final NotChainApi _noChainApi = NotChainApi();
  Future<double> getPrice({required String symbol}) async => await _noChainApi.getTokenPrice(symbol: symbol);
  Future getSignatureInfo({required String txHash}) async => await _noChainApi.getSignatureInfo(txHash: txHash);
}
