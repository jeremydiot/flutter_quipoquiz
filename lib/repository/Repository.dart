import 'package:flutter_quiz_mds/config/util.dart';
import 'package:flutter_quiz_mds/models/answer_result.dart';
import 'package:flutter_quiz_mds/models/question.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
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
          int.parse(
            element["uid_variation"]),
            removeHtml(element["question"]),
            element["credit"],
            element["image"],
        )
      );
    });

    return questions;
  }

  Future<AnswerResult> answerQuestion(int quizId, int questionId, bool answer) async{
    Map<String, dynamic> apiResponse =  await _quizRepository.fetchAnswer(quizId, questionId, answer);
    return AnswerResult(
        apiResponse["correct"],
        removeHtml(apiResponse["explanation"]?.toString() ?? "")
    );
  }

  Future<QuizResult> finishQuiz(int id) async{
    Map<String, dynamic> apiResponse = await _quizRepository.fetchResult(id);
    Score score = Score(int.parse(apiResponse["correct"]), int.parse(apiResponse["total"]));
    return QuizResult(score, apiResponse["statistics"]["new_avg"], int.parse(apiResponse["statistics"]["nb_attempt"]));
  }

  Future<List<Quiz>> loadQuizzes() => _preferencesRepository.loadQuizzes();

  Future<void> saveQuizzes(List<Quiz> quizzes) => _preferencesRepository.saveQuizzes(quizzes);

  factory Repository.factory(){
    return Repository(PreferencesRepository(), QuizRepository());
  }
}