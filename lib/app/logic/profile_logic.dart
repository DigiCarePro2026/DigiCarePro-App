import 'package:digi_care_pro/app/data/models/profile.dart';
import 'package:digi_care_pro/app/data/repositories/account_repository.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileLogic extends GetxController{

  late Profile profile;


  @override
  onInit(){
    super.onInit();

    _fetchProfile();
  }

  _fetchProfile(){
    profile = AccountRepository.get().fetchProfile();

    update();
  }

  logout(){
    AccountRepository.get().logout();

    Get.offAllNamed(Routes.LOGIN);
  }
}