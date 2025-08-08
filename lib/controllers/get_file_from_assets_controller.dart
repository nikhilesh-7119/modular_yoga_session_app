import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/images.dart';

class GetFileFromAssetsController extends GetxController{

  String getUrlFromAsset(Map<String,String> asset,String key,String type){
    if(!asset.containsKey(key)){
      if(type=='audio'){
        return AssetsClass.defaultAudioUrl;
      } else{
        return AssetsClass.defaultImageUrl;
      }
    }
    return asset[key]!;
  }
  
}