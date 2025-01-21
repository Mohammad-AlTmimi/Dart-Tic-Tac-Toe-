import 'dart:io';

String player1 = "", player2 = "";
List<String> board = List.filled(9, "");
bool is1v1 = false; // Flag to determine game mode

// Check if three positions are the same (win condition)
bool isWinningMove(int a, int b, int c) {
  return board[a] == board[b] &&
         board[b] == board[c] &&
         board[a] != "";
}

// Print the current board state
String displayBoard() {
  return '''
   ${board[0].isEmpty ? '1' : board[0]} | ${board[1].isEmpty ? '2' : board[1]} | ${board[2].isEmpty ? '3' : board[2]}
  ---+---+---
   ${board[3].isEmpty ? '4' : board[3]} | ${board[4].isEmpty ? '5' : board[4]} | ${board[5].isEmpty ? '6' : board[5]}
  ---+---+---
   ${board[6].isEmpty ? '7' : board[6]} | ${board[7].isEmpty ? '8' : board[7]} | ${board[8].isEmpty ? '9' : board[8]}
  ''';
}

// AI selects the first available empty square
int getAiMove() {
  for (int i = 0; i < 9; i++) {
    if (board[i].isEmpty) {
      return i;
    }
  }
  return -1; // This shouldn't be reached
}

// Prompt the user to choose X or O
void choosePlayerChar() {
  print("Do you want to play as X or O?");
  String input = stdin.readLineSync()?.toUpperCase() ?? '';

  if (input == 'X') {
    player1 = 'X';
    player2 = 'O';
  } else if (input == 'O') {
    player1 = 'O';
    player2 = 'X';
  } else {
    print("Invalid choice. Please enter 'X' or 'O'.");
    choosePlayerChar();
  }
}

// Prompt the user to choose the game mode
void chooseGameMode() {
  print("Choose game mode:");
  print("1. 1v1 (Player vs. Player)");
  print("2. 1vAI (Player vs. AI)");

  String input = stdin.readLineSync() ?? '';
  if (input == '1') {
    is1v1 = true;
  } else if (input == '2') {
    is1v1 = false;
  } else {
    print("Invalid choice. Please enter '1' or '2'.");
    chooseGameMode();
  }
}

// Read and validate user input for a move
int getPlayerMove() {
  print("Enter the number of the square where you want to place your marker:");
  String input = stdin.readLineSync() ?? '';
  try {
    int position = int.parse(input) - 1;
    if (position >= 0 && position < 9 && board[position].isEmpty) {
      return position;
    }
    throw FormatException();
  } catch (e) {
    print("Invalid input. Please enter a valid number (1-9) for an empty square.");
    return getPlayerMove();
  }
}

void main() {
  chooseGameMode();
  choosePlayerChar();

  int remainingMoves = 9;

  while (remainingMoves > 0) {
    print(displayBoard());
    remainingMoves--;

    // Determine the current player and their move
    bool isPlayer1Turn = remainingMoves % 2 == 0;
    String currentPlayer = isPlayer1Turn ? player1 : player2;

    int move;
    if (isPlayer1Turn || is1v1) {
      move = getPlayerMove();
    } else {
      move = getAiMove();
      print("AI chose square ${move + 1}");
    }

    // Make the move and update the board
    board[move] = currentPlayer;

    // Check for a winner
    if (isWinningMove(0, 1, 2) || isWinningMove(3, 4, 5) || isWinningMove(6, 7, 8) || // Rows
        isWinningMove(0, 3, 6) || isWinningMove(1, 4, 7) || isWinningMove(2, 5, 8) || // Columns
        isWinningMove(0, 4, 8) || isWinningMove(2, 4, 6)) {                           // Diagonals
      print(displayBoard());
      print("Player ${isPlayer1Turn ? 1 : (is1v1 ? 2 : 'AI')} wins!");
      return;
    }
  }

  print("It's a draw!");
}
