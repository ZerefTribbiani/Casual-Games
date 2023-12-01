import 'package:basic/games/tic_tac_toe/game_internals/board_state.dart';
import 'package:basic/games/tic_tac_toe/play_session/player.dart';
import 'package:basic/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TilePlacement {
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topEdge,
  bottomEdge,
  leftEdge,
  rightEdge
}

class Tile extends StatelessWidget {
  final int x;
  final int y;
  final TilePlacement tilePos;

  const Tile({
    super.key,
    required this.x,
    required this.y,
    this.tilePos = TilePlacement.center,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final boardState = context.watch<BoardState>();
    final tileOwner = boardState.tileOwners[x][y];

    final screenWidth = MediaQuery.of(context).size.width;
    final cols = boardState.tileOwners[0].length;
    final fontSize = screenWidth / cols / 1.5;
    final Color color =
        boardState.winningTiles[x][y] ? Colors.red : palette.ink;

    Border border;
    BorderSide borderSide = BorderSide(color: palette.inkFullOpacity, width: 3);
    switch (tilePos) {
      case TilePlacement.center:
        border = Border.all(color: palette.inkFullOpacity, width: 3);
      case TilePlacement.topLeft:
        border = Border(bottom: borderSide, right: borderSide);
      case TilePlacement.topRight:
        border = Border(bottom: borderSide, left: borderSide);
      case TilePlacement.bottomLeft:
        border = Border(top: borderSide, right: borderSide);
      case TilePlacement.bottomRight:
        border = Border(top: borderSide, left: borderSide);
      case TilePlacement.topEdge:
        border =
            Border(bottom: borderSide, left: borderSide, right: borderSide);
      case TilePlacement.bottomEdge:
        border = Border(top: borderSide, left: borderSide, right: borderSide);
      case TilePlacement.leftEdge:
        border = Border(top: borderSide, bottom: borderSide, right: borderSide);
      case TilePlacement.rightEdge:
        border = Border(top: borderSide, bottom: borderSide, left: borderSide);
    }

    return Container(
      decoration: BoxDecoration(
        border: border,
      ),
      child: Center(
        child: Text(
          tileOwner.string(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontFamily: 'Permanent Marker',
            fontSize: fontSize,
            height: 1,
          ),
        ),
      ),
    );
  }
}
