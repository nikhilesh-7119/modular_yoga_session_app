import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickFilesController extends GetxController {


  Future<Map<String, dynamic>?> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'ogg'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final Uint8List? fileBytes = file.bytes;
      final String fileName = file.name;

      if (fileBytes != null) {
        return {'name': fileName, 'bytes': fileBytes};
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      final Uint8List bytes = await imageFile.readAsBytes();
      final String fileName = imageFile.name;

      return {'name': fileName, 'bytes': bytes};
    }

    return null;
  }

  Future<File?> pickJsonFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
