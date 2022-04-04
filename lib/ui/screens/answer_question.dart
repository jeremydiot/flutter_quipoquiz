import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/blocs/quizzes_cubit.dart';
import 'package:flutter_quiz_mds/blocs/question_cubit.dart';
import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:flutter_quiz_mds/models/answer_result.dart';
import 'package:flutter_quiz_mds/models/question.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:flutter_quiz_mds/models/quiz_result.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';
import 'package:flutter_quiz_mds/ui/screens/quiz_finished.dart';
import 'package:provider/provider.dart';

class AnswerQuestionArguments{
  final Quiz quiz;
  final List<Question> questions;
  AnswerQuestionArguments(this.quiz, this.questions);
}

class AnswerQuestion extends StatelessWidget {
  const AnswerQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Repository repository = Repository.factory();

    final args = ModalRoute.of(context)!.settings.arguments as AnswerQuestionArguments;
    final List<Question> questions  = args.questions;

    int questionTabNum = -1;
    bool nextQuestion() {
      questionTabNum++;
      if(questionTabNum < questions.length){
        Provider.of<QuestionCubit>(context, listen: false).loadQuestion(questions[questionTabNum]);
      } else {
        return false;
      }
      return true;
    }
    if(!nextQuestion()) Navigator.pop(context);

    // answer result modal
    void resultModal(parentContext, AnswerResult answerResult){
      bool onceTap = true;
      showDialog(
        barrierDismissible: false,
        context: parentContext,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    child: answerResult.correct?const Icon(Icons.check_circle, color: Colors.green, size: 60,):const Icon(Icons.cancel, color: Colors.red, size: 60,),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(child:SingleChildScrollView(
                    child:Text(
                        answerResult.detail,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize:20)
                    )
                  ),),
                  ElevatedButton(onPressed: () {
                    if(!onceTap) return;
                    onceTap = false;

                    if(!nextQuestion()){
                      repository.finishQuiz(args.quiz.id).then((QuizResult quizResult) async {
                        Provider.of<QuizzesCubit>(context, listen: false).addScore(quizResult.score,args.quiz.id);
                        await Navigator.pushNamed(context, "/quizFinished", arguments:QuizFinishedArguments(quizResult));
                        Navigator.pop(context); // close modal
                        Navigator.pop(parentContext); // close current screen
                      }).onError((error, stackTrace){
                        Navigator.pop(context); // close modal
                        Navigator.pop(parentContext); // close current screen
                      });
                    }else{
                      Navigator.pop(context);
                    }
                  }, child: const Text("Continuer"))
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title:Text(args.quiz.label)),
      body: BlocBuilder <QuestionCubit, Question?>(
        builder: (context, question){

          if(question == null) return const Text("Error");
          bool onceTap = true;

          return Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        apiHost+question.image,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress){
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error, size: 50, color: Colors.red,)),
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Text(
                      (questionTabNum+1).toString()+" / "+questions.length.toString(),
                      style: TextStyle(
                          fontSize:25,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Colors.black.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      (questionTabNum+1).toString()+" / "+questions.length.toString(),
                      style: const TextStyle(fontSize:25, color:  Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(child:SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      question.question,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize:25,
                        height: 1.4,
                        color: Colors.black.withOpacity(0.75)
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      question.credit,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                )
              )),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if(!onceTap) return;
                        onceTap = false;
                        //AnswerResult answerResult =  await repository.answerQuestion(args.quizId, question.id, true);
                        //resultModal(context, answerResult);
                      },
                    child: Row(
                      children: const [
                        Text(
                          "Vrai  ",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Icon(Icons.thumb_up)
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width / 2, 80),
                      primary: Colors.green.withOpacity(0.8),
                      shape: ContinuousRectangleBorder()
                    ),
                  ),
                  ElevatedButton(onPressed: () async {
                    if(!onceTap) return;
                    onceTap = false;

                    //AnswerResult answerResult =  await repository.answerQuestion(args.quizId, question.id, false);
                    //resultModal(context, answerResult);
                  }, child: Row(
                      children: const [
                        Text(
                            "Faux  ",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                        Icon(Icons.thumb_down)
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width / 2, 80),
                      primary: Colors.red.withOpacity(0.8),
                      shape: ContinuousRectangleBorder()
                    ),
                  )
                ],)
            ],
          );
        }
      )
    );
  }
}

