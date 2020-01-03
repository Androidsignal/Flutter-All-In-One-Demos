class LatLongModel {
  var lat, long;

  LatLongModel.fromMap(Map<String, dynamic> map) {
    List maps = map["latlng"];
    lat = maps[0];
    long = maps[1];
  }
}
