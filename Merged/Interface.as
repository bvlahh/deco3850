package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.display.SimpleButton;
	import flashx.textLayout.operations.MoveChildrenOperation;
	import RouteFinding;
	
	
	public class Interface extends MovieClip {
		
		var footX : Number = -1;
		var footY : Number = -1;
		
		var buttonStart:MovieClip = new ButtonStart();
		var buttonBack:MovieClip = new ButtonBack();
		
		var foodButton:MovieClip = new FoodButton();
		var foodMenu:MovieClip = new FoodMenu();
		
		var graffitiButton:MovieClip = new GraffitiButton();
		var graffitiMenu:MovieClip = new GraffitiMenu();
		
		var mazeButton:MovieClip = new MazeButton();
		var mazeMenu:MovieClip = new MazeMenu();
		
		var oneringButton:MovieClip = new OneringButton();
		var oneringMenu:MovieClip = new OneringMenu();
		
		var skyhighButton:MovieClip = new SkyhighButton();
		var skyhighMenu:MovieClip = new SkyhighMenu();
		
		var slappypuppyButton:MovieClip = new SlappypuppyButton();
		var slappypuppyMenu:MovieClip = new SlappypuppyMenu();
		
		var whatsupButton:MovieClip = new WhatsupButton();
		var whatsupMenu:MovieClip = new WhatsupMenu();
		
		var arcButton:MovieClip = new ArcButton();
		var arcMenu:MovieClip = new ArcMenu();
		
		var beatbloxButton:MovieClip = new BeatbloxButton();
		var beatbloxMenu:MovieClip = new BeatbloxMenu();
		
		var brotechButton:MovieClip = new BrotechButton();
		var brotechMenu:MovieClip = new BrotechMenu();
		
		var transposeButton:MovieClip = new TransposeButton();
		var transposeMenu:MovieClip = new TransposeMenu();
		
		var startBackground:MovieClip = new background1();
		var otherBackground:MovieClip = new background2();
		
		var route:RouteFinding;
		var bool:Boolean;
		
		//public static var buttonHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var buttonHolder:Array = new Array(foodButton, graffitiButton, mazeButton, oneringButton, skyhighButton, slappypuppyButton, whatsupButton , arcButton , beatbloxButton ,brotechButton , transposeButton );
		public var menuHolder:Array = new Array(foodMenu, graffitiMenu, mazeMenu , oneringMenu , skyhighMenu , slappypuppyMenu , whatsupMenu , arcMenu , beatbloxMenu , brotechMenu, transposeMenu);
		public var buttonCounter:Array = new Array();
		public var mapHolder:Array = new Array();
		
		public function Interface() {
			
			for (var button in buttonHolder) {
				route = new RouteFinding(button - 1);
				trace(button);
				mapHolder.push(route);
				trace(buttonHolder[button], menuHolder[button], mapHolder[button]);
			}
			
			
			this.addChild(startBackground);
			
			this.addChild(buttonStart);
			buttonStart.x = 500;
			buttonStart.y = 300;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
			addEventListener(PositionEvent.POSITIONEVENT, foot);
			
			//addEventListener(MouseEvent.MOUSE_MOVE, test);
			
		}
		
		/*
		public function test(MouseEvent : Event) : void {
			
			footX = mouseX;
			footY = mouseY;
			
		}
		*/
		
		private function foot(pe : PositionEvent) : void {
			
			var point : Point = pe.point;
			
			if (point == null) {
				footX = -1;
				footY = -1;
			} else {
				footX = point.x;
				footY = point.y;
			}
			
		}
		
		private function onEnterFrameHandler(event : Event) : void {
			
			//start button
			if (buttonStart.hitTestPoint(footX,footY,true)){
				
				this.removeChild(startBackground);
				this.addChild(otherBackground);
				//startSize.start();
				//remove start
				removeChild(buttonStart);
				//run function
				startClick(event);
			}
			
			//loop through each button, check for hit
			for each(var a:MovieClip in buttonHolder){
				//for(var a:Number = 0; a < buttonHolder.length; a++){
				var button:Number = buttonHolder.indexOf(a);
				if (a.hitTestPoint(footX,footY,true)){
					bool = true;
					
					//trace(index);
					this.addChild(menuHolder[button]);
					menuHolder[button].x = a.x;
					menuHolder[button].y = a.y - 100;
					
					this.addChild(mapHolder[button]);
					mapHolder[button].x = menuHolder[button].x - 100;
					mapHolder[button].y = menuHolder[button].y - 100;
					mapHolder[button].scaleY = 1;//0.5;
					mapHolder[button].scaleX = 1;//0.5;
			
				} else {
					
					var i:uint;
					
					for( i = 0; i < this.numChildren; i++ )
						if ( this.getChildAt(i) == menuHolder[button] )
							this.removeChildAt(i);
					
					for( i = 0; i < this.numChildren; i++ )
						if (this.getChildAt(i) == mapHolder[button])
							this.removeChildAt(i);
					
				}
			}
			
		}
		
		

		
		public function startClick(event:Event){
			for each (var a:MovieClip in buttonHolder){
			 
				addButton(a);
				
				
				
			}
			
		}
		
		public function addButton(button:MovieClip){
			
			button.x = 100 + Math.random() * (stage.width - 200);
			button.y = 200 + Math.random() * (stage.height - 300);
			//trace("coords: " +  button.x,button.y);
			if(canStartHere(button) == true){
				this.addChild(button);
				buttonCounter.push(button);
			}else{
				addButton(button);
				return;
			}
		}
		
		
		private function canStartHere(button:MovieClip):Boolean
		{
			//var retval:Boolean = true;
			
			// loop thru balls array
			//for each (var b:MovieClip in buttonCounter){
			for (var i:int = 0; i < buttonCounter.length; i++){
				
				var currentX = buttonCounter[i].x;
				var currentY = buttonCounter[i].y;
				// don't test hit on self
				if (button == buttonCounter[i]) continue;
				
				// make sure we dont start inside another ball
				if (button.hitTestObject(buttonCounter[i])){
					return false;
				}
				
				if (i == 0)continue;
				
				var distance:Number = Math.sqrt((button.x - currentX) + (button.y - currentY));
				
				if (distance < 5){
					return false;
				}
				
				// make sure we dont start outside the container
				if (button.x > stage.width - 100 || button.x < 50)
				{
					return false;
				}
				else if (button.y > stage.height - 100 || button.y < 50)
				{
					return false;
				}
			}
			
			return true;
		}
	}
}
