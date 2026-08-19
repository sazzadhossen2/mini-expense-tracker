import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/expense_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../widgets/expense_tile.dart';
import '../../../widgets/loading_widget.dart';
import 'expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  const ExpenseListView({super.key});

  Future<void> _confirmDelete(BuildContext context, ExpenseModel expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text(
          'This will permanently delete the "${expense.category}" expense of \$${expense.amount.toStringAsFixed(2)}.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      controller.deleteExpense(expense.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Expenses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: controller.setSearch,
              decoration: const InputDecoration(
                hintText: 'Search by category or note...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 40,
            child: Obx(() {
              final selected = controller.selectedCategory.value;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category =
                  index == 0 ? 'All' : AppConstants.categories[index - 1];
                  final isSelected = selected == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => controller.setCategory(category),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget(message: 'Loading expenses...');
              }
              if (controller.errorMessage.value.isNotEmpty) {
                return ErrorStateWidget(
                  message: controller.errorMessage.value,
                  onRetry: controller.refresh,
                );
              }

              final expenses = controller.filteredExpenses;
              if (expenses.isEmpty) {
                return const EmptyStateWidget(
                  title: 'No expenses found',
                  message: 'Try a different category or search term.',
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ExpenseTile(
                      expense: expense,
                      onTap: () => Get.toNamed(Routes.editExpense,
                          arguments: expense),
                      onDelete: () => _confirmDelete(context, expense),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
