package models
{	
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import models.Config;
	import models.valueObjects.Frame;
	
	import mx.collections.ArrayCollection;
	
	public class KnipseData extends EventDispatcher
	{
		private static var _instance:KnipseData;
		[Bindabel]
		public static function get i():KnipseData
		{
			if( _instance == null ) _instance = new KnipseData( new SingletonEnforcer() );
			return _instance;
		}
		public function KnipseData(pvt:SingletonEnforcer)
		{}
		
		public static var ADD_FRAME_COMPLETE:String = "addFrameComplete";
		public static var ADD_FRAME_ERROR:String = "addFrameError";
		public static var CREATE_SLIDESHOW_COMPLETE:String = "createSlideshowComplete";
		public static var CREATE_SLIDESHOW_ERROR:String = "createSlideshowError";
		public static var SORT_SLIDESHOW_COMPLETE:String = "sortSlidesComplete";
		public static var SORT_SLIDESHOW_ERROR:String = "sortSlidesError";
		
		private static var SERVICE_URL:String = 'http://localhost:3000';
		
		private var slideShowId:uint = 0;
		private var runningNumber:uint = 0;
		private var loader:URLLoader;
		
		[Bindable]
		public var frames:ArrayCollection = new ArrayCollection();
		
		public function addFrameToMemoryAndService(bitmapData:BitmapData):void {
			addFrameToMemory(bitmapData);
			addFrameToService(bitmapData);
		}
		
		public function addFrameToMemory(bitmapData:BitmapData):void {
			var frame:Frame = new Frame();
			frame.bitmapData = bitmapData;
			frame.duration = Config.i.defaultDuration;
			frame.id = runningNumber;
			frames.addItem(frame);
			runningNumber++;
		}
		
		private function addFrameToService(bitmapData:BitmapData):void {
			if (slideShowId == 0) {
				trace('You should request a new slideshow first!');
				return;
			}
			
			var request:URLRequest = new URLRequest();
			request.url = SERVICE_URL + "/slideshows/" + slideShowId + "/slides.xml";
			request.contentType = "multipart/form-data; boundary=" + UploadPostHelper.getBoundary();
			request.method = URLRequestMethod.POST;
			request.data = UploadPostHelper.getPostData('image' + runningNumber + '.jpg', new JPGEncoder(80).encode(bitmapData));
			
			loader = new URLLoader(request);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, addFrameCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, addFrameErrorHandler);
			loader.load(request);
		}
		
		private function addFrameCompleteHandler(e:Event):void {
			var result:XML = new XML(loader.data);
			frames[frames.length-1].id = result..id;
			dispatchEvent(new Event(ADD_FRAME_COMPLETE));
		}
		
		private function addFrameErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new Event(ADD_FRAME_ERROR));
		}
		
		public function sortSlides():void {
			if (slideShowId == 0) {
				trace('You should request a new slideshow first!');
				return;
			}
			
			var request:URLRequest = new URLRequest();
			request.url = SERVICE_URL + "/slideshows/sort";
			request.method = URLRequestMethod.POST;
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.id = slideShowId
				
			var slides:Array = new Array;
			
			for each(var s:Frame in frames){
				slides.push(s.id);
			}
			
			requestVars["slide[]"] = slides;
			request.data = requestVars
			
			
			var loader:URLLoader = new URLLoader(request);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, sortSlidesCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, sortSlidesErrorHandler);
			loader.load(request);
		}
		
		private function sortSlidesCompleteHandler(e:Event):void {
			dispatchEvent(new Event(SORT_SLIDESHOW_COMPLETE));
		}
		
		private function sortSlidesErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new Event(SORT_SLIDESHOW_ERROR));
		}
		
		
		public function createSlideshow(title:String = ''):void {			
			var request:URLRequest = new URLRequest();
			request.url = SERVICE_URL + "/slideshows.xml";
			request.method = URLRequestMethod.POST;
			request.data = new URLVariables('slideshow[title]=' + title);
			
			loader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, createSlideshowCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, createSlideshowErrorHandler);
			loader.load(request);
		}
		
		private function createSlideshowCompleteHandler(e:Event):void {
			dispatchEvent(new Event(CREATE_SLIDESHOW_COMPLETE));
			
			var result:XML = new XML(loader.data);
			
			// gets returned Slideshow ID 
			slideShowId = result..id;
			
			trace('slideshow created: ' + slideShowId);
		}
		
		private function createSlideshowErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new Event(CREATE_SLIDESHOW_ERROR));
		}
	}
}

internal class SingletonEnforcer{}