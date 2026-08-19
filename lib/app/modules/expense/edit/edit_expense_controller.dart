import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/providers/expense_repository.dart';

class EditExpenseController extends GetxController {
  final ExpenseRepository _expenseRepo = Get.find<ExpenseRepository>();

  late final ExpenseModel originalExpense;

  final formKey = GlobalKey<FormState>();
  late final TextEditingController amountCtrl;
  late final TextEditingController noteCtrl;

  final Rxn<String> selectedCategory = Rxn<String>();
  late final Rx<DateTime> selectedDate;
  final RxBool isSaving = false.obs;
  final RxString categoryError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    originalExpense = Get.arguments as ExpenseModel;
    amountCtrl =
        TextEditingController(text: originalExpense.amount.toString());
    noteCtrl = TextEditingController(text: originalExpense.note ?? '');
    selectedCategory.value = originalExpense.category;
    selectedDate = originalExpense.date.obs;
  }

  void setCategory(String? category) {
    selectedCategory.value = category;
    categoryError.value = '';
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> saveExpense() async {
    final formValid = formKey.currentState!.validate();
    if (selectedCategory.value == null) {
      categoryError.value = 'Please select a category';
    }
    if (!formValid || selectedCategory.value == null) return;

    isSaving.value = true;
    try {
      final updated = originalExpense.copyWith(
        amount: double.parse(amountCtrl.text.trim()),
        category: selectedCategory.value!,
        date: selectedDate.value,
        note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
        updatedAt: DateTime.now(),
      );
      await _expenseRepo.updateExpense(updated);
      Get.back();
      Get.snackbar('Success', 'Expense updated successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to update expense. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }
}
