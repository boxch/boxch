import 'dart:convert';
import 'package:http/http.dart' as http;

class NotChainApi {

  Future<double> getTokenPrice({required String symbol}) async {
    var url = Uri.parse("https://price.jup.ag/v1/price?id=$symbol");

    try {
      var response = await http.get(url);
      return json.decode(response.body)['data']['price'];
    } catch (_) {
        try {
          var url = Uri.parse("https://api.coingecko.com/api/v3/simple/price?ids=${symbol.toLowerCase()},usd-coin&vs_currencies=usd");
          var response = await http.get(url);
          return json.decode(response.body)['${symbol.toLowerCase()}']['usd'];
        } catch (_) {
          return 0.0;
      }
    }
  }


  Future getSignatureInfo({required String txHash}) async {
    var url = Uri.parse("https://public-api.solscan.io/transaction/$txHash");
    var response = await http.get(url);
    Map decodeJson = json.decode(response.body);
    List list = [];
    decodeJson.forEach((key, value) { 
      
     });
    return list;
  }

}