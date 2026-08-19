import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'add_expense_controller.dart';

class AddExpenseView extends GetView<AddExpenseController> {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: controller.amountCtrl,
                  label: 'Amount',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: Validators.amount,
                ),
                const SizedBox(height: 16),
                Text('Category', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.categories.map((category) {
                      final selected =
                          controller.selectedCategory.value == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) => controller.setCategory(category),
                      );
                    }).toList(),
                  ),
                ),
                Obx(
                  () => controller.categoryError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            controller.categoryError.value,
                            style: TextStyle(
                                color: theme.colorScheme.error, fontSize: 12),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                Text('Date', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Obx(
                  () => InkWell(
                    onTap: () => controller.pickDate(context),
                    borderRadius: BorderRadius.circular(14),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        DateFormat('MMM d, yyyy')
                            .format(controller.selectedDate.value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.noteCtrl,
                  label: 'Note (optional)',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                Obx(
                  () => CustomButton(
                    label: 'Save Expense',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveExpense,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
