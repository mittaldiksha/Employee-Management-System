import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<String> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location service is disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('Location permission denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return "${position.latitude}, ${position.longitude}";
  }
}
