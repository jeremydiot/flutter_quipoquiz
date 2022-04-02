import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/blocs/history_cubit.dart';
import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:flutter_quiz_mds/models/question.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';
import 'package:flutter_quiz_mds/ui/screens/answer_question.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Repository _repository = Repository.factory();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          late int randomId;
          late List<Question> questions;

          while(true){
            randomId = Random().nextInt(maxQuizId - minQuizId) + minQuizId;

            try{
              questions = await _repository.selectQuiz(randomId);
              break;
            }catch(_){}
          }
          Navigator.pushNamed(context, "/answerQuestion", arguments:AnswerQuestionArguments(randomId, questions));
        },
        child: const Icon(Icons.play_arrow_outlined, size: 50,),
      ),
      appBar: AppBar(
        title: const Text("Quiz"),
      ),body: Column(
          children: [
            Expanded(child: BlocBuilder<HistoryCubit, List<Score>>(

              builder: (context, scores) {
                return ListView.separated(
                    itemCount: scores.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        title: Text("Quiz N° "+scores[index].id.toString()),
                        subtitle: Text("Score "+scores[index].correct.toString()+"/"+scores[index].total.toString()),
                        leading: const Icon(Icons.help_outline, size: 50),
                        onTap: () async {
                          List<Question> questions = await _repository.selectQuiz(scores[index].id);
                          Navigator.pushNamed(context, "/answerQuestion", arguments:AnswerQuestionArguments(scores[index].id, questions));
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index){
                      return const Divider(height: 0);
                    },
                );
              }
            )),
          ],
        ),

    );
  }
}
