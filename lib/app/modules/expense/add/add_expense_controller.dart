import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/expense_model.dart';
import '../../../data/providers/expense_repository.dart';
import '../../auth/auth_controller.dart';

class AddExpenseController extends GetxController {
  final ExpenseRepository _expenseRepo = Get.find<ExpenseRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  final Rxn<String> selectedCategory = Rxn<String>();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isSaving = false.obs;
  final RxString categoryError = ''.obs;

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

    if (selectedCategory.value == null) {
      categoryError.value = 'Please select a category';
    } else {
      categoryError.value = '';
    }

    final formValid = formKey.currentState!.validate();
    if (!formValid || selectedCategory.value == null) return;

    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'You must be signed in to add an expense.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSaving.value = true;
    try {
      final now = DateTime.now();
      final expense = ExpenseModel(
        id: '',
        userId: uid,
        amount: double.parse(amountCtrl.text.trim()),
        category: selectedCategory.value!,
        date: selectedDate.value,
        note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await _expenseRepo.addExpense(expense);
      Get.back();
      Get.snackbar('Success', 'Expense added successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to save expense. Please try again.',
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