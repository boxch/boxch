import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum AppIcon { ligthIcon, darkIcon }

final appicon = {
  AppIcon.ligthIcon: Icon(Iconsax.moon, color: Colors.black),
  AppIcon.darkIcon: Icon(Iconsax.sun_1, color: Colors.amber),
};