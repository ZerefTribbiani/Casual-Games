// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const sliderLevels = [
  SliderLevel(
    number: 1,
    goal: 5,
    difficulty: 'Easy',
  ),
  SliderLevel(
    number: 2,
    goal: 42,
    difficulty: 'Easy',
  ),
  SliderLevel(
    number: 3,
    goal: 100,
    difficulty: 'Easy',
  ),
  SliderLevel(
    number: 4,
    goal: 100,
    difficulty: 'Hard',
  ),
  SliderLevel(
    number: 5,
    goal: 42,
    difficulty: 'Hard',
  ),
  SliderLevel(
    number: 6,
    goal: 5,
    difficulty: 'Hard',
  ),
];

class SliderLevel {
  final int number;
  final int goal;
  final String difficulty;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const SliderLevel({
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
