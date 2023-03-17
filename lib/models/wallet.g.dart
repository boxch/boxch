// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalWalletAdapter extends TypeAdapter<LocalWallet> {
  @override
  final int typeId = 0;

  @override
  LocalWallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalWallet(
      network: fields[0] as String,
      publicKey: fields[1] as String,
      secretKey: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalWallet obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.network)
      ..writeByte(1)
      ..write(obj.publicKey)
      ..writeByte(2)
      ..write(obj.secretKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalWalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
