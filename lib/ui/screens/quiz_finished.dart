import 'package:flutter/material.dart';
import 'package:flutter_quiz_mds/models/quiz_result.dart';

class QuizFinishedArguments{
  QuizResult quizResult;
  QuizFinishedArguments(this.quizResult);
}

class QuizFinished extends StatelessWidget {
  const QuizFinished({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as QuizFinishedArguments;
    QuizResult quizResult = args.quizResult;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(
              quizResult.score.correct.toString()+"/"+quizResult.score.total.toString(),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10,),
            Text(
                "La moyenne est de \n"+(quizResult.average/quizResult.score.total).toStringAsFixed(1)+
                "/"+quizResult.score.total.toString()+" pour "+quizResult.count.toString()+" joueurs",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25
              ),
            ),
            const SizedBox(height: 10,),
            TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: ()=> Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false),
                child: const Text("Continuer"))
          ],),
        ),
      ),
    );
  }
}
