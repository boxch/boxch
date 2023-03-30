import 'package:boxch/auth/cubit/auth_cubit.dart';
import 'package:boxch/auth/screens/enter_password_screen.dart';
import 'package:boxch/auth/screens/password_screen.dart';
import 'package:boxch/theme/theme_cubit.dart';
import 'package:boxch/theme/theme_states.dart';
import 'package:boxch/theme/themes.dart';
import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/start/cubit/start_states.dart';
import 'package:boxch/start/screens/create_wallet_screen.dart';
import 'package:boxch/start/screens/first_screen.dart';
import 'package:boxch/start/screens/restore_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

class Landing extends StatelessWidget {
  const Landing({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
            return OKToast(
              position: ToastPosition.center,
                child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.ligthTheme
                              ? apptheme[AppTheme.ligth]
                              : apptheme[AppTheme.dark],
              home: BlocProvider<StartCubit>(
                create: (context) => StartCubit(),
                child: BlocBuilder<StartCubit, StartStates>(
                  builder: (context, state) {

                    if (state is FirstScreenStartState) {
                      return const StartScreen();
                    }

                    if (state is CreateWalletStartState) {
                      return CreateWalletScreen(mnemonic: state.mnemonic);
                    }

                    if (state is RestoreWalletStartState) {
                      return RestoreWalletScreen();
                    }

                    if (state is AuthScreenStartState) {
                      return BlocProvider<AuthCubit>(
                        create: (context) => AuthCubit(),
                        child: PasswordScreen());
                    }


                    return Container();
                  },
                ))));
        }));
  }
}