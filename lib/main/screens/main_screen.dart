import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/main/cubit/main_states.dart';
import 'package:boxch/main/screens/choose_tokens_screen.dart';
import 'package:boxch/main/screens/history_transactions_screen.dart';
import 'package:boxch/main/screens/settings_screens/settings_screen.dart';
import 'package:boxch/main/screens/webview_screen.dart';
import 'package:boxch/utils/config.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:boxch/widgets/custom_shimmer.dart';
import 'package:boxch/widgets/main_item.dart';
import 'package:boxch/widgets/mdivider.dart';
import 'package:boxch/widgets/notification_button.dart';
import 'package:flutter/material.dart';
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
  MainScreen({Key? key}) : super(key: key);

  final String address = Hive.box(walletBox).get(boxCurrentWalletKey).publicKey;

  @override
  Widget build(BuildContext context) {
    final MainCubit cubit = context.read<MainCubit>();
    return BlocBuilder<MainCubit, MainStates>(builder: (context, state) {
      if (state is LoadingMainScreenState) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150.0),
              child: Container(
                height: 140.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CustomShimmer(
                          radius: 50.0,
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        CustomShimmer(
                          radius: 20.0,
                          child: Container(
                            height: 25.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        )
                      ],
                    ),
                    CustomShimmer(
                      radius: 50.0,
                      child: Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomShimmer(
                            child: Container(
                              height: 20.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          CustomShimmer(
                            radius: 5.0,
                            child: Container(
                              height: 45.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 70.0,
                        width: 50.0,
                        alignment: Alignment.topLeft,
                        child: CustomShimmer(
                          radius: 50.0,
                          child: Container(
                            height: 25.0,
                            width: 30.0,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 26.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 65.0,
                      width: 65.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                    ),
                    Container(
                      height: 65.0,
                      width: 65.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                    ),
                    Container(
                      height: 65.0,
                      width: 65.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 20.0,
                        width: 50.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                )
              ],
            ));
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomInkWell(
                              onTap: () =>
                                  replaceWindow(context, SettingsScreen()),
                              child: Container(
                                height: 35.0,
                                width: 35.0,
                                alignment: Alignment.center,
                                child: Icon(Iconsax.menu5,
                                    size: 20.0,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.5)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            CustomInkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: address))
                                    .then((result) {
                                  okCopyToast(context);
                                });
                              },
                              child: Text(
                                  "${address.substring(0, 4)}. . .${address.substring(address.length - 7, address.length)}",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Theme.of(context).cardColor)),
                            ),
                          ],
                        ),
                        NotificationButton(),
                      ],
                    )
                  ]),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(220.0),
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
                                        fontSize: 11.0,
                                        color: Theme.of(context).hintColor),
                                  ),
                                  SizedBox(height: 4.0),
                                  state.totalBalance == "*,**"
                                      ? Text(state.totalBalance,
                                          style: TextStyle(
                                              fontSize: 36.0,
                                              color:
                                                  Theme.of(context).cardColor))
                                      : Countup(
                                          precision: 2,
                                          prefix: "\$",
                                          begin: state.totalBalance -
                                              (state.totalBalance / 100 * 20),
                                          end: state.totalBalance,
                                          separator: ",",
                                          duration:
                                              Duration(milliseconds: 1500),
                                          style: TextStyle(
                                              fontSize: 36.0,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
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
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MainMenu(
                            icon: Iconsax.arrow_down,
                            onTap: () => receiveBottomSheet(context),
                            text: "Receive",
                          ),
                          MainMenu(
                            icon: Iconsax.arrow_up_3,
                            onTap: () => replaceWindow(context,
                                ChooseTokensScreen(tokens: state.tokens)),
                            text: "Send",
                          ),
                          MainMenu(
                            icon: Iconsax.card,
                            onTap: () => tradingMethods(context),
                            text: "Buy",
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
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
                      SizedBox(height: 32.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('tokensText'.tr,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).cardColor)),
                      ),
                      SizedBox(height: 8.0),
                      state.tokens.isEmpty
                          ? Expanded(
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 8.0),
                                          Image.asset(
                                              "assets/images/cryptos.png",
                                              height: 70.0,
                                              width: 70.0),
                                          SizedBox(height: 16.0),
                                          Text(
                                              "yourTokensWillAppearHereText".tr,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                          SizedBox(height: 16.0),
                                          CustomInkWell(
                                              onTap: () =>
                                                  tradingMethods(context),
                                              child: Text("buyCryptoText".tr,
                                                  style: TextStyle(
                                                      color: Colors.amber))),
                                          SizedBox(height: 16.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: state.tokens.length,
                                itemBuilder: (context, index) {
                                  return TokenListTile(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      onPressed: () => replaceWindow(
                                          context,
                                          BlocProvider<HistoryCubit>(
                                              create: (context) => HistoryCubit(
                                                  state: state
                                                      .tokens[index].address),
                                              child: HistoryTransactionsScreen(
                                                  mint: state
                                                      .tokens[index].address!,
                                                  balance: state
                                                      .tokens[index].usdBalance,
                                                  amount: state.tokens[index]
                                                      .balance!))),
                                      image: state.tokens[index].image,
                                      title: state.tokens[index].symbol ??
                                          "unknown",
                                      trailingTitle: state.hideBalanceState
                                          ? '*'
                                          : '${state.tokens[index].balance}',
                                      trailingSubtitle: state.hideBalanceState
                                          ? '-'
                                          : '\$${state.tokens[index].usdBalance}');
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return Container();
    });
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
            height: 180.0,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => replaceWindow(
                            context,
                            WebviewScreen(
                                urlLink:
                                    "https://buy.onramper.com/?wallets=SOL:${wallet.address}&API_KEY=pk_prod_puiFMHyFkJpStdWO1jV2HtmhMk37Esi4oeBmB0BxNAY0&defaultCrypto=SOL&themeName=${context.isDarkMode ? "dark" : "ligth"}&borderRadius=0.5&wgBorderRadius=2")),
                        title: Text("OnRamper"),
                        subtitle: Text(
                            "Aggregator of cryptocurrency payment services",
                            style: TextStyle(fontSize: 11.0)),
                        leading: Image.asset("assets/images/onramper.png",
                            height: 40.0, width: 40.0),
                      ),
                      Mdivider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                            "If this method does not suit you, buy cryptocurrency on the exchange Binance, OKEX, Kucoin etc. We are already working on adding other payment methods.",
                            style: TextStyle(
                                fontSize: 9.0,
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5))),
                      )
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

  receiveBottomSheet(BuildContext context) {
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
                      color: Theme.of(context).primaryColor),
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
