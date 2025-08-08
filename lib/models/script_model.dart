class ScriptModel {
  String? text;
  int? startSec;
  int? endSec;
  String? imageRef;

  ScriptModel({this.endSec,this.imageRef,this.startSec,this.text});

  ScriptModel.fromJson(Map<String,dynamic> script){
    text=script['text'];
    startSec=script['startSec'];
    endSec=script['endSec'];
    imageRef=script['imageRef'];
  }
}