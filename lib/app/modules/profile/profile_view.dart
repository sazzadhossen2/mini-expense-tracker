import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/theme_controller.dart';
import '../../widgets/custom_button.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.put(ThemeController(), permanent: true);

    final name = controller.userProfile?.name ??
        controller.firebaseUser?.displayName ??
        'User';
    final email = controller.userProfile?.email ??
        controller.firebaseUser?.email ??
        '';
    final joined = controller.userProfile != null
        ? DateFormat('MMM yyyy').format(controller.userProfile!.createdAt)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(name, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                email,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),
                  if (joined != null)
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Member since'),
                      subtitle: Text(joined),
                    ),
                  Obx(
                    () => SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Dark mode'),
                      value: themeController.themeMode.value == ThemeMode.dark,
                      onChanged: themeController.toggleDarkMode,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                label: 'Log Out',
                icon: Icons.logout,
                outlined: true,
                isLoading: controller.isLoggingOut.value,
                onPressed: controller.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
