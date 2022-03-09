import 'package:spaitr_map/core/player.dart';

class Game {
  double coorX;
  double coorY;
  String id;

  String startTime;
  String creatorId;
  List<Player> players;

  Game(this.coorX, this.coorY, this.id, this.startTime, this.creatorId, this.players);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory Game.fromJson(Map<String, dynamic> data) {    // this is required if robust lint rules are enabled
    final coorX = data['coorX'] as String;
    final coorY = data['coorY'] as String;
    final id = data['gameId'] as String;

    final startTime = data['startTime'] as String;
    final creatorId = data['creatorId'] as String;

    final playersRaw = data['players'] as List<dynamic>;
    final players = playersRaw.map<Player>((playerInfo) => Player.fromDynamic(playerInfo)).toList();

    // TODO: double.parse could fail here and cause problems
    return Game(double.parse(coorX), double.parse(coorY), id, startTime, creatorId, players);
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