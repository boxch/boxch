import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:boxch/models/token.dart';
import 'package:boxch/services/repository.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

class SolanaNetwork {
  
   static Future loadBalance({required Map tokens}) async {
    List<Token> _balance = [];
    
    final ProgramAccountsResult tokenAccountsByOwner = await mainnetSolanaClient.rpcClient.getTokenAccountsByOwner(wallet.address, TokenAccountsFilter.byProgramId(TokenProgram.programId), encoding: Encoding.jsonParsed, commitment: Commitment.processed);
    
    var solBalance = await mainnetSolanaClient.rpcClient.getBalance(wallet.address);
    _balance.add(Token(name: "Solana", 
    symbol: "SOL", 
    address: SOL, 
    decimals: 9, 
    balance: (solBalance.value / pow(10, 9)).toString(),
    image: "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png"));

    for (var element in tokenAccountsByOwner.value) { 
      final data = element.account.data as ParsedAccountData;
      var programData = data as ParsedSplTokenProgramAccountData;
      final parsed = programData.parsed as TokenAccountData;

      if (tokens[parsed.info.mint] != null) {
        _balance.add(Token(
                price: "0.0",
                name: tokens[parsed.info.mint]!['name'],
                symbol: tokens[parsed.info.mint]!['symbol'],
                address: parsed.info.mint,
                decimals: parsed.info.tokenAmount.decimals,
                image: tokens[parsed.info.mint]!['logoUrl'],
                balance: parsed.info.tokenAmount.uiAmountString!
                ));
      } else {
        _balance.add(Token(
                price: "0.0",
                name: null,
                symbol: null,
                address: parsed.info.mint,
                decimals: parsed.info.tokenAmount.decimals,
                image: null,
                balance: parsed.info.tokenAmount.uiAmountString!
                ));
      }
    }

    final ids = Set();
    _balance.retainWhere((x) => ids.add(x.address));

     for (var bal in _balance) {
       if (bal.symbol != null) {
         bal.price = await NoChainApiRepository().getPrice(symbol: bal.symbol!);
       }
     }

     return _balance;
  }


  static Future getTokensFromBoxchTokenlist() async {
    var responseTokens = await http.get(Uri.parse("https://raw.githubusercontent.com/boxch/boxch-tokens/main/bin/tokens.json"));
    final Map<String, dynamic> tokensJsonDecode = json.decode(responseTokens.body);
    return tokensJsonDecode;
  }

  
}