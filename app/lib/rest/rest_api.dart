import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:spaitr_map/core/bool_response.dart';
import 'package:spaitr_map/core/game.dart';
import 'package:spaitr_map/rest/dummy_data.dart' as dummy_data;

class URLS {
  static const String baseURL = 'http://10.0.2.2:8000';
}

/*
REST API calls that the client makes to the server
 */
class RestAPI {
  // Retrieves a list of nearby games based on the given coordinates
  Future<List<Game>> fetchGames(double coorX, double coorY) async {
    // https://www.tutorialspoint.com/flutter/flutter_accessing_rest_api.htm
    List<Game> parseGames(String responseBody) {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<Game>((json) => Game.fromJson(json)).toList();
    }

    // TODO: Remove this in future, here to speed up debugging until server works
    return parseGames(dummy_data.DUMMY_FETCHGAMES_JSON);

    try {
      final response = await http.get(
          Uri.parse('${URLS.baseURL}/nearby_games/$coorX/$coorY'),
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "DELETE, POST, GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With",
          }
      );

      if (response.statusCode == 200) {
        return parseGames(response.body);
      } else {
        throw Exception('Unable to fetching games from ${URLS.baseURL}');
      }
    } on Exception catch(_) {
      // TODO: Remove this once server sends back real data
      return parseGames(dummy_data.DUMMY_FETCHGAMES_JSON);

      throw Exception('Unable to fetching games from ${URLS.baseURL}');
    }
  }

  Future<BoolResponse> createGame(String gameTime, String gameDate, int maxPlayerAmount, double coorX, double coorY) async {
    BoolResponse parseCreateGameResponse(String responseBody) {
      Map<String, dynamic> parsedJson = jsonDecode(responseBody);
      return BoolResponse.fromJson(parsedJson);
    }

    // TODO: Remove this in future, here to speed up debugging until server works
    return parseCreateGameResponse(dummy_data.DUMMY_CREATEGAME_JSON);

    try {
      final response = await http.get(
          Uri.parse('${URLS.baseURL}/create_game/$coorX/$coorY/$gameDate/$gameTime/$maxPlayerAmount'),
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "DELETE, POST, GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With",
          }
      );

      if (response.statusCode == 200) {
        return parseCreateGameResponse(response.body);
      } else {
        throw Exception('Unable to fetching games from ${URLS.baseURL}');
      }
    } on Exception catch(_) {
      throw Exception('Unable to fetching games from ${URLS.baseURL}');
    }
  }

}