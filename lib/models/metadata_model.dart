class MetadataModel {
  String? id;
  String? title;
  String? category;
  int? defaultLoopCount;
  String? tempo;

  MetadataModel({this.category,this.defaultLoopCount,this.id,this.tempo,this.title});

  MetadataModel.fromJson(Map<String,dynamic> metadata){
    id=metadata['id'];
    title=metadata['title'];
    category=metadata['category'];
    defaultLoopCount=metadata['defaultLoopCount'];
    tempo=metadata['tempo'];
  }
}