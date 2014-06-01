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
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	
	public class MapEditor extends MovieClip {
		
		private var mapPicture:String;
		private var mapPoints:Array;
		private var mapLinks:Array;
		private var nodeArray:Array;
		
		
		private var _image:Bitmap;
		private var bmd:BitmapData;
		protected var fileRef:FileReference;
		
		
		private static var nodeHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		//public static var mapPoints:Vector.<Point> = new Vector.<Point>();
		
		private var nodeCircle:MovieClip;
		private var oldNode:Number;
		private var newNode:Number;
		
		private var x1:Number;
		private var y1:Number;
		private var nodeLine:Sprite;
		
		private var nodeName:TextField;
		private var nodeImage:TextField;
		private var nodeNeighbours:TextField;
		private var commitButton:Sprite;
		
		private var strName:String = "";
		private var strImage:String = "";
		private var nodeIterator:Number;
		private var nodenode:Number = 0;
		
		public function MapEditor() {
			
			mapPicture = "";
			mapPoints = new Array();
			mapLinks = new Array();
			nodeArray = new Array();
			
			
			nodeLine = new Sprite();
			addChild(nodeLine);
			
			
			fileName.text = "No File Loaded";
			
			openButton.addEventListener(MouseEvent.CLICK, openFile);
			saveButton.addEventListener(MouseEvent.CLICK, saveFile);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, chooseFile);
			
			stage.addEventListener(MouseEvent.CLICK, nodeClicked);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, deleteNode);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, nodeReleased);
			
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelect);
			
			stage.doubleClickEnabled=true;
			
			nodeName = new TextField();
				nodeName.type = TextFieldType.INPUT;
            	nodeName.border = true;
				nodeName.background = true;
				
				nodeName.x = 550;
				nodeName.y = 0;
				nodeName.width = 200;
				nodeName.height = 20;
				this.addChild(nodeName);
				
				nodeImage = new TextField();
				nodeImage.type = TextFieldType.INPUT;
            	nodeImage.border = true;
				nodeImage.background = true;
				
				nodeImage.x = 550;
				nodeImage.y = 20;
				nodeImage.width = 200;
				nodeImage.height = 20;
				this.addChild(nodeImage);
				
				nodeNeighbours = new TextField();
				nodeNeighbours.type = TextFieldType.DYNAMIC;
            	nodeNeighbours.border = true;
				
				nodeNeighbours.x = 550;
				nodeNeighbours.y = 40;
				nodeNeighbours.width = 200;
				nodeNeighbours.height = 200;
				this.addChild(nodeNeighbours);
				
				commitButton = new Sprite();
				commitButton.graphics.beginFill(0xDDDDDD);
				commitButton.graphics.drawRect(550, 260, 200, 20);
				this.addChild(commitButton);
				
				
			
 
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
						//trace("point: " + mapPoints[node][0],mapPoints[node][1]);
						//trace("number: " + Number(mapPoints[node][0]));
						nodeCircle = new NodeCircle();
						addChild(nodeCircle);
						nodeCircle.x = Number(mapPoints[node][0]);
						nodeCircle.y = Number(mapPoints[node][1]);
					}
				
					trace("got to here");
					//trace(mapPoints[node][1]);
					
					var neighbour:String;
					mapLinks = (map[2]);
					for (neighbour in mapLinks){
						Number(mapLinks[neighbour][0]);
						Number(mapLinks[neighbour][1]);
					}
					trace(mapLinks);
					
					nodeArray = map[3];
					trace(nodeArray[1][0]);
					
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
		private function saveFile(e:Event){
			
			//for bytearray to hold Point type
			//registerClassAlias("byteNodes", Point);
			
			var outArr : Array = new Array();
			outArr[0] = mapPicture;
			//outArr.writeUTFBytes(mapPicture);
		
			//convert2byte();
			outArr[1] = mapPoints;
			//outArr.writeObject(mapPointsByte);
			
			outArr[2] = mapLinks;
			//outArr.writeUTFBytes(mapLinks.toString());
			
			outArr[3] = nodeArray;
			
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
		
		  
		
		//Add new node
		private function addNode(e:Event):void{
			
			nodeCircle = new NodeCircle();
			var node:Array = new Array(mouseX, mouseY);
			
			mapPoints.push(node);
			trace("mapPoints: " + mapPoints);
			
			this.addChild(nodeCircle);
			nodeCircle.x = mouseX;
			nodeCircle.y = mouseY;
			
			nodeHolder.push(nodeCircle);
			
			nodeArray.push(new Array("node"+nodenode.toString(), "imagefile"));
			nodenode++;
			//trace("nodeArray: " + nodeArray[0][0]);
	
			nodeCircle.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, nodePressed);
			
			trace("Added Node: " + node);
	
		}
		
		
		private function deleteNode(e:Event):void{
			
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
						
						var neighbour:String;
						for (neighbour in mapLinks){ 
							trace("is: " + mapLinks[neighbour][0] + " == " + i + ": " + (mapLinks[neighbour][0] == i));
							if(mapLinks[neighbour][0] == i || mapLinks[neighbour][1] == i){
								mapLinks.splice(Number(neighbour),1);
								trace("removed link");
							}
						}
					}
				}
			}
		}
		
		
		//node has been pressed
		private function nodePressed(e:Event):void{
			
			x1 = e.target.x;
			y1 = e.target.y;
			
			oldNode = nodeHolder.indexOf(e.target);
			
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, addNode);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			
		}
		
		//draw line
		private function drawLine(e:Event):void{
			
    		nodeLine.graphics.clear();
			nodeLine.graphics.moveTo(x1,y1);
			nodeLine.graphics.lineStyle(2, 0x990000, .75);
			nodeLine.graphics.lineTo(mouseX,mouseY);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, nodeReleased);
			
			
		}
		
		//mouse released create neighbour or cancel line
		private function nodeReleased(e:Event):void{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			
			if(e.target is NodeCircle){
				nodeLine.graphics.moveTo(x1,y1);
				nodeLine.graphics.lineStyle(e.target.x,e.target.y);
				newNode = nodeHolder.indexOf(e.target);
				//trace ("Neighbours: " + oldNode + " -> " + newNode);
				var neighbours:Array = new Array (oldNode, newNode);
				mapLinks.push(neighbours);
				trace(mapLinks);
			}else{
				nodeLine.graphics.clear();
				trace ("No neighbour" + e.target);
			}
			stage.addEventListener(MouseEvent.RIGHT_CLICK, addNode);
		}
		
		
		private function nodeClicked(e:Event):void{
			
			if(e.target is NodeCircle){
				
				nodeIterator = nodeHolder.indexOf(e.target);
				
				var neighbour:String;
				var tempArray:Array = new Array();
				for (neighbour in mapLinks){ 
					if(mapLinks[neighbour][0] == nodeIterator){
						tempArray.push(mapLinks[neighbour][1]);
						
					}
					
				}
				
				trace("iterator: " + nodeIterator);
				trace("nodeArray: " + nodeArray[nodeIterator]);
			
				nodeName.text = nodeArray[nodeIterator][0];
				nodeImage.text = nodeArray[nodeIterator][1];
				nodeNeighbours.text = tempArray.toString();
				trace("heelo: " + nodeArray[nodeIterator]);
				
				commitButton.addEventListener(MouseEvent.CLICK, commitNode);
				//trace("array: " + currentArray);
			}
		}
		
		private function commitNode(e:Event) : void {
			strName = nodeName.text;
			strImage = nodeImage.text;
			nodeArray[nodeIterator][0] = strName;
			nodeArray[nodeIterator][1] = strImage;
			//nodeArray[nodeIterator][2] = nodeNeighbours.text;
			nodeName.text = "";
			nodeImage.text = "";
			//strName = nodeArray[nodeIterator][0];
			//strImage = nodeArray[nodeIterator][1];
			
			trace("arrayname: " + nodeArray[nodeIterator]);
		}
		
		//open file browser
		private function chooseFile(event:Event):void{
			trace("did it double click");
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, chooseFile);
			fileRef.browse([new FileFilter("Images (*.jpg, *.jpeg, *.png, *.JPG)", "*.jpg;*.jpeg;*.png; *.JPG")]);
		}
 
 		//load file
		private function onFileSelect(event:Event):void {
			
			this.buttonMode = false;
			fileRef.removeEventListener(Event.SELECT, onFileSelect);
			fileRef.addEventListener(Event.COMPLETE, onFileLoad);
			fileRef.load();
		}
 
		
 		//now its loaded get data from file
		private function onFileLoad(event:Event):void {
			
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
		private function onImageParse(event:Event):void {
			
			var content:DisplayObject = LoaderInfo(event.target).content;
			_image = Bitmap(content);
			addChild(_image);
			setChildIndex(_image, 0);
			
			
			//if map changes, reset node arrays OR place map on bottom keeping node arrays
			if(mapPoints != null){
				//mapPoints = new Array();
				//nodeHolder = new Vector.<MovieClip>();
				setChildIndex(_image, 0);
			}
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK, chooseFile);
			fileRef.addEventListener(Event.SELECT, onFileSelect);
		}
		
	}
	
}
