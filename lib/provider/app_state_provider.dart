import 'dart:async';
import 'dart:math';
import 'package:capek_mikir/provider/user_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:capek_mikir/models/question.dart';
import 'package:capek_mikir/models/categories.dart';
import '../data/questions_list.dart';
import 'package:flutter/foundation.dart';

class AppStateProvider extends ChangeNotifier {
  // ==== KONSTANTA ====
  static const int _quizTime = 180; // 3 menit dalam detik

  // ==== STATE ====
    final List<Question> _questions = [];
    final Map<int, String?> _answers = {}; // index -> jawaban user

  int _currentIndex = 0;
  int _score = 0;
  late Categories _category;

  // ==== TIMER ====
  Timer? _timer;
  int _remainingSeconds = _quizTime;
  bool _isTimeUp = false;

  // ==== KONSTRUKTOR ====
  AppStateProvider(UserStateProvider userProvider) {
    _category = userProvider.category ?? Categories.programming;
    _loadAndRandomizeQuestions();
    _startTimer();
  }

  // ==== GETTER ====
  List<Question> get questions => _questions;

  int get currentIndex => _currentIndex;

  int get score => _score;

  bool get isFirst => _currentIndex == 0;

  bool get isLast => _currentIndex == _questions.length - 1;

  bool get isTimeUp => _isTimeUp;

  int get remainingSeconds => _remainingSeconds;

  Question? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  String? get selectedAnswer => _answers[_currentIndex];

  bool get isAnswered => _answers[_currentIndex] != null;

  String? getAnswerFor(int index) => _answers[index];

  // ==== WAKTU ====
  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds
        .toString()
        .padLeft(2, '0')}";
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _quizTime;
    _isTimeUp = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _isTimeUp = true;
        t.cancel();
        calculateScore();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    _remainingSeconds = _quizTime;
    _isTimeUp = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ==== LOGIKA QUIZ ====
  void _loadAndRandomizeQuestions() {
    final baseQuestions = QuestionList.questions[_category] ?? [];
    final randomized = List<Question>.from(baseQuestions)
      ..shuffle(Random());

    _questions
      ..clear()
      ..addAll(
        randomized.take(10).map((q) {
          final shuffledChoices = List<String>.from(q.choices)
            ..shuffle(Random());
          return Question(
            problem: q.problem,
            choices: shuffledChoices,
            solution: q.solution,
            explanation: q.explanation,
          );
        }),
      );

    _answers.clear();
    _score = 0;
    _currentIndex = 0;
    notifyListeners();
  }

  void selectAnswer(String choice) {
    _answers[_currentIndex] = choice;
    notifyListeners();
  }

  void nextQuestion() {
    if (!isLast) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (!isFirst) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void calculateScore() {
    _score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].solution) {
        _score++;
      }
    }
  }

  void resetQuiz(UserStateProvider userProvider) {
    _category = userProvider.category ?? Categories.programming;
    _score = 0;
    _currentIndex = 0;
    _answers.clear();
    resetTimer();
  }

  void restartQuiz(UserStateProvider userProvider) {
    stopTimer();
    _category = userProvider.category ?? Categories.programming;
    _loadAndRandomizeQuestions();
    _startTimer();
    notifyListeners();
  }
}