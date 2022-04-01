import 'dart:convert';

import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:http/http.dart';
import 'package:sprintf/sprintf.dart';

class QuizRepository{
  Future<List<dynamic>> fetchQuiz(int id) async{
    print(quizApiHost+sprintf(selectQuizApiRoute,[id]));
    final Response response = await get(Uri.parse(quizApiHost+sprintf(selectQuizApiRoute,[id])));

    if(response.statusCode == 200) {
      List<dynamic> questions = [];
      final Map<String, dynamic> json = jsonDecode(response.body);
      if(json.containsKey("questions")) {
        questions = json['questions'];
      }
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<Map<String, String>> fetchAnswer(int quizId, int questionId, bool answer) async{
    final Response response = await get(Uri.parse(quizApiHost+sprintf(answerQuestionApiRoute,[quizId, answer.toString(), questionId])));

    if(response.statusCode == 200) {
      Map<String, String> answer = {};
      final Map<String, dynamic> json = jsonDecode(response.body);
      if(json.containsKey("answer")) {
        answer = json['answer'];
      }
      return answer;
    } else {
      throw Exception('Failed to load answer');
    }
  }

  Future<Map<String, dynamic>> fetchResult(int id) async{
    final Response response = await get(Uri.parse(quizApiHost+sprintf(resultQuizApiRoute,[id])));

    if(response.statusCode == 200) {
      Map<String, dynamic> result = {};
      final Map<String, dynamic> json = jsonDecode(response.body);
      if(json.containsKey("result")) {
        result = json['result'];
      }
      return result;
    } else {
      throw Exception('Failed to load result');
    }
  }
}