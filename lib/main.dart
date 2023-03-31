import 'dart:io';
import 'package:boxch/landing.dart';
import 'package:boxch/models/wallet.dart';
import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'utils/config.dart';
import 'package:boxch/translate/locale_string.dart';
import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/theme/theme_cubit.dart';
import 'package:boxch/theme/theme_states.dart';
import 'package:boxch/theme/themes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCKHw9b6VNf6hmtJnbnp43Ivqehc-rqZYY",
            appId: "1:323388584315:ios:8f7f7b211066398e95cdde",
            messagingSenderId: "323388584315",
            projectId: "boxch-31c17"));
  } else {
    await Firebase.initializeApp();
  }

  var path = Directory.systemTemp.path;
  Hive.registerAdapter(LocalWalletAdapter());
  Hive..init(path);
  
  await Hive.openBox(boxPassword);
  await Hive.openBox(walletBox);
  await Hive.openBox(mainBox);

  if (Hive.box(walletBox).isNotEmpty) {
    final LocalWallet current = Hive.box(walletBox).get(boxCurrentWalletKey);
    wallet = await Wallet.fromMnemonic(current.secretKey);
  }

  runApp(BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    state.ligthTheme ? Brightness.dark : Brightness.light));
                    List<String> lan = Hive.box(mainBox).get(boxLanguageKey) ?? [];
            return OKToast(
              position: ToastPosition.top,
                child: BlocProvider<StartCubit>(
                  create: (context) => StartCubit(),
                    child:  BlocProvider<MainCubit>(
                      create: (context) => MainCubit(context),
                        child:  GetMaterialApp(
                            locale: (lan.isNotEmpty) ? Locale(lan.first, lan.last) : Locale('en', 'US'),
                            translations: LocaleString(),
                            theme: state.ligthTheme
                              ? apptheme[AppTheme.ligth]
                              : apptheme[AppTheme.dark],
                          debugShowCheckedModeBanner: false,
                      home: Landing()),
                ),
              )
          );
        },
      ),
    ));
}
