
import 'dart:math';

int generateRandomSixDigitNumber() {
  Random random = Random();
  int min = 100000; 
  int max = 999999;
  return min + random.nextInt(max - min + 1);
}
