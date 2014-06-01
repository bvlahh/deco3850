package  {		import flash.display.MovieClip;	import flash.media.Camera;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.utils.Timer;	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.display.Graphics;
		public class FlooredDesign extends MovieClip {				var cameras : Array = new Array();				var calibrateState : uint = 0;		var calibrateTime : uint = 500;		var calibrateWait : uint = 5000;		var numCalibrates : uint = 40;				var main : MovieClip;				var calibrateMovie : MovieClip;				public function FlooredDesign() {						main = new MovieClip(); // TEMPORARY - replace with UI main class						calibrateMovie = new CalibrationPattern(stage);			this.addChild(calibrateMovie);						for (var cam : uint = 0; cam < Camera.names.length; cam++) {
				//Camera.getCamera( String(cam) ).setMode(640, 480, stage.frameRate, false);
				Camera.getCamera( String(cam) ).setMode(320, 240, stage.frameRate, false);
				cameras.push( new TrackingCamera( Camera.getCamera( String(cam) ) ) );
			}
						// this should probably be set on the event change to visible			setTimeout(calibrate0, calibrateWait);					}				private function setTimeout(f:Function, t:uint) {						function ft(te : TimerEvent) {				f();			}						if (calibrateState < numCalibrates) {				var myTimer:Timer = new Timer(t, 1);				myTimer.addEventListener(TimerEvent.TIMER, ft);				myTimer.start();			} else {				calibrateDone();			}					}				private function calibrate0() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate3();						calibrateMovie.state0();						setTimeout(calibrate1, calibrateTime);			calibrateState++;					}				private function calibrate1() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate0();						calibrateMovie.state1();						setTimeout(calibrate2, calibrateTime);			calibrateState++;					}				private function calibrate2() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate1();						calibrateMovie.state2();						setTimeout(calibrate3, calibrateTime);			calibrateState++;					}				private function calibrate3() : void {
			
			for (var camera in cameras)
				cameras[camera].calibrate2();						calibrateMovie.state3();						setTimeout(calibrate0, calibrateTime);			calibrateState++;					}				private function calibrateDone() : void {						for (var camera in cameras)				cameras[camera].calibrateDone();						removeChild(calibrateMovie);			
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
						stage.addEventListener(MouseEvent.CLICK, testClicked);					}
		
		var shapes : Array;
		
		private function drawColour(camera:String) : uint {
			
			if (camera == "0")
				return 0xFF0000;
			
			if (camera == "1")
				return 0x00FF00;
			
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
			
			stage.addEventListener(MouseEvent.CLICK, runClicked);
			
		}
		
		private function trackDemo(e : Event) : void {
			
			for (var camera in cameras) {
				var trackPoint : Point = (TrackingCamera)(cameras[camera]).track();
				shapes[camera].x = trackPoint.x * stage.stageWidth;
				shapes[camera].y = trackPoint.y * stage.stageHeight;
			}
			
		}				private function runClicked(me : MouseEvent) : void {			
			stage.removeEventListener(Event.ENTER_FRAME, trackDemo);
						stage.removeEventListener(MouseEvent.CLICK, runClicked);						runMain();					}						public function runMain() {						// remove all current children			for (var i:uint = 0; i < numChildren; i++)
				removeChild( getChildAt(i) );						addChild(main);					}					}	}