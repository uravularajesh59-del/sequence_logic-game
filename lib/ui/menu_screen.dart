import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_logic.dart';
import 'game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SEQUENCE\nLOGIC',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 60),
            _buildDifficultyButton(context, 3, 'Easy (3x3)'),
            const SizedBox(height: 20),
            _buildDifficultyButton(context, 4, 'Medium (4x4)'),
            const SizedBox(height: 20),
            _buildDifficultyButton(context, 5, 'Hard (5x5)'),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, int size, String label) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<GameState>(context, listen: false).startNewGame(size);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
          );
        },
        child: Text(label),
      ),
    );
  }
}
