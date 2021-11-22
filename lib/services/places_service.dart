import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:spaitr_map/models/place_search.dart';

// This is for getting the places and complete APIs
// NOTE***: I can't get the request working because...
/// in the Google Cloud platform, the API key is invalid???
class PlacesService {
  final key = 'AIzaSyCV6P-3w00O6rgu-QDCwR31qqMpuDy-XiQ';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(url as Uri);
    var json = convert.jsonDecode(response.body);
    // Grabs predictions json object (key) and stores all values within a list
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}
