import 'package:get/get.dart';

import '../modules/auth/login/login_view.dart';
import '../modules/auth/login/login_controller.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/auth/register/register_controller.dart';
import '../modules/auth/splash/splash_view.dart';
import '../modules/expense/add/add_expense_view.dart';
import '../modules/expense/add/add_expense_controller.dart';
import '../modules/expense/edit/edit_expense_view.dart';
import '../modules/expense/edit/edit_expense_controller.dart';
import '../modules/expense/list/expense_list_view.dart';
import '../modules/expense/list/expense_list_controller.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_controller.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/profile_controller.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => RegisterController())),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
    ),
    GetPage(
      name: Routes.expenseList,
      page: () => const ExpenseListView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => ExpenseListController())),
    ),
    GetPage(
      name: Routes.addExpense,
      page: () => const AddExpenseView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => AddExpenseController())),
    ),
    GetPage(
      name: Routes.editExpense,
      page: () => const EditExpenseView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => EditExpenseController())),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ProfileController())),
    ),
  ];
}
