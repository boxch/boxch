import 'dart:io';
import 'package:solana/solana.dart';
import 'package:walletconnect_flutter_v2/apis/web3wallet/web3wallet.dart';

late Wallet wallet;
late Web3Wallet wcClient;

final alchemyRpcUrl = "https://solana-mainnet.g.alchemy.com/v2/PfAUTZzcYvtrEs_nUTGvc6o_njLPXDkS";
final alchemyWebsocketUrl = "wss://solana-mainnet.g.alchemy.com/v2/PfAUTZzcYvtrEs_nUTGvc6o_njLPXDkS";


SolanaClient get mainnetSolanaClient => SolanaClient(rpcUrl: Uri.parse(alchemyRpcUrl), websocketUrl: Uri.parse(alchemyWebsocketUrl));


final devnetRpcUrl =
    Platform.environment['MAINNET_RPC_URL'] ?? 'https://api.devnet.solana.com';
final devnetWebsocketUrl =
    Platform.environment['MAINNET_WEBSOCKET_URL'] ?? 'ws://api.devnet.solana.com';

SolanaClient get devnetSolanaClient => SolanaClient(rpcUrl: Uri.parse(devnetRpcUrl), websocketUrl: Uri.parse(devnetWebsocketUrl));