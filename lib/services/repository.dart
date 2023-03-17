import 'package:boxch/services/no_chain_api.dart';
import 'package:boxch/services/solana.dart';
import 'package:solana/dto.dart';

class SolanaRepository {
  final SolanaApi _solanaApi = SolanaApi();
  get generationMnemonic => _solanaApi.generationMnemonic;
  Future createUserWallet(String mnemonic) async => await _solanaApi.createUserWallet(mnemonic);
  Future<List<ProgramAccount>> getTokenAccountsByOwner() async => await _solanaApi.getTokenAccountsByOwner();
  Future getTokenBalance({required String mint}) async => await
      _solanaApi.getTokenBalance(mintAddress: mint);
  Future sendTokenTransaction(
          {required String addressdestination,
          required int naxar,
          required String mint}) async => await
      _solanaApi.sendTokenTransaction(
          addressDestination: addressdestination, amount: naxar, mintAddress: mint);
  Future getDecimal({required String address}) async => await _solanaApi.getDecimal(mintAddress: address);
  Future closeTokenAccount({required String tokenAddress}) async => await _solanaApi.closeTokenAccountAddress(mint: tokenAddress);
  Future closeSmallBalanceAccount({required String mint, required double amount}) async => await _solanaApi.burnAndCloseAccount(mint: mint, amount: amount);
}



class NoChainApiRepository {
  final NoChainApi _noChainApi = NoChainApi();
  Future<double> getPrice({required String symbol}) async => await _noChainApi.getTokenPrice(symbol: symbol);
  Future getSignatureInfo({required String txHash}) async => await _noChainApi.getSignatureInfo(txHash: txHash);
}
