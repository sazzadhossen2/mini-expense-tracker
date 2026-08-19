import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Let\'s get you set up',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: controller.nameCtrl,
                  label: 'Full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) => Validators.required(v, 'Name'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.emailCtrl,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordCtrl,
                    label: 'Password',
                    obscureText: controller.obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscurePassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: controller.toggleObscure,
                    ),
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CustomTextField(
                    controller: controller.confirmPasswordCtrl,
                    label: 'Confirm password',
                    obscureText: controller.obscureConfirmPassword.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscureConfirmPassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: controller.toggleObscureConfirm,
                    ),
                    validator: (v) => Validators.confirmPassword(
                        v, controller.passwordCtrl.text),
                  ),
                ),
                const SizedBox(height: 28),
                Obx(
                  () => CustomButton(
                    label: 'Create account',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Back to login',
                  outlined: true,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
