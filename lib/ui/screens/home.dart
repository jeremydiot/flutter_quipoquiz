import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quiz_mds/blocs/quizzes_cubit.dart';
import 'package:flutter_quiz_mds/config/constants.dart';
import 'package:flutter_quiz_mds/models/quiz.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';
import 'package:flutter_quiz_mds/ui/screens/answer_question.dart';
import 'package:flutter_quiz_mds/ui/widgets/full_screen_loading.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Repository repository = Repository.factory();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(50),
          child: const Image(
            image: AssetImage('assets/image/banner.png')
          )
        )
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocBuilder<QuizzesCubit, List<Quiz>>(
            builder: (context, quizzes) {
              bool onceTap = false;
              return GridView.builder(
                cacheExtent: 10000,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
                ),
                itemCount: quizzes.length,
                itemBuilder: (BuildContext context, int index){

                  final String label = quizzes[index].label;
                  final lastScoreResult = (quizzes[index].score.total > 0)?quizzes[index].score.correct.toString()+"/"+quizzes[index].score.total.toString():"";
                  final imageUrl = apiHost+quizzes[index].imageLink;

                  return GridTile(
                    child: InkWell(
                      onTap: () {
                        if(onceTap) return;
                        onceTap = true;
                        fullScreenLoading(context);
                        FocusScope.of(context).unfocus();
                        repository.selectQuiz(quizzes[index].id).then((questions) {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/answerQuestion", arguments:AnswerQuestionArguments(quizzes[index],questions));
                          onceTap = false;
                        }).onError((error, stackTrace) {Navigator.pop(context);});
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(label,
                                style: const TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              )
                            )
                          ),
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: CachedNetworkImageProvider(imageUrl, errorListener: () => Center(child: Icon(Icons.error, size: 50, color: Colors.red.withOpacity(0.5)))),
                                fit: BoxFit.fill
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(3, 3), // changes position of shadow changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                            child: Text(lastScoreResult,style: TextStyle(
                              fontSize: 15,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = Colors.black,
                                 ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                            child: Text(lastScoreResult,style: const TextStyle(color: Colors.white, fontSize: 15),),
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
            }
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 1,
                    blurRadius: 6,
                  ),
                ],
            ),
            margin:const EdgeInsets.all(20),
            child: TextField(
              autocorrect: false,
              autofocus: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                labelText: "Rechercher..."
              ),
              onChanged: (String value){
                Provider.of<QuizzesCubit>(context, listen: false).search(value);
              },
            )
          )
        ]
      )
    );
  }
}
