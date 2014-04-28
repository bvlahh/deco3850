﻿package  {
	
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
		
		
		public function main() {
			
			
			
			cam = Camera.getCamera("0");
			cam.setMode(640, 480, stage.frameRate);
			
			tracker = new FootTracker(cam, 640, 480);
			
			vid = new Video(640, 480);
			vid.attachCamera(cam);
			this.addChild(vid);
			
			circle = new Shape();
			this.addChild(circle);
			
			this.addChild(buttonStart);
			buttonStart.x = 250;
			buttonStart.y = 200;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
			//buttonStart.addEventListener(MouseEvent.MOUSE_OVER, startClick);
			
			startSize.addEventListener(TimerEvent.TIMER, timerListener);
			
		}
		
		private function onEnterFrameHandler(event : Event) : void {
			
			var point:Point;
			
			if (tracker != null)
				point = tracker.track();
				trace(point);
				
			if (buttonStart.hitTestPoint(point.x,point.y,true))
				startClick(event);
				
			if (buttonA.hitTestPoint(point.x,point.y,true))
				afClick(event);
				
			if (buttonB.hitTestPoint(point.x,point.y,true))
				afClick(event);
				
			if (buttonC.hitTestPoint(point.x,point.y,true))
				afClick(event);
				
			if (buttonD.hitTestPoint(point.x,point.y,true))
				afClick(event);
				
			if (buttonE.hitTestPoint(point.x,point.y,true))
				afClick(event);
				
			if (buttonF.hitTestPoint(point.x,point.y,true))
				afClick(event);
			
			circle.graphics.clear();
			circle.graphics.lineStyle(5, 0xFF0000);
			
			if (point != null)
				circle.graphics.drawCircle(point.x - 5, point.y - 5, 10);
			
		}
		
		public function startClick(event: Event){
			//removeChild(buttonStart);
			startSize.start();
			//buttonStart.removeEventListener(MouseEvent.MOUSE_OVER, startClick);
			
			this.addChild(buttonA);
			buttonA.x = 50;
			buttonA.y = 100;
			//buttonA.addEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			this.addChild(buttonB);
			buttonB.x = 300;
			buttonB.y = 50;
			//buttonB.addEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			this.addChild(buttonC);
			buttonC.x = 450;
			buttonC.y = 150;
			//buttonC.addEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			this.addChild(buttonD);
			buttonD.x = 100;
			buttonD.y = 250;
			//buttonD.addEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			this.addChild(buttonE);
			buttonE.x = 350;
			buttonE.y = 300;
			//buttonE.addEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			this.addChild(buttonF);
			buttonF.x = 500;
			buttonF.y = 300;
			//buttonF.addEventListener(MouseEvent.MOUSE_OVER, afClick);
		}
		
		function timerListener (e:TimerEvent):void{
				buttonStart.scaleX = i;
				buttonStart.scaleY = i;
				i -= .10;
				trace(i);
		}
		
		public function afClick(event: Event){
			removeChild(buttonA);
			//buttonA.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			removeChild(buttonB);
			//buttonB.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			removeChild(buttonC);
			//buttonC.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			removeChild(buttonD);
			//buttonD.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			removeChild(buttonE);
			//buttonE.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			removeChild(buttonF);
			//buttonF.removeEventListener(MouseEvent.MOUSE_OVER, afClick);
			
			
			trace(event.target);
			switch(event.target)
     		{
         	case buttonA:
            	this.addChild(buttonA);
				buttonA.x = 100;
				buttonA.y = 100;
         	break;
   
          	case buttonB:
            	this.addChild(buttonB);
				buttonB.x = 100;
				buttonB.y = 100;
          	break;

          	case buttonC:
            	this.addChild(buttonC);
				buttonC.x = 100;
				buttonC.y = 100;
          	break;

          	case buttonD:
            	this.addChild(buttonD);
				buttonD.x = 100;
				buttonD.y = 100;
          	break;
			
			case buttonE:
            	this.addChild(buttonE);
				buttonE.x = 100;
				buttonE.y = 100;
          	break;
			
			case buttonF:
            	this.addChild(buttonF);
				buttonF.x = 100;
				buttonF.y = 100;
          	break;
     		}
			
			this.addChild(displayBox);
			displayBox.x = 350;
			displayBox.y = 200;
			
		}
	}
}
