import 'package:basic/game_internals/tic_tac_toe/board_state.dart';
import 'package:basic/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Player { x, o, none }

extension PlayerToString on Player {
  String string() {
    switch (this) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }
}

enum TileSide {
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
  final TileSide tileSide;

  const Tile({
    super.key,
    required this.x,
    required this.y,
    this.tileSide = TileSide.center,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final tileOwner = context.watch<BoardState>().tileOwners[x][y];

    Border border;
    BorderSide borderSide = BorderSide(color: palette.inkFullOpacity, width: 3);
    switch (tileSide) {
      case TileSide.center:
        border = Border.all(color: palette.inkFullOpacity, width: 3);
      case TileSide.topLeft:
        border = Border(bottom: borderSide, right: borderSide);
      case TileSide.topRight:
        border = Border(bottom: borderSide, left: borderSide);
      case TileSide.bottomLeft:
        border = Border(top: borderSide, right: borderSide);
      case TileSide.bottomRight:
        border = Border(top: borderSide, left: borderSide);
      case TileSide.topEdge:
        border =
            Border(bottom: borderSide, left: borderSide, right: borderSide);
      case TileSide.bottomEdge:
        border = Border(top: borderSide, left: borderSide, right: borderSide);
      case TileSide.leftEdge:
        border = Border(top: borderSide, bottom: borderSide, right: borderSide);
      case TileSide.rightEdge:
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
            fontFamily: 'Permanent Marker',
            fontSize: 55,
            height: 1,
          ),
        ),
      ),
    );
  }
}
