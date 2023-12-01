import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';

class CurrentPlayerDisplay extends StatelessWidget {
  const CurrentPlayerDisplay({super.key});

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
