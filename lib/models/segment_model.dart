import 'package:modular_yoga_session_app/models/script_model.dart';

class SegmentModel {
  String? type;
  String? name;
  String? audioRef;
  int? durationSec;
  // int? iterations;
  List<ScriptModel>? scripts;

  SegmentModel({this.audioRef,this.durationSec,this.name,this.scripts,this.type});

  SegmentModel.fromJson(Map<String,dynamic> segment){
    type=segment['type'];
    name=segment['name'];
    audioRef=segment['audioRef'];
    durationSec=segment['durationSec'];
    // iterations= segment['iterations'] != null ? segment['iterations'] : 0;
    scripts=(segment['script'] as List).map((e)=>ScriptModel.fromJson(e)).toList();
  }
}