﻿package  {
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.display.Graphics;
	
				//Camera.getCamera( String(cam) ).setMode(640, 480, stage.frameRate, false);
				Camera.getCamera( String(cam) ).setMode(320, 240, stage.frameRate, false);
				cameras.push( new TrackingCamera( Camera.getCamera( String(cam) ) ) );
			}
			
			
			for (var camera in cameras)
				cameras[camera].calibrate3();
			
			for (var camera in cameras)
				cameras[camera].calibrate0();
			
			for (var camera in cameras)
				cameras[camera].calibrate1();
			
			for (var camera in cameras)
				cameras[camera].calibrate2();
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
			
		}
			stage.removeEventListener(Event.ENTER_FRAME, trackDemo);
			
				removeChild( getChildAt(i) );