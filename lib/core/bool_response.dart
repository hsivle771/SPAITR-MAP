import 'package:spaitr_map/core/player.dart';

class BoolResponse {
  bool boolResponse;
  String errorMessage;

  BoolResponse(this.boolResponse, this.errorMessage);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory BoolResponse.fromJson(bool data) {    // this is required if robust lint rules are enabled
    final boolResponse = data;
    const errorMessage = "";

    return BoolResponse(boolResponse, errorMessage);
  }

  @override
  String toString() {
    return '''
     BoolResponse
        response: $boolResponse
        error_msg: $errorMessage
    ''';
  }
}