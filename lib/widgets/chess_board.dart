import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chess/chess.dart' as chess_pkg;
import '../providers/game_controller.dart';
import 'chess_piece_painter.dart';

class ChessBoardWidget extends StatefulWidget {
  const ChessBoardWidget({super.key});

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  String? selectedSquare;
  List<String> validMoves = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, child) {
        final board = controller.game.board;

        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFD166), width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                String squareName = '${String.fromCharCode(97 + col)}${8 - row}';
                
                bool isLight = (row + col) % 2 == 0;
                bool isSelected = selectedSquare == squareName;
                bool isValidMove = validMoves.contains(squareName);

                var piece = board[row][col];

                return GestureDetector(
                  onTap: () => _handleSquareTap(squareName, controller),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFD166).withOpacity(0.6)
                          : isLight
                              ? controller.lightSquare
                              : controller.darkSquare,
                      border: isValidMove
                          ? Border.all(color: Colors.greenAccent, width: 3)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (col == 0)
                          Positioned(
                            left: 2,
                            top: 2,
                            child: Text(
                              '${8 - row}',
                              style: TextStyle(
                                fontSize: 10,
                                color: isLight ? Colors.black54 : Colors.white54,
                              ),
                            ),
                          ),
                        if (row == 7)
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Text(
                              String.fromCharCode(97 + col),
                              style: TextStyle(
                                fontSize: 10,
                                color: isLight ? Colors.black54 : Colors.white54,
                              ),
                            ),
                          ),
                        if (piece != null)
                          Center(
                            child: SizedBox(
                              width: 36,
                              height: 36,
                              child: CustomPaint(
                                painter: ChessPiecePainter(
                                  piece.color == chess_pkg.Color.WHITE
                                      ? piece.type.toUpperCase()
                                      : piece.type.toLowerCase(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleSquareTap(String square, GameController controller) {
    if (controller.isGameOver) return;

    if (selectedSquare == null) {
      var piece = controller.game.get(square);
      if (piece != null && piece.color == controller.game.turn) {
        setState(() {
          selectedSquare = square;
          var moves = controller.game.moves({'square': square, 'verbose': true});
          validMoves = moves.map((m) => m['to'].toString()).toList();
        });
      }
    } else {
      if (selectedSquare == square) {
        setState(() {
          selectedSquare = null;
          validMoves = [];
        });
        return;
      }

      bool moved = controller.makeMove({'from': selectedSquare, 'to': square, 'promotion': 'q'});
      setState(() {
        selectedSquare = null;
        validMoves = [];
      });
    }
  }
}