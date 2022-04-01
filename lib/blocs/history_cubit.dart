import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';

class HistoryCubit extends Cubit<List<Score>>{
  final Repository _repository;
  HistoryCubit(this._repository): super([]);

  void addCompany(Score score){
    emit([...state, score]);
    _repository.saveHistory(state);
  }

  Future<void> loadCompanies() async{
    final List<Score> scores = await _repository.loadHistory();
    emit(scores);
  }
}