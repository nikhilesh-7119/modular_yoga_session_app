import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modular_yoga_session_app/models/json_model.dart';

class JsonFileController extends GetxController {
  final String jsonUrl;
  JsonFileController(this.jsonUrl);
  
  var jsonModel = Rxn<JsonModel>();
  RxBool isLoading=false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value=true;
    print("🌀 onInit triggered");
    loadJson();
    isLoading.value=false;
  }

  void loadJson() async {
    // final url = supabaseController.jsonUrl.value;
    // print("🌐 Fetching from URL: $url");

    try {
      final fetched = await fetchJsonFromUrl(jsonUrl);
      print("✅ JSON fetched successfully");
      jsonModel.value = fetched;
    } catch (e) {
      print("❌ Error fetching JSON: $e");
    }
  }

  Future<JsonModel> fetchJsonFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    print("📦 Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return JsonModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load JSON file from $url');
    }
  }
}


// class JsonFileController extends GetxController {
//   SupabaseController supabaseController=Get.put(SupabaseController());
//   JsonModel? jsonModel;

//   onInit() async{
//     super.onInit();
//     jsonModel=await fetchJsonFromUrl(supabaseController.jsonUrl.value);
//   }



//   Future<JsonModel> fetchJsonFromUrl(String url) async {
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonMap = json.decode(response.body);
//       return JsonModel.fromJson(jsonMap);
//     } else {
//       throw Exception('Failed to load JSON file from $url');
//     }
//   }
// }