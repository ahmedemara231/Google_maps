import '../../../modules/google_maps/ori_des_location.dart';

class PlaceDetailsModel
{
  String status;
  ResultModel result;

  PlaceDetailsModel({required this.status,required this.result});

  factory PlaceDetailsModel.fromJson(Map<String,dynamic> data)
  {
    return PlaceDetailsModel(
      status: data['status'],
      result: ResultModel.fromJson(data['result']),
    );
  }

}

class ResultModel
{
  String name;
  String icon;
  String iconBackgroundColor;
  String url;
  Geometry geometry;

  ResultModel({
    required this.name,
    required this.icon,
    required this.iconBackgroundColor,
    required this.url,
    required this.geometry,
  });

  factory ResultModel.fromJson(Map<String,dynamic> detailsResult)
  {
    return ResultModel(
        name: detailsResult['name'],
        icon: detailsResult['icon'],
        iconBackgroundColor: detailsResult['icon_background_color'],
        url: detailsResult['url'],
        geometry: Geometry.fromJson(detailsResult['geometry'])
    );
  }
}

class Geometry {
  PlaceLocation placeLocation;

  Geometry({required this.placeLocation});

  factory Geometry.fromJson(Map<String, dynamic> geometryData) {
    return Geometry(
      placeLocation: PlaceLocation(
        lat: geometryData['location']['lat'],
        long: geometryData['location']['lng'],
      ),
    );
  }
}
