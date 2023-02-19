import 'package:latlong2/latlong.dart';
import 'package:collection/collection.dart';

class MyLatLngs {
  static const minLat = 33.48971433;  // 제주도
  static const maxLat = 37.88462539;  // 강원도
  static const minLng = 126.46016729;  // 전라남도
  static const maxLng = 129.31253685;  // 울산

  static LatLng koreaCenter = LatLng(
    [minLat, maxLat].average,
    [minLng, maxLng].average
  );
}