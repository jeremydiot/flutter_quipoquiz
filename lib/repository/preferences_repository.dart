import 'package:flutter_quiz_mds/models/score.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository{
  Future<void> saveHistory(List<Score> scores) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("scores", scores.map((score)=>score.toJson()).toList());
  }

  Future<List<Score>> loadHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scoresPrefs =  prefs.getStringList("scores") ?? [];

    return scoresPrefs.map((score) => Score.fromJson(score)).toList();
  }
}