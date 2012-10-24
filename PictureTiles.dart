
#import('dart:html');
#import('dart:math');

class Basics {
  Element _dragSourceEl;
  Map tiles;
  
  void start() {
    var cols = document.queryAll('#columns .column');
    generateMap();
    for (var col in cols) {
      col.on.dragStart.add(_onDragStart);
      col.on.dragEnd.add(_onDragEnd);
      col.on.dragEnter.add(_onDragEnter);
      col.on.dragOver.add(_onDragOver);
      col.on.dragLeave.add(_onDragLeave);
      col.on.drop.add(_onDrop);
      col.style.setProperty("background-image", getRandomTile(), "");
    
    }
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
      var bg_image_old = dropTarget.style.backgroundImage;
      dropTarget.innerHTML = event.dataTransfer.getData('text/html');
      dropTarget.style.backgroundImage = _dragSourceEl.style.backgroundImage;
      _dragSourceEl.style.backgroundImage = bg_image_old;
      
    }
  }
  
  void generateMap(){
    tiles = new Map();
    tiles[1] = "url(img/pgriffin_tiles_01.png)";
    tiles[2] = "url(img/pgriffin_tiles_02.png)";
    tiles[3] = "url(img/pgriffin_tiles_03.png)";
    tiles[4] = "url(img/pgriffin_tiles_04.png)";
    tiles[5] = "url(img/pgriffin_tiles_05.png)";
    tiles[6] = "url(img/pgriffin_tiles_06.png)";
    tiles[7] = "url(img/pgriffin_tiles_07.png)";
    tiles[8] = "url(img/pgriffin_tiles_08.png)";
    tiles[9] = "url(img/pgriffin_tiles_09.png)";  
  }
  
  String getRandomTile(){
    var rand = new Random();
      var num = rand.nextInt(10);
       var imgUrl = tiles[num];
       while(imgUrl == null){
         num = rand.nextInt(10);
         imgUrl=tiles[num];
       }
       if(imgUrl != null){
         tiles.remove(num);
          }
       
    print(imgUrl);
    return imgUrl;
  }
}

void main() {
  var basics = new Basics();
  basics.start();

}
