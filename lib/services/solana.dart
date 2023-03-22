import 'dart:math';
import 'package:boxch/utils/config.dart';
import 'package:boxch/utils/constants.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hive/hive.dart';

class SolanaApi {
  var generationMnemonic = bip39.generateMnemonic();
  var box = Hive.box(walletBox);

  Future createUserWallet(String mnemonic) async {
    var fromMnemonic = await Wallet.fromMnemonic(mnemonic);
    return fromMnemonic.address;
  }

  Future getTokenBalance({required String mintAddress}) async {
    try {
      var balance = await mainnetSolanaClient.rpcClient.getTokenAccountBalance(mintAddress, commitment: Commitment.processed);
      return double.parse(balance.value.uiAmountString.toString());
    } catch (e) {
      return 0;
    }
  }

   Future getDecimal({required String mintAddress}) async {
    try {
      var token = await mainnetSolanaClient.getTokenBalance(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mintAddress));
      return token.decimals;
    } catch (e) {
      return 0;
    }
  }


  Future sendTokenTransaction({
    required String addressDestination,
    required int amount,
    required mintAddress,
  }) async {
    var sourceAssociatedTokenAddress = await mainnetSolanaClient.getAssociatedTokenAccount(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mintAddress));

    var hasAssociatedDestAccount = await mainnetSolanaClient.hasAssociatedTokenAccount(owner: Ed25519HDPublicKey.fromBase58(addressDestination), mint: Ed25519HDPublicKey.fromBase58(mintAddress));
   
    Ed25519HDPublicKey destinationAssociatedTokenAddress;
    if (hasAssociatedDestAccount) {
      var getAccount = await mainnetSolanaClient.getAssociatedTokenAccount(owner: Ed25519HDPublicKey.fromBase58(addressDestination), mint: Ed25519HDPublicKey.fromBase58(mintAddress));
      destinationAssociatedTokenAddress = Ed25519HDPublicKey.fromBase58(getAccount!.pubkey);
      } else {
      destinationAssociatedTokenAddress = await findAssociatedTokenAddress(owner: Ed25519HDPublicKey.fromBase58(addressDestination), mint: Ed25519HDPublicKey.fromBase58(mintAddress));
    }
    
     try {
       if (hasAssociatedDestAccount == false) {
         final message = Message(instructions: [
          AssociatedTokenAccountInstruction.createAccount(
          funder: Ed25519HDPublicKey.fromBase58(wallet.address), 
          address: destinationAssociatedTokenAddress, 
          owner: Ed25519HDPublicKey.fromBase58(addressDestination), 
          mint: Ed25519HDPublicKey.fromBase58(mintAddress)),
          TokenInstruction.transfer(
             source: Ed25519HDPublicKey.fromBase58(sourceAssociatedTokenAddress!.pubkey), 
            destination: destinationAssociatedTokenAddress, 
            owner: Ed25519HDPublicKey.fromBase58(wallet.address), 
            amount: amount)
        ]);
      var signature = await mainnetSolanaClient.rpcClient.signAndSendTransaction(message, [
        wallet,
      ]);
      await mainnetSolanaClient.waitForSignatureStatus(signature, status: Commitment.confirmed);
      return signature;
       } else {
         final message = Message(instructions: [
          TokenInstruction.transfer(
             source: Ed25519HDPublicKey.fromBase58(sourceAssociatedTokenAddress!.pubkey), 
            destination: destinationAssociatedTokenAddress, 
            owner: Ed25519HDPublicKey.fromBase58(wallet.address), 
            amount: amount)
        ]);
      var signature = await mainnetSolanaClient.rpcClient.signAndSendTransaction(message, [
        wallet,
      ]);
      return signature;
      }
    } catch (_) {
      return false;
    }
  }


  Future getTokenAccountsByOwner() async {
    final tokenAccountsByOwner = await mainnetSolanaClient.rpcClient.getTokenAccountsByOwner(wallet.address, TokenAccountsFilter.byProgramId(TokenProgram.programId), encoding: Encoding.jsonParsed, commitment: Commitment.processed);
    return tokenAccountsByOwner;
  }

  Future closeTokenAccountAddress({required String mint}) async {
   var associatedTokenAccount = await mainnetSolanaClient.getAssociatedTokenAccount(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mint));
    var message = Message(instructions: [
                TokenInstruction.closeAccount(
                  accountToClose: Ed25519HDPublicKey.fromBase58(associatedTokenAccount!.pubkey), 
                  destination: Ed25519HDPublicKey.fromBase58(wallet.address), 
                  owner: Ed25519HDPublicKey.fromBase58(wallet.address))
             ]);

      try {
        return await mainnetSolanaClient.rpcClient.signAndSendTransaction(message, [wallet]);
      } catch (_) {
        return false;
      }
  }

  Future burnAndCloseAccount({required String mint, required double amount}) async {
    var mintAssociatedAddressSource = await mainnetSolanaClient.getAssociatedTokenAccount(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mint), commitment: Commitment.finalized);
    var tokenBalance = await mainnetSolanaClient.getTokenBalance(owner: Ed25519HDPublicKey.fromBase58(wallet.address), mint: Ed25519HDPublicKey.fromBase58(mint));

    final message = Message(instructions: [
          TokenInstruction.burn(
            amount: int.parse((amount * pow(10, tokenBalance.decimals)).toStringAsFixed(0)), 
            accountToBurnFrom: Ed25519HDPublicKey.fromBase58(mintAssociatedAddressSource!.pubkey), 
            mint: Ed25519HDPublicKey.fromBase58(mint), 
            owner: wallet.publicKey),
          TokenInstruction.closeAccount(accountToClose: Ed25519HDPublicKey.fromBase58(mintAssociatedAddressSource.pubkey),
           destination: Ed25519HDPublicKey.fromBase58(wallet.address), 
           owner: Ed25519HDPublicKey.fromBase58(wallet.address))
        ]);

    try {
      return await mainnetSolanaClient.rpcClient.signAndSendTransaction(message, [wallet]);
    } catch (_) {
      return false;
    }
  }
}
