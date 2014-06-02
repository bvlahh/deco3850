package  {
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PositionEvent extends Event {
		
		static var POSITIONEVENT : String = "PositionEvent";
		
		var point : Point;
		
		public function PositionEvent(point:Point) {
			
			super(POSITIONEVENT);
			
			this.point = point;
			
		}

	}
	
}
