import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_controller.dart';
import 'providers/theme_controller.dart';
import 'screens/game_screen.dart';
import 'models/game_mode.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const SAChessChampionApp(),
    ),
  );
}

class SAChessChampionApp extends StatelessWidget {
  const SAChessChampionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'SA Chess Champion',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF12181F),
            primaryColor: const Color(0xFFFFD166),
          ),
          theme: ThemeData.light(),
          home: const MainMenuScreen(),
        );
      },
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SA Chess Champion'),
        backgroundColor: const Color(0xFF1B232B),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.sports_esports,
                size: 80,
                color: Color(0xFFFFD166),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to SA Chess',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuButton(
                context,
                'Classic Chess (10 Min)',
                GameMode.classic,
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                'Quick Chess (5 Min)',
                GameMode.quick,
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                'Play vs Computer',
                GameMode.computer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, GameMode mode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD166),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Provider.of<GameController>(context, listen: false).startGame(mode);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(mode: mode),
          ),
        );
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}