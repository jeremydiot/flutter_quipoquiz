import 'dart:convert';

class Score{
  int correct;
  int total;

  Score(this.correct, this.total);

  String toJson(){
    return jsonEncode({
      'correct' : correct,
      'total': total
    });
  }

  factory Score.fromJson(String json){
    var map = jsonDecode(json);
    return Score(
        map['correct'],
        map['total']
    );
  }
}