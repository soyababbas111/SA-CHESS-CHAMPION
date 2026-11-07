import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_mode.dart';
import '../providers/game_controller.dart';
import '../widgets/chess_board.dart';
import '../widgets/player_card.dart';

class GameScreen extends StatelessWidget {
  final GameMode mode;

  const GameScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mode.title),
        backgroundColor: const Color(0xFF1B232B),
        elevation: 0,
      ),
      body: Consumer<GameController>(
        builder: (context, controller, child) {
          bool isWhiteTurn = controller.game.turn.toString() == 'Color.WHITE';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Black Player Card
                PlayerCard(
                  playerName: mode == GameMode.computer ? 'Computer' : 'Black Player',
                  timeInSeconds: controller.blackTime,
                  isCurrentTurn: !isWhiteTurn,
                ),
                
                // Chess Board
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ChessBoardWidget(),
                ),

                // White Player Card
                PlayerCard(
                  playerName: 'White Player (You)',
                  timeInSeconds: controller.whiteTime,
                  isCurrentTurn: isWhiteTurn,
                ),

                // Game Over Banner
                if (controller.isGameOver)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.winnerMessage,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}