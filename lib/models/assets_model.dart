class AssetsModel {
  Map<String, String>? images;
  Map<String, String>? audio;

  AssetsModel({this.audio, this.images});

  // AssetsModel.fromJson(Map<String,dynamic> assets){
  //   images=assets['images'];
  //   audio=assets['audio'];
  // }

  AssetsModel.fromJson(Map<String, dynamic> assets) {
    images = Map<String, String>.from(assets['images'] ?? {});
    audio = Map<String, String>.from(assets['audio'] ?? {});
  }
}
