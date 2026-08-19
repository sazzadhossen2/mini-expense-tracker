import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(AppConstants.appName, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
