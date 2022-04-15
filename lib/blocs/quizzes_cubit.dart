import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';

class QuizzesCubit extends Cubit<List<Quiz>>{

  final Repository _repository;
  Timer? _searchTimer;

  QuizzesCubit(this._repository) : super([]) {
    _repository.loadQuizzes().then((quizzes){
      emit(quizzes);
    });
  }

  void search(String value){
    if(_searchTimer != null){
      _searchTimer?.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      _repository.loadQuizzes().then((quizzes){
        if(value.isEmpty) {
          emit(quizzes);
        } else {
          emit(quizzes.where((e) => e.label.toLowerCase().contains(value.toLowerCase())).toList());
        }
      });
    });
  }

  void addScore(Score score, int quizId){
    state.firstWhere((e) => e.id==quizId).score = score;
    emit([...state]);

    _repository.loadQuizzes().then((quizzes){
      quizzes.firstWhere((e) => e.id==quizId).score = score;
      _repository.saveQuizzes(quizzes);
    });
  }
}