package  {
	
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.FrameLabel;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.display.Shader;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	public class FootTracker {
		
		private var camW : uint;
		private var camH : uint;
		
		private var cam:Camera;
		private var vid:Video;
		
		private var vid_past:BitmapData;
		private var vid_current:BitmapData;
		private var vid_delta:BitmapData;
		
		var oldHingeRow:int;
		var oldHingeCol:int;
		
		public function FootTracker(camera:Camera, cameraWidth:uint, cameraHeight:uint) {
			
			camW = cameraWidth;
			camH = cameraHeight;
			
			cam = camera;
			vid = new Video(camW, camH);
			vid.attachCamera(camera);
			
			vid_past = new BitmapData(camW, camH);
			vid_current = new BitmapData(camW, camH);
			vid_delta = new BitmapData(camW, camH);
			
		}
		
		public function track() : Point {
			
			var threshold:uint = 0xFF333333;
			
			var fg:uint = 0xFFFFFFFF;
			var bg:uint = 0xFF000000;
			
			var checkDistance:uint = 5;
			
			if ( !cam.muted ) {
				
				vid_current.draw(vid);
				
				vid_delta.draw(vid);
				vid_delta.draw(vid_past, null, null, BlendMode.DIFFERENCE);
				vid_delta.threshold(vid_delta, vid_delta.rect, new Point(), '>', threshold, fg);
				vid_delta.threshold(vid_delta, vid_delta.rect, new Point(), '<', threshold, bg);
				
				vid_past.draw(vid_current);
				
				/// track it on the delta
				
				var hingeRow:int = camH-1;
				var hingeCol:int = -1;
				var hinge:Point = new Point();
				//var oldPoint:Point = new Point(hingeCol, hingeRow);
				
				var vect = vid_delta.getVector(vid_delta.rect);
				
				while ( (hingeRow >= checkDistance) && ((hingeCol=checkCollision(vect, camW, camH, hingeRow, checkDistance)) == -1))
					hingeRow--;
				
				if (hingeCol != -1){
					oldHingeCol = hingeCol;
					oldHingeRow = hingeRow;
					return new Point(hingeCol, hingeRow);
				} else{ 
					return new Point(oldHingeCol, oldHingeRow);
					//return null;
				}
			} else {
				
				return null;
				
			}
			
		}
		
		private function checkCollision(image:Vector.<uint>, imageWidth:uint, imageHeight:uint, row:uint, checkDistance:uint) : int {
			
			for (var col:uint = checkDistance; col < imageWidth - checkDistance; col++) {
				
				var matches:uint = 0;
				
				for (var c:uint = 0; c <= checkDistance; c++) {
					
					if ( image[( (row - c) * imageWidth) + col] != 0xFF000000 )
						matches++;
					
					if ( image[( (row - c) * imageWidth) + (col - c)] != 0xFF000000 )
						matches++;
					
					if ( image[( (row - c) * imageWidth) + (col  + c)] != 0xFF000000 )
						matches++;
					
				}
				
				if (matches >= 3.0 * checkDistance)
					return col;
				
			}
			
			return -1;
			
		}
		
	}
	
}
