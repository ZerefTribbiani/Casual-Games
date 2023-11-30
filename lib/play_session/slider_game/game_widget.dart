// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../game_internals/slider_game/level_state.dart';
import '../../level_selection/slider_game/levels.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class GameWidget extends StatelessWidget {
  const GameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final level = context.watch<GameLevel>();
    final levelState = context.watch<LevelState>();
    final Text goalText;
    if (level.difficulty == 'Easy') {
      goalText = Text('Drag the slider to ${level.goal}% or above!');
    } else {
      goalText = Text('Drag the slider to exactly ${level.goal}%!');
    }

    return Column(
      children: [
        goalText,
        Slider(
          label: 'Level Progress',
          autofocus: true,
          value: levelState.progress / 100,
          onChanged: (value) => levelState.setProgress((value * 100).round()),
          onChangeEnd: (value) {
            context.read<AudioController>().playSfx(SfxType.wssh);
            if (level.difficulty == 'Easy') {
              levelState.evaluateGreaterThan();
            } else {
              levelState.evaluateEqualTo();
            }
          },
        ),
        Text('${levelState.progress}%'),
      ],
    );
  }
}
