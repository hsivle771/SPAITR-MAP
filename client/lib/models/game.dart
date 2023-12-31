import 'package:spaitr_map/models/player.dart';

class Game {
  double coorX;
  double coorY;
  String id;

  String startTime;
  String date;
  String creatorId;
  List<Player> players;
  int maxPlayers;

  Game(this.coorX, this.coorY, this.id, this.startTime, this.creatorId, this.players, this.date, this.maxPlayers);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory Game.fromJson(Map<String, dynamic> data) {    // this is required if robust lint rules are enabled
    final coorX = data['x_coord'] as double;
    final coorY = data['y_coord'] as double;
    final id = data['_id'] as String;

    final date = data['date'] as String;
    final startTime = data['time'] as String;
    // final creatorId = data['creatorId'] as String;
    const creatorId = "1";

    final playersRaw = data['player_list'] as List<dynamic>;
    final players = playersRaw.map<Player>((playerInfo) => Player.fromDynamic(playerInfo)).toList();
    final maxPlayers = data["max_players"] as int;

    // TODO: double.parse could fail here and cause problems
    return Game(coorX, coorY, id, startTime, creatorId, players, date, maxPlayers);
  }

  @override
  String toString() {
    return '''
     Game $id
        X-Coor: $coorX
        Y-Coor: $coorY
        Start Time: $startTime
        creatorId: $creatorId
        players: $players
    ''';
  }
}