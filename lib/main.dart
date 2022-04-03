import 'package:flutter/material.dart';
import 'package:flutter_quiz_mds/blocs/quizzes_cubit.dart';
import 'package:flutter_quiz_mds/blocs/question_cubit.dart';
import 'package:flutter_quiz_mds/repository/Repository.dart';
import 'package:flutter_quiz_mds/ui/screens/quiz_finished.dart';
import 'package:flutter_quiz_mds/ui/screens/home.dart';
import 'package:flutter_quiz_mds/ui/screens/answer_question.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final Repository repository = Repository.factory();

  final QuizzesCubit quizzesCubit = QuizzesCubit(repository);
  quizzesCubit.loadQuizzes();

  final QuestionCubit questionCubit = QuestionCubit();

  runApp(
    MultiProvider(
      providers: [
        Provider<QuizzesCubit>(create: (_) => quizzesCubit),
        Provider<QuestionCubit>(create:(_) => questionCubit)
      ],
      child:const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/answerQuestion' : (context) => const AnswerQuestion(),
        '/quizFinished' : (context) => const QuizFinished(),
        '/home' : (context) => const Home(),
      },
      home: const Home(),
    );
  }
}