class Token {
  final String? name;
  final String? symbol;
  final String? address;
  final int decimals;
  final String? image;
  final String? balance;
  var price;
  var usdBalance;

  Token({
   required this.name,
   required this.symbol,
   required this.address,
   required this.decimals,
   required this.image,
   this.balance,
   this.price,
   this.usdBalance,
  });

    factory Token.fromMap(key, json) {
    return Token(
      address: json['address'],
      name: json['name'],
      symbol: json['symbol'],
      decimals: json['decimals'],
      image: json['logoUrl'],
    );
  }
}