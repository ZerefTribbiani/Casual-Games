// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/game_selection/game_selection_screen.dart';
import 'package:basic/games/tic_tac_toe/level_selection/make_custom_level_screen.dart';
import 'package:basic/games/tic_tac_toe/level_selection/level_selection_screen.dart';
import 'package:basic/games/tic_tac_toe/level_selection/levels.dart';
import 'package:basic/games/tic_tac_toe/play_session/player.dart';
import 'package:basic/games/tic_tac_toe/play_session/tic_tac_toe_screen.dart';
import 'package:basic/games/tic_tac_toe/end_game/end_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'games/slider_game/game_internals/score.dart';
import 'games/slider_game/level_selection/level_selection_screen.dart';
import 'games/slider_game/level_selection/levels.dart';
import 'main_menu/main_menu_screen.dart';
import 'games/slider_game/play_session/slider_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'games/slider_game/win_game/slider_win_screen.dart';

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
                child: const SliderLevelSelectionScreen(
                  key: Key('slider game level selection'),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'session/:level',
                  pageBuilder: (context, state) {
                    final levelNumber =
                        int.parse(state.pathParameters['level']!);
                    final level = sliderLevels
                        .singleWhere((e) => e.number == levelNumber);
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
                    final score = map['score'] as SliderScore;

                    return buildMyTransition<void>(
                      key: ValueKey('won'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: SliderWinScreen(
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
                  color: context.watch<Palette>().backgroundLevelSelection,
                  child: TicTacToeLevelSelectionScreen(
                    key: ValueKey('tic tac toe level selection'),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'session/custom',
                  pageBuilder: (context, state) {
                    final map = state.extra! as Map<String, TicTacToeLevel>;
                    final level = map['level']!;
                    return buildMyTransition<void>(
                      key: ValueKey('tic tac toe custom level creation'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: TicTacToeScreen(
                        level: level,
                        key: ValueKey('tic tac toe custom play session'),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'session/:level',
                  pageBuilder: (context, state) {
                    final levelNumber =
                        int.parse(state.pathParameters['level']!);
                    final level = ticTacToeLevels
                        .singleWhere((e) => e.number == levelNumber);
                    return buildMyTransition<void>(
                      key: ValueKey('tic tac toe level'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: TicTacToeScreen(
                        level: level,
                        key: ValueKey('tic tac toe play session'),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'make_custom_session',
                  pageBuilder: (context, state) {
                    return buildMyTransition<void>(
                      key: ValueKey('tic tac toe custom level'),
                      color: context.watch<Palette>().backgroundLevelSelection,
                      child: MakeCustomLevelScreen(
                        key: ValueKey('tic tac toe custom level creation'),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'finish',
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
                    final winner = map['winner'] as Player;
                    final duration = map['duration'] as Duration;

                    return buildMyTransition<void>(
                      key: ValueKey('finish'),
                      color: context.watch<Palette>().backgroundPlaySession,
                      child: TicTacToeEndScreen(
                        winner: winner,
                        duration: duration,
                        key: const Key('win game'),
                      ),
                    );
                  },
                ),
              ],
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
