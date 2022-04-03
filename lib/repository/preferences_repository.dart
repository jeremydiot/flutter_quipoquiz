import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository{
  Future<void> saveQuizzes(List<Quiz> quizzes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("quizzes", quizzes.map((e)=>e.toJson()).toList());
  }

  Future<List<Quiz>> loadQuizzes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? quizPrefs =  prefs.getStringList("quizzes");
    List<Quiz> quizzes = [];

    // init prefs if it's empty
    if(quizPrefs == null){
      String quizListFile = await rootBundle.loadString('assets/json/quiz_list.json');
      json.decode(quizListFile).forEach((e) => quizzes.add(Quiz(int.parse(e["quiz_id"]!), e["label"]!, e["image_link"]!, [])));
      await saveQuizzes(quizzes);
      return await loadQuizzes();
    }

    quizPrefs.forEach((e)=>quizzes.add(Quiz.fromJson(e)));
    return quizzes;
  }
}