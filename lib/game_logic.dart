import 'dart:math';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  int gridSize = 3;
  List<int> tiles = [];
  int moves = 0;
  bool isSolved = false;
  Stopwatch _stopwatch = Stopwatch();

  GameState() {
    startNewGame(3);
  }

  String get timeElapsed {
    final duration = _stopwatch.elapsed;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startNewGame(int size) {
    gridSize = size;
    moves = 0;
    isSolved = false;
    _stopwatch.reset();
    _stopwatch.start();
    
    // Initialize tiles [1, 2, ..., N*N-1, 0]
    tiles = List.generate(gridSize * gridSize, (index) {
      if (index == gridSize * gridSize - 1) return 0; // Empty tile
      return index + 1;
    });

    _shuffle();
    notifyListeners();
  }

  void _shuffle() {
    // Perform random valid moves to ensure solvability
    final random = Random();
    int emptyIndex = tiles.indexOf(0);
    int previousIndex = -1;

    for (int i = 0; i < 100 * gridSize; i++) {
      List<int> validMoves = _getValidMoves(emptyIndex);
      // Avoid immediately undoing the move
      validMoves.remove(previousIndex);
      
      if (validMoves.isEmpty) {
        // Should rarely happen in this shuffle method, but safe fallback
        validMoves = _getValidMoves(emptyIndex); 
      }
      
      int moveIndex = validMoves[random.nextInt(validMoves.length)];
      _swap(emptyIndex, moveIndex);
      previousIndex = emptyIndex; // The old empty pos is where the tile came from
      emptyIndex = moveIndex;
    }
  }

  List<int> _getValidMoves(int emptyIndex) {
    List<int> moves = [];
    int row = emptyIndex ~/ gridSize;
    int col = emptyIndex % gridSize;

    // Up
    if (row > 0) moves.add(emptyIndex - gridSize);
    // Down
    if (row < gridSize - 1) moves.add(emptyIndex + gridSize);
    // Left
    if (col > 0) moves.add(emptyIndex - 1);
    // Right
    if (col < gridSize - 1) moves.add(emptyIndex + 1);

    return moves;
  }

  void moveTile(int index) {
    if (isSolved) return;

    int emptyIndex = tiles.indexOf(0);
    
    // Check adjacency
    int row = index ~/ gridSize;
    int col = index % gridSize;
    int emptyRow = emptyIndex ~/ gridSize;
    int emptyCol = emptyIndex % gridSize;

    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      
      _swap(index, emptyIndex);
      moves++;
      _checkWin();
      notifyListeners();
    }
  }

  void _swap(int i, int j) {
    int temp = tiles[i];
    tiles[i] = tiles[j];
    tiles[j] = temp;
  }

  void _checkWin() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return;
    }
    _stopwatch.stop();
    isSolved = true;
  }
}
