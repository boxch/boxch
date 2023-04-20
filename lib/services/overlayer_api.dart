import 'dart:convert';
import 'dart:developer';
import 'package:boxch/utils/config.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:http/http.dart' as http;
import 'package:solana_web3/solana_web3.dart';

class OverlayerApi {

  static Future tokenTransfer({required String source, required String destination, required String mint, required int amount}) async {

    var sourceAssociated = await mainnetSolanaClient.getAssociatedTokenAccount(owner: wallet.publicKey, mint: Ed25519HDPublicKey.fromBase58(mint));
    var hasAssociatedDestAccount =
            await mainnetSolanaClient.hasAssociatedTokenAccount(
                owner: Ed25519HDPublicKey.fromBase58(destination),
                mint: Ed25519HDPublicKey.fromBase58(mint));
        Ed25519HDPublicKey destinationAssociated;
        if (hasAssociatedDestAccount) {
          var getAccount = await mainnetSolanaClient.getAssociatedTokenAccount(
              owner: Ed25519HDPublicKey.fromBase58(destination),
              mint: Ed25519HDPublicKey.fromBase58(mint));
          destinationAssociated =
              Ed25519HDPublicKey.fromBase58(getAccount!.pubkey);
        } else {
          destinationAssociated = await findAssociatedTokenAddress(
              owner: Ed25519HDPublicKey.fromBase58(destination),
              mint: Ed25519HDPublicKey.fromBase58(mint));
        }

    var getMessage = await http.post(Uri.parse("https://overlayer.herokuapp.com/token_transfer"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: json.encode({
        "solana": {
          "source": sourceAssociated!.pubkey,
          "destination": destinationAssociated.toBase58(),
          "mint": mint,
          "owner": wallet.address,
          "amount": amount
        }
      })
      );

      var ms = json.decode(getMessage.body);

      var signature = await wallet.sign(base58.decode(ms['message']));

      var transactionBytes = ByteArray.merge([
          ByteArray([2]),
          ByteArray.fromBase58(ms['signature']),
          ByteArray(signature.bytes),
          ByteArray.fromBase58(ms['message'])
      ]);

      var tx = await mainnetSolanaClient.rpcClient.sendTransaction(base64.encode(transactionBytes.toList()), maxRetries: 2, skipPreflight: true);
      await mainnetSolanaClient.waitForSignatureStatus(tx, status: Commitment.processed);
      print(tx);
      return tx;

  }

}