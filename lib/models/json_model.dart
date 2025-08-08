import 'package:modular_yoga_session_app/models/assets_model.dart';
import 'package:modular_yoga_session_app/models/metadata_model.dart';
import 'package:modular_yoga_session_app/models/segment_model.dart';

class JsonModel {
  MetadataModel? metadata;
  AssetsModel? assets;
  List<SegmentModel>? sequence;

  JsonModel({this.assets,this.metadata,this.sequence});

  JsonModel.fromJson(Map<String,dynamic> json){
    // metadata=json['metadata'];
    // assets=json['assets'];

    metadata = MetadataModel.fromJson(json['metadata']);
    assets = AssetsModel.fromJson(json['assets']);
    sequence=(json['sequence'] as List).map((e)=>SegmentModel.fromJson(e)).toList();
  }
}