package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.IBitmapDrawable;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class RouteFinding extends MovieClip {
		
		private static var WAYPOINTFILE = "./testfile4.txt";
		private var waypoints:Object;
		
		private var startNodeName:TextField;
		private var endNodeName:TextField;
		private var searchButton:Sprite;
		
		private var mapPicture:String;
		private var mapPoints:Array;
		private var mapLinks:Array;
		private var nodeArray:Array;
		private var neighbourArray:Array;
		private var routePath:Array;
		
		private static var nodeHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var nodeCircle:MovieClip;
		private var _image:Bitmap;
		private var nodeIterator:Number;
		private var startNode:String = null;
		private var endNode:String = null;
		private var node:String;
		private var nodeLine:Sprite;
		
		public function RouteFinding(button:Number) {
			
			mapPicture = "";
			mapPoints = new Array();
			mapLinks = new Array();
			nodeArray = new Array();
			neighbourArray = new Array();
			routePath = new Array();
			
			nodeLine = new Sprite();
			addChild(nodeLine);
			
			var myRequest:URLRequest = new URLRequest(WAYPOINTFILE);
			var myLoader = new URLLoader();
			
			//stage.addEventListener(MouseEvent.CLICK, nodeClicked);
			
			myLoader.addEventListener(Event.COMPLETE, JSONLoad);
			myLoader.load(myRequest);
			
			function JSONLoad(e:Event):void
			{
				waypoints = JSON.parse(myLoader.data);
				
				
				mapPicture = waypoints[0].toString();
				openImage(e);
				
				mapPoints = waypoints[1];
					
				var i:Number = 0;
				for (node in mapPoints){
				nodeCircle = new NodeCircle();
					nodeHolder.push(nodeCircle);
					
					if(i < 12){
						addChild(nodeCircle);
						nodeCircle.x = Number(mapPoints[node][0]);
						nodeCircle.y = Number(mapPoints[node][1]);
						i++;
					}
				}
				
					
				var neighbour:String;
				mapLinks = waypoints[2];
				for (neighbour in mapLinks){
					Number(mapLinks[neighbour][0]);
					Number(mapLinks[neighbour][1]);
				}
				
					
				nodeArray = waypoints[3];
				
				
				nodeIterator = button;
				
				startNode = nodeArray[0][0];
				trace("start: " + startNode);
				if (nodeArray[node][0] != ""){
					endNode = nodeArray[nodeIterator][0];
					trace("end: " + endNode);
				}
				
				if ( (startNode == null) || (endNode == null) ){
					throw new Error("Invalid end nodes");
				}
				routePath = ids(startNode, endNode);
				trace("Path: " + routePath);
				
				drawPath(routePath);
				
				
				
			}
			
		}
		
		//get image location
		public function openImage(e:Event) {
			
			var url:URLRequest = new URLRequest(mapPicture);
			var imgage:Loader = new Loader();
			
			imgage.load(url);
			imgage.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageParse);
			
			trace("image loaded");
			trace(mapPicture);
		}
		
		public function onImageParse(event:Event):void {
			
			var content:DisplayObject = LoaderInfo(event.target).content;
			_image = Bitmap(content);
			addChild(_image);
			setChildIndex(_image, 0);
			
			
			//if map changes, reset node arrays OR place map on bottom keeping node arrays
			if(mapPoints != null){
				setChildIndex(_image, 0);
			}
		}
		
		
		public function nodeClicked(e:Event):void{
			
			if(e.target is NodeCircle){
				
				nodeIterator = nodeHolder.indexOf(e.target);
				
				
				
				
				
				startNode = nodeArray[0][0];
				trace("start: " + startNode);
				if (nodeArray[node][0] != ""){
					endNode = nodeArray[nodeIterator][0];
					trace("end: " + endNode);
				}
				
				if ( (startNode == null) || (endNode == null) ){
					throw new Error("Invalid end nodes");
				}
				routePath = ids(startNode, endNode);
				trace("Path: " + routePath);
				
				drawPath(routePath);
			}
		}
	
			
		
		function drawPath(route:Array):void{
			nodeLine.graphics.clear();
			var node:String;
			var i:Number = 0;
				while (i < route.length-1){
					var currentNode = route[i];
					var nextNode = route[i+1];
					//trace("currentNode: " + currentNode);
					//trace("nextNode: " + nextNode);
					var p1x:Number = mapPoints[currentNode][0];
					var p1y:Number = mapPoints[currentNode][1];
					var p2x:Number = mapPoints[nextNode][0];
					var p2y:Number = mapPoints[nextNode][1];
					//trace("point: " + p1x,p1y);
					//trace("nextPoint: " + p2x,p2y);
					
					
					nodeLine.graphics.moveTo(p1x,p1y);
					nodeLine.graphics.lineStyle(5, 0x990000, 1);
					nodeLine.graphics.lineTo(p2x,p2y);
					
					i++;
				}
		}
		
		
			
		function rd(currentNode:String, visitedNodes:Array, goalState:String, depth:int) : Array {
				
			if (depth == 0)
				return null;
				
			var myVisitedNodes:Array = new Array();
			myVisitedNodes = myVisitedNodes.concat(visitedNodes);
			
				
			myVisitedNodes.push(currentNode);
			//trace("visited: " + myVisitedNodes);
			
			//trace("going from: " + currentNode + " to: " + goalState);
			if (currentNode == goalState)
				return myVisitedNodes;
				
				
				
			var neighbour:String;
				var tempArray:Array = new Array();
				for (neighbour in mapLinks){ 
					//trace("neighbour: " + neighbour); 
					//trace("current node: " + ("node" + (mapLinks[neighbour][0])));
					//trace("current node: " + currentNode);
					//trace("is mapLink the current node: " + ("node" + (mapLinks[neighbour][0]) == currentNode));
					if((mapLinks[neighbour][0]) == currentNode){
						tempArray.push(mapLinks[neighbour][1]);
						//trace("tempArray: " + tempArray);
						
					}
					//neighbourArray[nodeIterator] = tempArray;
						//trace("neighbours: " + neighbourArray);
				
				}	
				
				
				
			var node:String;
				
			for (node in tempArray) {
				//trace("node: " + node);
				//trace("in array: " + tempArray);
					
				if ( myVisitedNodes.indexOf(tempArray[node]) == -1 ) {
						
					var ret:Array = rd(tempArray[node], myVisitedNodes, endNode, depth-1);
						
					if (ret != null)
						return ret;
						
				}
			
			}
				
			return null;
				
		}
			
		function ids(currentNode:String, goalState:String) : Array {
				
			var i:int;
				
			for (i=0; i<=mapLinks.length; i++) {
				//trace("lenght: " + mapLinks.length);
				//trace("i: " + i);
					
				var goalPath : Array = rd(currentNode, new Array(), endNode, i);
					
				if (goalPath != null)
					return goalPath;
					
			}
				
			return null;
				
		}
		
	}
	
}
