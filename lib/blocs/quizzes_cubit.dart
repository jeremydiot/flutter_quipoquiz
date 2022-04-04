import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';

class QuizzesCubit extends Cubit<List<Quiz>>{

  final Repository _repository;

  Timer? _searchTimer;

  List<Quiz> _quizzes = [];
  String _search = "";

  QuizzesCubit(this._repository) : super([]) {
    _repository.loadQuizzes().then((quizzes){
      _quizzes = quizzes;
    }).whenComplete((){
      emit(_quizzes);
    });
  }


  void search(String value){
    _search = value;
    if(_searchTimer != null){
      _searchTimer?.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      if(value.isEmpty) {
        emit(_quizzes);
      } else {
        emit(_quizzes.where((e) => e.label.toLowerCase().contains(value.toLowerCase())).toList());
      }
    });
  }

  void addScore(Score score, int quizId){
    _quizzes.firstWhere((e) => e.id==quizId).scores.add(score);
    search(_search);
    _repository.saveQuizzes(_quizzes);
  }
}