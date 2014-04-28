package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.Event;
	import flash.display.Bitmap;
	import FootTracker;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class main extends MovieClip {
		
		
		var buttonStart:MovieClip = new ButtonStart();
		var buttonBack:MovieClip = new ButtonBack();
		var buttonA:MovieClip = new ButtonA();
		var buttonB:MovieClip = new ButtonB();
		var buttonC:MovieClip = new ButtonC();
		var buttonD:MovieClip = new ButtonD();
		var buttonE:MovieClip = new ButtonE();
		var buttonF:MovieClip = new ButtonF();
		var displayBox:MovieClip = new DisplayBox();
		
		//var stepTimer:Timer = new Timer(1000);
		var startSize:Timer = new Timer(20, 11);
		var i:Number = 1;
		
		var cam:Camera;
		var tracker:FootTracker;
		
		var vid:Video;
		var circle:Shape;
		
		public static var buttonHolder:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		public function main() {
			
			cam = Camera.getCamera("0");
			cam.setMode(640, 480, stage.frameRate);
			
			tracker = new FootTracker(cam, 640, 480);
			
			vid = new Video(640, 480);
			vid.attachCamera(cam);
			//this.addChild(vid);
			
			circle = new Shape();
			this.addChild(circle);
			
			this.addChild(buttonStart);
			buttonStart.x = 250;
			buttonStart.y = 200;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			startSize.addEventListener(TimerEvent.TIMER, timerListener);
			
		}
		
		private function onEnterFrameHandler(event : Event) : void {
			
			var point:Point;
			
			if (tracker != null){
				point = tracker.track();
			}
			
			if (point == null){
				return
			}
			
			point.y = (point.y * 2.6) - 140;
			
			if (buttonStart.hitTestPoint(point.x,point.y,true)){
				startSize.start();
				removeChild(buttonStart);
				startClick(event);
			}
				
			for each(var a:MovieClip in main.buttonHolder){
				if (a.hitTestPoint(point.x,point.y,true)){
					beGoneButtons(event);
					trace("a: " + a);
					this.addChild(a);
					a.x = 100;
					a.y = 100;
					
					this.addChild(displayBox);
					displayBox.x = 350;
					displayBox.y = 200;
					
					this.addChild(buttonBack);
					buttonBack.x = 100;
					buttonBack.y = 350;
				}
			}
			
			if (buttonBack.hitTestPoint(point.x,point.y,true)){
				trace("HEELOO");
				trace("a: " + a);
				removeChild(displayBox);
				removeChild(buttonBack);
				startClick(event);
			}
			
			circle.graphics.clear();
			circle.graphics.lineStyle(5, 0xFF0000);
			
			if (point != null){
				circle.graphics.drawCircle(point.x - 5, point.y - 5, 10);
			}
		}
		
		public function startClick(event: Event){
			
			
			this.addChild(buttonA);
			buttonHolder.push(buttonA);
			buttonA.x = 50;
			buttonA.y = 100;
			
			this.addChild(buttonB);
			buttonHolder.push(buttonB);
			buttonB.x = 300;
			buttonB.y = 50;
			
			this.addChild(buttonC);
			buttonHolder.push(buttonC);
			buttonC.x = 450;
			buttonC.y = 150;
			
			this.addChild(buttonD);
			buttonHolder.push(buttonD);
			buttonD.x = 100;
			buttonD.y = 250;
			
			this.addChild(buttonE);
			buttonHolder.push(buttonE);
			buttonE.x = 350;
			buttonE.y = 300;
			
			this.addChild(buttonF);
			buttonHolder.push(buttonF);
			buttonF.x = 500;
			buttonF.y = 300;
		}
		
		function timerListener (e:TimerEvent):void{
				buttonStart.scaleX = i;
				buttonStart.scaleY = i;
				i -= .10;
		}
		
		public function beGoneButtons(event: Event){
			removeChild(buttonA);
			removeChild(buttonB);
			removeChild(buttonC);
			removeChild(buttonD);
			removeChild(buttonE);
			removeChild(buttonF);
			
			
		}
	}
}
