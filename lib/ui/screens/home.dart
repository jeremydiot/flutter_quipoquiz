import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/blocs/history_cubit.dart';
import 'package:flutter_quiz_mds/blocs/quiz_cubit.dart';
import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:flutter_quiz_mds/models/score.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final List<Score> listTest = List.generate(100, (index) => Score(index, index, index));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          bool ready = true;
          late int randomId;

          while(ready){
            randomId = Random().nextInt(maxQuizId - minQuizId) + minQuizId;
            try{
              await Provider.of<QuizCubit>(context, listen: false).loadQuiz(randomId);
              ready = false;
            }catch(_){}
          }
          await Navigator.of(context).pushNamed("/answerQuestion", arguments: {"quizId":randomId});
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
                          await Provider.of<QuizCubit>(context, listen: false).loadQuiz(scores[index].id);
                          await Navigator.of(context).pushNamed("/answerQuestion", arguments: {"quizId":scores[index].id});
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
