import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spaitr_map/Services/geolocator_service.dart';
import 'package:spaitr_map/models/place_search.dart';
import 'package:spaitr_map/services/geocode_service.dart';
import 'package:spaitr_map/services/places_service.dart';

// Alerts our UI to changes to the app.
class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final geocodeService = GeocodeService();

  // Variables
  // Position variable for current location (using coordinates)
  // 'late' means initialize when first read. Accepts 'null'
  late Position currentLocation;

  // Constructor
  ApplicationBloc() {
    setCurrentLocation();
  }

  // Calls the getCurrentLocation service under the services folder
  // Changes current location to returned location.
  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners(); // Notifies that a change has been made
  }

  Future<LatLng> getCoordinate(String address) async {
    return await geocodeService.getCoordinate(address);
  }

  Future<List<PlaceSearch>> searchPlaces(String searchTerm) async{
    notifyListeners();
    return await placesService.getAutocomplete(searchTerm);
  }
}
