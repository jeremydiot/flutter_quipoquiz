import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/question.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';

class QuizCubit extends Cubit<List<Question>>{
  final Repository _repository;
  QuizCubit(this._repository): super([]);

  void clear(){
    emit([]);
  }

  Future<void> loadQuiz(int id) async{
    final List<Question> questions = await _repository.selectQuiz(id);
    emit(questions);
  }
}