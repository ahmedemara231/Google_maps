import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../modules/google_maps/ori_des_location.dart';
import '../api_request.dart';
import '../error_handling/errors.dart';
import '../languages_and_methods.dart';
import '../request_model.dart';
import '../google_maps_api_constants.dart';
import '../google_maps_models/autoCompleteModel.dart';
import '../google_maps_models/place_details.dart';
import '../google_maps_models/route_model.dart';


class GoogleMapsRepo
{
  late ApiService googleMapsConnection;
  GoogleMapsRepo({required this.googleMapsConnection});

  Future<Result<AutoCompleteModel,CustomError>> getSuggestions({
    required String input,
    required String sessionToken,
})async
  {
    Map<String,dynamic> params =
    {
      'input' : input,
      'key' : MapsConstants.apiKey,
      'sessiontoken' : sessionToken,
    };

   Result<Response,CustomError> suggestionsResponse = await googleMapsConnection.callApi(
        request: RequestModel(
            method: Methods.GET,
            endPoint: '${MapsConstants.googleMapsPlacesBaseUrl}autocomplete/json',
            queryParams: params,
        ),
    );
   return suggestionsResponse.when(
           (success) => Result.success(AutoCompleteModel.fromJson(success.data)),
           (error) => Result.error(error),
   );
  }

  Future<Result<PlaceDetailsModel,CustomError>> getPlaceDetails({
    required String placeId,
    required String sessionToken,
  })async
  {
    final params =
    {
      'key' : MapsConstants.apiKey,
      'place_id' : placeId,
      'sessiontoken' : sessionToken,
    };

    Result<Response,CustomError> placeDetailsResponse = await googleMapsConnection.callApi(
        request: RequestModel(
            method: Methods.GET,
            endPoint: '${MapsConstants.googleMapsPlacesBaseUrl}details/json',
            queryParams: params,
        ),
    );

    return placeDetailsResponse.when(
            (success) => Result.success(PlaceDetailsModel.fromJson(success.data)),
            (error) => Result.error(error),
    );
  }

  final getRouteHeaders =
  {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': MapsConstants.apiKey,
    'X-Goog-FieldMask' : 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
  };

  Future<Result<List<LatLng>,CustomError>> getRoute({
    required PlaceLocation originLocation,
    required PlaceLocation desLocation,
})async
  {
    final getRouteBody =
    {
      "origin":{
        "location":{
          "latLng":{
            "latitude": originLocation.lat,
            "longitude": originLocation.long
          }
        }
      },
      "destination":{
        "location":{
          "latLng":{
            "latitude": desLocation.lat,
            "longitude": desLocation.long,
          }
        }
      },
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false
      },
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    Result<Response,CustomError> getRouteResponse = await googleMapsConnection.callApi(
      request: RequestModel(
          method: Methods.POST,
          endPoint: MapsConstants.googleMapsRouteBaseUrl,
          data: getRouteBody,
          headers: getRouteHeaders,
        ),
    );

    if(getRouteResponse.isSuccess())
      {
        final List route = getRouteResponse.getOrThrow().data['routes'];
        List<RouteModel> routeList = route.map((e) => RouteModel.fromJson(e)).toList();

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result = polylinePoints.decodePolyline(routeList.first.polyline['encodedPolyline'] as String);
        List<LatLng> points = result.map((e) => LatLng(e.latitude, e.longitude)).toList();

        return Result.success(points);
      }
    else{
      return Result.error(getRouteResponse.tryGetError()!);
    }
  }

}