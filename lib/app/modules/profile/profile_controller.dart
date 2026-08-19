import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../auth/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  UserModel? get userProfile => _authController.userProfile.value;
  User? get firebaseUser => _authController.firebaseUser.value;

  final RxBool isLoggingOut = false.obs;

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await _authController.logout();
      // Navigation to Login is handled centrally by AuthController.
    } finally {
      isLoggingOut.value = false;
    }
  }
}
