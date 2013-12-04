package classes {
 

  	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.*;				// Filters library (shadow and blur)



	public class Star extends StarryNightStar
	{
 
  		//- PUBLIC & PRIVATE VARIABLES -------------------------------------------------------------------------	
		
		// Shadow for highest brightness level
		public var dropShadow:DropShadowFilter = new DropShadowFilter();
		
 		// Star's Parameters
  		private var _scale:Number;
  		private var _alpha:Number;
		private var _speed:Number;
		private var _twinkle:Number;

		// Max and Min alpha value
		private var _alphaMax:Number;
		private var _alphaMin:Number
 
 
 
 		//- CONSTRUCTOR --------------------------------------------------------------------------------

		/**
		 *	Function TODO: Create an instance of Star with the given parameters.
		 *
		 *  @param: $dimension - Number: default value = 1.
		 *  @param: $brightness - Number: default value = 1.
		 *  @param: $twinkle - Number: default value = 0.15.		
		 *  @param: $speed - Number: default value = 0.	
		 *  @return: void
		 */
		function Star(dimension:Number = 1, brightness:Number = 1, twinkle:Number = 0.15, speed:Number = 0):void
		{
			
			// generating initial value
			this._scale = ((Math.random() * 1));
			this._alpha = Math.min(Math.random() + 0.30, 1);
			
			// SETTING INITIAL VALUE:	

			// 1. Scale
			setScale(dimension);

			// 2. Alpha
			setAlpha(brightness);

			// 3. Twinkle
			setTwinkle(twinkle);

			// 4. Speed
			setSpeed(speed);

			// 5. Rotation
			this.rotation = Math.random()*360;

			// 6. Position
			this.addEventListener(Event.ADDED_TO_STAGE, setPosition)
			
			// add Event: do Twinkle and Movement
			this.addEventListener(Event.ENTER_FRAME, doTwinkleAndMovement);
			
		}



		/**
		 *	Function TODO: Set scaleX and scaleY. 
		 *
		 *  @param: $dimension - Number: scale factor.
		 *  @return: void
		 */
		public function setScale(dimension:Number = 1):void
		{
			this.scaleX = this._scale * dimension;
			this.scaleY = this.scaleX;
		}


		/**
		 *	Function TODO: Set alpha and brightness shadow
		 *
		 *  @param: $brightness - Numnber: alpha factor.
		 *  @return: void
		 */
		public function setAlpha(brightness:Number = 1):void
		{
			// set alpha value
			this.alpha =  Math.min(this._alpha * brightness, 1);
			
			// if sliders get alpha value > 1, create a yellow shadow
			// show (remove) shadow on highest (lowest) brightness
			if(brightness>1){
				showShadow(brightness);
			} else {
				this.filters = [];
			}
			
			// set Max-Min value, for Twinkling
			this.setMaxMinAlpha();
		}


		/**
		 *	Function TODO: Set max and min alpha value, based on current alpha value
		 *
		 *  @param: void
		 *  @return: void
		 */
		public function setMaxMinAlpha(){
			// setting max and min value 
			this._alphaMax = this.alpha + 0.4;
			this._alphaMin = this.alpha - 0.4;
	
			// bounce
			if (_alphaMin < 0) _alphaMin = 0;
			if (_alphaMax > 1) _alphaMax = 1;	
		}



		/**
		 *	Function TODO: Set Twinkle.
		 *
		 *  @param: $twinkle - Number: twinkle factor (alpha range)
		 *  @return: void
		 */
		public function setTwinkle(twinkle:Number = 0):void
		{
			this._twinkle = twinkle;
		}



		/**
		 *	Function TODO: Set speed.
		 *
		 *  @param: $speed - Number: speed factor (0: off, 1: right, -1: left)
		 *  @return: void
		 */
		public function setSpeed(speed:Number = 0):void
		{
			this._speed = speed;
		}
		



		/**
		 *	Function TODO: Set random position on parent
		 *
		 *  @param: $e - Event: on Added_stage. Event needed to retrive stageWidth and stageHeight.
		 *  @return: void
		 */
		private function setPosition(event:Event):void
		{
			this.x = Math.random() * stage.stageWidth;
			this.y = Math.random() * stage.stageHeight;
		}





		/**
		 *	Function TODO: Create Shadow for stars with highest brightness value
		 *
		 *  @param: $brightness - Number: brightness factore, used to set shadow alpha
		 *  @return: void
		 */
		private function showShadow(brightness:Number = 0):void
		{
			
			// delete existing shadow
			if(this.filters.length >= 0)	this.filters = [];

			// append current shadow, with personalized strong
			dropShadow = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.color = 0xFFFF00;
			dropShadow.blurX = 8;
			dropShadow.blurY = 8;
			dropShadow.alpha = brightness - 1;
			//dropShadow.quality = 3;
			dropShadow.strength = 2; 	// intensity of the shadow. Ranges from 0 to 255
			this.filters = [dropShadow];
	
		}



		/**
		 *	Function TODO: Twinkling and Moving stars
		 *
		 *  @param: $e - Event.
		 *  @return: void
		 */
		function doTwinkleAndMovement(event:Event):void
		{
			// get the current star to tweak
			var star:Star = Star(event.currentTarget);
			
			// twinkling with sporadin changes
			if (Math.random() > 0.2 && star._twinkle>0) {
				star.alpha += Math.random() * star._twinkle - (star._twinkle/2);
				
				// bounds checking: prevent failure
				if (star.alpha < star._alphaMin) star.alpha = star._alphaMin;
				if (star.alpha > star._alphaMax) star.alpha = star._alphaMax;
			}
			
			// movement along x
			if(star._speed>0 || star._speed<0){
				star.x += Math.random()*star._speed;
	
				if (star.x > stage.stageWidth) {
					star.x = 0;
				} else if (star.x < 0) {
					star.x = stage.stageWidth;
				}
			}
			
			
		}



	//- END CLASS 
	}
	
//- END PACKAGE 
}