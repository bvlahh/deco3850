﻿package  {
	
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.display.Graphics;
	
	public class FlooredDesign extends MovieClip {
		
		var thresh : Number = .15;
		var camNumber : uint = 2;
		
		var cameras : Array = new Array();
		
		var calibrateState : uint = 0;
		var calibrateTime : uint = 500;
		var calibrateWait : uint = 5000;
		var numCalibrates : uint = 20;
		
		var main : MovieClip;
		
		var calibrateMovie : MovieClip;
		
		public function FlooredDesign() {
			
			addEventListener(Event.ADDED_TO_STAGE, setup);
			
		}
		
		private function setup(e : Event) : void {
			
			removeEventListener(Event.ADDED_TO_STAGE, setup);
			
			calibrateMovie = new CalibrationPattern(stage);
			this.addChild(calibrateMovie);
			
			/*for (var cam : uint = 0; cam < Camera.names.length; cam++) {
				//Camera.getCamera( String(cam) ).setMode(640, 480, stage.frameRate, false);
				Camera.getCamera( String(cam) ).setMode(320, 240, stage.frameRate, false);
				cameras.push( new TrackingCamera( Camera.getCamera( String(cam) ) ) );
			}*/
			
			
			var useCameras : Array = new Array("1", "2");
			
			for (var camIndex in useCameras) {
				var cam : String = useCameras[camIndex];
				Camera.getCamera( cam ).setMode(320, 240, stage.frameRate, false);
				cameras.push( new TrackingCamera( Camera.getCamera( cam ) ) );
			}
			
			
			// this should probably be set on the event change to visible
			setTimeout(calibrate0, calibrateWait);
			
		}
		
		private function setTimeout(f:Function, t:uint) {
			
			function ft(te : TimerEvent) {
				f();
			}
			
			if (calibrateState < numCalibrates) {
				var myTimer:Timer = new Timer(t, 1);
				myTimer.addEventListener(TimerEvent.TIMER, ft);
				myTimer.start();
			} else {
				calibrateDone();
			}
			
		}
		
		private function calibrate0() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate3();
			
			calibrateMovie.state0();
			
			setTimeout(calibrate1, calibrateTime);
			calibrateState++;
			
		}
		
		private function calibrate1() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate0();
			
			calibrateMovie.state1();
			
			setTimeout(calibrate2, calibrateTime);
			calibrateState++;
			
		}
		
		private function calibrate2() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate1();
			
			calibrateMovie.state2();
			
			setTimeout(calibrate3, calibrateTime);
			calibrateState++;
			
		}
		
		private function calibrate3() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate2();
			
			calibrateMovie.state3();
			
			setTimeout(calibrate0, calibrateTime);
			calibrateState++;
			
		}
		
		private function calibrateDone() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrateDone();
			
			removeChild(calibrateMovie);
			
			/*{
				
				var cam : Camera = cameras["0"].cam;
				var vid : Video = new Video(cam.width, cam.height);
				vid.attachCamera(cam);
				var g : Shape = new Shape();
				g.graphics.clear();
				g.graphics.lineStyle(5, 0xFF0000);
				g.graphics.drawCircle(cameras["0"].A.x, cameras["0"].A.y, 5);
				g.graphics.drawCircle(cameras["0"].B.x, cameras["0"].B.y, 5);
				g.graphics.drawCircle(cameras["0"].C.x, cameras["0"].C.y, 5);
				g.graphics.drawCircle(cameras["0"].D.x, cameras["0"].D.y, 5);
				this.addChild(vid);
				this.addChild(g);
				
			}*/
			
			stage.addEventListener(MouseEvent.CLICK, testClicked);
			
		}
		
		var shapes : Array;
		
		private function drawColour(camera:String) : uint {
			
			if (camera == "0")
				return 0xFF0000;
			
			if (camera == "1")
				return 0x00FF00;
			
			if (camera == "2")
				return 0x0000FF;
			
			if (camera == "3")
				return 0xFF00FF;
			
			return 0x000000;
			
		}
		
		private function testClicked(me : MouseEvent) : void {
			
			stage.removeEventListener(MouseEvent.CLICK, testClicked);
			
			shapes = new Array();
			
			for (var camera in cameras) {
				shapes[camera] = new Shape();
				shapes[camera].graphics.clear();
				shapes[camera].graphics.lineStyle(5, drawColour(camera));
				shapes[camera].graphics.drawCircle(0, 0, 5);
				this.addChild(shapes[camera]);
			}
			
			stage.addEventListener(Event.ENTER_FRAME, trackDemo);
			
			stage.addEventListener(MouseEvent.CLICK, groupClicked);
			
		}
		
		private function trackDemo(e : Event) : void {
			
			for (var camera in cameras) {
				
				var trackPoint : Point = (TrackingCamera)(cameras[camera]).track();
				
				if (trackPoint != null) {
					shapes[camera].x = trackPoint.x * stage.stageWidth;
					shapes[camera].y = trackPoint.y * stage.stageHeight;
				} else {
					shapes[camera].x = -shapes[camera].width;
				}
				
			}
			
		}
		
		var groupShape : Shape;
		
		private function groupClicked(me : MouseEvent) : void {
			// do the grouping demo
			
			for (var shape in shapes) {
				shapes[shape].graphics.clear();
				removeChild(shapes[shape]);
			}
			
			groupShape = new Shape();
			
			groupShape.graphics.clear();
			groupShape.graphics.lineStyle(5, 0x00FF00);
			groupShape.graphics.drawCircle(0, 0, 5);
			
			addChild(groupShape);
			
			stage.removeEventListener(MouseEvent.CLICK, groupClicked);
			stage.addEventListener(Event.ENTER_FRAME, groupDemo);
			stage.addEventListener(MouseEvent.CLICK, runClicked);
			
		}
		
		private function groupDemo(e : Event) : void {
			
			var cameraPoints : Array = new Array();
			
			for (var camera in cameras) {
				
				var trackPoint : Point = (TrackingCamera)(cameras[camera]).track();
				
				cameraPoints.push( trackPoint );
				
			}
			
			var groups : Array = TrackingCamera.group_points(cameraPoints, thresh);
			
			var cam : Point = TrackingCamera.avg_points(cameraPoints);
			
			if (groups[0] >= camNumber) {
				groupShape.x = cam.x * stage.stageWidth;
				groupShape.y = cam.y * stage.stageHeight;
			}
			
		}
		
		private function runClicked(me : MouseEvent) : void {
			
			groupShape.graphics.clear();
			removeChild(groupShape);
			
			stage.removeEventListener(Event.ENTER_FRAME, groupDemo);
			
			stage.removeEventListener(MouseEvent.CLICK, runClicked);
			
			runMain();
			
		}
		
		public function runMain() {
			
			//main = new MovieClip(); // TEMPORARY - replace with UI main class
			main = new Interface();
			
			addChild(main);
			
			stage.addEventListener(Event.ENTER_FRAME, trackMain);
			
		}
		
		private function trackMain(e : Event) : void {
			
			var cameraPoints : Array = new Array();
			
			for (var camera in cameras) {
				
				var trackPoint : Point = (TrackingCamera)(cameras[camera]).track();
				
				cameraPoints.push( trackPoint );
				
			}
			
			var groups : Array = TrackingCamera.group_points(cameraPoints, thresh);
			
			var avgPoint : Point = TrackingCamera.avg_points(cameraPoints);
			
			if (groups[0] >= camNumber) {
				main.dispatchEvent( new PositionEvent( new Point(avgPoint.x * stage.stageWidth, avgPoint.y * stage.stageHeight) ) );
			}
			
		}
		
		
	}
	
}
