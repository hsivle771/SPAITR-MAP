import 'package:spaitr_map/core/player.dart';

class BoolResponse {
  bool boolResponse;
  String errorMessage;

  BoolResponse(this.boolResponse, this.errorMessage);

  // https://codewithandrea.com/articles/parse-json-dart/
  factory BoolResponse.fromJson(Map<String, dynamic> data) {    // this is required if robust lint rules are enabled
    final boolResponse = data['success'] as String;
    final errorMessage = data['error_msg'] as String;

    return BoolResponse(boolResponse.toLowerCase() == 'true', errorMessage);
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