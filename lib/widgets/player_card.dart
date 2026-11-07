import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String playerName;
  final int timeInSeconds;
  final bool isCurrentTurn;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.timeInSeconds,
    required this.isCurrentTurn,
  });

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentTurn ? const Color(0xFF263238) : const Color(0xFF1B232B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentTurn ? const Color(0xFFFFD166) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFD166),
                radius: 16,
                child: Icon(Icons.person, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                playerName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Text(
            _formatTime(timeInSeconds),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFFFD166)),
          ),
        ],
      ),
    );
  }
}