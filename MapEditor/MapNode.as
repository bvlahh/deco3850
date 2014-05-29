package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	public class MapNode extends MovieClip{
		
		var node:Point;

		public function MapNode(){
		}
		
		public function getNode() : Point {
			return node;
		}

	}
	
}
