package  {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.display.Stage;
	
	public class CalibrationPattern extends MovieClip {
		
		var circleDia : uint = 50;
		var redDot : Shape = new Shape();
		
		var coords : Array = new Array();
		
		public function CalibrationPattern(stage:Stage) {
			
			coords.push( new Point(0, 0) );
			coords.push( new Point(stage.stageWidth, 0) );
			coords.push( new Point(0, stage.stageHeight) );
			coords.push( new Point(stage.stageWidth, stage.stageHeight) );
			
			coords.push( new Point(-circleDia, -circleDia) );
			
			redDot.graphics.clear();
			redDot.graphics.beginFill(0xFF0000);
			redDot.graphics.drawCircle(coords[0].x, coords[0].y, circleDia);
			stateOff();
			
			this.addChild(redDot);
			
		}
		
		public function state0() : void {
			
			redDot.x = coords[0].x;
			redDot.y = coords[0].y;
			
		}
		
		public function state1() : void {
			
			redDot.x = coords[1].x;
			redDot.y = coords[1].y;
			
		}
		
		public function state2() : void {
			
			redDot.x = coords[2].x;
			redDot.y = coords[2].y;
			
		}
		
		public function state3() : void {
			
			redDot.x = coords[3].x;
			redDot.y = coords[3].y;
			
		}
		
		public function stateOff() : void {
			
			redDot.x = coords[4].x;
			redDot.y = coords[4].y;
			
		}
		
	}
	
}
