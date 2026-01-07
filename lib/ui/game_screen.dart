import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update UI every second for the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    // Show win dialog if solved
    if (gameState.isSolved) {
      // Use a post-frame callback to show dialog to avoid build conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
           _showWinDialog(context);
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Sequence Logic', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBox(context, 'MOVES', '${gameState.moves}'),
              _buildStatBox(context, 'TIME', gameState.timeElapsed),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 350,
              height: 350,
              child: GridView.builder(
                padding: const EdgeInsets.all(4),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gameState.gridSize,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: gameState.tiles.length,
                itemBuilder: (context, index) {
                  final tileValue = gameState.tiles[index];
                  if (tileValue == 0) return const SizedBox(); // Empty tile

                  return GestureDetector(
                    onTap: () => gameState.moveTile(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$tileValue',
                          style: TextStyle(
                            fontSize: gameState.gridSize == 3 ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => gameState.startNewGame(gameState.gridSize),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Puzzle Solved!', style: TextStyle(color: Colors.white)),
        content: const Text('Great job! You ordered the sequence.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go to menu
            },
            child: const Text('Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Provider.of<GameState>(context, listen: false).startNewGame(
                 Provider.of<GameState>(context, listen: false).gridSize
              );
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
