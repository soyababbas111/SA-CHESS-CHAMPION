import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess_pkg;
import '../models/game_mode.dart';
import '../services/ad_service.dart';

class GameController extends ChangeNotifier {
  late chess_pkg.Chess _game;
  GameMode _gameMode = GameMode.classic;
  
  int _whiteTime = 600;
  int _blackTime = 600;
  Timer? _timer;
  
  bool _isGameOver = false;
  String _winnerMessage = '';
  
  // Custom board theme colors
  Color lightSquare = const Color(0xFFE0E0E0);
  Color darkSquare = const Color(0xFF757575);

  chess_pkg.Chess get game => _game;
  GameMode get gameMode => _gameMode;
  int get whiteTime => _whiteTime;
  int get blackTime => _blackTime;
  bool get isGameOver => _isGameOver;
  String get winnerMessage => _winnerMessage;

  GameController() {
    _game = chess_pkg.Chess();
  }

  void startGame(GameMode mode) {
    _gameMode = mode;
    _game = chess_pkg.Chess();
    _isGameOver = false;
    _winnerMessage = '';

    if (mode == GameMode.quick) {
      _whiteTime = 300;
      _blackTime = 300;
    } else if (mode == GameMode.classic) {
      _whiteTime = 600;
      _blackTime = 600;
    } else {
      _whiteTime = 600;
      _blackTime = 600;
    }

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameOver) {
        timer.cancel();
        return;
      }

      if (_game.turn == chess_pkg.Color.WHITE) {
        if (_whiteTime > 0) {
          _whiteTime--;
        } else {
          _endGame("Black wins on time!");
        }
      } else {
        if (_blackTime > 0) {
          _blackTime--;
        } else {
          _endGame("White wins on time!");
        }
      }
      notifyListeners();
    });
  }

  bool makeMove(Map<String, dynamic> move) {
    if (_isGameOver) return false;

    try {
      bool success = _game.move(move);
      if (success) {
        if (_game.game_over) {
          _checkGameOverConditions();
        } else if (_gameMode == GameMode.computer && _game.turn == chess_pkg.Color.BLACK) {
          _makeComputerMove();
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  void _makeComputerMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isGameOver) return;
      var moves = _game.moves({'verbose': true});
      if (moves.isNotEmpty) {
        moves.shuffle();
        _game.move(moves.first);
        if (_game.game_over) {
          _checkGameOverConditions();
        }
        notifyListeners();
      }
    });
  }

  void _checkGameOverConditions() {
    _isGameOver = true;
    _timer?.cancel();
    
    if (_game.in_checkmate) {
      String winner = _game.turn == chess_pkg.Color.WHITE ? "Black" : "White";
      _winnerMessage = "👑 Checkmate! $winner Wins!";
    } else if (_game.in_draw) {
      _winnerMessage = "Game Drawn!";
    } else {
      _winnerMessage = "Game Over!";
    }
    
    AdService.instance.showInterstitial();
    notifyListeners();
  }

  void _endGame(String message) {
    _isGameOver = true;
    _timer?.cancel();
    _winnerMessage = message;
    AdService.instance.showInterstitial();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}