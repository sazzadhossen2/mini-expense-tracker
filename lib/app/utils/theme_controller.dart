import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void toggleDarkMode(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }
}
