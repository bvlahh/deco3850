﻿package  {		import flash.display.MovieClip;	import flash.media.Camera;	import flash.media.Video;	import flash.events.Event;	import flash.display.Bitmap;	import flash.display.FrameLabel;	import flash.display.BitmapData;	import flash.display.BlendMode;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.display.Shader;	import flash.geom.Rectangle;	import flash.display.Shape;	import flash.geom.ColorTransform;		public class CameraVectors extends MovieClip {				private var camW : int = 640;		private var camH : int = 480;				private var cam1:Camera;		private var cam2:Camera;				private var vid1:Video;		private var vid2:Video;				private var vid1_past:BitmapData;		private var vid2_past:BitmapData;		private var vid1_current:BitmapData;		private var vid2_current:BitmapData;				private var vid1_delta:BitmapData;		private var vid2_delta:BitmapData;				private var display1:Bitmap;		private var display2:Bitmap;				public function CameraVectors() {						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);					}				public function onAddedToStage(event : Event) : void {						cam1 = Camera.getCamera("0");			cam2 = Camera.getCamera("1");						cam1.setMode(camW, camH, stage.frameRate);			cam2.setMode(camW, camH, stage.frameRate);						vid1 = new Video(camW, camH);			vid2 = new Video(camW, camH);						vid1.attachCamera(cam1);			vid2.attachCamera(cam2);						vid1_current = new BitmapData(camW, camH);			vid2_current = new BitmapData(camW, camH);						vid1_past = new BitmapData(camW, camH);			vid2_past = new BitmapData(camW, camH);						vid1_delta = new BitmapData(camW, camH);			vid2_delta = new BitmapData(camW, camH);			/*			display1 = new Bitmap(vid1_delta);			display2 = new Bitmap(vid2_delta);			*/			display1 = new Bitmap(vid1_current);			display2 = new Bitmap(vid2_current);						display2.x = display1.width;						this.addChild( display1 );			this.addChild( display2 );						addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);						rect1 = new Shape();			rect2 = new Shape();						rect1.x = display1.x;			rect1.y = display1.y;						rect2.x = display2.x;			rect2.y = display2.y;						this.addChild(rect1);			this.addChild(rect2);					}				private var rect1:Shape;		private var rect2:Shape;				private function onEnterFrameHandler(event : Event) : void {						var threshold:uint = 0xFF333333;						var fg:uint = 0xFFFFFFFF;			var bg:uint = 0xFF000000;						if ( !cam1.muted ) {								vid1_current.draw(vid1);				vid2_current.draw(vid2);								vid1_delta.draw(vid1);				vid1_delta.draw(vid1_past, null, null, BlendMode.DIFFERENCE);				vid1_delta.threshold(vid1_delta, vid1_delta.rect, new Point(), '>', threshold, fg);				vid1_delta.threshold(vid1_delta, vid1_delta.rect, new Point(), '<', threshold, bg);								vid2_delta.draw(vid2);				vid2_delta.draw(vid2_past, null, null, BlendMode.DIFFERENCE);				vid2_delta.threshold(vid2_delta, vid2_delta.rect, new Point(), '>', threshold, fg);				vid2_delta.threshold(vid2_delta, vid2_delta.rect, new Point(), '<', threshold, bg);								var r1:Point = track(vid1_delta);				var r2:Point = track(vid2_delta);								rect1.graphics.clear();				rect1.graphics.lineStyle(5, 0xFF0000);								if (r1 != null)					rect1.graphics.drawCircle(r1.x - 5, r1.y - 5, 10);								rect2.graphics.clear();				rect2.graphics.lineStyle(5, 0xFF0000);								if (r2 != null)					rect2.graphics.drawCircle(r2.x - 5, r2.y - 5, 10);								vid1_past.draw(vid1_current);				vid2_past.draw(vid2_current);							}					}				private function checkCollision(image:Vector.<uint>, imageWidth:uint, imageHeight:uint, row:uint, checkDistance:uint) : int {						for (var col:uint = checkDistance; col < imageWidth - checkDistance; col++) {								var matches:uint = 0;								for (var c:uint = 0; c <= checkDistance; c++) {										if ( image[( (row - c) * imageWidth) + col] != 0xFF000000 )						matches++;										if ( image[( (row - c) * imageWidth) + (col - c)] != 0xFF000000 )						matches++;										if ( image[( (row - c) * imageWidth) + (col  + c)] != 0xFF000000 )						matches++;									}								if (matches >= 3.0 * checkDistance)					return col;							}						return -1;					}				private function track(image : BitmapData) : Point {						// coords are:			// (y * ROWSIZE) + x						var hinge:Point;						var imgWidth:int;			var imgHeight:int;						imgWidth = image.width;			imgHeight = image.height;						hinge = new Point();						var vect = image.getVector(image.rect);						var hingeRow:int = imgHeight-1;			var hingeCol:int = -1;						var checkDistance:uint = 5;						while ( (hingeRow >= checkDistance) && ((hingeCol=checkCollision(vect, imgWidth, imgHeight, hingeRow, checkDistance)) == -1))				hingeRow--;						if (hingeCol != -1)				return new Point(hingeCol, hingeRow);			else				return null;					}			}}