import 'package:boxch/main/screens/notifications_screen.dart';
import 'package:boxch/utils/functions.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationButton extends StatelessWidget {
  final String? numberOfNotifications;
  const NotificationButton({Key? key, this.numberOfNotifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: () => replaceWindow(context, NotificationsScreen()),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 35.0,
            width: 35.0,
            alignment: Alignment.center,
            child: Icon(Iconsax.notification5,
                size: 20.0, color: Theme.of(context).hintColor.withOpacity(0.5)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
          ),
         numberOfNotifications != null ? SizedBox(height: 13.0, width: 13.0, child: CircleAvatar(child: Text(numberOfNotifications!, style: TextStyle(fontSize: 9.0)), backgroundColor: Colors.amber)) : SizedBox()
        ],
      ),
    );
  }
}
