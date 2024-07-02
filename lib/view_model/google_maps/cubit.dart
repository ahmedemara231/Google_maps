import 'package:Mapy/view_model/google_maps/states.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../model/google_maps_service/google_maps_models/autoCompleteModel.dart';
import '../../model/google_maps_service/google_maps_models/place_details.dart';
import '../../model/google_maps_service/maps_api_connection.dart';
import '../../model/google_maps_service/repositories/google_maps_repo.dart';
import '../../modules/google_maps/ori_des_location.dart';

class MapsCubit extends Cubit<GoogleMapsStates>
{
  MapsCubit() : super(MapsInitialState());
  factory MapsCubit.getInstance(context) => BlocProvider.of(context);

  Set<Marker> markers = {};


  late Location location;

  // check enabling location service in settings
  Future<bool> checkAndRequestToEnableLocationService()async
  {
    bool isLocationServiceEnabled = await location.serviceEnabled();
    if(isLocationServiceEnabled)
    {
      return true;
    }
    else{
      bool isEnabledNow = await location.requestService();
      return isEnabledNow;
    }
  }

  // request for access location
  Future<bool> requestLocationPermission()async
  {
    PermissionStatus hasPermission = await location.hasPermission();
    if(hasPermission == PermissionStatus.denied)
    {
      PermissionStatus requestPermissionResult = await location.requestPermission();
      return requestPermissionResult == PermissionStatus.granted;
    }
    else{
      return true;
    }
  }


  late LocationData currentUserLocation;
  Set<Marker> routeTrackingAppMarkers = {};
  Future<void> getLocation()async
  {
     await location.getLocation().then((userLocationData)
    {
      LatLng userLatLng = LatLng(userLocationData.latitude!, userLocationData.longitude!);
      Marker userLocationMarker = Marker(
        markerId: const MarkerId('3'),
        position: userLatLng
      );

      routeTrackingAppMarkers.add(userLocationMarker);
      myMapCont.animateCamera(
          CameraUpdate.newLatLng(
              userLatLng
          ),
      );
      currentUserLocation = userLocationData;
      return userLocationData;
    });
  }


  late GoogleMapController myMapCont;
  late Marker userMarker;
  bool isAnotherRouteCalculated = false;
  Future<void> getStreamLocation({
    PlaceLocation? desLocation
})async
  {
    await location.changeSettings(
        distanceFilter: 2
    );
    location.onLocationChanged.listen((newLocationData) async{
      currentUserLocation = newLocationData;

      if(isAnotherRouteCalculated)
        {
          getRouteForLocation(
              originLocation: PlaceLocation(
                lat: newLocationData.latitude!,
                long: newLocationData.longitude!,
              ),
              desLocation: desLocation!
          );
        }

      userMarker = Marker(
          markerId: const MarkerId('2'),
          position: LatLng(
              newLocationData.latitude!,
              newLocationData.longitude!
          ),
      );
      routeTrackingAppMarkers.add(userMarker);
      emit(GetStreamLocationSuccess());

       await myMapCont.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(newLocationData.latitude!, newLocationData.longitude!),
        ),
      );
    });
  }


  Future<void> getStreamLocationProcess(context,{PlaceLocation? desLocation})async
  {
    bool isLocationServiceEnabled = await checkAndRequestToEnableLocationService();
    if(isLocationServiceEnabled)
      {
        await requestLocationPermission().then((permissionResult)async
        {
          if(permissionResult)
          {
            await getStreamLocation(
              desLocation: desLocation
            );
            emit(GetStreamLocationSuccess());
          }
          else
          {
            Navigator.pop(context);
          }
        });
      }
    else{
      Navigator.pop(context);
    }
  }


  Future<void> getLocationProcess(context)async
  {
    bool isLocationServiceEnabled = await checkAndRequestToEnableLocationService();
    if(isLocationServiceEnabled)
    {
      await requestLocationPermission().then((permissionResult)async
      {
        if(permissionResult)
        {
          await getLocation();
          emit(GetLocationSuccess());
        }
        else{}
      });
    }
    else{
      Navigator.pop(context);
    }
  }
  
  GoogleMapsRepo googleMapsRepo = GoogleMapsRepo(googleMapsConnection: GoogleMapsConnection.getInstance());
  late AutoCompleteModel autoCompleteModel;
  Future<void> getSuggestions({
    required String input,
    required String sessionToken,
})async
  {
    emit(GetSuggestionsLoading());

    if(input.isEmpty)
      {
        autoCompleteModel.predictions.clear();
        emit(ClearSuggestionsList());
      }
    else{
      await googleMapsRepo.getSuggestions(
        input: input,
        sessionToken: sessionToken
      ).then((suggestionsResult)
      {
        if(suggestionsResult.isSuccess())
          {
            autoCompleteModel = suggestionsResult.getOrThrow();
            emit(GetSuggestionsSuccess());
          }
        else{
          emit(
              GetSuggestionsError(
                  message: suggestionsResult.tryGetError()?.message
              ),
          );
        }
      });
    }
  }

  late PlaceDetailsModel placeDetailsModel;
  Future<void> getPlaceDetails({
    required String placeId,
    required String sessionToken,
})async
  {
    emit(GetPlaceDetailsLoading());

    await googleMapsRepo.getPlaceDetails(
        placeId: placeId,
        sessionToken: sessionToken
    ).then((getDetailsResult)
    {
      if(getDetailsResult.isSuccess())
        {
          placeDetailsModel = getDetailsResult.getOrThrow();
          emit(GetPlaceDetailsSuccess());
        }
      else{
        emit(
            GetPlaceDetailsError(
              message: getDetailsResult.tryGetError()?.message
            ),
        );
      }
    });
  }


  Future<void> selectThePlace()async
  {
    LatLng desLocation = LatLng(
        placeDetailsModel.result.geometry.placeLocation.lat,
        placeDetailsModel.result.geometry.placeLocation.long
    );
    Marker desLocationMarker = Marker(
      markerId: const MarkerId('5'),
      position: desLocation,
    );

    routeTrackingAppMarkers.add(desLocationMarker);
    await myMapCont.animateCamera(CameraUpdate.newLatLng(desLocation));
    emit(LocationSelectedSuccess());
  }

  late List<LatLng> routeModel;
  Polyline? routePolyLine;
  Set<Polyline> polyLines = {};

  bool isRouteShown = false;

  Future<void> getRouteForLocation({
    required PlaceLocation originLocation,
    required PlaceLocation desLocation,
  })async
  {
    emit(GetLocationRouteLoading());
    await googleMapsRepo.getRoute(
        originLocation: originLocation,
        desLocation: desLocation
    ).then((getRouteResult)async
    {
      if(getRouteResult.isSuccess())
        {
          isRouteShown = true;

          routeModel = getRouteResult.getOrThrow();
          routePolyLine = Polyline(
            polylineId: const PolylineId('1'),
            color: Colors.blue,
            points: routeModel
          );
          polyLines.add(routePolyLine!);

          Marker desMarker = Marker(
            markerId: const MarkerId('4'),
            position: LatLng(desLocation.lat, desLocation.long),
          );

          routeTrackingAppMarkers.add(desMarker);

          if(routePolyLine!.points.length < 3)
          {
            await finish();
          }
          emit(GetLocationRouteSuccess());
        }
      else{
        emit(
            GetLocationRouteError(
              message: getRouteResult.tryGetError()?.message
            )
        );
      }
    });
  }

  late AudioPlayer player;
  Future<void> playSound(SoundCode soundCode)async
  {
    player = AudioPlayer();
    switch(soundCode)
    {
      case SoundCode.arrive:
        await player.play(UrlSource('https://example.com/my-audio.wav'));

      case SoundCode.finish:
        await player.play(UrlSource('https://example.com/my-audio.wav'));
    }
  }

  Future<void> arrive()async
  {
    await playSound(SoundCode.arrive);
  }

  Future<void> finish()async
  {
    isAnotherRouteCalculated = false;
    isRouteShown = false;
    polyLines = {};
    emit(FinishAndReturn());
    await playSound(SoundCode.finish);
  }
}
enum SoundCode{ arrive,finish }