import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/expense_model.dart';
import '../../../data/providers/expense_repository.dart';
import '../../auth/auth_controller.dart';

class ExpenseListController extends GetxController {
  final ExpenseRepository _expenseRepo = Get.find<ExpenseRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ExpenseModel> allExpenses = <ExpenseModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  StreamSubscription<List<ExpenseModel>>? _subscription;

  List<ExpenseModel> get filteredExpenses {
    return allExpenses.where((e) {
      final matchesCategory = selectedCategory.value == 'All' ||
          e.category == selectedCategory.value;
      final query = searchQuery.value.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          e.category.toLowerCase().contains(query) ||
          (e.note?.toLowerCase().contains(query) ?? false);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void _listen() {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    _subscription = _expenseRepo.streamExpenses(uid).listen(
      (data) {
        allExpenses.value = data;
        isLoading.value = false;
      },
      onError: (_) {
        isLoading.value = false;
        errorMessage.value = 'Failed to load your expenses. Pull down to retry.';
      },
    );
  }

  Future<void> refresh() async {
    await _subscription?.cancel();
    _listen();
  }

  void setCategory(String category) => selectedCategory.value = category;
  void setSearch(String query) => searchQuery.value = query;

  Future<void> deleteExpense(String id) async {
    try {
      await _expenseRepo.deleteExpense(id);
      Get.snackbar('Deleted', 'Expense removed successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to delete expense. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
