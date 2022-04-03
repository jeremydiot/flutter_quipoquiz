import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';

class QuizzesCubit extends Cubit<List<Quiz>>{
  final Repository _repository;
  Timer? searchTimer;

  QuizzesCubit(this._repository): super([]);

  void search(String value){
    if(searchTimer != null){
      searchTimer?.cancel();
    }

    if(value.isEmpty){
      _repository.loadQuizzes().then(emit);
    }else if(value.length > 2){
      searchTimer = Timer(const Duration(milliseconds: 500), () async {
        List<Quiz> quizzes = await _repository.loadQuizzes();
        emit(quizzes.where((e) => e.label.toLowerCase().contains(value.toLowerCase())).toList());
      });
    }

  }

  void addScore(Score score, int quizId){
    state.firstWhere((e) => e.id==quizId).scores.add(score);
    emit(state);
    _repository.saveQuizzes(state);
  }

  Future<void> loadQuizzes() async{
    List<Quiz> quizzes = await _repository.loadQuizzes();
    emit(quizzes);
  }
}