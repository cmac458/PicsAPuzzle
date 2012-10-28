import 'dart:html';
import 'dart:math';

class Game {
  Element _dragSourceEl;
  Map tiles;
  int noOfTiles;
  var tileWidth;
  var tileHeight;
  int rowSize;
  
  void initGame(){
    ButtonElement create = document.query("#createButton");
    create.on.click.add(createGame);
  }

  void buildGame(int size, String url){

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
      //tile.classes.add('medium');

      tile.style.setProperty('height',height, '');
      tile.style.setProperty('width', width, '');

      tile.style.setProperty('background-position',getRandomTile(), '');
      tile.style.setProperty('background-size', getPositionString(570,390), '');
      tile.style.setProperty('background-image',url,'');

      tile.on.dragStart.add(_onDragStart);
      tile.on.dragEnd.add(_onDragEnd);
      tile.on.dragEnter.add(_onDragEnter);
      tile.on.dragOver.add(_onDragOver);
      tile.on.dragLeave.add(_onDragLeave);
      tile.on.drop.add(_onDrop);

      gameBoard.elements.add(tile);

    }

  }

  void generatePictureMap(){
    var currentX = 0;
    var currentY = 0;
    tiles = new Map();

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
    Element dragTarget = event.target;
    dragTarget.classes.add('moving');
    _dragSourceEl = dragTarget;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/html', dragTarget.innerHTML);
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

  void _onDrop(MouseEvent event) {
    // Stop the browser from redirecting.
    event.stopPropagation();

    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = event.target;
    if (_dragSourceEl != dropTarget) {
      // Set the source column's HTML to the HTML of the column we dropped on.
      _dragSourceEl.innerHTML = dropTarget.innerHTML;
      var bg_image_old = dropTarget.style.backgroundPosition;
      dropTarget.innerHTML = event.dataTransfer.getData('text/html');
      dropTarget.style.backgroundPosition = _dragSourceEl.style.backgroundPosition;
      _dragSourceEl.style.backgroundPosition = bg_image_old;


    }
  }
  
  void createGame(MouseEvent event){
    InputElement imageUrl = document.query("#urlInput");
    var url = imageUrl.value;
    
    SelectElement selectGrid = document.query("#gridSelect");
    var size =selectGrid.value;
    
    ImageElement solution = document.query("#solutionImg");
    solution.src = url;
    
 
    if(url == ""){
      url = "default";
    }
    
    print(url);
    
    DivElement tiles = document.query("#columns");
    tiles.elements.clear();
    

    buildGame(int.parse(size), url);
  }
  
 

}

void main(){
  Game g = new Game();
  g.initGame();
  g.buildGame(4,"default");
}