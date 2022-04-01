import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/blocs/quiz_cubit.dart';
import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:flutter_quiz_mds/models/question.dart';


class AnswerQuestion extends StatelessWidget {
  const AnswerQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Map<String, int> args = ModalRoute.of(context)?.settings.arguments as Map<String, int>;

    return Scaffold(
      appBar: AppBar(title: Text("Quiz N° "+args["quizId"].toString()),),
      body: BlocBuilder <QuizCubit, List<Question>>(
        builder: (context, questions){
          Question currentQuestion = questions[0];
          return Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    apiHost+currentQuestion.image,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.scaleDown,
                    loadingBuilder: (context, child, loadingProgress){
                      if (loadingProgress == null) return child;

                      return const Center(child: Text('Loading...'));
                    },
                    errorBuilder: (context, error, stackTrace) => const Text('Some errors occurred!'),
                  )
                )


                // Text(currentQuestion.question),
                // Text(currentQuestion.credit),
                // Text(currentQuestion.image),
                // Text(currentQuestion.id.toString()),
              ],
            ),
          );
        }
      )
    );


      BlocBuilder <QuizCubit, List<Question>>(
        builder: (context, questions){

          return Scaffold(
            appBar: AppBar(title: Text("Quizz N°"),),

          );
        }
    );
  }
}
