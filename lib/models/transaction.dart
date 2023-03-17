class TransactionSolscan {
  final String txHash;
  final String status;


  TransactionSolscan({required this.txHash, required this.status});

  factory TransactionSolscan.fromJson(json) {
    return TransactionSolscan(
      txHash: json['txHash'],
      status: json['status'],
    );
  }
}

class TxHash {
  final TokenTransfer? tokenTransfers;
  final List? solTransfers;
  final List? serumTransactions;
  final List? raydiumTransactions;
  final List? unknownTransfers;

  TxHash({this.solTransfers, this.tokenTransfers, this.raydiumTransactions, this.serumTransactions, this.unknownTransfers});

  factory TxHash.fromJson(json) {
    return TxHash(
      solTransfers: json['solTransfers'] ?? [],
      tokenTransfers: json['tokenTransfers'] ?? [],
      raydiumTransactions: json['raydiumTransactions'] ?? [],
      serumTransactions: json['serumTransactions'] ?? [],
      unknownTransfers: json['unknownTransfers'] ?? []
    );
  }
}

class TokenSolscan {
  final String address;
  final String symbol;
  final String icon;
  final int decimals;

  TokenSolscan({required this.address, required this.decimals, required this.icon, required this.symbol});

  factory TokenSolscan.fromJson(json) {
    return TokenSolscan(
      address: json['address'],
      decimals: json['decimals'],
      icon: json['icon'],
      symbol: json['symbol']
    );
  }
}

class TokenTransfer {
  final String sourceOwner;
  final String destinationOwner;
  final String amount;
  final TokenSolscan token;

  TokenTransfer({required this.amount, required this.destinationOwner, required this.sourceOwner, required this.token});

  factory TokenTransfer.fromJson(json) {
    return TokenTransfer(
      amount: json['amount'], 
      destinationOwner: json['destination_owner'], 
      sourceOwner: json['source_owner'], 
      token: TokenSolscan.fromJson(json['token']));
  }
}