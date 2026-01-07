import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'game_logic.dart';
import 'ui/menu_screen.dart';

void main() {
  runApp(const SequenceLogicApp());
}

class SequenceLogicApp extends StatelessWidget {
  const SequenceLogicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Sequence Logic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.dark,
            background: const Color(0xFF1A1A2E), // Deep Blue/Black
            primary: const Color(0xFF6C63FF),
            secondary: const Color(0xFFE94560),
            surface: const Color(0xFF16213E),
          ),
          textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: const MenuScreen(),
      ),
    );
  }
}
