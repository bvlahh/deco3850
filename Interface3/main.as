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
	
	
	public class main extends MovieClip {
		
		
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
		
		
	
		
		//public static var buttonHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var buttonHolder:Array = new Array(foodButton, graffitiButton, mazeButton, oneringButton, skyhighButton, slappypuppyButton, whatsupButton , arcButton , beatbloxButton ,brotechButton , transposeButton );
		public var menuHolder:Array = new Array(foodMenu, graffitiMenu, mazeMenu , oneringMenu , skyhighMenu , slappypuppyMenu , whatsupMenu , arcMenu , beatbloxMenu , brotechMenu, transposeMenu);
		
		
		public function main() {
			
			this.addChild(startBackground);
			
			this.addChild(buttonStart);
			buttonStart.x = 500;
			buttonStart.y = 300;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
		}
		
		private function onEnterFrameHandler(event : Event) : void {
			
			//start button
			if (buttonStart.hitTestPoint(mouseX,mouseY,true)){
				
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
				if (a.hitTestPoint(mouseX,mouseY,true)){
					var button:Number = buttonHolder.indexOf(a);
					//trace(index);
					this.addChild(menuHolder[button]);
					menuHolder[button].x = a.x;
					menuHolder[button].y = a.y - 100;
					
					//this.addChild(buttonBack);
					//buttonBack.x = 100;
					//buttonBack.y = 700;
				}
				
				//if (a.hitTestPoint(mouseX,mouseY,false)){
					//var menu:Number = buttonHolder.indexOf(a);
					//this.removeChild(menuHolder[menu]);
				//}
			}
			
			if (buttonBack.hitTestPoint(mouseX,mouseY,true)){
				trace("HEELOO");
				//trace("a: " + a);
				//removeChild(displayBox);
				removeChild(buttonBack);
				startClick(event);
			}
			
		}
		
		

		
		public function startClick(event:Event){
			for each(var b:MovieClip in buttonHolder){
				b.x = Math.random() * stage.width;
				b.y = Math.random() * stage.height;
				trace("coords: " + b.x,b.y);
				if(canStartHere(b)){
					this.addChild(b);
				}
			}
			
		}
		
		
		private function canStartHere(button:MovieClip):Boolean
		{
			//var retval:Boolean = true;
			
			// loop thru balls array
			for (var i:int = 0; i < buttonHolder.length; i++)
			{
				// don't test hit on self
				if (button == buttonHolder[i]) continue;
				
				// make sure we dont start inside another ball
				if (button.hitTestObject(buttonHolder[i])){
					return false;
				}
				
				// make sure we dont start outside the container
				if (button.x > stage.width || button.x < 0)
				{
					return false;
				}
				else if (button.y > stage.height || button.y < 0)
				{
					return false;
				}
			}
			
			return true;
		}
		
		
	
	}
}
