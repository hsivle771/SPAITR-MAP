import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:spaitr_map/core/bool_response.dart';
import 'package:spaitr_map/core/game.dart';
import 'package:spaitr_map/rest/rest_api.dart';
import 'package:mockito/annotations.dart';

// Create a partial mock of the rest API where I can insert a JSON response to make the test be
// independent of a live server
class PartialMockRestAPI extends RestAPI {
  String jsonResponseString;

  PartialMockRestAPI(this.jsonResponseString);

  @override
  Future<Response> makeJsonRequest(String url) async {
    return Future(() => Response(jsonResponseString, 200));
  }
}

@GenerateMocks([(RestAPI)])
void main() {
  test('fetch_games response gets correctly parsed', () async {
    const DUMMY_FETCHGAMES_JSON = '''
    [ 
        {
            "gameId": "1", 
            "coorX": "43.1473344217516", 
            "coorY": "-70.96334267332212",
            "startTime": "4:15 PM",
            "creatorId": "1",
            "players": ["2"]
        },
        {
            "gameId": "2", 
            "coorX": "43.1477991", 
            "coorY": "-70.963315",
            "startTime": "4:16 PM",
            "creatorId": "2",
            "players": ["1"]
        }
    ]
    ''';

    var partialMockRestAPI = PartialMockRestAPI(DUMMY_FETCHGAMES_JSON);

    // final client = MockRestAPI();
    double testCoorX = 1.0;
    double testCoorY = 1.0;

    // Build our app and trigger a frame.
    Future<List<Game>> gameList = partialMockRestAPI.fetchGames(testCoorX, testCoorY);

    gameList.then((games) => {
      expect(games.length, 2)
    });
  });

  test('create_game response gets correctly parsed', () async {
    const DUMMY_CREATEGAME_JSON = '''
    {
        "success": "true", 
        "error_msg": ""
    }
    ''';

    var partialMockRestAPI = PartialMockRestAPI(DUMMY_CREATEGAME_JSON);

    // final client = MockRestAPI();
    double testCoorX = 1.0;
    double testCoorY = 1.0;

    // Build our app and trigger a frame.
    Future<BoolResponse> gameList = partialMockRestAPI.createGame("12:45", "3/5", 5, testCoorX, testCoorY);

    gameList.then((BoolResponse boolResponse) => {
      expect(boolResponse.boolResponse, true),
      expect(boolResponse.errorMessage, "")
    });
  });

  test('join_game response gets correctly parsed', () async {
    const DUMMY_JOINGAME_JSON = '''
    {
        "success": "true", 
        "error_msg": ""
    }
    ''';

    var partialMockRestAPI = PartialMockRestAPI(DUMMY_JOINGAME_JSON);

    // final client = MockRestAPI();
    String gameId = "5";
    String playerId = "2";

    // Build our app and trigger a frame.
    Future<BoolResponse> gameList = partialMockRestAPI.joinGame(gameId, playerId);

    gameList.then((BoolResponse boolResponse) => {
      expect(boolResponse.boolResponse, true),
      expect(boolResponse.errorMessage, "")
    });
  });
}
