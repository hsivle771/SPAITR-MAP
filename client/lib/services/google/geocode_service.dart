import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:spaitr_map/tools/constants.dart';
import 'dart:convert' as convert;

// Address to coordinates converter service
class GeocodeService {
  String formatAddress(String unformattedAddress) {
    return unformattedAddress.replaceAll(" ","+").replaceAll(",", "");
  }

  Future<LatLng> getCoordinate(String address) async {
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${formatAddress(address)}&key=${Constants.googleAPIKey}';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    // Grabs predictions json object (key) and stores all values within a list
    var jsonResults = json['results'] as List;

    if (jsonResults.isEmpty) {
      // TODO: Probably make this an option and have this be fail case
      return const LatLng(0, 0);
    } else {
      double latitude = jsonResults[0]['geometry']['location']['lat'] as double;
      double longitude = jsonResults[0]['geometry']['location']['lng'] as double;

      return LatLng(latitude, longitude);
    }
  }
}
