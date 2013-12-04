package classes {
 
 	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;		// Timer library
	import flash.geom.Rectangle;	// Graphics library
	import flash.filters.*;			// Filters library: shadow and blur


 
	public class ShootingStar extends MovieClip{
	
	 	//- PUBLIC & PRIVATE VARIABLES -----------------------------------------------------------------
 	
	 	// Star's Parameters
		private var _speedX:Number = new Number();
		private var _speedY:Number = new Number();
		private var _speed:Number = new Number();
		private var _nShadow:Number = new Number();

		// New StarryNightStar: main shooting star
		private var _star:StarryNightStar = new StarryNightStar();

		// Filters
		var shadowBlur:BlurFilter = new BlurFilter();
		var starBlur:BlurFilter = new BlurFilter();
		var starShadow:DropShadowFilter = new DropShadowFilter();


 		//- CONSTRUCTOR --------------------------------------------------------------------------------

		/**
		 *	Function TODO: Initialize ShootingStar.
		 *
		 *  @param: $speed - Number: default value = 3. 
		 *  @param: $trajectorie - Number: default value = 0. (random trajectorie: left and right)
		 *  @param: $dimension - Number: default value = 0.		
 
		 *  @return: void
		 */
		function ShootingStar(speed:Number = 3, trajectorie:Number = 0, dimension:Number = 1):void
		{	
			
			// Initial position on this MovieClip				
			_star.x = 0;
			_star.y = 0;
			
			// current shadow, with personalized strong
			starShadow = new DropShadowFilter();
			starShadow.distance = 0;
			starShadow.color = 0xFFFF00;
			starShadow.blurX = 6;
			starShadow.blurY = 6;
			starShadow.alpha = 0.7;
			starShadow.strength = 2; 	// intensity of the shadow. Ranges from 0 to 255
			
			// current blur
			starBlur.quality = 3;
			starBlur.blurX = 2;
			starBlur.blurY = 2;
			
			// append both filters
			_star.filters = [starShadow];
			
			// echo shadow
			shadowBlur.quality = 2;
			shadowBlur.blurX = 2;
			shadowBlur.blurY = 2;

			// add Star to Movie Clip
			addChild(_star);

			// setting speed and shadows echo
			setSpeed(speed);
			setScale(dimension);
			this._nShadow = 5*speed;
			
			
			// setting trajectorie
			if(trajectorie==0) {												// random
				if(Math.random()>0.5)
					this._speedX = + Math.min(Math.random()+ 0.4, 0.8);
				else
					this._speedX = - Math.min(Math.random()+ 0.4, 0.8);
			} else if (trajectorie>0) {											// right
					this._speedX = + Math.min(Math.random()+ 0.4, 0.8);
			} else {															// left
					this._speedX = - Math.min(Math.random()+ 0.4, 0.8);
			}
			
			// setting speed
			this._speedY = Math.min(Math.random()+0.05, 0.10);				

			// create shadow
			createShadow();
			
			// set position
			this.addEventListener(Event.ADDED_TO_STAGE, this._setPosition);			
			
		}
		


		/**
		 *	Function TODO: Set speed.
		 *
		 *  @param: $speed - Number: speed factor.
		 *  @return: void
		 */
		public function setSpeed(speed:Number = 0){
			this._speed = speed;
		}



		/**
		 *	Function TODO: Set scaleX and scaleY. 
		 *
		 *  @param: $dimension - Number: scale factor.
		 *  @return: void
		 */
		public function setScale(dimension:Number = 1){
			this.scaleX = dimension;
			this.scaleY = this.scaleX;
		}

		

		/**
		 *	Function TODO: Create Shadow. 
		 *
		 *  @param: $trajectorie - Number.
		 *  @return: void
		 */
		private function createShadow(trajectorie:Number = 1):void
		{
			// Position shadow
			var posX:Number = new Number();
			var posY:Number = new Number();

			if(this._speedX>0)
				posX = 0;
			else	
				posX = 0; //_star.width;
			
			posY = 0;

			//
			for(var i=1; i<=_nShadow; i++){
				
				// create current Cirlce (element of shadow)
				var echo:Sprite = new Sprite();
				echo.graphics.beginFill(0xFFFFFF);
				echo.graphics.drawCircle(0, 0, 1.2);
				
				// calculate and apply scaleXY and alpha
				echo.scaleX = _star.scaleX - (_star.scaleX*i)/(_nShadow);
				echo.scaleY = echo.scaleX;
				echo.alpha = (_star.alpha - (_star.alpha*i)/(_nShadow))/2;

				// calculate position
				if(this._speedX>0)
					posX += -echo.width;
				else	
					posX += echo.width;
					
				posY -= (this._speedY)*echo.height;

				// positioning
				echo.x = posX;
				echo.y = posY;
								
				// appling blur filter
				echo.filters = [shadowBlur];

				// add to this Movie Clip
				this.addChild(echo);			
			}
		
		}




		/*
		 *	Function TODO: Set random position
		 *
		 *  @param: $e - Event: on Added_stage. Event needed to retrive stageWidth and stageHeight.
		 *  @return: void
		 */
		private function _setPosition(e:Event):void
		{
			// sporadic shooting star starting point
			if(Math.random()>0.2){
				// x
				if(this._speedX>0)	this.x = 0;
				else				this.x = stage.stageWidth;
				this.y = Math.random() * stage.stageHeight/4;
			} else {
				this.x = Math.random() * stage.stageWidth;
				this.y = 0;
			}
	
			this.addEventListener(Event.ENTER_FRAME, doMovement);
		}



		/**
		 *	Function TODO: Move Shooting Star on sky.
		 *
		 *  @param: $e - Event.
		 *  @return: void
		 */
		public function doMovement(event:Event):void
		{
			
			// movement along x
			if(this._speed!=0){
				this.x += this._speedX*this._speed;
				this.y += this._speedY*this._speed;

				// reduce alpha to "hide" shooting stars before leaving stage
				this.alpha -= this._speedY*this._speed/200;

				// prepare Shooting Star to be deleted
				if ((this.x-this.width) > stage.stageWidth || (this.x+this.width) < 0) {
					trace("-- doMovement()");
					trace("Out of stage.");
					dispatchEvent(new Event("shootingStarOutOfStage"));
					this.removeEventListener(Event.ENTER_FRAME, doMovement);
				}
			}
			
			
		}







	//- END CLASS 
	}
	
//- END PACKAGE 
}