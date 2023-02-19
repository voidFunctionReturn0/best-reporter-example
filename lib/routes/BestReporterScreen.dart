import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsheets/src/gsheets.dart';
import 'package:latlong2/latlong.dart';
import '../models/BestReporter.dart';
import '../models/Member.dart';
import '../models/Place.dart';
import '../res/colors.dart';
import '../res/constants.dart';
import '../res/latLngs.dart';
import '../res/strings.dart';
import '../res/textStyles.dart';

class BestReporterScreen extends StatefulWidget {
  const BestReporterScreen({Key? key}) : super(key: key);

  @override
  State<BestReporterScreen> createState() => _BestReporterScreenState();
}

class _BestReporterScreenState extends State<BestReporterScreen> {
  ZoomLevel currentZoomLevel = ZoomLevel.level1;
  List<BestReporter> bestReporters = [];
  List<Marker> markers = [];

  @override
  initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyStrings.bestReporter),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 64,
        backgroundColor: MyColors.surface,
        titleTextStyle: MyTextStyles.medium,
        actions: [
          GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Icon(
                    Icons.info_outline,
                    color: MyColors.gray4,
                    size: 24,
                  ),
                ),
              )
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
            center: MyLatLngs.koreaCenter,
            zoom: 7,
            // minZoom: 1,
            // maxZoom: 19,
            maxBounds: LatLngBounds(
                LatLng(
                    MyLatLngs.koreaCenter.latitude - Constants.kmLat*700,
                    MyLatLngs.koreaCenter.longitude - Constants.kmLng*700
                ),
                LatLng(
                    MyLatLngs.koreaCenter.latitude + Constants.kmLat*700,
                    MyLatLngs.koreaCenter.longitude + Constants.kmLng*700
                )
            ),
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            onMapEvent: (MapEvent event) {
              double zoom = event.zoom;

              if (zoom < 8) {
                if (currentZoomLevel != ZoomLevel.level1) {
                  Fluttertoast.showToast(msg: "Zoom 1");
                  setState(() {
                    currentZoomLevel = ZoomLevel.level1;
                    setMarkers();
                  });
                }
              } else if (8 <= zoom && zoom < 12) {
                if (currentZoomLevel != ZoomLevel.level2) {
                  Fluttertoast.showToast(msg: "Zoom 2");
                  setState(() {
                    currentZoomLevel = ZoomLevel.level2;
                    setMarkers();
                  });
                }
              } else if (12 <= zoom && zoom < 14) {
                if (currentZoomLevel != ZoomLevel.level3) {
                  Fluttertoast.showToast(msg: "Zoom 3");
                  setState(() {
                    currentZoomLevel = ZoomLevel.level3;
                    setMarkers();
                  });
                }
              } else {
                if (currentZoomLevel != ZoomLevel.level4) {
                  Fluttertoast.showToast(msg: "Zoom 4");
                  setState(() {
                    currentZoomLevel = ZoomLevel.level4;
                    setMarkers();
                  });
                }
              }
            }
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: markers,
          )
        ],
      ),
    );
  }

  void loadData() async {
    await dotenv.load(fileName: ".env");
    String googleKeyId = dotenv.env['GOOGLE_KEY_ID']!;
    String googleKey = dotenv.env['GOOGLE_KEY']!;
    String googleClientEmail = dotenv.env['GOOGLE_CLIENT_EMAIL']!;
    String googleClientId = dotenv.env['GOOGLE_CLIENT_ID']!;


    String googleCredential = '''
    {
    "type": "service_account",
    "project_id": "best-reporter-test",
    "private_key_id": "$googleKeyId",
    "private_key": "$googleKey",
    "client_email": "$googleClientEmail",
    "client_id": "$googleClientId",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/bestreportertest%40best-reporter-test.iam.gserviceaccount.com"
    }
    ''';

    var gSheets = GSheets(googleCredential);

    final ss = await gSheets.spreadsheet(dotenv.env['SPREADSHEET_ID']!);
    var postAndPlaceSheet = ss.worksheetByTitle('PostAndPlace');
    var tMapPlaceSheet = ss.worksheetByTitle('TMapPlace');
    var memberSheet = ss.worksheetByTitle('Member');
    var administrativeAreaSheet = ss.worksheetByTitle('AdministrativeArea');
    var postAndPlaces = await postAndPlaceSheet?.cells.allRows(
        fromRow: 2
    );
    var tMapPlaces = await tMapPlaceSheet?.cells.allRows(
        fromRow: 2
    );
    var members = await memberSheet?.cells.allRows(
        fromRow: 2
    );
    var administrativeAreas = await administrativeAreaSheet?.cells.allRows(
        fromRow: 2
    );

    // Map<AreaName, Map<MemberId, LikingCount>>
    Map<String, Map<int, int>> likes = getLikesFromPostAndPlaces(postAndPlaces);

    // 베스트 리포터 데이터 세팅
    setBestReporterFromLikes(likes, tMapPlaces!, members!);

    // 베스트 리포터 없는 지역 데이터 세팅
    setRestAreas(administrativeAreas);

    setState(() {
      setMarkers();
    });
  }

  Place? getPlaceByName(List<List<Cell>> tMapPlaces, String areaName) {
    Place? place;

    for (var element in tMapPlaces) {
      String address = element[0].value;
      double latitude = double.parse(element[1].value);
      double longitude = double.parse(element[2].value);

      if (address.endsWith(areaName)) {
        place = Place(
            address,
            LatLng(
                latitude,
                longitude
            )
        );
      }
    }

    return place;
  }

  Member? getMemberById(List<List<Cell>>? members, int? bestMemberId) {
    Member? member;

    members?.forEach((element) {
      int memberId = int.parse(element[0].value);
      String name = element[1].value;

      if (bestMemberId == memberId) {
        member = Member(name);
      }
    });

    return member;
  }

  Map<String, Map<int, int>> getLikesFromPostAndPlaces(List<List<Cell>>? postAndPlaces) {
    // Map<AreaName, Map<MemberId, LikingCount>>
    Map<String, Map<int, int>> likes = {};

    // 행정구역별 좋아요 제일 많이 받은 베스트 리포터 찾기
    postAndPlaces?.forEach((postAndPlace) {
      int likingCount = int.parse(postAndPlace[2].value);
      int writerId = int.parse(postAndPlace[3].value);
      String lotNumberAddress = postAndPlace[5].value;

      List<String> addressComponents = lotNumberAddress.split(' ');  // 지번 주소 구성요소 분리. 단, 실제 개발 시에는 구성요소 앞부분까지 합치기
      for (var addressComponent in addressComponents) {
        if (!addressComponent.startsWith(RegExp('^[0-9]'))) { // 주소 구성요소가 숫자로 시작하지 않는 경우
          if (!likes.containsKey(addressComponent)) { // 장소가 존재하지 않으면 추가
            likes[addressComponent] = {writerId: likingCount};
          } else if (!likes[addressComponent]!.containsKey(writerId)) { // 회원 존재하지 않으면 추가
            likes[addressComponent]![writerId] = likingCount;
          } else { // 회원 존재하면 좋아요 숫자에 추가
            likes[addressComponent]![writerId] =
            (likes[addressComponent]![writerId]! + likingCount);
          }
        }
      }
    });

    return likes;
  }

  void setBestReporterFromLikes(Map<String, Map<int, int>> likes, List<List<Cell>> tMapPlaces, List<List<Cell>> members) {
    likes.forEach((areaName, memberAndLikes) {
      int? bestMemberId;
      int bestLikingCount = -1;

      memberAndLikes.forEach((memberId, likingCount) {
        if (bestLikingCount < likingCount) {  // 여러 명이면? 더 먼저 달성한 사람
          bestLikingCount = likingCount;
          bestMemberId = memberId;
        }
      });
      bestReporters.add(
          BestReporter.withMember(
              getPlaceByName(tMapPlaces, areaName)!,
              getMemberById(members, bestMemberId)!
          )
      );
    });
  }

  void setRestAreas(List<List<Cell>>? administrativeAreas) {
    administrativeAreas?.forEach((area) {
      String areaName = area[0].value;
      for (int i = 1; i < 5; i++) {
        if (area[i].value.isNotEmpty) {
          areaName = '$areaName ${area[i].value}';
        }
      }
      bool flag = false;
      for (var bestReporter in bestReporters) {
        if (bestReporter.place.name == areaName) {
          flag = true;
        }
      }
      if (!flag) {
        double centerLat = double.parse(area[5].value);
        double centerLon = double.parse(area[6].value);

        bestReporters.add(
            BestReporter(
                Place(
                    areaName,
                    LatLng(
                        centerLat,
                        centerLon
                    )
                )
            )
        );
      }
    });
  }

  void setMarkers() {
    var bestReportersAtCurrentZoom;

    switch (currentZoomLevel) {
      case ZoomLevel.level1:
        bestReportersAtCurrentZoom = bestReporters.where((bestReporter) => (bestReporter.areaLevel == AreaLevel.level1)).cast<BestReporter>();
        break;
      case ZoomLevel.level2:
        bestReportersAtCurrentZoom = bestReporters.where((bestReporters) => (bestReporters.areaLevel == AreaLevel.level1) || (bestReporters.areaLevel == AreaLevel.level2));
        break;
      case ZoomLevel.level3:
        bestReportersAtCurrentZoom = bestReporters.where((bestReporters) => ((bestReporters.areaLevel == AreaLevel.level3) || (bestReporters.areaLevel == AreaLevel.level4)));
        break;
      case ZoomLevel.level4:
        bestReportersAtCurrentZoom = bestReporters.where((bestReporters) => (bestReporters.areaLevel == AreaLevel.level5));
    }

    markers.clear();
    for (var bestReporter in bestReportersAtCurrentZoom) {
      markers.add(
        Marker(
          point: bestReporter.place.location,
          width: 40,
          height: 40,
          builder: (context) {
            return const FlutterLogo();
          }
        )
      );
    }
  }
}

enum ZoomLevel {
  level1,
  level2,
  level3,
  level4
}