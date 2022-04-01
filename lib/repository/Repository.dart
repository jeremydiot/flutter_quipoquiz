import 'package:flutter_quiz_mds/models/answer_result.dart';
import 'package:flutter_quiz_mds/models/question.dart';
import 'package:flutter_quiz_mds/models/quiz_result.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/preferences_repository.dart';
import 'package:flutter_quiz_mds/repository/quiz_repository.dart';

class Repository{
  final PreferencesRepository _preferencesRepository;
  final QuizRepository _quizRepository;

  Repository(this._preferencesRepository, this._quizRepository);

  Future<List<Question>> selectQuiz(int id) async{
    List<Question> questions = [];

    List<dynamic> apiResponse =  await _quizRepository.fetchQuiz(id);

    apiResponse.forEach((element) {
      questions.add(
        Question(
          int.parse(element["uid_variation"]),
          element["question"],
          element["credit"],
          element["image"],
        )
      );
    });

    return questions;
  }

  Future<AnswerResult> answerQuestion(int quizId, int questionId, bool answer) async{
    Map<String, String> apiResponse =  await _quizRepository.fetchAnswer(quizId, questionId, answer);

    return AnswerResult(
        (apiResponse["correct"]=="true")?true:false,
        apiResponse["explanation"] ?? ""
    );
  }

  Future<QuizResult> finishQuiz(int id) async{
    Map<String, dynamic> apiResponse = await _quizRepository.fetchResult(id);
    Score score = Score(id,int.parse(apiResponse["correct"]), int.parse(apiResponse["total"]));
    
    return QuizResult(score, apiResponse["statistics"]["new_avg"], int.parse(apiResponse["statistics"]["nb_attempt"]));
  }

  Future<List<Score>> loadHistory() async => await _preferencesRepository.loadHistory();

  Future<void> saveHistory(List<Score> scores) async => await _preferencesRepository.saveHistory(scores);
}