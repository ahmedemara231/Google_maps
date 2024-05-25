import 'package:uuid/uuid.dart';

class MapsConstants
{
  static Duration timeoutDuration = const Duration(seconds: 15);

  // api key
  static const String apiKey = 'AIzaSyCSNqKNa1x4sMId5ouQ08JUX88npwSUl7U';

  // session token
  static Uuid? uuidObj = const Uuid();

  // base url
  static const String googleMapsPlacesBaseUrl = 'https://maps.googleapis.com/maps/api/place/';
  static const String googleMapsRouteBaseUrl = 'https://routes.googleapis.com/directions/v2:computeRoutes';
}