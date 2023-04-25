import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/models/transaction.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:boxch/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final MainCubit mainCubit;
  final String mint;
  const TransactionHistoryScreen({super.key, required this.mainCubit, required this.mint});

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
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
      body: FutureBuilder<List<TransactionHistory>>(
        future: mainCubit.getTransactionHistory(mint: mint),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CustomShimmer(
                          radius: 100.0,
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        CustomShimmer(
                          radius: 5.0,
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ); 
                });
            }

            if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                      return CustomInkWell(
                        onTap: () async => await launchUrl(Uri.parse("https://solscan.io/tx/${snapshot.data![index].signature}")),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.greenAccent),
                                SizedBox(width: 16.0),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${snapshot.data![index].signature.toString().substring(0, 35)}...",
                                    style: TextStyle(fontSize: 12.0, color: Theme.of(context).cardColor)),
                                    Text(snapshot.data![index].data.toString()
                                    .replaceRange(snapshot.data![index].data.toString().length - 4,
                                     snapshot.data![index].data.toString().length, '')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ); 
                  });
            }

            return SizedBox();
        }),
    );
  }
}