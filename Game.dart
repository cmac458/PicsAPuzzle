import 'dart:html';
import 'dart:math';

class Game {
  Element _dragSourceEl;
  Element _dropTarget;
  Map tiles;
  Map solution;
  int noOfTiles;
  var tileWidth;
  var tileHeight;
  int rowSize;
  int score;


  void initGame(){
  ButtonElement create = document.query('#createButton');
  create.onClick.listen(createGame);
  }

  void buildGame(int size, String url){

    score = 0;
    noOfTiles = size * size;
    rowSize = size;

    if(url == "default"){
      url = "url(img/solution.jpg)";
    }else{
      url = "url($url)";
    }

    DivElement gameBoard = document.query("#columns") ;

    var container = document.query('.board');

   tileWidth = 570 / size;
   tileHeight = 390 / size;
   tileWidth = tileWidth -5;
   tileHeight = tileHeight -5;

    DivElement tile ;

    var width = getWidthString(tileWidth.toInt());
    var height = getWidthString(tileHeight.toInt());

   generatePictureMap();


    for (int i = 1; i <=  noOfTiles; i ++){

      tile = new DivElement();
      tile.draggable = true;

      tile.classes.add("column");
      tile.id = i.toString();
      //tile.classes.add('medium');

      tile.style.setProperty('height',height, '');
      tile.style.setProperty('width', width, '');

      tile.style.setProperty('background-position',getRandomTile(), '');
      tile.style.setProperty('background-size', getPositionString(570,390), '');
      tile.style.setProperty('background-image',url,'');

      tile.onDragStart.listen(_onDragStart);
      tile.onDragEnd.listen(_onDragEnd);
      tile.onDragEnter.listen(_onDragEnter);
      tile.onDragOver.listen(_onDragOver);
      tile.onDragLeave.listen(_onDragLeave);
      tile.onDrop.listen(_onDrop);

     tile.onTouchStart.listen(_onTouchStart);
     tile.onTouchMove.listen(_onTouchMove);
     tile.onTouchEnd.listen(_onTouchEnd);
     tile.onTouchLeave.listen(_onTouchLeave);

      gameBoard.append(tile);

    }

  }


  void checkGame(){
    int check = 0;
    var columns = document.queryAll('#columns .column');

    for (var col in columns){
      if(col.style.backgroundPosition.toString() == solution[int.parse(col.id)]){
        print("equals");
        check ++;
      }
    }
    if(check == noOfTiles){
      var modal = document.query("#endModal");
      Element scoreElement = document.query('#noMoves');
      scoreElement.innerHtml = " $score moves !!";
      modal.classes.clear();
      modal.classes.add("modal show");
    }
  }
  void generatePictureMap(){
    var currentX = 0;
    var currentY = 0;
    tiles = new Map();
    solution = new Map();

    for (int i = 1; i <=  noOfTiles; i ++){

    var position = getPositionString(currentX.toInt(),currentY.toInt());

      if(i <=rowSize || i >rowSize){
        currentX = currentX-tileWidth;

      }

      if(i%rowSize == 0 && i !=0){
        currentX = 0;
        currentY = currentY-tileHeight;

      }
      tiles[i]= position;
      solution[i] = position;
    }
  }

  String getRandomTile(){

    var rand = new Random();
    var tempTiles = noOfTiles+1;
    var num = rand.nextInt(tempTiles);
    var pos = tiles[num];
    while(pos == null){
      num = rand.nextInt(tempTiles);
      pos=tiles[num];
    }
    if(pos != null){
      tiles.remove(num);
    }
    return pos;


  }
  String getWidthString(int value){
    var pixel = "$value px";
    pixel = pixel.replaceAll(' ','');
    return pixel;
  }

  String getPositionString(int x,int y){
    var pixel1 = "$x px";
    pixel1 = pixel1.replaceAll(' ','');
    var pixel2 = "$y px";
    pixel2 = pixel2.replaceAll(' ','');
    pixel1 = "$pixel1 $pixel2";
    return pixel1;
  }


  void _onDragStart(MouseEvent event) {
    print(event.type);
    Element dragTarget = event.target;
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/html', dragTarget.innerHtml);
  }

  void _onDragEnd(MouseEvent event) {
    Element dragTarget = event.target;
    dragTarget.classes.remove('moving');
    var cols = document.queryAll('#columns .column');
    for (var col in cols) {
      col.classes.remove('over');
    }
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.add('over');
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.remove('over');

  }

  void _onTouchStart(TouchEvent event){
    event.preventDefault();
    Element dragTarget = event.target;
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;

  }

  void _onTouchEnd(TouchEvent event){
    event.preventDefault();

    Element dragTarget = event.target;
    dragTarget.classes.remove('moving');
    var cols = document.queryAll('#columns .column');
    for (var col in cols) {
      col.classes.remove('over');
    }

    DivElement dragSource = event.currentTarget;
    var idsrc = dragSource.id;
    print(idsrc);


    dragSource.innerHtml = _dropTarget.innerHtml;
    var bg_image_old = _dropTarget.style.backgroundPosition;

    _dropTarget.style.backgroundPosition = dragSource.style.backgroundPosition;
    dragSource.style.backgroundPosition = bg_image_old;
  }

  void _onTouchMove(TouchEvent event){
    _dragSourceEl.classes.add('moving');
    event.preventDefault();
    Element dropTarget = event.target;
    dropTarget.classes.add('over');
    _dropTarget = document.elementFromPoint(event.touches[0].page.x,event.touches[0].page.y);

  }

  void _onTouchLeave(TouchEvent event){
    event.preventDefault();
    event.stopImmediatePropagation();
    _dropTarget.classes.remove('over');

  }

  void _onDrop(MouseEvent event) {


    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      // Set the source column's HTML to the HTML of the column we dropped on.
      _dragSourceEl.innerHtml = dropTarget.innerHtml;
      var bg_image_old = dropTarget.style.backgroundPosition;
      dropTarget.innerHtml = event.dataTransfer.getData('text/html');
      dropTarget.style.backgroundPosition = _dragSourceEl.style.backgroundPosition;
      _dragSourceEl.style.backgroundPosition = bg_image_old;

      if(dropTarget.style.backgroundPosition == solution[int.parse(dropTarget.id)]){

      }

      score ++;
      checkGame();

    }
  }

  void createGame(MouseEvent event){
    InputElement imageUrl = document.query("#urlInput");
    var url = imageUrl.value;

    SelectElement selectGrid = document.query("#gridSelect");
    var size =selectGrid.value;

    if(url == ""){
      url = "default";
    }else{
      ImageElement solution = document.query("#solutionImg");
      solution.src = url;
    }

    print(url);

    DivElement tiles = document.query("#columns");
    tiles.children.clear();


    buildGame(int.parse(size), url);
  }



}

void main(){
  Game g = new Game();
  g.initGame();
  g.buildGame(2,"default");
}