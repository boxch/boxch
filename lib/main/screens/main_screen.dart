import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/main/cubit/main_states.dart';
import 'package:boxch/main/screens/add_contact_screen.dart';
import 'package:boxch/main/screens/all_contacts_screen.dart';
import 'package:boxch/main/screens/choose_tokens_screen.dart';
import 'package:boxch/main/screens/history_transactions_screen.dart';
import 'package:boxch/main/screens/settings_screens/settings_screen.dart';
import 'package:boxch/main/screens/webview_screen.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/walletconnect/cubit/walletconnect_cubit.dart';
import 'package:boxch/walletconnect/screens/walletconnect_screen.dart';
import 'package:boxch/widgets/main_item.dart';
import 'package:boxch/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:boxch/history/history_cubit.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/functions.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boxch/widgets/token_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:countup/countup.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key }) : super(key: key);

  final String address = Hive.box(walletBox).get(boxCurrentWalletKey).publicKey;

  @override
  Widget build(BuildContext context) {
    final MainCubit cubit = context.read<MainCubit>();
    return BlocBuilder<MainCubit, MainStates>(
      builder: (context, state) {
        if (state is LoadingMainScreenState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is MainScreenState) {
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: NestedScrollView(
              
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  pinned: false,
                  floating: true,
                  snap: true,
                  elevation: 0.0,
                  title: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => menuCard(context),
                              child: Icon(Iconsax.menu),
                            ),
                            SizedBox(width: 16.0),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: address))
                                    .then((result) {
                                  okCopyToast(context);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userGreeting(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5))),
                                  Text(
                                      "${address.substring(0, 4)}. . .${address.substring(address.length - 7, address.length)}  ❐",
                                      style: TextStyle(fontSize: 14.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(),
                      ],
                    )
                  ]),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(260.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'totalBalanceText'.tr,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Theme.of(context).hintColor),
                                  ),
                                  state.totalBalance == "*,**"
                                      ? Text(state.totalBalance,
                                          style: TextStyle(
                                            fontSize: 40.0,
                                          ))
                                      : Countup(
                                          precision: 2,
                                          prefix: "\$",
                                          begin: state.totalBalance -
                                              (state.totalBalance / 100 * 20),
                                          end: state.totalBalance,
                                          separator: ",",
                                          duration: Duration(milliseconds: 1500),
                                          style: TextStyle(
                                            fontSize: 40.0,
                                          ),
                                        ),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                height: 70.0,
                                width: 65.0,
                                child: IconButton(
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () => cubit.hideBalance(),
                                    icon: state.hideBalanceState
                                        ? Icon(
                                            Iconsax.eye,
                                            color: Theme.of(context).hintColor,
                                            size: 21.0,
                                          )
                                        : Icon(
                                            Iconsax.eye_slash,
                                            color: Theme.of(context).hintColor,
                                            size: 21.0,
                                          )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 135.0,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8.0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: MainMenu(
                                icon: Iconsax.arrow_down,
                                onTap: () => receiveAddress(context),
                                text: "Receive",
                              ),
                            ),
                            SizedBox(width: 16.0),
                            MainMenu(
                              icon: Iconsax.arrow_up_3,
                              onTap: () => replaceWindow(
                                  context, ChooseTokensScreen(tokens: state.tokens)),
                              text: "Send",
                            ),
                            SizedBox(width: 16.0),
                            MainMenu(
                              icon: Iconsax.card,
                              onTap: () => tradingMethods(context),
                              text: "Buy",
                            ),
                            SizedBox(width: 16.0),
                            MainMenu(
                              icon: Iconsax.layer,
                              onTap: () {},
                              text: "Earn",
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              displacement: 5.0,
              color: Colors.grey,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              onRefresh: () async => await cubit.refreshMain(),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeTop: true,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('quickSend'.tr, style: TextStyle(fontSize: 16.0)),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => replaceWindow(
                                  context,
                                  AllContactsScreen(
                                      tokenList: state.tokens,
                                      contacts: Hive.box(mainBox).get(boxContactsKey) != null ? Hive.box(mainBox)
                                              .get(boxContactsKey)
                                              .reversed
                                              .toList() : [])),
                              child: Text('viewAll'.tr,
                                  style:
                                      TextStyle(color: Theme.of(context).hintColor)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 112.0,
                        child: state.contacts!.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.contacts!.length,
                                itemBuilder: ((context, index) {
                                  return index == 0
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0,
                                                  bottom: 8.0,
                                                  right: 8.0,
                                                  top: 8.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () => replaceWindow(
                                                    context, AddContactScreen()),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Icon(Icons.add,
                                                          color: Theme.of(context)
                                                              .hintColor),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  25.0),
                                                          color: Theme.of(context)
                                                              .primaryColor),
                                                      height: 80.0,
                                                      width: 80.0,
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Text("",
                                                        style:
                                                            TextStyle(fontSize: 10.0))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 4.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () => replaceWindow(
                                                    context,
                                                    ChooseTokensScreen(
                                                        quick: state.contacts![index],
                                                        tokens: state.tokens)),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(25.0),
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: state.contacts![index]
                                                                    ['image'] !=
                                                                ""
                                                            ? Image.file(
                                                                File.fromUri(Uri.parse(
                                                                    state.contacts![index]
                                                                        ['image'])),
                                                                height: 80.0,
                                                                width: 80.0,
                                                                fit: BoxFit.fill)
                                                            : Text(
                                                                state.contacts![index]
                                                                        ['name']
                                                                    .toString()
                                                                    .substring(0, 1),
                                                                style: TextStyle(
                                                                    fontSize: 21.0)),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  25.0),
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                        ),
                                                        height: 80.0,
                                                        width: 80.0,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Text(
                                                        state.contacts![index]
                                                            ['name'],
                                                        style:
                                                            TextStyle(fontSize: 10.0))
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () => replaceWindow(
                                                context,
                                                ChooseTokensScreen(
                                                    tokens: state.tokens,
                                                    quick: state.contacts![index])),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: state.contacts![index]
                                                                ['image'] !=
                                                            ""
                                                        ? Image.file(
                                                            File.fromUri(Uri.parse(
                                                                state.contacts![index]
                                                                    ['image'])),
                                                            height: 80.0,
                                                            width: 80.0,
                                                            fit: BoxFit.fill)
                                                        : Text(
                                                            state.contacts![index]
                                                                    ['name']
                                                                .toString()
                                                                .substring(0, 1),
                                                            style: TextStyle(
                                                                fontSize: 21.0)),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(25.0),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    height: 80.0,
                                                    width: 80.0,
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                Text(state.contacts![index]['name'],
                                                    style: TextStyle(fontSize: 10.0))
                                              ],
                                            ),
                                          ),
                                        );
                                }),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0, bottom: 8.0, right: 8.0, top: 8.0),
                                  child: InkWell(
                                    onTap: () =>
                                        replaceWindow(context, AddContactScreen()),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.add,
                                          color: Theme.of(context).hintColor),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          color: Theme.of(context).primaryColor),
                                      height: 80.0,
                                      width: 80.0,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            Text('assetsText'.tr, style: TextStyle(fontSize: 16.0)),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                          child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: state.tokens.length,
                        itemBuilder: (context, index) {
                          return TokenListTile(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              onPressed: () => replaceWindow(
                                  context,
                                  BlocProvider<HistoryCubit>(
                                      create: (context) => HistoryCubit(
                                          state: state.tokens[index].address),
                                      child: HistoryTransactionsScreen(
                                          mint: state.tokens[index].address!,
                                          balance: state.tokens[index].usdBalance,
                                          amount: state.tokens[index].balance!))),
                              image: state.tokens[index].image,
                              title: state.tokens[index].symbol ?? "unknown",
                              subtitle: state.tokens[index].name ?? "unknown",
                              trailingTitle: state.hideBalanceState
                                  ? '*'
                                  : '${state.tokens[index].balance}',
                              trailingSubtitle: state.hideBalanceState
                                  ? '-'
                                  : '\$${state.tokens[index].usdBalance}');
                        },
                      )),
                    ],
                  ),
                ),
              ),
            ),
                  ),
          );
        }
        return Container();
      }
    );
  }

  tradingMethods(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Material(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  height: 30.0,
                  alignment: Alignment.centerLeft,
                  child: Text("Buy crypto",
                      style: TextStyle(
                          fontSize: 16.0, color: Theme.of(context).hintColor)),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => replaceWindow(
                            context,
                            WebviewScreen(
                                urlLink:
                                    "https://buy.onramper.com/?wallets=SOL:${wallet.address}&API_KEY=pk_prod_puiFMHyFkJpStdWO1jV2HtmhMk37Esi4oeBmB0BxNAY0&defaultCrypto=SOL")),
                        title: Text("OnRamper"),
                        subtitle:
                            Text("Creadit/Debit card", style: TextStyle(fontSize: 11.0)),
                        leading: Image.asset("assets/images/onramper.png",
                            height: 40.0, width: 40.0),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  menuCard(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Material(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  alignment: Alignment.centerLeft,
                  child: Text("Menu",
                          style: TextStyle(
                              fontSize: 16.0, color: Theme.of(context).hintColor)),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MenuItem(onTap: () => replaceWindow(context, BlocProvider<WalletConnectCubit>(
                        create: (context) => WalletConnectCubit(context),
                        child: WalletConnectScreen(),
                      )), 
                      text: "Connect", icon: Image.asset("assets/images/wallet_connect.png", height: 35.0, width: 35.0)),
                      SizedBox(width: 16.0),
                      MenuItem(onTap: () => replaceWindow(context, SettingsScreen()), text: "settingsText".tr,
                       icon: Image.asset("assets/images/settings.png", height: 35.0, width: 35.0))
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  receiveAddress(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.5),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (builder) {
      return Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10.0,
                width: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Theme.of(context).cardColor
                ),
              ),
              SizedBox(height: 16.0),
              Text("Solana network", style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: QrImage(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    data: wallet.address,
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
                    dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle),
                    size: 220.0),
              ),
              SizedBox(height: 32.0),
              InkWell(
                  onTap: () {
                    if (wallet.address.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: wallet.address))
                          .then((result) {
                        okCopyToast(context);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color:
                                Theme.of(context).hintColor.withOpacity(0.1)),
                        child: Text("${wallet.address} ❐",
                            style: TextStyle(fontSize: 12))),
                  )),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    },
  );
}
}


