import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/question.dart';

class QuestionCubit extends Cubit<Question?>{
  QuestionCubit() : super(null);

  void loadQuestion(Question question){
    emit(question);
  }

  void clear(){
    emit(null);
  }
}