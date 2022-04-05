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
          bool onceTap = false;
          const double padding = 15;
          const double radius = 30;
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    padding: const EdgeInsets.only(
                      top: padding+radius,
                      bottom: padding,
                      left: padding,
                      right: padding,
                    ),
                    margin: const EdgeInsets.only(top:radius),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(padding),
                      boxShadow: const [BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0,10)
                      )]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                                answerResult.detail,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:20,
                                    color: Colors.black.withOpacity(0.75)
                                )
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if(onceTap) return;
                            onceTap = true;

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
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text("Continuer"),
                              Icon(Icons.navigate_next)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: padding,
                    right: padding,
                    child: CircleAvatar(
                      child: Icon(
                        answerResult.correct?Icons.check:Icons.close,
                        color: Colors.white,
                        size: radius*2
                      ),
                      backgroundColor: answerResult.correct? Colors.green : Colors.red,
                      radius: radius,
                    ))
                ],
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
                        height: 1.2,
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
                        AnswerResult answerResult =  await repository.answerQuestion(args.quiz.id, question.id, true);
                        resultModal(context, answerResult);
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

                    AnswerResult answerResult =  await repository.answerQuestion(args.quiz.id, question.id, false);
                    resultModal(context, answerResult);
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

