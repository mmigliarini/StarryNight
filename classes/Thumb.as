package classes {
 
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	
 	import caurina.transitions.Tweener;			// import Caurina Tween external library
 
	public class Thumb extends MovieClip
	{
 
		//- PUBLIC VARIABLES ----------------------------------------------------------------------------		
		
		// Background data (url, thumb url, description)
 		public var bgThumb:String = new String();
		public var bgTitle:String = new String();
		public var bgSrc:String = new String();
 
 		// Thumb data and box
 		public var thumbBg:Sprite = new Sprite();
		public var thumbImg:Loader = new Loader();
		public var thumbUrlRequest:URLRequest = new URLRequest();
		public var thumbText:TextField = new StarryNightTextField();
		public var thumbLoadingText:TextField = new StarryNightTextField();
		public var thumbBox:MovieClip = new MovieClip();
		public var thumbWhiteBox:Sprite = new Sprite();
		public var thumbOn:Boolean = false;

		//- CONSTANT VARIABLES --------------------------------------------------------------------------
		
		// Thumb alphas and height
		const THUMB_FADE_OUT:Number = 0.2;
		const THUMB_FADE_IN:Number = 1;
		const THUMB_HEIGHT_OUT:Number = 84;
		const THUMB_HEIGHT_IN:Number = 104;		



		//- CONSTRUCTOR ---------------------------------------------------------------------------------

		/**
		 *	Function TODO: Create an instance of Thumb with the given parameters.
		 *
		 *  @param: $myThumb - String: Background thumb url.
		 *  @param: $myText - String: Background description.
		 *  @param: $mySrc - String: Background image url.		
		 *  @param: $myThumbOn - Boolean: true: thumb is checked and highlighted. false: thumb is not checked and unhighlighted
		 *  @return: void
		 */
		function Thumb(myThumb:String, myText:String="", mySrc:String="", myThumbOn:Boolean=false):void
		{
			
			// initalize thumb var
			bgThumb = myThumb;
			bgTitle = myText;
			bgSrc   = mySrc;
			thumbOn = myThumbOn;
			
			
			// create with box, border of thumb image
			thumbWhiteBox.graphics.beginFill(0xFFFFFF);
			thumbWhiteBox.graphics.drawRect( 0, 0, 110, 84);
			thumbWhiteBox.alpha = THUMB_FADE_OUT;
			
			
			// set description format, position, and text value
			thumbText.alpha = 0;
			thumbText.text = bgTitle;
			thumbText.textColor = 0x000000;
			thumbText.x = 3;
			thumbText.y = THUMB_HEIGHT_OUT + (THUMB_HEIGHT_IN-THUMB_HEIGHT_OUT-thumbText.height)/2 ;
							
			
			// load thumb image
			thumbUrlRequest.url = bgThumb;
			thumbImg.load(thumbUrlRequest);
			
			// loading text position		
			thumbLoadingText.x = (thumbWhiteBox.width-thumbLoadingText.width)/2;
			thumbLoadingText.y = (thumbWhiteBox.height-thumbLoadingText.height)/2-8;
			
			// add white box, loading text, thumb description text
			thumbBox.addChild(thumbWhiteBox);
			thumbBox.addChild(thumbLoadingText);
			thumbBox.addChild(thumbText);
			
			// Loader Event Listener. on Complete: onThumbComplete();
			thumbImg.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onThumbProgress);
			thumbImg.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbComplete);

			
			// positioning image on white box (border: 3px)
			thumbImg.x = thumbImg.y = 3;

			// enable button mode
			thumbBox.buttonMode = true;

			// Thumb Box Event Listener for Mouse Behaviours
			thumbBox.addEventListener(MouseEvent.CLICK, onThumbClick);
			thumbBox.addEventListener(MouseEvent.MOUSE_OVER, onThumbOver);
			thumbBox.addEventListener(MouseEvent.MOUSE_OUT, onThumbOut);		
			
			// add Thumb Box
			addChild(thumbBox);
			
		}
		




		//- PUBLIC & PRIVATE METHODS --------------------------------------------------------------------


		/**
		 *	Function TODO: Check and Call Highlight.
		 *
		 *  @param: void
		 *  @return: void 
		 */			
		public function checkThumb():void
		{
			thumbOn = true;		// check
			highlightThumb();	// highlight
		}



		/**
		 *	Function TODO: Uncheck and Call Unhighlight.
		 *
		 *  @param: void
		 *  @return: void 
		 */
		public function uncheckThumb():void
		{
			thumbOn = false;	// uncheck
			unhighlightThumb();	// unhighlight
		}



		/**
		 *	Function TODO: Highlight Thumb
		 *
		 *  @param: void
		 *  @return: void
		 */	
		private function highlightThumb():void
		{
			// Tweener alpha in
			Tweener.addTween(this.thumbWhiteBox, { alpha: THUMB_FADE_IN, time: 1} );
			
			// Height: THUMB_HEIGHT_IN
			this.thumbWhiteBox.height = THUMB_HEIGHT_IN;
			
			// show text under thumb
			thumbText.alpha = 1;	
		}



		/**
		 *	Function TODO: Unhighlight Thumb
		 *
		 *  @param: void
		 *  @return: void
		 */			
		private function unhighlightThumb():void
		{
			if(!thumbOn){
				// Tweener alpha out
				Tweener.addTween(this.thumbWhiteBox, { alpha: THUMB_FADE_OUT, time: 1} );
				
				// Height: THUMB_HEIGHT_IN
				this.thumbWhiteBox.height = THUMB_HEIGHT_OUT;
				
				// hide text under thumb
				thumbText.alpha = 0;
			}
		}
		
		
		

		//- EVENTS METHODS ------------------------------------------------------------------------------

		
		/**
		 *	Function TODO: Show % of loaded thumb image.
		 *
		 *  @param: $e - Event: thumbImg loading.
		 *  @return: void
		 */		
		private function onThumbProgress(e:ProgressEvent):void
		{
			// calculate %info
			var loadedBytes:int = Math.round(e.target.bytesLoaded  / 1024);
			var totalBytes:int = Math.round(e.target.bytesTotal / 1024);
			var percent:int = (e.target.bytesLoaded / e.target.bytesTotal) * 100;
			
			// show %infos
			this.thumbLoadingText.text = String(percent + "%");			
		}


		/**
		 *	Function TODO: Show image on Loading Complete.
		 *
		 *  @param: $e - Event: thumbImg loading.
		 *  @return: void 
		 */		
		private function onThumbComplete(e:Event):void
		{
			// remove listener
			thumbImg.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onThumbComplete);
			thumbImg.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbComplete);
			
			// remove loading info text
			thumbBox.removeChild(thumbLoadingText);
			
			// add thumb image. Tweener alpha in
			thumbBox.addChild(thumbImg);
			Tweener.addTween(this.thumbImg, { alpha: 1, time: 1} );

			// check Thumb if it's joined to the current background image
			if(thumbOn)	checkThumb();

			
			
		}
		
		
		
		/**
		 *	Function TODO: Dispatch new event for Control Panel class, on ThumbClick.
		 *
		 *  @param: $e - Event: Thumb Box cliecked.
		 *  @return: void 
		 */				
		private function onThumbClick(e:MouseEvent):void
		{
			// dispath event "thumbClicked"
			dispatchEvent(new Event("thumbClicked"));
			trace("thumbClicked");
		}
		
		
		/**
		 *	Function TODO: Highlight thumb on Mouse Over, setting a higher alpha value.
		 *
		 *  @param: $e - Event: Thumb Box Mouse Overed.
		 *  @return: void 
		 */		
		 private function onThumbOver(e:MouseEvent):void
		{
			// hightlight thumb
			this.highlightThumb();
		}
		
		
		/**
		 *	Function TODO: Unhighlight thumb on Mouse Out, setting a lower alpha value.
		 *
		 *  @param: $e - Event: Thumb Box Mouse Outed.
		 *  @return: void 
		 */	
		private function onThumbOut(e:MouseEvent):void
		{
			// unhighlight thumb
			this.unhighlightThumb();		
		}
		
		

		
		
	}

}