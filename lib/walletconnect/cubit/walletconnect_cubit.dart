import 'package:boxch/walletconnect/cubit/walletconnect_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:walletconnect_flutter_v2/apis/auth_api/models/auth_client_models.dart';
import 'package:walletconnect_flutter_v2/apis/core/pairing/utils/pairing_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/session_models.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_events.dart';
import 'package:walletconnect_flutter_v2/apis/utils/errors.dart';
import 'package:walletconnect_flutter_v2/apis/web3wallet/web3wallet.dart';
import '../../utils/config.dart';

class WalletConnectCubit extends Cubit<WalletConnectStates> {
  WalletConnectCubit({initialState})
      : super(WalletConnectScreenState(session: []));

  List<SessionConnect> listSession = [];
  final String projectId = 'd1ee7c7da750c228d3b931b7c3313b10';
  late Web3Wallet wcClient;
  late int id;

  var metadata = PairingMetadata(
    name: 'Boxch Wallet',
    description: 'A wallet that can be requested to sign transactions',
    url: 'https://boxch.net',
    icons: [
      'https://raw.githubusercontent.com/boxch/boxch-tokens/main/assets/boxch.png'
    ],
  );

  final walletNamespaces = {
    'solana': Namespace(
      accounts: ['solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ:${wallet.address}'],
      methods: ['solana_signTransaction', 'solana_signMessage'],
      events: [],
    ),
  };

  Future<void> init({required String wsUrl}) async {
    wcClient = await Web3Wallet.createInstance(
        projectId: projectId, metadata: metadata);

    wcClient.onSessionProposal.subscribe((SessionProposalEvent? args) async {
      id = args!.id;
      await wcClient.approveSession(id: args.id, namespaces: walletNamespaces);
      emit(WalletConnectScreenState(session: listSession));
    });

    wcClient.onSessionConnect.subscribe((SessionConnect? session) {
      listSession.add(session!);
    });

    wcClient.registerRequestHandler(
        chainId: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
        method: "solana_signTransaction");

    wcClient.registerRequestHandler(
        chainId: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
        method: "solana_signMessage");

    wcClient.onSessionRequest.subscribe((args) async {
      //  var instructions = args!.params['instructions'];

      //  var message = [];

      //  for (var instr in instructions) {
      //    var parsedInstruction = ParsedInstruction.fromJson(instr);
      //    message.add(parsedInstruction);
      //  }

      //  wallet.sign(data);

      //  final blockhash = await mainnetSolanaClient.rpcClient.getLatestBlockhash();
      //  final signature = await wallet.signMessage(message: message, recentBlockhash: blockhash.value.blockhash);
      //  print(signature.encode());
      //  await wcClient.respondAuthRequest(
      //       id: args.id,
      //       iss: '${args.chainId}:${wallet.address}',
      //       signature: CacaoSignature(t: CacaoSignature.EIP191, s: signature.encode()),
      //     );
    });

    await wcClient.pair(uri: Uri.parse(wsUrl));
  }

  Future<void> disconnect(
      {required SessionData sessionData, required int index}) async {
    await wcClient.disconnectSession(
      topic: sessionData.topic,
      reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
    );
    listSession.removeAt(index);
    emit(WalletConnectScreenState(session: listSession));
  }
}
