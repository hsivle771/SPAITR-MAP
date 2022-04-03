import 'package:flutter_test/flutter_test.dart';
import 'package:spaitr_map/create_game.dart';

// Test to check if your google api key works correctly
void main() {
  test('validateNewGameSettings test', () async {
    String validGameTime = "6:23pm";
    String validGameDate = "1/23/2012";

    String invalidGameTime = "";
    String invalidGameDate = "";

    expect(Validators.validateNewGameSettings(validGameTime, validGameDate), true);
    expect(Validators.validateNewGameSettings(validGameDate, invalidGameDate), false);
    expect(Validators.validateNewGameSettings(invalidGameTime, validGameDate), false);
    expect(Validators.validateNewGameSettings(invalidGameTime, invalidGameDate), false);
  });
}
