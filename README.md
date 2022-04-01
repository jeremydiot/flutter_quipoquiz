# flutter_quiz_mds

## specification

### Versions
- Flutter: 2.10.0
- Dart: 2.16.0

### Functionalities
- Open random quiz from API
- Store quiz result in app
- Show history of results
- Reopen quiz from history list

### API
- Host : https://quipoquiz.com/module/sed/quiz/fr/
- Select quiz : /start_quiz.snc?quiz=1
- Answer question : /answer_question.snc?quiz=1&answer=false&question=1
- Quiz result : /end_quiz.snc?quiz=1

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