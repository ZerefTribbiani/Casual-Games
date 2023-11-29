import 'dart:math' show max, min;

import 'package:basic/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  final int rows;
  final int cols;
  final int n;

  const Board({
    super.key,
    required this.rows,
    required this.cols,
    required this.n,
  });

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  int currentPlayer = 1;
  int filledBoxes = 0;
  late List<String> tileDisplayList;

  @override
  void initState() {
    super.initState();
    tileDisplayList = List.filled(widget.rows * widget.cols, '');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Current Player: $currentPlayer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 40,
              height: 1,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: GridView.builder(
            itemCount: widget.rows * widget.cols,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cols),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (() {
                  _tapped(index);
                }),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: palette.inkFullOpacity,
                      width: 5.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tileDisplayList[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 55,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _tapped(int index) {
    if (tileDisplayList[index] != '') {
      return;
    }

    setState(() {
      if (currentPlayer == 1) {
        tileDisplayList[index] = 'X';
        currentPlayer = 2;
      } else {
        tileDisplayList[index] = 'O';
        currentPlayer = 1;
      }
    });
    filledBoxes++;
    _checkForWin(index, tileDisplayList[index]);
  }

  void _checkForWin(int index, String player) {
    int x = index ~/ widget.cols;
    int y = index % widget.cols;

    // Checking rows
    int count = 0;
    int yStart = max(0, y - widget.n + 1);
    int yEnd = min(widget.cols - 1, y + widget.n - 1);
    for (var i = yStart; i <= yEnd; i++) {
      if (tileDisplayList[x * widget.cols + i] == player) {
        count++;
        if (count == widget.n) {
          _onWin(player);
          return;
        }
      } else {
        count = 0;
      }
    }

    // Checking columns
    count = 0;
    int xStart = max(0, x - widget.n + 1);
    int xEnd = min(widget.rows - 1, x + widget.n - 1);
    for (var i = xStart; i <= xEnd; i++) {
      if (tileDisplayList[i * widget.cols + y] == player) {
        count++;
        if (count == widget.n) {
          _onWin(player);
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
    while (diagX < widget.rows && diagY < widget.cols) {
      if (tileDisplayList[diagX * widget.cols + diagY] == player) {
        count++;
        if (count == widget.n) {
          _onWin(player);
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
    while (diagX < widget.rows - 1 && diagY > 0) {
      diagX++;
      diagY--;
    }
    while (diagX >= 0 && diagY < widget.cols) {
      if (tileDisplayList[diagX * widget.cols + diagY] == player) {
        count++;
        if (count == widget.n) {
          _onWin(player);
          return;
        }
      } else {
        count = 0;
      }
      diagX--;
      diagY++;
    }

    if (filledBoxes == widget.rows * widget.cols) {
      _onDraw();
    }
  }

  void _onWin(String player) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Player $player has won!'),
        );
      },
    );
  }

  void _onDraw() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('The game has ended in a draw!'),
        );
      },
    );
  }
}
