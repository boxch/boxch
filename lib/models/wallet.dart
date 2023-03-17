import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 0)
class LocalWallet {
  @HiveField(0)
  final String network;
  @HiveField(1)
  final String publicKey;
  @HiveField(2)
  final String secretKey;

  LocalWallet({required this.network, required this.publicKey, required this.secretKey});
}