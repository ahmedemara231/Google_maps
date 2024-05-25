class RouteModel {
  int distanceMeters;
  String duration;
  Map<String, dynamic> polyline;

  RouteModel({
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
  });

  factory RouteModel.fromJson(Map<String, dynamic> routeData) {
    return RouteModel(
        distanceMeters: routeData['distanceMeters'],
        duration: routeData['duration'],
        polyline: routeData['polyline'],
    );
  }
}
