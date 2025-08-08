import 'package:get/get.dart';
import 'package:modular_yoga_session_app/controllers/supabase_controller.dart';
import 'package:modular_yoga_session_app/pages/homePage/home_page.dart';
import 'package:modular_yoga_session_app/pages/upload/upload.dart';

class SplashController extends GetxController {
  SupabaseController supabaseController=Get.put(SupabaseController());

  void onInit() {
    super.onInit();
    splashHandle();
  }

  Future<void> splashHandle() async{
    await Future.delayed(Duration(seconds: 3),);
    // Get.showSnackbar(GetSnackBar(message: SupabaseController.jsonUrl.value ?? '',));
    print(supabaseController.jsonUrls);
    
    if(supabaseController.jsonUrls.length!=0){
      Get.offAll(HomePage());
    } else{
      Get.offAll(Upload());
    }

  }
}