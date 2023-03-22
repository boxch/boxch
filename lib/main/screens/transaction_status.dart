import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TransactionStatusScreen extends StatelessWidget {
  const TransactionStatusScreen({ Key? key }) : super(key: key);

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
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
    );
  }
}