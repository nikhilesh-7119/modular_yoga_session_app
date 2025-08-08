import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/images.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseController extends GetxController {
  final RxList<String> jsonUrls = <String>[].obs;
  final store = Supabase.instance.client;

  @override
  void onInit() async {
    super.onInit();
    await getAvailableJsonAtStarting();
  }

  Future<void> getAvailableJsonAtStarting() async {
    try {
      final files = await store.storage
          .from('yoga-json-file')
          .list(path: 'jsonFiles');

      final allJsonUrls = files
          .where((file) => file.name.endsWith('.json'))
          .map((file) =>
              store.storage.from('yoga-json-file').getPublicUrl('jsonFiles/${file.name}'))
          .toList();

      jsonUrls.assignAll(allJsonUrls); 
      print("✅ All JSON files loaded: ${jsonUrls.length}");
    } catch (e) {
      print('❌ Error fetching JSON list: $e');
      jsonUrls.clear(); // clear if error happens
    }
  }

  Future<void> uploadFileToSupabase(File file) async {
    final newFileName = 'jsonFiles/${file.path.split('/').last}';

    try {
      await store.storage
          .from('yoga-json-file')
          .upload(newFileName, file, fileOptions: const FileOptions(upsert: true));

      print('✅ File uploaded: $newFileName');

      // 🔁 Refresh the entire list including new file
      await getAvailableJsonAtStarting();
    } catch (e) {
      print('❌ Error uploading file: $e');
    }
  }


  // onInit() async {
  //   super.onInit();
  //   bool answer = await doesJsonFileExist();
  //   if (answer == true) {
  //     await getPublicUrlAtStarting();
  //   } else {
  //     jsonUrl.value = '';
  //   }
  // }

  // Future<bool> doesJsonFileExist() async {
  //   try {
  //     await Supabase.instance.client.storage
  //         .from('yoga-json-file')
  //         .download('myJson');

  //     return true;
  //   } catch (e) {
  //     print("File not found: $e");
  //     return false;
  //   }
  // }

  // Future<void> uploadFileToSupabase(File file) async {
  //   final newFileName='jsonFiles/${file.path.split('/').last}';
  //   try {
  //     await store.storage
  //         .from('yoga-json-file')
  //         .upload(newFileName, file, fileOptions: const FileOptions(upsert: true));
  //     final downloadUrl = store.storage
  //         .from('yoga-json-file')
  //         .getPublicUrl(newFileName);
  //     jsonUrl.value = downloadUrl;
  //   } catch (e) {
  //     print(e.toString() + '😂😂😂😂😂');
  //   }
  // }

  // Future<void> getPublicUrlAtStarting() async {
  //   try {
  //     jsonUrl.value = await store.storage
  //         .from('yoga-json-file')
  //         .getPublicUrl(fileName);
  //   } catch (e) {
  //     print(e.toString() + '😂😂😂');
  //   }
  // }

  Future<void> uploadImageToSupabase(
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      String newFileName = 'images/' + fileName;
      final response = await store.storage
          .from('imagefiles')
          .uploadBinary(
            newFileName,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );
    } catch (e) {
      print(e.toString() + 'imagetosupabase');
    }
  }

  Future<String> getImageUrlFromSupabase(String fileName) async {
    if(fileName==null || fileName=='')
    return AssetsClass.defaultImageUrl;

    try {
      final path = 'images/$fileName';
      final files = await store.storage
          .from('imagefiles')
          .list(path: 'images');

      final exists = files.any((file) => file.name == fileName);

      if (exists) {
        return store.storage.from('imagefiles').getPublicUrl(path);
      } else {
        return AssetsClass.defaultImageUrl;
      }
    } catch (e) {
      print('Error checking file: $e');
      return AssetsClass.defaultImageUrl;
    }
  }

  Future<void> uploadAudioToSupabase(
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      final String filePath = 'audios/$fileName';

      final response = await store.storage
          .from('audiosfiles')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'audio/mpeg',
            ),
          );

      print('✅ Audio uploaded at path: $filePath');
    } catch (e) {
      print('❌ Error uploading audio: $e');
    }
  }

  Future<String> getAudioUrlFromSupabase(String fileName) async {
    if(fileName==null || fileName=='')
    return AssetsClass.defaultAudioUrl;

    try {
      final String folder = 'audios';
      final String path = '$folder/$fileName';
      final files = await store.storage
          .from('audiosfiles')
          .list(path: folder);
      final exists = files.any((file) => file.name == fileName);

      if (exists) {
        return store.storage.from('audiosfiles').getPublicUrl(path);
      } else {
        return AssetsClass.defaultAudioUrl;
      }
    } catch (e) {
      print('❌ Error retrieving audio: $e');
      return AssetsClass.defaultAudioUrl;
    }
  }

}
