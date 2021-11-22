import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spaitr_map/Services/geolocator_service.dart';
import 'package:spaitr_map/models/place_search.dart';
import 'package:spaitr_map/services/places_service.dart';

// Alerts our UI to changes to the app.
class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();

  // Variables
  // Position variable for current location (using coordinates)
  // 'late' means initialize when first read. Accepts 'null'
  late Position currentLocation;
  late List<PlaceSearch> searchResults;

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

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}
