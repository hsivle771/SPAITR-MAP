import 'package:spaitr_map/models/player.dart';

class BoolResponse {
  bool boolResponse;

  BoolResponse(this.boolResponse);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory BoolResponse.fromJson(bool data) {    // this is required if robust lint rules are enabled
    final boolResponse = data;

    return BoolResponse(boolResponse);
  }

  @override
  String toString() {
    return '''
     BoolResponse
        response: $boolResponse
    ''';
  }
}