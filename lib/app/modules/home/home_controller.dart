import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/expense_model.dart';
import '../../data/providers/expense_repository.dart';
import '../auth/auth_controller.dart';

class HomeController extends GetxController {
  final ExpenseRepository _expenseRepo = Get.find<ExpenseRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<List<ExpenseModel>>? _subscription;

  double get totalExpense =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get currentMonthTotal {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<ExpenseModel> get recentExpenses => expenses.take(5).toList();

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
        expenses.value = data;
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

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
