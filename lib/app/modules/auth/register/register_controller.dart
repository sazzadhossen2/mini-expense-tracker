import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;
  void toggleObscureConfirm() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authRepo.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration failed', _mapError(e.code),
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
