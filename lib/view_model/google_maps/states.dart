abstract class GoogleMapsStates {}

class MapsInitialState extends GoogleMapsStates {}

class InitMarkers extends GoogleMapsStates {}

class InitPolyLines extends GoogleMapsStates {}

class GetStreamLocationSuccess extends GoogleMapsStates {}

class GetLocationSuccess extends GoogleMapsStates {}

class GetSuggestionsLoading extends GoogleMapsStates {}

class GetSuggestionsSuccess extends GoogleMapsStates {}


class LocationSelectedSuccess extends GoogleMapsStates {}


class GetSuggestionsError extends GoogleMapsStates {
  String? message;
  GetSuggestionsError({required this.message});
}

class ClearSuggestionsList extends GoogleMapsStates {}

class GetPlaceDetailsLoading extends GoogleMapsStates {}

class GetPlaceDetailsSuccess extends GoogleMapsStates {}

class GetPlaceDetailsError extends GoogleMapsStates {
  String? message;
  GetPlaceDetailsError({required this.message});
}

class GetLocationRouteLoading extends GoogleMapsStates {}
class GetLocationRouteSuccess extends GoogleMapsStates {}
class GetLocationRouteError extends GoogleMapsStates {
  String? message;
  GetLocationRouteError({required this.message});
}

class FinishAndReturn extends GoogleMapsStates {}

