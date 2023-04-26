import 'dart:convert';
/// organs : "leaf"
/// gbif-id : "3169677"
/// img-url : "https://firebasestorage.googleapis.com/v0/b/planttag-2fb93.appspot.com/o/2d912d46-4bbb-48b4-b3ea-ce73664488d04904171794882442010.jpg_1682416420248?alt=media&token=11b46b28-1b3f-4905-8641-f3c29bd9534e"
/// user-id : "YRv5qtnQKuM0lDb3WVHvHv144Pm1"
/// latitude : 26.8004034
/// rfid : "00F5B72C50E79E2E4341C301"
/// ref-images : ["https://bs.plantnet.org/image/o/21843239f5a6f7754f8bcf3046a9f6662a700df3","https://bs.plantnet.org/image/o/4ac0a1766e0ddbaf83e27d3e9ffe0e3d2bdc630b","https://bs.plantnet.org/image/o/32f241b30cae4a64fd3b0c1052b1651be83e7a1d","https://bs.plantnet.org/image/o/6ce7418d2a49b54fbe2de49c68c1955da5676289","https://bs.plantnet.org/image/o/9ebf151f7ca90e9c823a41fb0b550c782750127c","https://bs.plantnet.org/image/o/842a318b734e12466ef05dc3a7fb296166549322"]
/// longitude : 81.0241832
/// timestamp : 1682416441837

TreeSpeciesModel treeSpeciesModelFromJson(String str) => TreeSpeciesModel.fromJson(json.decode(str));
String treeSpeciesModelToJson(TreeSpeciesModel data) => json.encode(data.toJson());
class TreeSpeciesModel {
  TreeSpeciesModel({
      String? organs, 
      String? gbifid, 
      String? imgurl, 
      String? userid, 
      double? latitude, 
      String? rfid, 
      List<String>? refimages, 
      double? longitude, 
      int? timestamp,}){
    _organs = organs;
    _gbifid = gbifid;
    _imgurl = imgurl;
    _userid = userid;
    _latitude = latitude;
    _rfid = rfid;
    _refimages = refimages;
    _longitude = longitude;
    _timestamp = timestamp;
}

  TreeSpeciesModel.fromJson(dynamic json) {
    _organs = json['organs'];
    _gbifid = json['gbif-id'];
    _imgurl = json['img-url'];
    _userid = json['user-id'];
    _latitude = json['latitude'];
    _rfid = json['rfid'];
    _refimages = json['ref-images'] != null ? json['ref-images'].cast<String>() : [];
    _longitude = json['longitude'];
    _timestamp = json['timestamp'];
  }
  String? _organs;
  String? _gbifid;
  String? _imgurl;
  String? _userid;
  double? _latitude;
  String? _rfid;
  List<String>? _refimages;
  double? _longitude;
  int? _timestamp;
TreeSpeciesModel copyWith({  String? organs,
  String? gbifid,
  String? imgurl,
  String? userid,
  double? latitude,
  String? rfid,
  List<String>? refimages,
  double? longitude,
  int? timestamp,
}) => TreeSpeciesModel(  organs: organs ?? _organs,
  gbifid: gbifid ?? _gbifid,
  imgurl: imgurl ?? _imgurl,
  userid: userid ?? _userid,
  latitude: latitude ?? _latitude,
  rfid: rfid ?? _rfid,
  refimages: refimages ?? _refimages,
  longitude: longitude ?? _longitude,
  timestamp: timestamp ?? _timestamp,
);
  String? get organs => _organs;
  String? get gbifid => _gbifid;
  String? get imgurl => _imgurl;
  String? get userid => _userid;
  double? get latitude => _latitude;
  String? get rfid => _rfid;
  List<String>? get refimages => _refimages;
  double? get longitude => _longitude;
  int? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['organs'] = _organs;
    map['gbif-id'] = _gbifid;
    map['img-url'] = _imgurl;
    map['user-id'] = _userid;
    map['latitude'] = _latitude;
    map['rfid'] = _rfid;
    map['ref-images'] = _refimages;
    map['longitude'] = _longitude;
    map['timestamp'] = _timestamp;
    return map;
  }

}