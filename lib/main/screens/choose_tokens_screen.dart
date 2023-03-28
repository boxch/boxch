import 'package:boxch/main/screens/send_screen.dart';
import 'package:boxch/models/token.dart';
import 'package:boxch/utils/functions.dart';
import 'package:boxch/widgets/cryptocurrencys_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChooseTokensScreen extends StatefulWidget {
  final List<Token> tokens;
  ChooseTokensScreen({required this.tokens});

  @override
  State<ChooseTokensScreen> createState() => _ChooseTokensScreenState();
}

class _ChooseTokensScreenState extends State<ChooseTokensScreen> {

  final TextEditingController _controllerSearch = TextEditingController();
  List<Token> duplicateTokens = [];

  @override
  void initState() {
    duplicateTokens.addAll(widget.tokens);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
                  leading: IconButton(
                    focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
              alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextField(
                    onChanged: _searchTokens,
                    controller: _controllerSearch,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'chooseCryptocurrency'.tr,
                    ),
                  ),
              ),
            )],
        ),
        body: Column(children: [
         Expanded(child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
                Container(
                  height: MediaQuery.of(context).size.height + (duplicateTokens.length * 40),
                  child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                itemCount: duplicateTokens.length,
                itemBuilder: (context, index) {
                  return CryptocurrencysListTile(
                    onPressed: () => replaceWindow(
                          context,
                          SendScreen(
                            symbol: duplicateTokens[index].symbol ?? "unknown",
                              address: duplicateTokens[index].address!, tokenBalance: duplicateTokens[index].balance)),
                    image: duplicateTokens[index].image,
                    title: duplicateTokens[index].symbol ?? "unknown",
                  ); 
                }))
            ],
          ),
    )]));
  }

   void _searchTokens(String query) {
  List<Token> dummySearchList = [];
  dummySearchList.addAll(duplicateTokens);

  if(query.isNotEmpty) {
    final suggestions = dummySearchList.where((token) {
      final name = token.symbol?.toLowerCase();
      final input = query.toLowerCase();
      return name!.contains(input);
    });
    setState(() {
      duplicateTokens.clear();
      duplicateTokens.addAll(suggestions);
    });
  } else {
    setState(() {
      duplicateTokens.clear();
      duplicateTokens.addAll(widget.tokens);
    });
    }
  }
}
