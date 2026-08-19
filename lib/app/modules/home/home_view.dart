import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_state_widget.dart';
import '../../widgets/expense_tile.dart';
import '../../widgets/loading_widget.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed(Routes.profile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.addExpense),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading your expenses...');
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: controller.refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Expense',
                      value: currency.format(controller.totalExpense),
                      color: theme.colorScheme.primary,
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'This Month',
                      value: currency.format(controller.currentMonthTotal),
                      color: theme.colorScheme.tertiary,
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Expenses', style: theme.textTheme.titleMedium),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.expenseList),
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (controller.recentExpenses.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: EmptyStateWidget(
                    title: 'No expenses yet',
                    message:
                        'Tap "Add Expense" below to log your first expense.',
                  ),
                )
              else
                ...controller.recentExpenses
                    .map((e) => ExpenseTile(expense: e)),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline)),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
