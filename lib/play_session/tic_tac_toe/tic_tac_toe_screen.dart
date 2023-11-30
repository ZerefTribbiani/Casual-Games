import 'package:basic/audio/audio_controller.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/game_internals/tic_tac_toe/board_state.dart';
import 'package:basic/level_selection/tic_tac_toe/tic_tac_toe_levels.dart';
import 'package:basic/play_session/tic_tac_toe/board.dart';
import 'package:basic/play_session/tic_tac_toe/tile.dart';
import 'package:basic/style/confetti.dart';
import 'package:basic/style/my_button.dart';
import 'package:basic/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class TicTacToeScreen extends StatefulWidget {
  final TicTacToeLevel level;

  const TicTacToeScreen({super.key, required this.level});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static final _log = Logger('SliderGamePlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        Provider.value(value: widget.level),
        ChangeNotifierProvider(
          create: (context) => BoardState(
            onGameFinish: _onGameFinish,
            rows: widget.level.rows,
            cols: widget.level.cols,
          ),
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 7,
                    child: Board(),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () => GoRouter.of(context).go('/play/tic_tac_toe'),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onGameFinish(Player winner) async {
    _log.info('Level ${widget.level.number} won');

    setState(() {
      _duringCelebration = true;
    });

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    final duration = DateTime.now().difference(_startOfPlay);

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go(
      '/play/tic_tac_toe/finish',
      extra: {'winner': winner, 'duration': duration},
    );
  }
}
