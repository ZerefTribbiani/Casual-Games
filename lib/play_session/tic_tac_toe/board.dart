import 'package:basic/audio/audio_controller.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/game_internals/tic_tac_toe/board_state.dart';
import 'package:basic/level_selection/tic_tac_toe/tic_tac_toe_levels.dart';
import 'package:basic/play_session/tic_tac_toe/tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPlayerWidget extends StatelessWidget {
  const CurrentPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final playerSide = boardState.currentPlayer == 1 ? 'X' : 'O';

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
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    final level = context.watch<TicTacToeLevel>();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: CurrentPlayerWidget(),
        ),
        Expanded(
          flex: 4,
          child: GridView.builder(
            itemCount: level.rows * level.cols,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: level.cols),
            itemBuilder: (context, index) {
              int x = index ~/ level.cols;
              int y = index % level.cols;
              TilePlacement tileSide;
              if (x == 0 && y == 0) {
                tileSide = TilePlacement.topLeft;
              } else if (x == 0 && y == level.cols - 1) {
                tileSide = TilePlacement.topRight;
              } else if (x == level.rows - 1 && y == 0) {
                tileSide = TilePlacement.bottomLeft;
              } else if (x == level.rows - 1 && y == level.cols - 1) {
                tileSide = TilePlacement.bottomRight;
              } else if (x == 0) {
                tileSide = TilePlacement.topEdge;
              } else if (x == level.rows - 1) {
                tileSide = TilePlacement.bottomEdge;
              } else if (y == 0) {
                tileSide = TilePlacement.leftEdge;
              } else if (y == level.cols - 1) {
                tileSide = TilePlacement.rightEdge;
              } else {
                tileSide = TilePlacement.center;
              }

              return GestureDetector(
                onTap: (() {
                  _onTap(context, index);
                }),
                child: Tile(x: x, y: y, tilePos: tileSide),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.buttonTap);
    final level = Provider.of<TicTacToeLevel>(context, listen: false);
    final boardState = Provider.of<BoardState>(context, listen: false);
    boardState.makeMove(index, level.goal);
  }
}
