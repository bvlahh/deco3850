﻿package  {		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filesystem.File;	import flash.filesystem.FileMode;	import flash.filesystem.FileStream;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.utils.Dictionary;	import flash.profiler.Telemetry;	import flash.utils.ByteArray;	//import mx.utils.Base64Encoder;	//import com.hurlant.util.Base64.*;		public class MapEditor extends MovieClip {				private var backgroundPicture:String;		private var mapPoints:Array;		private var mapLinks:Array;				public function MapEditor() {						//DictionaryJSON.fixJSON();						backgroundPicture = "";			mapPoints = new Array();			mapLinks = new Array();						fileName.text = "No File Loaded";						openButton.addEventListener(MouseEvent.CLICK, openFile);			saveButton.addEventListener(MouseEvent.CLICK, saveFile);						editorFrame.addEventListener(MouseEvent.DOUBLE_CLICK, addNode);			editorFrame.addEventListener(MouseEvent.RIGHT_CLICK, pickBackground);					}				private function openFile(e:Event) {						var map:Object;						var inFile : File = new File();						inFile.browseForOpen("Open File");						inFile.addEventListener(Event.SELECT, function(e:Event) : void{								fileName.text = inFile.nativePath;				//fileName.text = inFile.name;								var fs:FileStream = new FileStream();				fs.open(inFile, FileMode.READ);								try {										map = JSON.parse( fs.readUTFBytes(fs.bytesAvailable) );										backgroundPicture = Base64.decode(map[0]);										mapPoints = map[1];										mapLinks = map[2];									} catch (e:SyntaxError) {										map = null;					fileName.text = "Could Not Load " + inFile.name;									}								fs.close();								loadMap(map);							});					}				private function saveFile(e:Event) {						var outArr : Array = new Array();						outArr[0] = Base64.encode(backgroundPicture).toString();			outArr[1] = mapPoints;			outArr[2] = mapLinks;						var outFile : File = new File();						outFile.browseForSave("Save File");						outFile.addEventListener(Event.SELECT, function(e:Event) : void{										fileName.text = outFile.nativePath;										var fs:FileStream = new FileStream();					fs.open(outFile, FileMode.WRITE);										fs.writeUTFBytes( JSON.stringify(outArr) );										fs.close();									});					}				private function loadMap(map:Object) {					}				private function addNode(e:Event) {						trace("ADD NODE");											}				private function pickBackground(e:Event) {						var backgroundPicture : File = new File();						backgroundPicture.browseForOpen("Select Background File");						backgroundPicture.addEventListener(Event.SELECT, function(e:Event) : void{								var fs:FileStream = new FileStream();				fs.open(backgroundPicture, FileMode.READ);								//fs.readUTFBytes(fs.bytesAvailable)				//fs.readMultiByte(fs.bytesAvailable, 								fs.close();							});					}							}	}