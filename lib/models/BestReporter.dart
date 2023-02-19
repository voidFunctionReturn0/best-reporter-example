import 'package:best_reporter/models/Place.dart';
import 'package:best_reporter/res/constants.dart';

import 'Member.dart';

class BestReporter {
  Place place;
  late AreaLevel areaLevel;
  Member? member;
  late Tier? tier;

  BestReporter(this.place) {
    areaLevel = getAreaLevel(place);
  }
  BestReporter.withMember(this.place, this.member) {
    areaLevel = getAreaLevel(place);
    tier = getTier(areaLevel);
  }

  AreaLevel getAreaLevel(Place place) {
    if (isAreaLevel1(place.name)) {
      return AreaLevel.level1;
    } else if (isAreaLevel2(place.name)) {
      return AreaLevel.level2;
    } else if (isAreaLevel3(place.name)) {
      return AreaLevel.level3;
    } else if (isAreaLevel4(place.name)) {
      return AreaLevel.level4;
    } else if (isAreaLevel5(place.name)) {
      return AreaLevel.level5;
    } else {
      throw "### Error: getAreaLevel()";
    }
  }

  Tier getTier(AreaLevel areaLevel) {
    switch (areaLevel) {
      case AreaLevel.level1:
      case AreaLevel.level2:
        return Tier.gold;
      case AreaLevel.level3:
        return Tier.silver;
      case AreaLevel.level4:
      case AreaLevel.level5:
        return Tier.bronze;
      default:
        throw "### Error: getTier()";
    }
  }

  // 특별시, 광역시, 특별자치시, 도, 특별자치도
  bool isAreaLevel1(String placeName) {
    List<String> placeNames = placeName.split(' ');

    if (placeNames.length == 1) {
      if ((Constants.areaSpecialSis.contains(placeNames.first))
          || (Constants.areaDos.contains(placeNames.first))) {
        return true;
      }
    }
    return false;
  }

  // 자치시, 행정시, 도 하위 자치군
  bool isAreaLevel2(String placeName) {
    List<String> placeNames = placeName.split(' ');

    if (placeNames.length == 2) {
      if ((placeNames.last.endsWith("시"))
        || ((Constants.areaDos.contains(placeNames.first)) && (placeNames.last.endsWith("군")))) {
        return true;
      }
    }
    return false;
  }

  // 자치구, 일반구, 시 하위 자치군
  bool isAreaLevel3(String placeName) {
    List<String> placeNames = placeName.split(' ');

    if ((placeNames.length == 2)
      || (placeNames.length == 3)) {
      if (!isAreaLevel2(placeName)) {
        if ((placeNames.last.endsWith("구"))
          || (placeNames.last.endsWith("군"))) {
          return true;
        }
      }
    }
    return false;
  }

  // 읍, 면
  bool isAreaLevel4(String placeName) {
    List<String> placeNames = placeName.split(' ');

    if ((placeNames.last.endsWith("읍"))
    || (placeNames.last.endsWith("면"))
    ) {
      return true;
    } else {
      return false;
    }
  }

  // 법정동, 리
  bool isAreaLevel5(String placeName) {
    List<String> placeNames = placeName.split(' ');

    if ((placeNames.last.endsWith("동"))
    || (placeNames.last.endsWith("가"))
    || (placeNames.last.endsWith("로"))
    || (placeNames.last.endsWith("리"))
    ) {
      return true;
    } else {
      return false;
    }
  }
}

enum Tier {
  gold,
  silver,
  bronze
}

enum AreaLevel {
  level1,
  level2,
  level3,
  level4,
  level5
}