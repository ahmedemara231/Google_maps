import '../../model/google_maps_service/google_maps_api_constants.dart';

String generateNewSessionToken()
{
  return MapsConstants.uuidObj!.v4();
}