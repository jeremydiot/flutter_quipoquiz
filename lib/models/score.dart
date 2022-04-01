import 'dart:convert';

class Score{
  int id;
  int correct;
  int total;

  Score(this.id, this.correct, this.total);

  String toJson(){
    return jsonEncode({
      'id': id.toString(),
      'correct' : correct.toString(),
      'total': total.toString()
    });
  }

  factory Score.fromJson(String json){
    Map<String, dynamic> map = jsonDecode(json);
    return Score(
        map['id'],
        map['correct'],
        map['total']
    );
  }
}