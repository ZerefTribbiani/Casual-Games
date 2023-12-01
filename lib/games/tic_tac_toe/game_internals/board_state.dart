import 'dart:math' show max, min;

import 'package:basic/games/tic_tac_toe/play_session/player.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class BoardState extends ChangeNotifier {
  static final _log = Logger('Board State');

  final void Function(Player) onGameFinish;

  int currentPlayer = 1;
  int filledBoxes = 0;
  Player winner = Player.none;

  late List<List<Player>> tileOwners;
  late List<List<bool>> winningTiles;

  BoardState({
    required this.onGameFinish,
    int rows = 3,
    int cols = 3,
  }) {
    tileOwners = List.generate(rows, (index) => List.filled(cols, Player.none));
    winningTiles = List.generate(rows, (index) => List.filled(cols, false));
  }

  makeMove(int index, int n) {
    int x = index ~/ tileOwners[0].length;
    int y = index % tileOwners[0].length;

    if (tileOwners[x][y] == Player.none) {
      tileOwners[x][y] = currentPlayer == 1 ? Player.x : Player.o;
      filledBoxes++;
      if (_checkForWin(x, y, n)) {
        onGameFinish(tileOwners[x][y]);
      } else if (_checkForDraw()) {
        onGameFinish(Player.none);
      } else {
        currentPlayer = 3 - currentPlayer;
      }
      notifyListeners();
    }
  }

  bool _checkForWin(int x, int y, int goal) {
    int rows = tileOwners.length;
    int cols = tileOwners[0].length;
    Player currentSide = tileOwners[x][y];

    // Checking rows
    int count = 0;
    int yStart = max(0, y - goal + 1);
    int yEnd = min(cols - 1, y + goal - 1);
    for (var i = yStart; i <= yEnd; i++) {
      if (tileOwners[x][i] == currentSide) {
        count++;
        if (count == goal) {
          _highlightWinningTiles(x, i, goal, 'Row');
          return true;
        }
      } else {
        count = 0;
      }
    }

    // Checking columns
    count = 0;
    int xStart = max(0, x - goal + 1);
    int xEnd = min(rows - 1, x + goal - 1);
    for (var i = xStart; i <= xEnd; i++) {
      if (tileOwners[i][y] == currentSide) {
        count++;
        if (count == goal) {
          _highlightWinningTiles(i, y, goal, 'Column');
          return true;
        }
      } else {
        count = 0;
      }
    }

    // Checking top-left to bottom-right diagonal
    count = 0;
    int diagX = x;
    int diagY = y;
    while (diagX > 0 && diagY > 0) {
      diagX--;
      diagY--;
    }
    while (diagX < rows && diagY < cols) {
      if (tileOwners[diagX][diagY] == currentSide) {
        count++;
        if (count == goal) {
          _highlightWinningTiles(
              diagX, diagY, goal, 'TopLeftBottomRightDiagonal');
          return true;
        }
      } else {
        count = 0;
      }
      diagX++;
      diagY++;
    }

    // Checking bottom-left to top-right diagonal
    count = 0;
    diagX = x;
    diagY = y;
    while (diagX < rows - 1 && diagY > 0) {
      diagX++;
      diagY--;
    }
    while (diagX >= 0 && diagY < cols) {
      if (tileOwners[diagX][diagY] == currentSide) {
        count++;
        if (count == goal) {
          _highlightWinningTiles(
              diagX, diagY, goal, 'BottomLeftTopRightDiagonal');
          return true;
        }
      } else {
        count = 0;
      }
      diagX--;
      diagY++;
    }
    return false;
  }

  bool _checkForDraw() {
    int rows = tileOwners.length;
    int cols = tileOwners[0].length;
    return filledBoxes == rows * cols;
  }

  void _highlightWinningTiles(int x, int y, int goal, String winType) {
    switch (winType) {
      case 'Row':
        for (int i = 0; i < goal; i++) {
          winningTiles[x][y - i] = true;
        }
      case 'Column':
        for (int i = 0; i < goal; i++) {
          winningTiles[x - 1][y] = true;
        }
      case 'TopLeftBottomRightDiagonal':
        for (int i = 0; i < goal; i++) {
          winningTiles[x - i][y - i] = true;
        }
      case 'BottomLeftTopRightDiagonal':
        for (int i = 0; i < goal; i++) {
          winningTiles[x + i][y - i] = true;
        }
      default:
        _log.info('Invalid winType parameter passed: $winType');
    }
  }
}
