const games = [
  Game(
    number: 1,
    name: 'slider_game',
    title: 'Slider Game',
  ),
  Game(
    number: 2,
    name: 'tic_tac_toe',
    title: 'Tic Tac Toe',
  ),
];

class Game {
  final int number;

  final String name;
  final String title;

  const Game({
    required this.number,
    required this.name,
    required this.title,
  });
}
