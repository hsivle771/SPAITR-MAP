class Game {
  double coorX;
  double coorY;
  String id;

  Game(this.coorX, this.coorY, this.id);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory Game.fromJson(Map<String, dynamic> data) {    // this is required if robust lint rules are enabled
    final coorX = data['coorX'] as double;
    final coorY = data['coorY'] as double;
    final id = data['id'] as String;
    return Game(coorX, coorY, id);
  }

  @override
  String toString() {
    return "Game $id at ($coorX, $coorY)";
  }
}