import 'package:boxch/auth/cubit/auth_cubit.dart';
import 'package:boxch/auth/cubit/auth_states.dart';
import 'package:boxch/auth/screens/enter_password_screen.dart';
import 'package:boxch/auth/screens/create_password_screen.dart';
import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/main/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        
        if (state is EnterPasswordState) {
          return EnterPasswordScreen(error: state.error);
        }

        if (state is CreatePasswordState) {
          return CreatePasswordScreen(message: state.message ?? "");
        }


        if (state is ValidPasswordState) {
          return BlocProvider<MainCubit>(
            create: (context) => MainCubit(state),
            child: MainScreen());
        }

        return Container();
    });
  }
}