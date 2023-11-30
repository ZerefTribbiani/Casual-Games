// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(
    number: 1,
    goal: 5,
    difficulty: 'Easy',
  ),
  GameLevel(
    number: 2,
    goal: 42,
    difficulty: 'Easy',
  ),
  GameLevel(
    number: 3,
    goal: 100,
    difficulty: 'Easy',
  ),
  GameLevel(
    number: 4,
    goal: 100,
    difficulty: 'Hard',
  ),
  GameLevel(
    number: 5,
    goal: 42,
    difficulty: 'Hard',
  ),
  GameLevel(
    number: 6,
    goal: 5,
    difficulty: 'Hard',
  ),
];

class GameLevel {
  final int number;
  final int goal;
  final String difficulty;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.goal,
    required this.difficulty,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
