
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/controllers/supabase_controller.dart';
import 'package:modular_yoga_session_app/models/assets_model.dart';
import 'package:modular_yoga_session_app/models/json_model.dart';

class AssetsController extends GetxController {
  final Rxn<JsonModel> jsonModel ;
  AssetsController(this.jsonModel);
  SupabaseController supabaseController = Get.put(SupabaseController());

  var assetsModel = Rxn<AssetsModel>();
  RxBool isLoading=false.obs;

  @override
  void onInit() {
    isLoading.value=true;
    super.onInit();
    waitForJsonModel();
    isLoading.value=false;
  }

  void waitForJsonModel() async {
    while (jsonModel.value == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // initializeAudiosToAssetsModel();
    initializeImagesToAssetsModel();
  }

  void initializeImagesToAssetsModel() async {
    // final jsonModel = jsonFileController.jsonModel.value;
    if (jsonModel == null || jsonModel.value!.assets?.images == null) return;

    final originalAssets = jsonModel.value!.assets!;
    Map<String, String> updatedImage = {};

    for (final entry in originalAssets.images!.entries) {
      final String key = entry.key;
      final String fileName = entry.value;

      final String url = await supabaseController.getImageUrlFromSupabase(
        fileName,
      );
      updatedImage[key] = url;
    }


    Map<String, String> updatedAudio = {};

    for (final entry in originalAssets.audio!.entries) {
      final String key = entry.key;
      final String fileName = entry.value;

      final String? url = await supabaseController.getAudioUrlFromSupabase(
        fileName,
      );
      if (url != null) {
        updatedAudio[key] = url;
      }
    }


    assetsModel.value = AssetsModel(
      images: updatedImage,
      audio: updatedAudio,
    );
  }
}

//   void initializeAudiosToAssetsModel() async {
//     // final jsonModel = jsonFileController.jsonModel.value;
//     if (jsonModel == null || jsonModel.value!.assets?.audio == null) return;

//     final originalAssets = jsonModel.value!.assets!;
//     Map<String, String> updatedAudio = {};

//     for (final entry in originalAssets.audio!.entries) {
//       final String key = entry.key;
//       final String fileName = entry.value;

//       final String? url = await supabaseController.getAudioUrlFromSupabase(
//         fileName,
//       );
//       if (url != null) {
//         updatedAudio[key] = url;
//       }
//     }

//     assetsModel.value = AssetsModel(
//       images: originalAssets.images,
//       audio: updatedAudio,
//     );
//   }
// }
