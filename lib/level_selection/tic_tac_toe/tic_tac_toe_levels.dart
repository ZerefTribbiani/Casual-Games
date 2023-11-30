const ticTacToeLevels = [
  TicTacToeLevel(
    number: 1,
    rows: 3,
    cols: 3,
    goal: 3,
  ),
  TicTacToeLevel(
    number: 2,
    rows: 4,
    cols: 4,
    goal: 3,
  ),
  TicTacToeLevel(
    number: 3,
    rows: 5,
    cols: 5,
    goal: 4,
  ),
];

class TicTacToeLevel {
  final int number;
  final int rows;
  final int cols;
  final int goal;

  const TicTacToeLevel({
    required this.number,
    required this.rows,
    required this.cols,
    required this.goal,
  });
}
