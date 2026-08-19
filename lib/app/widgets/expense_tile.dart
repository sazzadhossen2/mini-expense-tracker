import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_outlined;
      case 'Transport':
        return Icons.directions_bus_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Bills':
        return Icons.receipt_long_outlined;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Health':
        return Icons.favorite_outline;
      case 'Education':
        return Icons.school_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(symbol: '\$');
    final dateStr = DateFormat('MMM d, yyyy').format(expense.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
          child: Icon(_categoryIcon(expense.category),
              color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(expense.category,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          expense.note != null && expense.note!.isNotEmpty
              ? '${expense.note}\n$dateStr'
              : dateStr,
        ),
        isThreeLine: expense.note != null && expense.note!.isNotEmpty,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currency.format(expense.amount),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            if (onDelete != null)
              InkWell(
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.delete_outline,
                      size: 18, color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
