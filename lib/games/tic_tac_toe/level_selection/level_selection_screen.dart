import 'package:basic/games/tic_tac_toe/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../audio/audio_controller.dart';
import '../../../audio/sounds.dart';
import '../../../style/my_button.dart';
import '../../../style/palette.dart';
import '../../../style/responsive_screen.dart';

class TicTacToeLevelSelectionScreen extends StatelessWidget {
  const TicTacToeLevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select level',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                children: [
                  for (final level in ticTacToeLevels)
                    ListTile(
                      onTap: () {
                        final audioController = context.read<AudioController>();
                        audioController.playSfx(SfxType.buttonTap);

                        GoRouter.of(context)
                            .go('/play/tic_tac_toe/session/${level.number}');
                      },
                      leading: Text(level.number.toString()),
                      title: Text('Grid: ${level.rows} x ${level.cols}\n'
                          'Goal: ${level.goal}'),
                    ),
                  ListTile(
                    onTap: () {
                      final audioController = context.read<AudioController>();
                      audioController.playSfx(SfxType.buttonTap);

                      GoRouter.of(context)
                          .go('/play/tic_tac_toe/make_custom_session');
                    },
                    leading: Text((ticTacToeLevels.length + 1).toString()),
                    title: Text('Custom Level'),
                  ),
                ],
              ),
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/play');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
