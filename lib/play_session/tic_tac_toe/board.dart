import 'package:basic/game_internals/tic_tac_toe/board_state.dart';
import 'package:basic/play_session/tic_tac_toe/tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPlayerWidget extends StatelessWidget {
  const CurrentPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPlayer = context.watch<BoardState>().currentPlayer;
    final playerSide = currentPlayer == 1 ? 'X' : 'O';

    return Text(
      'Current Player: $playerSide',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Permanent Marker',
        fontSize: 40,
        height: 1,
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: CurrentPlayerWidget(),
        ),
        Expanded(
          flex: 4,
          child: GridView.builder(
            itemCount: widget.rows * widget.cols,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cols),
            itemBuilder: (context, index) {
              int x = index ~/ widget.cols;
              int y = index % widget.cols;
              TileSide tileSide;
              if (x == 0 && y == 0) {
                tileSide = TileSide.topLeft;
              } else if (x == 0 && y == widget.cols - 1) {
                tileSide = TileSide.topRight;
              } else if (x == widget.rows - 1 && y == 0) {
                tileSide = TileSide.bottomLeft;
              } else if (x == widget.rows - 1 && y == widget.cols - 1) {
                tileSide = TileSide.bottomRight;
              } else if (x == 0) {
                tileSide = TileSide.topEdge;
              } else if (x == widget.rows - 1) {
                tileSide = TileSide.bottomEdge;
              } else if (y == 0) {
                tileSide = TileSide.leftEdge;
              } else if (y == widget.cols - 1) {
                tileSide = TileSide.rightEdge;
              } else {
                tileSide = TileSide.center;
              }

              return GestureDetector(
                onTap: (() {
                  _onTap(context, index);
                }),
                child: Tile(x: x, y: y, tileSide: tileSide),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    final boardState = Provider.of<BoardState>(context, listen: false);
    boardState.makeMove(index, widget.n);
  }
}
