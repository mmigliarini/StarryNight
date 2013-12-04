package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;			// TextField Library
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	
	
	public class Preloader extends MovieClip
	{

		//- PUBLIC VARIABLES ----------------------------------------------------------------------------	
		public var snPreloaderText:TextField = new StarryNightTextField();
		public var snBgImg:String = new String();
		public var snFileLoader:Loader = new Loader();
		public var snURLRequest:URLRequest = new URLRequest();


		//- CONSTRUCTOR ---------------------------------------------------------------------------------

		/**
		 *	Function TODO: Create an instance of Preloader with the given parameter.
		 *
		 *  @param: $myTextField - TextField: Background thumb url.
		 *  @return: void
		 */
		function Preloader(myTextField:TextField)
		{
			// initialize preloader textfield
			this.snPreloaderText = myTextField;
		}



		//- PUBLIC & PRIVATE METHODS --------------------------------------------------------------------
	
		/**
		 *	Function TODO: Star initial loading: Load SWF and Default Background Image (method called by StarryNight class)
		 *
		 *  @param: $myBgImg - String: Default Background Url
		 *  @return: void
		 */
		public function start(myBgImg:String):void
		{
			// initialize preloader bg_img
			this.snBgImg = myBgImg;
			
			// load StarryNight.swf, on complete load Image
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, onSwfComplete);
			
			// Event Listener for Image loading completed
			this.addEventListener("loadingImgCompleted", PreloaderComplete);
		}


		/**
		 *	Function TODO: Preloader Completed (swf and image loaded). Dispatch new Event for StarryNight class. 
		 *
		 *  @param: $e - Event.
		 *  @return: void
		 */
		private function PreloaderComplete(e:Event):void
		{
			this.removeEventListener("loadingImgCompleted", PreloaderComplete);
			dispatchEvent(new Event("preloaderCompleted"));
			trace("Loading completed.");
		}



		/**
		 *	Function TODO: Load given background image (used to load background image on user change - thumbClicked). 
		 *
		 *  @param: $myBgImg - String: Background image url to be loaded.
		 *  @return: void
		 */
		public function loadBgImg(myBgImg:String = ""){

			// if give url is "" - set it to inital value (as constructor)
			if (myBgImg=="") myBgImg = this.snBgImg;
	
			// load image
			snURLRequest.url = myBgImg;
			snFileLoader.load(snURLRequest);
			
			// event listener on loading image
			snFileLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onImgProgress);
			snFileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgComplete);
		 
		}



		//- EVENTS METHODS ------------------------------------------------------------------------------


		/**
		 *	Function TODO: Show % of loaded swf.
		 *
		 *  @param: $e - Event: swf loading.
		 *  @return: void
		 */		
		private function onSwfProgress(e:ProgressEvent):void
		{
			// calculate %info
			var loadedBytes:int = Math.round(e.target.bytesLoaded  / 1024);
			var totalBytes:int = Math.round(e.target.bytesTotal / 1024);
			var percent:int = (e.target.bytesLoaded / e.target.bytesTotal) * 100;
			
			// show %infos
			snPreloaderText.text = String("Loading " + e.target.url.match(/(?:\\|\/)([^\\\/]*)$/)[1] + ":" + percent + "%");
		}


		/**
		 *	Function TODO: SWF Loading Completed - Proced loading background image (call loadBgImg()).
		 *
		 *  @param: $e - Event: swf loading.
		 *  @return: void 
		 */	
		private function onSwfComplete(e:Event):void
		{
			// remove listener
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			this.loaderInfo.removeEventListener(Event.COMPLETE, onSwfComplete);
			
			// proced loading background image
			loadBgImg();
		}
		
		

		/**
		 *	Function TODO: Show % of loaded image.
		 *
		 *  @param: $e - Event: img loading.
		 *  @return: void
		 */
		private function onImgProgress(e:ProgressEvent):void
		{
			// calculate %info
			var loadedBytes:int = Math.round(e.target.bytesLoaded  / 1024);
			var totalBytes:int = Math.round(e.target.bytesTotal / 1024);
			var percent:int = (e.target.bytesLoaded / e.target.bytesTotal) * 100;
			
			// show %infos
			snPreloaderText.text = String("Loading " + fileName + ": " + percent + "%");

		}



		/**
		 *	Function TODO: Image Loading Completed. Dispatch new Event "loadingImgCompleted".
		 *
		 *  @param: $e - Event: swf loading.
		 *  @return: void 
		 */	
		private function onImgComplete(e:Event):void
		{
			// remove listener
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onImgProgress);
			this.loaderInfo.removeEventListener(Event.COMPLETE, onImgComplete);
			
			// dispatch new event
			dispatchEvent(new Event("loadingImgCompleted"));
			trace("Loading " + fileName + " completed.");
		}
		
		
		
		//- GETTER METHODS ------------------------------------------------------------------------------
    	public function get fileName():String { return snURLRequest.url.match(/(?:\\|\/)([^\\\/]*)$/)[1];} 
		
		
	}
}