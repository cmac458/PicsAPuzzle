import 'dart:html';
import 'dart:math';
import 'https://raw.github.com/cmac458/dart_touch/master/lib/dart_touch.dart' as touch;
class Conundrum {
  
  List words;
  String targetWord;
  List chars;
  int score = 0 ;
  
  void init(){
    
    populateWords();
    
    targetWord = randomWord();
    chars = new List();
    List tempList = targetWord.splitChars();
    chars.addAll(tempList);
    var cards = document.queryAll('#cards .card');
    
    for (var card in cards){
     card.innerHTML = getCharFromWord(targetWord) ;
     touch.setDragNDropDefault(card);
     card.on.drop.add(_onDropCheck);
    }
  }
  
  
  void populateWords(){
    words = new List();
    words.add("ACCLAIMED");
    words.add("DECREASED");
    words.add("EXCLAIMED");
    words.add("HARDWIRED");
    words.add("PARASITES");
  }
  
  String randomWord(){
    var rand = new Random();
    var num = rand.nextInt(words.length);
    
    var word = words[num];
    while(word == null){
      num = rand.nextInt(words.length);
      word = words[num];
    }
    if (word != null){
      words.removeAt(num);
    }
    return word;
  }
  
  getCharFromWord(String target){
    var rand = new Random();
    var num = rand.nextInt(chars.length);
    var char = chars[num];
    while(char == null){
      num = rand.nextInt(chars.length);
      char = chars[num];
    }
    if (char != null){
      chars.removeAt(num);
    }   
    return char;
  }
  
  void checkSolution(){
    var cards = document.queryAll('#cards .card');
    StringBuffer check = null;
    if(check == null){
      check = new StringBuffer("");
    }
    for (var card in cards){
      String inner = card.innerHTML;
      inner = card.innerHTML.substring(inner.length-1);
      check.add(inner);
    }
   if(check.toString() == targetWord){
      score ++;
      newCards();
   }
  }
  
  
  void _onDropCheck(MouseEvent){
    checkSolution();
  }
 
  void newCards(){
    targetWord = randomWord();
    chars = new List();
    List tempList = targetWord.splitChars();
    chars.addAll(tempList);
    
 var cards = document.queryAll('#cards .card');
    
    for (var card in cards){
      card.innerHTML = getCharFromWord(targetWord) ;
    }
  }
}
 
void main(){
  var game = new Conundrum();
  game.init();
}