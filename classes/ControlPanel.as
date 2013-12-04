package classes {
 
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.FileReference;
	import fl.transitions.Tween;		// Tween library
 	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import fl.controls.Slider; 			// Sliders library
	import fl.events.SliderEvent; 


	public class ControlPanel extends MovieClip
	{
 
 		//- PUBLIC & PRIVATE VARIABLES -----------------------------------------------------------------
		
		// XML Loader and data
 		public var xmlLoader:URLLoader = new URLLoader(); 
		public var xmlData:XML = new XML();
		public var cpXMLUrl:String = new String();

		// Preloaders and related TextField
		public var cpPreloader:Preloader;
		public var cpLoadingText:TextField = new StarryNightTextField();
		
		// Current Values (after users changes)
		public var cpCurrentBgImg:String = new String();
		public var cpCurrentStarsNum:Number = new Number();
		public var cpCurrentStarsDimension:Number = new Number();
		public var cpCurrentStarsBrightness:Number = new Number();		
		public var cpCurrentStarsTwinkling:Number = new Number();
		public var cpCurrentStarsMovement:Number = new Number();	
		public var cpCurrentSStarsFrequency:Number = new Number();
		public var cpCurrentSStarsSpeed:Number = new Number();
		public var cpCurrentSStarsTrajectorie:Number = new Number();			
		
		// Thumbs Array
		public var cpThumbs:Array;
		
		// Thumb: loading and box
 		public var thumbBg:Sprite = new Sprite();
		public var thumbImg:Loader = new Loader();
		public var thumbUrl:URLRequest = new URLRequest();
		public var thumbText:TextField = new StarryNightTextField();
		public var thumbBox:MovieClip = new MovieClip();
		public var thumbWhiteBox:Sprite = new Sprite();
		public var thumbChk:Boolean = false;
		// Thumb alpha and height (in/out)
		private var thumbFadeOut:Number = .2;
		private var thumbFadeIn:Number = 1;
		private var thumbHeightOut:Number = 84;
		private var thumbHeightIn:Number  = 104;
		// Thumb positioning
		private var cpThumbX:Number = new Number();
		private var cpThumbY:Number = new Number();
		
		// Settings: Settings 
		public var cpStarsNumSlider:Slider;
		public var cpStarsDimensionSlider:Slider;
		public var cpStarsBrightnessSlider:Slider;
		public var cpStarsTwinklingSlider:Slider;
		public var cpStarsMovementSlider:Slider;
		// Settings: TextFields
		public var cpStarsNumText:TextField = new StarryNightTextField(11, "left");			// new StarryNightTextFiled, size=11px, align=left
		public var cpStarsDimensionText:TextField = new StarryNightTextField(11, "left");
		public var cpStarsBrightnessText:TextField = new StarryNightTextField(11, "left");
		public var cpStarsTwinklingText:TextField = new StarryNightTextField(11, "left");
		public var cpStarsMovementText:TextField = new StarryNightTextField(11, "left");
		// Settings: Position
		private var cpSettingsX:Number = new Number();
		private var cpSettingsY:Number = new Number();
		
		// Shooting Stars: Sliders
		public var cpSStarsFrequencySlider:Slider;
		public var cpSStarsSpeedSlider:Slider;
		public var cpSStarsTrajectorieSlider:Slider;
		// Shooting stars: TextFields
		public var cpSStarsFrequencyText:TextField = new StarryNightTextField(11, "left");
		public var cpSStarsSpeedText:TextField = new StarryNightTextField(11, "left");
		public var cpSStarsTrajectorieText:TextField = new StarryNightTextField(11, "left");
		
		// Return to Default Value - Buttons
		public var cpBtnDefaultSettings:btnDefault = new btnDefault();
		public var cpBtnDefaultBgImg:btnDefault = new btnDefault();
		public var cpBtnDefaultSStars:btnDefault = new btnDefault();	
		
		// Tween
		public var myTween:Tween;


		//- CONSTANT VARIABLES --------------------------------------------------------------------------
		
		// Thumb: position
		const CP_THUMBS_X:Number = 28;
		const CP_THUMBS_Y:Number = 150;

		// Settings: positioning
		const CP_SETTINGS_X:Number = 528;
		const CP_SETTINGS_Y:Number = 142;
		const CP_SETTINGS_SLIDER_X_DISTANCE:Number = 41;
		const CP_SETTINGS_SLIDER_WIDTH = 150;

		// Max Value
		const CP_MAX_S_NUMBER:Number = 900;			// 900 stars on sky
		const CP_MAX_S_DIMENSION:Number = 3;		// x3 current dimension
		const CP_MAX_S_BRIGHTNESS:Number = 2;		// <1: improve alpha, >1: create yellow shadow
		const CP_MAX_S_TWINKLING:Number = 0.5;		// alpha range change (100%)
		const CP_MAX_S_MOVEMENT:Number = 1;			// 100%
		const CP_MAX_SS_FREQUENCY:Number = 30;		// 30star/min
		const CP_MAX_SS_SPEED:Number = 50;			//




		//- CONSTRUCTOR ---------------------------------------------------------------------------------

		/**
		 *	Function TODO: Initialize Elements (Thumbs, Settings) position.
		 *
		 *  @param: void
		 *  @return: void
		 */
		function ControlPanel():void {
			
			// Thumb Init Position
			this.cpThumbX = CP_THUMBS_X;
			this.cpThumbY = CP_THUMBS_Y;
	
			// Sliders Init Position
			this.cpSettingsX = CP_SETTINGS_X;
			this.cpSettingsY = CP_SETTINGS_Y;		
						
		}
		
		
		//- PUBLIC & PRIVATE METHODS --------------------------------------------------------------------	
		
		/**
		 *	Function TODO: Initialize Control Panel.
		 *
		 *  @param: void
		 *  @return: void
		 */		
		public function init():void
		{
				// Initialize Thumbs
				initShowThumb();
				// Show Settings and ShootingStars Sliders
				showSettings();
		}
		
		
		
		//- THUMBS METHODS ------------------------------------------------------------------------------
			
		/**
		 *	Function TODO: Initialize Thumbs, loading XML from cpXMLurl = snXMLUrl
		 *
		 *  @param: void
		 *  @return: void
		 */		
		public function initShowThumb():void
		{
			xmlLoader.addEventListener(Event.COMPLETE, onXMLComplete); 
			xmlLoader.load(new URLRequest(this.cpXMLUrl));
		}
	

		
		/**
		 *	Function TODO: On XML Loading Complete, procede.
		 *
		 *  @param: $e - Event. xmlLoader Complete Loading.
		 *  @return: 
		 */		
	  	private function onXMLComplete(e:Event):void 
		{ 
			trace("Loading XML: completato.");
			xmlData = new XML(e.target.data); 
			// load and show thumbs
			showThumb(xmlData.img);	
		} 


		
		/**
		 *	Function TODO: Show Thumbs on stage
		 *
		 *  @param: $bgList - XMLList: Parsed XML in a list (img tags)
		 *  @return: void
		 */		
		private function showThumb(bgList:XMLList):void
		{
			var myThumbOn:Boolean = new Boolean();
		
			// DEFAULT SETTINGS BUTTON
			cpBtnDefaultBgImg.x = 370;
			cpBtnDefaultBgImg.y = 102;	
			cpBtnDefaultBgImg.buttonMode = true;
			cpBtnDefaultBgImg.addEventListener(MouseEvent.CLICK, changeBgImgDefault);
			addChild(cpBtnDefaultBgImg);
		
			// Initialize Thumbs Array()
			cpThumbs = new Array();
	
			// 
			for (var item:uint = 0; item < bgList.length(); item++ )  {
				
				// set myThumb value
				// true: associated to current background
				if(bgList[item].attribute("src") == this.cpCurrentBgImg){
					myThumbOn = true;
				} else {
					myThumbOn = false;
				}
				
				// create new Thumb ("thumb path", "thumb description", "thumb selected")
				var thumb:Thumb = new Thumb(bgList[item].attribute("thumb"), bgList[item].attribute("title"),bgList[item].attribute("src"), myThumbOn);

				// add Event. Intercept when Thumb is clicked
				// "thumbClicked" is dispatched by Thumb Class
				thumb.addEventListener("thumbClicked", updateBackground);
				
				// get position of current Thumb
				thumb.x = cpThumbX;
				thumb.y = cpThumbY;			
				
				// calculate position for next thumb
				if((item+1)%3==0 && item!=0){
					cpThumbY += 120;
					cpThumbX = CP_THUMBS_X
				} else {
					cpThumbX += 120;
				}

				// push this Thumb into array cpThumbs
				cpThumbs.push(thumb);
				
				// add Thumb
				addChild(thumb);
			}
			
			trace("Showing Thumbs: completed.");
		}
	

		
		/**
		 *	Function TODO: Dispatch new Event for StarryNight Class. "changeBackground". 
		 *
		 *  @param: $e - Event: "thumbClicked"
		 *  @return: void
		 */		
		public function updateBackground(e:Event):void
		{
			
			// set this Current Background
			this.cpCurrentBgImg = e.target.bgSrc;
			
			// dispatch new Event "changeBackround"
			// Listener: StarryNight Class
			dispatchEvent(new Event("changeBackground"));

		}
	
	
	
		/**
		 *	Function TODO: Highlight current background. 
		 *
		 *  @param: $src - String: Background to be checked/highlight
		 *  @return: void
		 */		
		public function highlightBackground(src:String = ""):void
		{	
	
			// check/uncheck and highlight/unhighlight Thumb
			for (var item:uint = 0; item < cpThumbs.length; item++ )  {
				if(cpThumbs[item].bgSrc == src){
					if(!cpThumbs[item].thumbOn) cpThumbs[item].checkThumb();
				} else {
					cpThumbs[item].uncheckThumb();
				}
			}	
		}
	


		//- SETTINGS AND SHOOTINGSTARS METHODS ----------------------------------------------------------

		/**
		 *	Function TODO: Show Settings and Shooting Stars Sliders.
		 *
		 *  @param: void
		 *  @return: void
		 */		
		public function showSettings():void
		{
			
				// DEFAULT SETTINGS BUTTON
				cpBtnDefaultSettings.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 30;
				cpBtnDefaultSettings.y = cpSettingsY - 40;
				addChild(cpBtnDefaultSettings);
				cpBtnDefaultSettings.buttonMode = true;
				cpBtnDefaultSettings.addEventListener(MouseEvent.CLICK, changeSettingsDefault);
									
				
				// NUMBER OF STARS ----------------------------------------------------------------------------
				cpStarsNumSlider = new Slider();
				cpStarsNumSlider.move(cpSettingsX, cpSettingsY);	
				cpStarsNumSlider.liveDragging = true;
				cpStarsNumSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpStarsNumSlider.maximum = CP_MAX_S_NUMBER;
				cpStarsNumSlider.minimum = 0;
				cpStarsNumSlider.snapInterval = 10;
				// positiong TextField
				cpStarsNumText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpStarsNumText.y = cpSettingsY - 6;
				// change init value
				changeStarsNumValue();	
			
				// add StarsNum
				addChild(cpStarsNumSlider);
				addChild(cpStarsNumText);						
				// StarsNumber Events
				cpStarsNumSlider.addEventListener(Event.CHANGE, changeStarsNum);
				cpStarsNumSlider.addEventListener(SliderEvent.THUMB_DRAG, changeStarsNumTextR);
				cpStarsNumSlider.addEventListener(SliderEvent.THUMB_PRESS, changeStarsNumTextR);            
				cpStarsNumSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeStarsNumTextW);



				// DIMENSION OF STARS -------------------------------------------------------------------------
				cpStarsDimensionSlider = new Slider();
				cpStarsDimensionSlider.move(cpSettingsX, cpSettingsY+CP_SETTINGS_SLIDER_X_DISTANCE);	
				cpStarsDimensionSlider.liveDragging = true;
				cpStarsDimensionSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpStarsDimensionSlider.maximum = CP_MAX_S_DIMENSION;
				cpStarsDimensionSlider.minimum = 0;
				cpStarsDimensionSlider.snapInterval = 0.1;
				// positiong TextField
				cpStarsDimensionText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpStarsDimensionText.y = (cpSettingsY - 6) + CP_SETTINGS_SLIDER_X_DISTANCE;
				// change init value
				changeStarsDimensionValue();	

			
				// add Dimension
				addChild(cpStarsDimensionSlider);
				addChild(cpStarsDimensionText);						
				// StarsDimension Events
				cpStarsDimensionSlider.addEventListener(Event.CHANGE, changeStarsDimension);
				cpStarsDimensionSlider.addEventListener(SliderEvent.THUMB_DRAG, changeStarsDimensionTextR);
				cpStarsDimensionSlider.addEventListener(SliderEvent.THUMB_PRESS, changeStarsDimensionTextR);            
				cpStarsDimensionSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeStarsDimensionTextW);



				// BRIGHTNESS OF STARS ------------------------------------------------------------------------
				cpStarsBrightnessSlider = new Slider();
				cpStarsBrightnessSlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*2));	
				cpStarsBrightnessSlider.liveDragging = true;
				cpStarsBrightnessSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpStarsBrightnessSlider.maximum = CP_MAX_S_BRIGHTNESS;
				cpStarsBrightnessSlider.minimum = 0;
				cpStarsBrightnessSlider.snapInterval = 0.1;
				// positiong TextField
				cpStarsBrightnessText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpStarsBrightnessText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*2);
				// change init value
				changeStarsBrightnessValue();	

			
				// add Brightness
				addChild(cpStarsBrightnessSlider);
				addChild(cpStarsBrightnessText);						
				// StarsBrightness Events
				cpStarsBrightnessSlider.addEventListener(Event.CHANGE, changeStarsBrightness);
				cpStarsBrightnessSlider.addEventListener(SliderEvent.THUMB_DRAG, changeStarsBrightnessTextR);
				cpStarsBrightnessSlider.addEventListener(SliderEvent.THUMB_PRESS, changeStarsBrightnessTextR);            
				cpStarsBrightnessSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeStarsBrightnessTextW);



				// TWINKLING OF STARS -------------------------------------------------------------------------
				cpStarsTwinklingSlider = new Slider();
				cpStarsTwinklingSlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*3));	
				cpStarsTwinklingSlider.liveDragging = true;
				cpStarsTwinklingSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpStarsTwinklingSlider.maximum = CP_MAX_S_TWINKLING;
				cpStarsTwinklingSlider.minimum = 0;
				cpStarsTwinklingSlider.snapInterval = 0.01;
				// positiong TextField
				cpStarsTwinklingText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpStarsTwinklingText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*3);
				// change init value
				changeStarsTwinklingValue();			

			
				// add Twinkling
				addChild(cpStarsTwinklingSlider);
				addChild(cpStarsTwinklingText);						
				// StarsTwinkling Events
				cpStarsTwinklingSlider.addEventListener(Event.CHANGE, changeStarsTwinkling);
				cpStarsTwinklingSlider.addEventListener(SliderEvent.THUMB_DRAG, changeStarsTwinklingTextR);
				cpStarsTwinklingSlider.addEventListener(SliderEvent.THUMB_PRESS, changeStarsTwinklingTextR);            
				cpStarsTwinklingSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeStarsTwinklingTextW);



				// MOVEMENT OF STARS --------------------------------------------------------------------------
				cpStarsMovementSlider = new Slider();
				cpStarsMovementSlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*4));	
				cpStarsMovementSlider.liveDragging = true;
				cpStarsMovementSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpStarsMovementSlider.maximum = CP_MAX_S_MOVEMENT;
				cpStarsMovementSlider.minimum = -CP_MAX_S_MOVEMENT;
				cpStarsMovementSlider.snapInterval = 0.01;
				// positiong TextField
				cpStarsMovementText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpStarsMovementText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*4);
				// change init value
				changeStarsMovementValue();

			
				// add Movement
				addChild(cpStarsMovementSlider);
				addChild(cpStarsMovementText);						
				// StarsMovement Events
				cpStarsMovementSlider.addEventListener(Event.CHANGE, changeStarsMovement);
				cpStarsMovementSlider.addEventListener(SliderEvent.THUMB_DRAG, changeStarsMovementTextR);
				cpStarsMovementSlider.addEventListener(SliderEvent.THUMB_PRESS, changeStarsMovementTextR);            
				cpStarsMovementSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeStarsMovementTextW);
				
				


									
				// DEFAULT SHOOTING STARS BUTTON
				cpBtnDefaultSStars.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 30;
				cpBtnDefaultSStars.y = cpSettingsY + CP_SETTINGS_SLIDER_X_DISTANCE*5.8;
				addChild(cpBtnDefaultSStars);
				cpBtnDefaultSStars.buttonMode = true;
				cpBtnDefaultSStars.addEventListener(MouseEvent.CLICK, changeSStarsDefault);
				
				
				// FREQUENCY OF SHOOTING STARS ----------------------------------------------------------------
				cpSStarsFrequencySlider = new Slider();
				cpSStarsFrequencySlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*6.7));	
				cpSStarsFrequencySlider.liveDragging = true;
				cpSStarsFrequencySlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpSStarsFrequencySlider.maximum = CP_MAX_SS_FREQUENCY;
				cpSStarsFrequencySlider.minimum = 0;
				cpSStarsFrequencySlider.snapInterval = 1;
				// positiong TextField
				cpSStarsFrequencyText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpSStarsFrequencyText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*6.7);
				// change init value
				changeSStarsFrequencyValue();

			
				// add Frequency
				addChild(cpSStarsFrequencySlider);
				addChild(cpSStarsFrequencyText);						
				// SStarsFrequency Events
				cpSStarsFrequencySlider.addEventListener(Event.CHANGE, changeSStarsFrequency);
				cpSStarsFrequencySlider.addEventListener(SliderEvent.THUMB_DRAG, changeSStarsFrequencyTextR);
				cpSStarsFrequencySlider.addEventListener(SliderEvent.THUMB_PRESS, changeSStarsFrequencyTextR);            
				cpSStarsFrequencySlider.addEventListener(SliderEvent.THUMB_RELEASE, changeSStarsFrequencyTextW);
				
				
				// SPEED OF SHOOTING STARS --------------------------------------------------------------------
				cpSStarsSpeedSlider = new Slider();
				cpSStarsSpeedSlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*7.7));	
				cpSStarsSpeedSlider.liveDragging = true;
				cpSStarsSpeedSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpSStarsSpeedSlider.maximum = CP_MAX_SS_SPEED;
				cpSStarsSpeedSlider.minimum = 0;
				cpSStarsSpeedSlider.snapInterval = 1;
				// positiong TextField
				cpSStarsSpeedText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpSStarsSpeedText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*7.7);
				// change init value
				changeSStarsSpeedValue();

			
				// add Speed
				addChild(cpSStarsSpeedSlider);
				addChild(cpSStarsSpeedText);						
				// SStarsFrequency Events
				cpSStarsSpeedSlider.addEventListener(Event.CHANGE, changeSStarsSpeed);
				cpSStarsSpeedSlider.addEventListener(SliderEvent.THUMB_DRAG, changeSStarsSpeedTextR);
				cpSStarsSpeedSlider.addEventListener(SliderEvent.THUMB_PRESS, changeSStarsSpeedTextR);            
				cpSStarsSpeedSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeSStarsSpeedTextW);
				
				
				// TRAJECTORIE OF SHOOTING STARS --------------------------------------------------------------
				cpSStarsTrajectorieSlider = new Slider();
				cpSStarsTrajectorieSlider.move(cpSettingsX, cpSettingsY+(CP_SETTINGS_SLIDER_X_DISTANCE*8.7));	
				cpSStarsTrajectorieSlider.liveDragging = true;
				cpSStarsTrajectorieSlider.setSize(CP_SETTINGS_SLIDER_WIDTH,0);
				cpSStarsTrajectorieSlider.maximum = +1;
				cpSStarsTrajectorieSlider.minimum = -1;
				cpSStarsTrajectorieSlider.snapInterval = 1;
				// positiong TextField
				cpSStarsTrajectorieText.x = cpSettingsX + CP_SETTINGS_SLIDER_WIDTH + 10;
				cpSStarsTrajectorieText.y = (cpSettingsY - 6) + (CP_SETTINGS_SLIDER_X_DISTANCE*8.7);
				// change init value
				changeSStarsTrajectorieValue();

			
				// add Trajectorie
				addChild(cpSStarsTrajectorieSlider);
				addChild(cpSStarsTrajectorieText);						
				// SStarsFrequency Events
				cpSStarsTrajectorieSlider.addEventListener(Event.CHANGE, changeSStarsTrajectorie);
				cpSStarsTrajectorieSlider.addEventListener(SliderEvent.THUMB_DRAG, changeSStarsTrajectorieTextR);
				cpSStarsTrajectorieSlider.addEventListener(SliderEvent.THUMB_PRESS, changeSStarsTrajectorieTextR);            
				cpSStarsTrajectorieSlider.addEventListener(SliderEvent.THUMB_RELEASE, changeSStarsTrajectorieTextW);
				

		}
		

		


		//- CHANGE SETTINGS VALUE METHODS ---------------------------------------------------------------

		/**
		 *	1. Change Settings Value: Number of Stars
		 */		
		public function changeStarsNumValue():void
		{
			// set text value
			cpStarsNumText.text = "" +(cpCurrentStarsNum);
			// set slider value
			cpStarsNumSlider.value = this.cpCurrentStarsNum;
		}
		
		/**
		 *	2. Change Settings Value: Dimension
		 */		
		public function changeStarsDimensionValue():void
		{
			// set text value
			cpStarsDimensionText.text = "" +Math.round(cpCurrentStarsDimension*100)+"%";
			// set slider value
			cpStarsDimensionSlider.value = this.cpCurrentStarsDimension;
		}
		
		/**
		 *	3. Change Settings Value: Brightness
		 */		
		public function changeStarsBrightnessValue():void
		{
			// set text value
			cpStarsBrightnessText.text = "" +Math.round((cpCurrentStarsBrightness*100)/CP_MAX_S_BRIGHTNESS)+"%";
			// set slider value
			cpStarsBrightnessSlider.value = this.cpCurrentStarsBrightness;
		}
			
		/**
		 *	4. Change Settings Value: Twinkling
		 */		
		public function changeStarsTwinklingValue():void
		{
			// set text value
			if(cpCurrentStarsTwinkling==0){
				cpStarsTwinklingText.text = "off";
			} else {
				cpStarsTwinklingText.text = "" +Math.round((cpCurrentStarsTwinkling*100)/CP_MAX_S_TWINKLING)+"%";
			}
			// set slider value
			cpStarsTwinklingSlider.value = this.cpCurrentStarsTwinkling;		
		}
		
		/**
		 *	5. Change Settings Value: Movement
		 */		
		public function changeStarsMovementValue():void
		{
			// set text value
			if(cpCurrentStarsMovement==0){
				cpStarsMovementText.text = "off";		// no movement
			} else if (cpCurrentStarsMovement>0) {
				cpStarsMovementText.text = "right";		// right movement
			} else if (cpCurrentStarsMovement<0) {		
				cpStarsMovementText.text = "left";		// left movement
			}
			// set slider value
			cpStarsMovementSlider.value = this.cpCurrentStarsMovement;		
		}
		
		
		//- CHANGE SHOOTING STARS VALUE METHODS ---------------------------------------------------------
		
		/**
		 *	1. Change Shooting Stars Value: Frequency
		 */		
		public function changeSStarsFrequencyValue():void
		{
			// set text value
			cpSStarsFrequencyText.text = "" +Math.round(60/this.cpCurrentSStarsFrequency)+ "/min";
			// set slider value
			cpSStarsFrequencySlider.value = Math.round(60/this.cpCurrentSStarsFrequency);
		}
		
		/**
		 *	2. Change Shooting Stars Value: Speed
		 */	
		public function changeSStarsSpeedValue():void
		{
			// set text value
			cpSStarsSpeedText.text = "" +Math.round((cpCurrentSStarsSpeed*100)/CP_MAX_SS_SPEED)+"%";
			// set slider value
			cpSStarsSpeedSlider.value = this.cpCurrentSStarsSpeed;	
		}
		
		/**
		 *	3. Change Shooting Stars Value: Trajectorie
		 */	
		public function changeSStarsTrajectorieValue():void
		{
			// set text value
			if(cpCurrentSStarsTrajectorie==0){
				cpSStarsTrajectorieText.text = "random";
			} else if(cpCurrentSStarsTrajectorie>0){ 
				cpSStarsTrajectorieText.text = "right";		
			} else {
				cpSStarsTrajectorieText.text = "left";	
			}
			// set slider value
			cpSStarsTrajectorieSlider.value = this.cpCurrentSStarsTrajectorie;	
		}	
		
		
		
		
		
		//- SETTINGS EVENTS METHODS ---------------------------------------------------------------------
		
		/**
		 *	1. Events: Number of Stars
		 */		
		private function changeStarsNum(e:Event):void {
				cpStarsNumText.text = "" +(e.target.value);
				
				// set this Current Stars Number
				this.cpCurrentStarsNum = e.target.value;
				
				// dispatch new Event "changeStarsNumber"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeStarsNum"));
		}
		
		private function changeStarsNumTextW(e:Event):void {
				cpStarsNumText.textColor = 0xFFFFFF;
		}
		
		private function changeStarsNumTextR(e:Event):void {
				cpStarsNumText.textColor = 0xFF0000;
		}
		


		/**
		 *	2. Events: Dimenesion
		 */	
		private function changeStarsDimension(e:Event):void {
				// set this Current Stars Dimension
				this.cpCurrentStarsDimension = e.target.value;
				
				// dispatch new Event "changeStarsDimension"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeStarsDimension"));
		}
		
		private function changeStarsDimensionTextW(e:Event):void {
				cpStarsDimensionText.textColor = 0xFFFFFF;
		}
		
		private function changeStarsDimensionTextR(e:Event):void {
				cpStarsDimensionText.textColor = 0xFF0000;
		
		}		
		
		
		
		/**
		 *	3. Events: Brightness
		 */	
		private function changeStarsBrightness(e:Event):void {
				// set this Current Stars Brightness
				this.cpCurrentStarsBrightness = e.target.value;
				
				// dispatch new Event "changeStarsBrightness"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeStarsBrightness"));
		}	
		
		private function changeStarsBrightnessTextW(e:Event):void {
				cpStarsBrightnessText.textColor = 0xFFFFFF;
		}
		
		private function changeStarsBrightnessTextR(e:Event):void {
				cpStarsBrightnessText.textColor = 0xFF0000;
		
		}
		

		
		/**
		 *	4. Events: Twinkling
		 */
		private function changeStarsTwinkling(e:Event):void {
				// set this Current Stars Twinkling
				this.cpCurrentStarsTwinkling = e.target.value;
				
				// dispatch new Event "changeStarsTwinkling"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeStarsTwinkling"));
		}	
		
		private function changeStarsTwinklingTextW(e:Event):void {
				cpStarsTwinklingText.textColor = 0xFFFFFF;
		}
		
		private function changeStarsTwinklingTextR(e:Event):void {
				cpStarsTwinklingText.textColor = 0xFF0000;
		
		}
		
		
		
		/**
		 *	5. Events: Movement
		 */
		private function changeStarsMovement(e:Event):void {
				// set this Current Stars Movement
				this.cpCurrentStarsMovement = e.target.value;
				
				// dispatch new Event "changeStarsMovement"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeStarsMovement"));
		}	
		
		private function changeStarsMovementTextW(e:Event):void {
				cpStarsMovementText.textColor = 0xFFFFFF;
		}
		
		private function changeStarsMovementTextR(e:Event):void {
				cpStarsMovementText.textColor = 0xFF0000;
		
		}
		


		//- SHOOTING STARS EVENTS METHODS ---------------------------------------------------------------

		/**
		 *	1. Events: Frequency
		 */	
		private function changeSStarsFrequency(e:Event):void {
				// set this Current Stars Movement
				this.cpCurrentSStarsFrequency = Math.round(60/e.target.value);
							
				// dispatch new Event "changeSStarsFrequency"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeSStarsFrequency"));
		}	
		
		private function changeSStarsFrequencyTextW(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFFFFFF;
		}
		
		private function changeSStarsFrequencyTextR(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFF0000;
		
		}


		/**
		 *	2. Events: Speed
		 */	
		private function changeSStarsSpeed(e:Event):void {
				// set this Current Shooting Stars Speed
				this.cpCurrentSStarsSpeed = e.target.value;
							
				// dispatch new Event "changeSStarsSpeed"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeSStarsSpeed"));
		}	
		
		private function changeSStarsSpeedTextW(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFFFFFF;
		}
		
		private function changeSStarsSpeedTextR(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFF0000;
		
		}


		/**
		 *	3. Events: Trajectorie
		 */
		private function changeSStarsTrajectorie(e:Event):void {
				// set this Current Shooting Stars Trajectorie
				this.cpCurrentSStarsTrajectorie = e.target.value;
							
				// dispatch new Event "changeSStarsTrajectorie"
				// Listener: StarryNight Class
				dispatchEvent(new Event("changeSStarsTrajectorie"));
		}	
		
		private function changeSStarsTrajectorieTextW(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFFFFFF;
		}
		
		private function changeSStarsTrajectorieTextR(e:Event):void {
				cpSStarsFrequencyText.textColor = 0xFF0000;
		
		}




		//- DEFAULT EVENTS METHODS ----------------------------------------------------------------------

		/**
		 *	1. Defaults: Background
		 */
		function changeBgImgDefault(e:Event):void
		{
			// set Current Background: "", dispatch new Event for StarryNight class
			this.cpCurrentBgImg = "";
			dispatchEvent(new Event("changeBackground"));
		}


		/**
		 *	2. Defaults: Settings
		 */
		function changeSettingsDefault(e:Event):void
		{
				// set Current Stars Number: -1, dispatch new Event for StarryNight class
				this.cpCurrentStarsNum = -1;
				dispatchEvent(new Event("changeStarsNum"));

				
				// set Current Stars Dimension: -1, dispatch new Event for StarryNight class
				this.cpCurrentStarsDimension = -1;
				dispatchEvent(new Event("changeStarsDimension"));
			
				
				// set Current Stars Brightness: -1, dispatch new Event for StarryNight class
				this.cpCurrentStarsBrightness = -1;
				dispatchEvent(new Event("changeStarsBrightness"));
				
				
				// set Current Stars Twinkling: -1, dispatch new Event for StarryNight class
				this.cpCurrentStarsTwinkling = -1;
				dispatchEvent(new Event("changeStarsTwinkling"));
				
				// set Current Stars Movement: -100, dispatch new Event for StarryNight class
				this.cpCurrentStarsMovement = -100;
				dispatchEvent(new Event("changeStarsMovement"));
		}



		/**
		 *	3. Defaults: Shooting Stars
		 */
		function changeSStarsDefault(e:Event):void
		{		
				// set Current SStars Frequency: -1, dispatch new Event for StarryNight class
				this.cpCurrentSStarsFrequency = -1;
				dispatchEvent(new Event("changeSStarsFrequency"));

				
				// set Current SStars Speed: -1, dispatch new Event for StarryNight class
				this.cpCurrentSStarsSpeed = -1;
				dispatchEvent(new Event("changeSStarsSpeed"));
			
				
				// set Current SStars Trajectorie: -1, dispatch new Event for StarryNight class
				this.cpCurrentSStarsTrajectorie = -100;
				dispatchEvent(new Event("changeSStarsTrajectorie"));
		}



	//- END CLASS 
	}
	
//- END PACKAGE 
}