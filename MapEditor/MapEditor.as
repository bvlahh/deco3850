package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.profiler.Telemetry;
	import flash.utils.ByteArray;
	
	import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.net.URLRequest;
    import flash.display.BitmapData;
    import flash.geom.Point;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.display.DisplayObject;
	import flash.net.registerClassAlias;
	
	import flash.display.Sprite;
	
	
	public class MapEditor extends MovieClip {
		
		private var mapPicture:String;
		private var decoderMap:Array;
		private var mapPoints:Array;
		private var mapLinks:Array;
		var mapPointsByte:ByteArray;
		
		
		private var _image:Bitmap;
		private var bmd:BitmapData;
		protected var fileRef:FileReference;
		
		
		public static var nodeHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		//public static var mapPoints:Vector.<Point> = new Vector.<Point>();
		
		var nodeCircle:MovieClip;
		var oldNode:Number;
		var newNode:Number;
		
		var x1:Number;
		var y1:Number;
		var nodeLine:Sprite;
		
		public function MapEditor() {
			
			//DictionaryJSON.fixJSON();
			
			mapPicture = "";
			mapPoints = new Array();
			mapLinks = new Array();
			decoderMap = new Array();
			mapPointsByte = new ByteArray();
			
			nodeLine = new Sprite();
			addChild(nodeLine);
			
			
			fileName.text = "No File Loaded";
			
			openButton.addEventListener(MouseEvent.CLICK, openFile);
			saveButton.addEventListener(MouseEvent.CLICK, saveFile);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, chooseFile);
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, deleteNode);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, nodeReleased);
			
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelect);
 
		}
		
		//open json file
		private function openFile(e:Event) {
			
			//var loadBytes:ByteArray = new ByteArray();
			var map : Object;
			
			var inFile : File = new File();
			
			inFile.browseForOpen("Open File");
			
			inFile.addEventListener(Event.SELECT, function(e:Event) : void{
				
				fileName.text = inFile.nativePath;
				//fileName.text = inFile.name;
				
				var fs:FileStream = new FileStream();
				fs.open(inFile, FileMode.READ);
				//fs.readBytes(loadBytes);
				
	
				try {
					
					map = JSON.parse( fs.readUTFBytes(fs.bytesAvailable) );
					
            		mapPicture = map[0].toString();
					//mapPicture = loadBytes.readUTFBytes(13);
					openImage(e);
				
					mapPoints = map[1];
					//mapPoints = loadBytes.readObject() as Vector.<Point>;
					//mapPoints = map[1].readObject() as Array;
					
					var node:String;
					
					//go through each point and draw the nodes
					//currently node is null because it cant cast to Point
					for (node in mapPoints){
						trace("point: " + mapPoints[node] as Point);
						//this.addChild(nodeCircle);
						//nodeCircle.x = node.x;
						//nodeCircle.y = node.y;
					}
					
					
					
					
					trace("got to here");
					trace(mapPoints);
					
					
					//mapLinks = map[2];
					//trace(mapLinks);
					
				} catch (e:SyntaxError) {
					
					map = null;
					fileName.text = "Could Not Load " + inFile.name;
					
				}
				
				fs.close();
				trace("file opened");
			});
		}
		
		//get image location
		private function openImage(e:Event) {

			var url:URLRequest = new URLRequest(mapPicture);
			var imgage:Loader = new Loader();
			
			imgage.load(url);
			imgage.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
			
			trace("image loaded");
			trace(mapPicture);
		}
	
		
		//save json file
		private function saveFile(e:Event) {
			//for bytearray to hold Point type
			//registerClassAlias("byteNodes", Point);
			
			var outArr : Array = new Array();
			outArr[0] = mapPicture;
			//outArr.writeUTFBytes(mapPicture);
		
			//convert2byte();
			outArr[1] = mapPoints;
			//outArr.writeObject(mapPointsByte);
			
			//outArr[2] = mapLinks;
			//outArr.writeUTFBytes(mapLinks.toString());
			
			var outFile : File = new File();
			
			outFile.browseForSave("Save File");
			
			outFile.addEventListener(Event.SELECT, function(e:Event) : void{
					
					fileName.text = outFile.nativePath;
					
					var fs:FileStream = new FileStream();
					fs.open(outFile, FileMode.WRITE);
					
					fs.writeUTFBytes( JSON.stringify(outArr) );
					//fs.writeBytes(outArr, 0, outArr.length);
					fs.close();
					trace("file saved");
					
				});
			
		}
		
		
		private function convert2byte(){
			 
        	mapPointsByte.writeObject(mapPoints);
        	mapPointsByte.position = 0;
        	var array:Array = mapPointsByte.readObject() as Array;
        	trace("byte to array: " + array);
		}
		  
		
		//Add new node
		private function addNode(e:Event) {
			nodeCircle = new NodeCircle();
			
			var node = new Point(mouseX, mouseY);

			//make sure the stupid array returns a point!!!
			//var node:Point = new Point(); 
			//node.x = mouseX; 
			//node.y = mouseY;  
			//mapPoints.writeObject(node);
        	
			//mapPoints.position = 0;
			//while(mapPoints.bytesAvailable){
				//trace("mapPoint: " + mapPoints.readObject());
			//}
			
			mapPoints.push(node);
			trace("mapPoints: " + mapPoints);
			
			this.addChild(nodeCircle);
			nodeCircle.x = node.x;
			nodeCircle.y = node.y;
			
			nodeHolder.push(nodeCircle);
	
			nodeCircle.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nodePressed);
			
			trace("Added Node: " + node);
	
		}
		
		
		private function deleteNode(e:Event) {
			
			for each(var a:MovieClip in nodeHolder){
				if (a.hitTestPoint(mouseX,mouseY,true)){
					var i = nodeHolder.indexOf(a);
					if(i == 0){
						trace("cant remove last element");
					} else{
						this.removeChild(nodeHolder[i]);
						mapPoints.splice(i,1);
						nodeHolder.splice(i,1);
						trace("removed: " + mapPoints.splice(i,1));
					}
				}
			}
		}
		
		
		//node right pressed
		private function nodePressed(e:Event) {
			x1 = e.target.x;
			y1 = e.target.y;
		
			oldNode = nodeHolder.indexOf(e.target);
			
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			
		}
		
		//draw line
		function drawLine(e:Event):void{
    		nodeLine.graphics.clear();
			nodeLine.graphics.moveTo(x1,y1);
			nodeLine.graphics.lineStyle(2, 0x990000, .75);
			nodeLine.graphics.lineTo(mouseX,mouseY);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, nodeReleased);
			
			
		}
		
		private function nodeReleased(e:Event) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			
			if(e.target is NodeCircle){
				nodeLine.graphics.moveTo(x1,y1);
				nodeLine.graphics.lineStyle(e.target.x,e.target.y);
				newNode = nodeHolder.indexOf(e.target);
				trace ("Neighbours: " + oldNode + " -> " + newNode);
			}else{
				nodeLine.graphics.clear();
				trace ("No neighbour");
			}
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
		}
		
		
		//open file browser
		private function chooseFile(event:KeyboardEvent):void{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, chooseFile);
			fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png, *.JPG)", "*.jpg;*.jpeg;*.png; *.JPG")]);
		}
 
 		//load file
		protected function onFileSelect(event:Event):void {	
			this.buttonMode = false;
			fileRef.removeEventListener(Event.SELECT, onFileSelect);
			fileRef.addEventListener(Event.COMPLETE, onFileLoad);
			fileRef.load();
		}
 
		
 		//now its loaded get data from file
		protected function onFileLoad(event:Event):void {
			//remove old map
			if(_image != null){
				removeChild(_image);
			}
			fileRef.removeEventListener(Event.COMPLETE, onFileLoad);
			var image:Loader = new Loader();
			image.loadBytes(fileRef.data);
			
			//filepath of image
			mapPicture = "./" + fileRef.name.toString();
			trace(mapPicture);
					
			image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
		}
 
 		//display bitmap data from file
		protected function onImageParse(event:Event):void {
			var content:DisplayObject = LoaderInfo(event.target).content;
			_image = Bitmap(content);
			addChild(_image);
			
			
			//if map changes, reset node arrays
			if(mapPoints != null){
				mapPoints = new Array();
				nodeHolder = new Vector.<MovieClip>();
			}
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, chooseFile);
			fileRef.addEventListener(Event.SELECT, onFileSelect);
		}
		
	}
	
}
