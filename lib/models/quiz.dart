import 'dart:convert';

import 'package:flutter_quiz_mds/models/score.dart';

class Quiz{
  int id;
  String label;
  String imageLink;
  List<Score> scores;

  Quiz(this.id, this.label, this.imageLink, this.scores);

  String toJson(){
    return jsonEncode({
      'id' : id,
      'label': label,
      'imageLink': imageLink,
      'scores': jsonEncode(scores)
    });
  }

  factory Quiz.fromJson(String json){
    var map = jsonDecode(json);
    return Quiz(
      map['id'],
      map['label'],
      map['imageLink'],
      Score.fromJsonList(map['scores']),
    );
  }
}