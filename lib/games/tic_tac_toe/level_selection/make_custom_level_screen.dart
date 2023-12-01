import 'dart:math' show max;

import 'package:basic/audio/audio_controller.dart';
import 'package:basic/audio/sounds.dart';
import 'package:basic/games/tic_tac_toe/level_selection/levels.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController colsController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      resizeToAvoidBottomInset: false,
      body: ResponsiveScreen(
        squarishMainArea: Form(
          key: _formKey,
          child: Column(
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
              TextFormField(
                controller: rowsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Rows'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final rows = int.tryParse(value) ?? 0;
                  if (rows < 3) {
                    return 'Value must be at least 3';
                  } else if (rows > 10) {
                    return 'Value must not be greater than 10';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: colsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Columns'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final cols = int.tryParse(value) ?? 0;
                  if (cols < 3) {
                    return 'Value must be at least 3';
                  } else if (cols > 10) {
                    return 'Value must not be greater than 10';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Goal'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final goal = int.tryParse(value) ?? 0;
                  if (goal < 3) {
                    return 'Value must be at least 3';
                  } else if (goal > 10) {
                    return 'Value must not be greater than 10';
                  }
                  final rows = int.tryParse(rowsController.text) ?? 0;
                  final cols = int.tryParse(colsController.text) ?? 0;
                  if (goal > max(rows, cols)) {
                    return 'Value must not be greater than both rows and columns';
                  }
                  return null;
                },
              ),
              Spacer(flex: 1),
              MyButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  final audioController = context.read<AudioController>();
                  audioController.playSfx(SfxType.congrats);

                  int rows = int.parse(rowsController.text);
                  int cols = int.parse(colsController.text);
                  int goal = int.parse(goalController.text);
                  _createCustomLevel(rows, cols, goal);
                },
                child: Text('Create'),
              ),
              Spacer(flex: 7),
            ],
          ),
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

  void _createCustomLevel(int rows, int cols, int goal) {
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
