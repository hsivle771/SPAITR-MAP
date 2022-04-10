import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spaitr_map/core/bool_response.dart';
import 'package:spaitr_map/core/game.dart';
import 'package:spaitr_map/rest/dummy_data.dart' as dummy_data;

class URLS {
  static const String baseURL = 'http://localhost:5000';
}

enum RequestType {PUT, GET, POST}

/*
REST API calls that the client makes to the server
 */
class RestAPI {


  Future<Response> makeJsonRequest(String url, RequestType rt) async {
    var reqHeaders = {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "DELETE, POST, GET, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With",
      };

    switch (rt) {
      case RequestType.PUT:
        {
          try {
            var response = await http.put(
                Uri.parse(url),
                headers: reqHeaders
            );

            return response;
          } on Exception catch(_) {
            throw Exception('Error sending request to: ${URLS.baseURL}');
          }
        }
      case RequestType.GET:
        {
          try {
            var response = await http.get(
                Uri.parse(url),
                headers: reqHeaders
            );

            return response;
          } on Exception catch(_) {
            throw Exception('Error sending request to: ${URLS.baseURL}');
          }
        }
      case RequestType.POST:
        {
          try {
            var response = await http.post(
                Uri.parse(url),
                headers: reqHeaders
            );

            return response;
          } on Exception catch(_) {
            throw Exception('Error sending request to: ${URLS.baseURL}');
          }
        }
      default: {
        try {
          var response = await http.get(
              Uri.parse(url),
              headers: reqHeaders
          );

          return response;
        } on Exception catch(_) {
          throw Exception('Error sending request to: ${URLS.baseURL}');
        }
      }
    }
  }

  // Retrieves a list of nearby games based on the given coordinates
  Future<List<Game>> fetchGames(double coorX, double coorY) async {
    // https://www.tutorialspoint.com/flutter/flutter_accessing_rest_api.htm
    List<Game> parseGames(String responseBody) {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<Game>((json) => Game.fromJson(json)).toList();
    }

    // TODO: Remove this in future, here to speed up debugging until server works
    // return parseGames(dummy_data.DUMMY_FETCHGAMES_JSON);

    String apiCallURL = '${URLS.baseURL}/nearby_games/$coorX/$coorY';

    Response response = await makeJsonRequest(apiCallURL, RequestType.GET);

    if (response.statusCode == 200) {
      return parseGames(response.body);
    } else {
      throw Exception('Error parsing response from ${URLS.baseURL}');
    }
  }

  Future<BoolResponse> createGame(String gameTime, String gameDate, int maxPlayerAmount, double coorX, double coorY) async {
    BoolResponse parseCreateGameResponse(String responseBody) {
      Map<String, dynamic> parsedJson = jsonDecode(responseBody);
      return BoolResponse.fromJson(parsedJson);
    }

    // TODO: Remove this in future, here to speed up debugging until server works
    // return parseCreateGameResponse(dummy_data.DUMMY_CREATEGAME_JSON);

    String apiCallURL = '${URLS.baseURL}/create_game/$coorX/$coorY/$gameDate/$gameTime/$maxPlayerAmount';

    Response response = await makeJsonRequest(apiCallURL, RequestType.PUT);

    if (response.statusCode == 200) {
      return parseCreateGameResponse(response.body);
    } else {
      throw Exception('Error parsing response from ${URLS.baseURL}');
    }
  }

  Future<BoolResponse> joinGame(String gameId, String playerId) async {
    BoolResponse parseJoinGameResponse(String responseBody) {
      Map<String, dynamic> parsedJson = jsonDecode(responseBody);
      return BoolResponse.fromJson(parsedJson);
    }

    // TODO: Remove this in future, here to speed up debugging until server works
    // return parseJoinGameResponse(dummy_data.DUMMY_JOINGAME_JSON);

    String apiCallURL = '${URLS.baseURL}/join_game/$gameId/$playerId';

    Response response = await makeJsonRequest(apiCallURL, RequestType.POST);

    if (response.statusCode == 200) {
      return parseJoinGameResponse(response.body);
    } else {
      throw Exception('Error parsing response from ${URLS.baseURL}');
    }
  }
}