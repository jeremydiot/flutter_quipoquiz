# flutter_quipoquiz

## specification

### Versions
- Flutter: 2.10.0
- Dart: 2.16.0

### Functionalities
- Open from list
- Search quiz
- Store quiz result
- Show last quiz result

### API
- Base URL : https://quipoquiz.com/module/sed/quiz/fr
- Select and Get quiz question : /start_quiz.snc?quiz={quiz_id}
- Answer question : /answer_question.snc?quiz={quiz_id}&answer={true || false}&question={question_id}
- Finish quiz and get result : /end_quiz.snc?quiz={quiz_id}

### Quiz list
- Extracted with [python_quipoquiz_scraping](https://github.com/jeremydiot/python_quipoquiz_scraping) Project.

### Screens
- Home
  - Result of last quiz (recycler view list)
    - Quiz number
    - Score
    - click on open quiz => on result erase previous score

  - button to start random quiz
    - select quiz id, min: 1 max: 492
    - open question

- Questions
  - image
  - text ( question or response result )
  - buttons ( 2 response button (True, False) or next question button )
  - After last response, redirect to finish quiz

- Finish quiz
  - register result
  - result ( good response / answer number )
  - stats
  - buttons ( new quiz, quit to home )