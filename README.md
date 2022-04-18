# flutter_quipoquiz

## specification

### Versions
- Flutter: 2.10.0
- Dart: 2.16.0

### Functionalities
- Open quiz from list
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
  - all quizzes (recycler grid view) loaded form share preferences
    - quiz image / label
    - score
    - on tap open view with quiz questions
  - new score for an quiz erase previous score => saved in share preferences
  - on tap all question loaded from API

- Questions
  - for each question
    - image
    - text question
    - buttons, 2 response button (True, False) => send answer to API
  - result of answer displayed on dialog element
  - After last response, redirect to finish quiz view

- Finish quiz
  - register result => in share preferences
  - score ( good response / answer number )
  - stats from API
  - buttons return to home