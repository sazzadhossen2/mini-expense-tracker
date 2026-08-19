import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.savings_outlined,
                      size: 56, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome back',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Log in to ${AppConstants.appName}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 28),
                  Obx(
                    () => CustomButton(
                      label: 'Log In',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: theme.textTheme.bodyMedium),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.register),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
