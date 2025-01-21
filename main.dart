import 'dart:io';
import 'dart:math';

String player1 = "", player2 = "";
List<String> board = List.filled(9, "");
bool is1v1 = false; // Flag to determine game mode
List<int> dp = List.filled(pow(3, 9).toInt() + 1, 999); // All possible states for Tic-Tac-Toe

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

// Calculate the current state value in base 3
int calculateState() {
  int value = 0;
  for (int i = 0; i < 9; i++) {
    if (board[i] == 'X') {
      value += pow(3, i).toInt(); // 1 represents X
    } else if (board[i] == 'O') {
      value += 2 * pow(3, i).toInt(); // 2 represents O
    }
    // if board is empty it just give the value 0 so no need for else statment here
  }
  return value;
}

// Dynamic programming function to calculate the best result for the AI player
int dynamicProgramming(int stateValue, bool isAITurn) {
  // Check if the result is already calculated
  if (dp[stateValue] != 999) return dp[stateValue];

  // Check for a winner or a draw
  for (int i = 0; i < 9; i += 3) {
    if (isWinningMove(i, i + 1, i + 2)) {
      return dp[stateValue] = board[i] == player2 ? 1 : -1;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (isWinningMove(i, i + 3, i + 6)) {
      return dp[stateValue] = board[i] == player2 ? 1 : -1;
    }
  }
  if (isWinningMove(0, 4, 8) || isWinningMove(2, 4, 6)) {
    return dp[stateValue] = board[4] == player2 ? 1 : -1;
  }
  if (!board.contains("")) return dp[stateValue] = 0; // Draw

  // Recursive minimax calculation
  int bestScore = isAITurn ? -999 : 999;
  for (int i = 0; i < 9; i++) {
    if (board[i].isEmpty) {
      board[i] = isAITurn ? player2 : player1;
      int newStateValue = calculateState();
      int score = dynamicProgramming(newStateValue, !isAITurn);
      board[i] = "";
      bestScore = isAITurn ? max(bestScore, score) : min(bestScore, score);
    }
  }
  return dp[stateValue] = bestScore;
}

// AI selects the best move based on dynamic programming
// I try to defet this ai system But i could not :)
// You can understand more about the algorithm i used here
// by read more about 
// 1) minimax algorithm
// 2) Dynamic Programming (I used it to minimize the Time complexity of the code 
//it is more like Cahce in backend system) it hold (save) the calculated value so it didn't 
//need to calculate it again
// I got the experiance with type of algorithm because i am a problem solver you can find my acount in codeforces 
// my name is MohammadAtCoder
// here is a link for my code forces account https://codeforces.com/profile/MohammadAtCoder
int getAiMove() {
  int bestScore = -999;
  int bestMove = -1;

  for (int i = 0; i < 9; i++) {
    if (board[i].isEmpty) {
      board[i] = player2; // Simulate the AI move
      int newStateValue = calculateState();
      int score = dynamicProgramming(newStateValue, false);
      board[i] = ""; // Undo the move

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  return bestMove;
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
