//HELPMETHOD

class ConvertInput {

    static int stringToInt_tryParse(String input, int defaultReturn) {
      var i = int.tryParse(input);
      print(i);
      if (i == null) {
        return defaultReturn;
      } else {
         return i;
      }
    }

    static String intToString(int input){
      return '$input';

    }

}
