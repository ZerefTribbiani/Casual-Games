import 'dart:math';

import 'package:basic/audio/audio_controller.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/level_selection/tic_tac_toe/tic_tac_toe_levels.dart';
import 'package:basic/style/my_button.dart';
import 'package:basic/style/palette.dart';
import 'package:basic/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MakeCustomLevelScreen extends StatefulWidget {
  const MakeCustomLevelScreen({super.key});

  @override
  State<MakeCustomLevelScreen> createState() => _MakeCustomLevelScreenState();
}

class _MakeCustomLevelScreenState extends State<MakeCustomLevelScreen> {
  TextEditingController rowsController = TextEditingController();
  TextEditingController colsController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      resizeToAvoidBottomInset: false,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Custom level',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            Spacer(flex: 7),
            TextField(
              controller: rowsController,
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              decoration: InputDecoration(labelText: 'Rows'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: colsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Columns'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Goal'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Spacer(flex: 1),
            Visibility(
              visible: _showError,
              child: const Text(
                'All values >= 3\n'
                'Goal <= max(rows, cols)',
                style: TextStyle(color: Color(0xFFFF0000)),
              ),
            ),
            Spacer(flex: 1),
            MyButton(
              onPressed: () {
                final audioController = context.read<AudioController>();
                audioController.playSfx(SfxType.congrats);
                _createCustomLevel();
              },
              child: Text('Create'),
            ),
            Spacer(flex: 7),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/play/tic_tac_toe');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }

  void _createCustomLevel() {
    int rows = int.tryParse(rowsController.text) ?? 0;
    int cols = int.tryParse(colsController.text) ?? 0;
    int goal = int.tryParse(goalController.text) ?? 0;

    if (rows < 3 || cols < 3 || goal < 3 || goal > max(rows, cols)) {
      setState(() {
        _showError = true;
      });
      return;
    }

    TicTacToeLevel customLevel = TicTacToeLevel(
      number: ticTacToeLevels.length + 1,
      rows: rows,
      cols: cols,
      goal: goal,
    );

    GoRouter.of(context).go(
      '/play/tic_tac_toe/session/custom',
      extra: {'level': customLevel},
    );
  }
}
