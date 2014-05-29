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
		
		
		private var _image:Bitmap;
		private var bmd:BitmapData;
		protected var fileRef:FileReference;
		
		
		public static var nodeHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		//public static var mapPoints:Vector.<Point> = new Vector.<Point>();
		
		var mapNode:MovieClip;
		var mapPointsByte:ByteArray;
		
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
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, deleteNode);
			//editorFrame.addEventListener(MouseEvent.RIGHT_CLICK, pickBackground);
			
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, lineClick);
			
			
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelect);
 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, chooseFile);
		}
		
		//open json file
		private function openFile(e:Event) {
			
			var map:Object;
			
			var inFile : File = new File();
			
			inFile.browseForOpen("Open File");
			
			inFile.addEventListener(Event.SELECT, function(e:Event) : void{
				
				fileName.text = inFile.nativePath;
				//fileName.text = inFile.name;
				
				var fs:FileStream = new FileStream();
				fs.open(inFile, FileMode.READ);
				
				

				
				
				
				
				try {
					
					map = JSON.parse( fs.readUTFBytes(fs.bytesAvailable) );
					
            		mapPicture = map[0].toString();
					openImage(e);
				
    				//var newByteArr:ByteArray=mapPicture.toByteArray();       
 					//var pixel:String;
					
				
					
					
					//for(pixel in mapPicture){
						//decoderMap.push(mapPicture[pixel]);
					//}
					//trace (decoderMap);
					
					//}
					
					//addChild(mapPicture); 
					
					mapPoints = map[1];
					//mapPoints.writeObject(map[1]);
					trace("got to here");
					//trace("read points: " + mapPoints.readObject());
					
					mapPoints.position = 0;
					while(mapPoints.bytesAvailable){
						var gayString:String = mapPoints.readObject()
						trace("mapPoint: " + gayString);
					}
					
					
					//mapPoints.position = 0;
					//var node1:Point = map[1].readObject();
					//trace( "is point: " + node1 is Point );
					//trace("loaded points: " + mapPoints);
					
					mapLinks = map[2];
					trace(mapLinks);
					
				} catch (e:SyntaxError) {
					
					map = null;
					fileName.text = "Could Not Load " + inFile.name;
					
				}
				
				fs.close();
				
				trace("file opened");
				
			});
			
		}
		
		private function openImage(e:Event) {
			// define image url
			var url:URLRequest = new URLRequest(mapPicture);

			// create Loader and load url
			var imgage:Loader = new Loader();
			imgage.load(url);

			// listener for image load complete
			imgage.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
			trace("image loaded");
			trace(mapPicture);
			// attaches the image when load is complete
		}
	
		
		//save json file
		private function saveFile(e:Event) {

			var outArr : Array = new Array();
			outArr[0] = mapPicture;
			//outArr[0] = Base64.encode(bmd.getVector(bmd.rect).toString())
			convert2byte();
			outArr[1] = mapPointsByte;
			//trace(outArr[1]);
			outArr[2] = mapLinks;
			
			var outFile : File = new File();
			
			outFile.browseForSave("Save File");
			
			outFile.addEventListener(Event.SELECT, function(e:Event) : void{
					
					fileName.text = outFile.nativePath;
					
					var fs:FileStream = new FileStream();
					fs.open(outFile, FileMode.WRITE);
					
					fs.writeUTFBytes( JSON.stringify(outArr) );
					
					fs.close();
					trace("file saved");
					
				});
			
		}
		
		
		private function convert2byte(){
			registerClassAlias( "byteNodes", Point ); 
        	mapPointsByte.writeObject(mapPoints);
        	mapPointsByte.position = 0;
        	var arrayB:Array = mapPointsByte.readObject() as Array;
        	//arrayB.push("e", "f", "g", "h");
        	//trace(arrayA.length); // Outputs 4
        	trace("byte to array: " + arrayB); // Outputs 8
		}
		  
		
		//Add new node
		private function addNode(e:Event) {
			mapNode = new MapNode();
			
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
			trace(mapPoints);
			
			this.addChild(mapNode);
			mapNode.x = node.x;
			mapNode.y = node.y;
			
			nodeHolder.push(mapNode);
			
			mapNode.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, drawLine);
			
			trace("Added Node: " + node);
			//trace("mapPoints: " + mapPoints);
		}
		
		
		private function deleteNode(e:Event) {
			
			for each(var a:MovieClip in nodeHolder){
				if (a.hitTestPoint(mouseX,mouseY,true)){
					var i = nodeHolder.indexOf(a);
					if(i == 0){
						trace("cant remove last element");
					} else{
						this.removeChild(nodeHolder[i]);
						trace("removed: " + mapPoints.splice(i,1));
						mapPoints.splice(i,1);
						
						nodeHolder.splice(i,1);		
						
					}
				}
			}
		}
		
		
		
		private function drawLine(e:Event) {
			x1 = e.target.x;
			y1 = e.target.y;
		
			oldNode = nodeHolder.indexOf(e.target);
			
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDraw);
			
		}
		
		
		function onDraw(e:Event):void{
    		nodeLine.graphics.clear();
			nodeLine.graphics.moveTo(x1,y1);
			nodeLine.graphics.lineStyle(2, 0x990000, .75);
			nodeLine.graphics.lineTo(mouseX,mouseY);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, cancelLine);
			
			
		}
		
		function cancelLine(e:Event){
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDraw);
			nodeLine.graphics.clear();
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
		}
		
		private function lineClick(e:Event) {
			if(e.target is MapNode){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDraw);
				nodeLine.graphics.moveTo(x1,y1);
				nodeLine.graphics.lineStyle(e.target.x,e.target.y);
				newNode = nodeHolder.indexOf(e.target);
				
				stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
				trace ("Neighbours: " + oldNode + " -> " + newNode);
			}else{
				return;
			}
		}
		
		
		//Load background image
		private function chooseFile(event:KeyboardEvent):void{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, chooseFile);
			fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png, *.JPG)", "*.jpg;*.jpeg;*.png; *.JPG")]);
		}
 
		protected function onFileSelect(event:Event):void {	
			this.buttonMode = false;
			fileRef.removeEventListener(Event.SELECT, onFileSelect);
			fileRef.addEventListener(Event.COMPLETE, onFileLoad);
			fileRef.load();
		}
 
		
 
		protected function onFileLoad(event:Event):void {
			fileRef.removeEventListener(Event.COMPLETE, onFileLoad);
			var image:Loader = new Loader();
			image.loadBytes(fileRef.data);
			
			mapPicture = "./" + fileRef.name.toString();
			trace(mapPicture);
					
			image.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
		}
 
		protected function onImageParse(event:Event):void {
		
			//bmd = Bitmap(LoaderInfo(event.target).content).bitmapData;
			
			//var ba:ByteArray = bmd.getPixels(bmd.rect);
			
			var content:DisplayObject = LoaderInfo(event.target).content;
			_image = Bitmap(content);
 
			addChild(_image);
		}
		
	}
	
}
