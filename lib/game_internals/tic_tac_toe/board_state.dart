import 'dart:math' show max, min;

import 'package:basic/play_session/tic_tac_toe/tile.dart';
import 'package:flutter/material.dart';

class BoardState extends ChangeNotifier {
  int currentPlayer = 1;
  int filledBoxes = 0;

  late List<List<Player>> tileOwners;

  BoardState({int rows = 3, int cols = 3}) {
    tileOwners = List.generate(rows, (index) => List.filled(cols, Player.none));
  }

  makeMove(int index, int n) {
    int x = index ~/ tileOwners[0].length;
    int y = index % tileOwners[0].length;

    if (tileOwners[x][y] == Player.none) {
      tileOwners[x][y] = currentPlayer == 1 ? Player.x : Player.o;
      currentPlayer = 3 - currentPlayer;
      filledBoxes++;
      notifyListeners();
      _checkForWin(x, y, n);
    }
  }

  _checkForWin(int x, int y, int n) {
    int rows = tileOwners.length;
    int cols = tileOwners[0].length;
    Player currentSide = tileOwners[x][y];

    // Checking rows
    int count = 0;
    int yStart = max(0, y - n + 1);
    int yEnd = min(cols - 1, y + n - 1);
    for (var i = yStart; i <= yEnd; i++) {
      if (tileOwners[x][i] == currentSide) {
        count++;
        if (count == n) {
          _onWin();
          return;
        }
      } else {
        count = 0;
      }
    }

    // Checking columns
    count = 0;
    int xStart = max(0, x - n + 1);
    int xEnd = min(rows - 1, x + n - 1);
    for (var i = xStart; i <= xEnd; i++) {
      if (tileOwners[i][y] == currentSide) {
        count++;
        if (count == n) {
          _onWin();
          return;
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
        if (count == n) {
          _onWin();
          return;
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
        if (count == n) {
          _onWin();
          return;
        }
      } else {
        count = 0;
      }
      diagX--;
      diagY++;
    }

    // Checking for draw
    if (filledBoxes == rows * cols) {
      _onDraw();
    }
  }

  void _onWin() {
    print('Won');
  }

  void _onDraw() {
    print('Draw');
  }
}
