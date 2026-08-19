import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/auth_repository.dart';
import '../../routes/app_routes.dart';
class AuthController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<UserModel> userProfile = Rxn<UserModel>();
  final RxBool isReady = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_authRepo.authStateChanges);
    ever(firebaseUser, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      userProfile.value = null;
      isReady.value = true;
      Get.offAllNamed(Routes.login);
      return;
    }

    userProfile.value = await _authRepo.fetchUserProfile(user.uid);
    isReady.value = true;
    Get.offAllNamed(Routes.home);
  }

  Future<void> logout() => _authRepo.logout();
}
