import 'dart:ffi';
import 'dart:io';
String Player1 = "", Player2 = "";
List<String> Quiz = List.filled(9, "");
bool isSame(int a, int b, int c) {
  if (Quiz[a] == Quiz[b] && Quiz[b] == Quiz[c]
  &&  Quiz[a] != "") {
    return true;
  }
  return false;
}
String printTable() {
  return ' ${Quiz[0] == "" ? 1 : Quiz[0]} | ${Quiz[1] == "" ? 2 : Quiz[1]} | ${Quiz[2] == "" ? 3 : Quiz[2]} \n'
         '---+---+---\n'
         ' ${Quiz[3] == "" ? 4 : Quiz[3]} | ${Quiz[4] == "" ? 5 : Quiz[4]} | ${Quiz[5] == "" ? 6 : Quiz[5]} \n'
         '---+---+---\n'
         ' ${Quiz[6] == "" ? 7 : Quiz[6]} | ${Quiz[7] == "" ? 8 : Quiz[7]} | ${Quiz[8] == "" ? 9 : Quiz[8]} \n';
}
int aiMove(){
  for(int i = 0; i < 9; i++){
    if(Quiz[i] == "")
        return i;
  }
  // will never get here
  return -1;
}
void chooseChar(){
  print("Do you want to Play in X or in O");
  String input = stdin.readLineSync() ?? '';
  if(input == 'X'){
    Player1 = 'X';
    Player2 = 'O';
    return ;
  }
  else if(input == 'O'){
    Player1 = 'O';
    Player2 = 'X';
    return ;
  }
  chooseChar();
}
int ReadValue(){
  String input = stdin.readLineSync() ?? '';
  try {
    int number =  int.parse(input);
    if(Quiz[number - 1] == "")
      return number - 1;
    throw(Error());
  } catch (e) {
    print('Invalid input. Please enter a valid integer.');
    return ReadValue();
  }
}
void main(){
  chooseChar();
  int cnt = 9;
  while(cnt != 0){
    print(printTable());
    cnt--;
    print('Player ${cnt % 2 == 0 ? 1 : 2}, Plese enter the number of the square '
          'Where you want to Place your ${cnt % 2 == 0 ? Player1 : Player2}\n');
    int ans = cnt % 2 == 0 ? ReadValue() : aiMove();
    if(cnt % 2 == 1){
      print(ans + 1);
    }
    Quiz[ans] = cnt % 2 == 0 ? Player1 : Player2;

    if(isSame(0, 1, 2) || isSame(3, 4, 5) || isSame(6, 7, 8)
    || isSame(0, 4, 8) || isSame(2, 4, 6)
    || isSame(6, 3, 0) || isSame(7, 4, 1) || isSame(8, 5, 2)){
      print('Player ${cnt % 2 == 0 ? 1 : 2} is Winer ');
      printTable();
      return ;
    }
    
  }
  print("Its a Draw");
  //List<String> fruits = new List<String>();
}