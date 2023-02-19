import 'package:latlong2/latlong.dart';

class Place {
  String name;
  LatLng location;

  Place(this.name, this.location) {
    if (name.endsWith(")")) {
      name = name.substring(0, name.indexOf('('));  // 지번주소 '리' 뒤에 한자가 붙을 때가 있음. 이런 경우 한자부분을 제거하도록 함. 예) 청주시 상당구 미원면 기암리(岐岩)
    }
  }
}