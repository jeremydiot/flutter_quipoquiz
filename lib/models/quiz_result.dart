import 'package:flutter_quiz_mds/models/score.dart';

class QuizResult{
  Score score;
  double average;
  int count;

  QuizResult(this.score, this.average, this.count);
}