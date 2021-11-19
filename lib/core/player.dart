// TODO: In the future, probably can store more information like username, etc.
class Player {
  String id;

  Player(this.id);

  factory Player.fromDynamic(dynamic data) {
    final id = data as String;
    return Player(id);
  }

  // https://codewithandrea.com/articles/parse-json-dart/
  factory Player.fromJson(Map<String, dynamic> data) {    // this is required if robust lint rules are enabled
    final id = data['id'] as String;

    return Player(id);
  }

  @override
  String toString() {
    return "Player $id";
  }
}