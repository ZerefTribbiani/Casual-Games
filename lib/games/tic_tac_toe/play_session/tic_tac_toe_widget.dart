import 'package:basic/audio/audio_controller.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/games/tic_tac_toe/game_internals/board_state.dart';
import 'package:basic/games/tic_tac_toe/level_selection/levels.dart';
import 'package:basic/games/tic_tac_toe/play_session/current_player_display.dart';
import 'package:basic/games/tic_tac_toe/play_session/tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicTacToeWidget extends StatefulWidget {
  const TicTacToeWidget({super.key});

  @override
  State<TicTacToeWidget> createState() => _TicTacToeWidgetState();
}

class _TicTacToeWidgetState extends State<TicTacToeWidget> {
  @override
  Widget build(BuildContext context) {
    final level = context.watch<TicTacToeLevel>();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: CurrentPlayerDisplay(),
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
