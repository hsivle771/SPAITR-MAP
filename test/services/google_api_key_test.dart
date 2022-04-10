import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:spaitr_map/services/google_api_key.dart';

// Test to check if your google api key works correctly
void main() {
  test('google api key works test', () async {
    const GOOGLE_API_KEY = GoogleAPIKey.key;
    const URL = "https://maps.googleapis.com/maps/api/geocode/json?key=$GOOGLE_API_KEY&address=durham";

    var response = await http.get(Uri.parse(URL));
    expect(false, response.body.contains("REQUEST_DENIED"));
  });
}
