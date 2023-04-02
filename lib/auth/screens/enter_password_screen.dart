import 'package:boxch/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPasswordScreen extends StatelessWidget {
  final bool error;
  EnterPasswordScreen({ Key? key, required this.error}) : super(key: key);

  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text("Boxch.net", style: TextStyle(fontSize: 16.0, color: Theme.of(context).hintColor)),
        elevation: 0.0,
      ),
      body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("assets/images/boxch_welcome.png", height: 100.0, width: 100.0),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                                height: 60.0,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  onSubmitted: (value) => cubit.checkPassword(password: _controllerPassword.text),
                                  controller: _controllerPassword,
                                  style: const TextStyle(
                                      fontSize: 21.0, fontWeight: FontWeight.bold),
                                      obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                      hintStyle: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w100),
                                          filled: true,
                                          errorText: error ? "" : null,
                                          errorStyle: const TextStyle(fontSize: 0.01),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 1.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          )),),
                                ),
                              ),
                        const SizedBox(height: 16.0),
                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: CustomInkWell(
                        //     onTap: () => cubit.checkPassword(password: _controllerPassword.text),
                        //     child: Container(
                        //       height: 55.0,
                        //       width: MediaQuery.of(context).size.width,
                        //       alignment: Alignment.center,
                        //       child: Text("Unlock", style: TextStyle(color: Theme.of(context).cardColor, fontSize: 16.0)),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5.0),
                        //         color: Theme.of(context).primaryColor,
                        //         border: Border.all(color: Theme.of(context).hintColor, width: 0.1)
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          // onTap: () => cubit.resetPassword(privateKey: privateKey),
                          child: Text("Forgot password", style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5))),
                        ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}