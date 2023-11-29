// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/game_selection/game_selection_screen.dart';
import 'package:basic/play_session/tic_tac_toe/tic_tac_toe_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/slider_game/score.dart';
import 'level_selection/level_selection_screen.dart';
import 'level_selection/levels.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/slider_game/slider_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('play'),
            color: context.watch<Palette>().backgroundLevelSelection,
            child: const GameSelectionScreen(
              key: Key('game selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'slider_game',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('slider game'),
                color: context.watch<Palette>().backgroundLevelSelection,
                child: const LevelSelectionScreen(
                  key: Key('slider game level selection'),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'session/:level',
                  pageBuilder: (context, state) {
                    final levelNumber =
                        int.parse(state.pathParameters['level']!);
                    final level =
                        gameLevels.singleWhere((e) => e.number == levelNumber);
                    return buildMyTransition<void>(
                      key: ValueKey('slider level'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: SliderScreen(
                        level,
                        key: const Key('slider play session'),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'won',
                  redirect: (context, state) {
                    if (state.extra == null) {
                      // Trying to navigate to a win screen without any data.
                      // Possibly by using the browser's back button.
                      return '/';
                    }

                    // Otherwise, do not redirect.
                    return null;
                  },
                  pageBuilder: (context, state) {
                    final map = state.extra! as Map<String, dynamic>;
                    final score = map['score'] as Score;

                    return buildMyTransition<void>(
                      key: ValueKey('won'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: WinGameScreen(
                        score: score,
                        key: const Key('win game'),
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'tic_tac_toe',
              pageBuilder: (context, state) {
                return buildMyTransition<void>(
                  key: ValueKey('tic tac toe'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: TicTacToeScreen(
                    key: ValueKey('tic tac toe play session'),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
