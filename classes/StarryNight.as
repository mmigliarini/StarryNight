package classes
{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;				// Timer library
	import flash.events.TimerEvent;
	import fl.transitions.Tween;			// Tween library
 	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;


	public class StarryNight extends MovieClip
	{
		
		//- PUBLIC VARIABLES ----------------------------------------------------------------------------
		
		// XML backgrounds data
		public var snXMLUrl:String = new String("bg.xml");					// bg.xml: url of available backgrounds
				
		// Default Values
		public var snDefaultBgImg:String = new String("pics/spietro.png");	// default Background Image
		public var snDefaultStarsNum:Number = 200;							// default Number of Stars on Sky
		public var snDefaultStarsDimension:Number = 1;						// default stars'scale factor: 1 = 100%
		public var snDefaultStarsBrightness:Number = 1;						// default stars's brightness factor: 1 = 100%
		public var snDefaultStarsTwinkling:Number = 0.25;					// default alpha changes range
		public var snDefaultStarsMovement:Number = 0;						// default directio and speed of movement. >0: right, <0: left.
		public var snDefaultSStarsFrequency:Number = 15;					// default Shooting Stars interval apparance in secons	
		public var snDefaultSStarsSpeed:Number = 25; 						// default Shooting Stars speed 
		public var snDefaultSStarsTrajectorie:Number = 0; 					// default Shooting Stars trajectorie. 0: random, 1: right, -1: left.
		
		// Current Values (after users changes)
		public var snCurrentBgImg:String = new String();
		public var snCurrentStarsNum:Number = new Number();
		public var snCurrentStarsDimension:Number;
		public var snCurrentStarsBrightness:Number;		
		public var snCurrentStarsTwinkling:Number;
		public var snCurrentStarsMovement:Number;	
		public var snCurrentSStarsFrequency:Number;
		public var snCurrentSStarsSpeed:Number;
		public var snCurrentSStarsTrajectorie:Number;

		// Preloaders and related TextField
		public var snPreloader:Preloader;
		public var snBgPreloader:Preloader;
		public var snPreloaderText:TextField = new StarryNightTextField();
		public var snBgPreloaderText:TextField = new StarryNightTextField();
		
		// Elements: sky, stars, backround image, shooting stars, control panel
		public var sky:Sky = new Sky();									// sky
		public var stars:Array;											// stars Array(). Include Star.
		public var img:Loader = new Loader();							// background image loader
		public var snShootingStar:ShootingStar = new ShootingStar();	// shooting star
		public var snControlPanel:ControlPanel = new ControlPanel();	// control panel
		
		// Tween
		public var myTween:Tween;
		public var skyTween:Tween;
		public var imgTween:Tween;
		
		// Buttons: open and close control panel
		public var snBtnControlPanel:ButtonControlPanel = new ButtonControlPanel();
		public var snButtonClose:ButtonClose = new ButtonClose();
	
		// Timer for initial pause and Shooting Stars interval
		public var timer:Timer;
		

		

		//- CONSTRUCTOR ---------------------------------------------------------------------------------

		/**
		 *	Function TODO: Preload content. Create and add new Preloader(). Preload needed files: swf, default background. 
		 *				   Initialize current variabile using default values.
		 *				   Proceed with a little pause (doInitPause()), before showing sky, img, stars.
		 *
		 *  @param: void
		 *  @return: void
		 */
		public function StarryNight():void
		{
			
			// New Preloader. Preloader informations on TextField.
			snPreloader = new Preloader(this.snPreloaderText);
			snPreloaderText.text = "Loading: --%";
			
			// add Preloader and PreloaderText in the middle of the screen
			snPreloader.x = (stage.stageWidth)/2;
			snPreloader.y = ((stage.stageHeight)/2)-30;
			snPreloaderText.x = (stage.stageWidth-snPreloaderText.width)/2;
			snPreloaderText.y = (stage.stageHeight)/2;
			addChild(snPreloader);
			addChild(snPreloaderText);
				
			// Initialize current values with default ones.
			snCurrentBgImg = this.snDefaultBgImg;
			snCurrentStarsNum = this.snDefaultStarsNum;
			snCurrentStarsDimension	= this.snDefaultStarsDimension;
			snCurrentStarsBrightness = this.snDefaultStarsBrightness;
			snCurrentStarsTwinkling = this.snDefaultStarsTwinkling;
			snCurrentStarsMovement = this.snDefaultStarsMovement;				
			snCurrentSStarsFrequency = this.snDefaultSStarsFrequency;
			snCurrentSStarsSpeed = this.snDefaultSStarsSpeed;
			snCurrentSStarsTrajectorie = this.snDefaultSStarsTrajectorie;		
			
			// Star Loading default background image
			snPreloader.start(this.snCurrentBgImg);
			
			// Listen for a "preloaderCompleted" message before proceding with Starry Night
			snPreloader.addEventListener("preloaderCompleted", doInitPause);
		}
		




		//- PUBLIC & PRIVATE METHODS --------------------------------------------------------------------
		
		/**
		 *	Function TODO: On Preloader Completed, stop and wait for 3 seconds. Then procede.
		 *
		 *  @param: $e - Event: generated by Constructor, as preloader is completed
		 *  @return: void
		 */	
		public function doInitPause(e:Event):void
		{
			// Star countdown of 3seconds, on Complete init()
			timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, init);
			timer.start();
			
			// create Tween alpha out on PreloaderText
			myTween = new Tween(snPreloaderText, "alpha", None.easeNone,1,0,.7,true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, doNextTween);
 
 			// Loading Completed
			function doNextTween(e:TweenEvent):void{
				snPreloaderText.text = "Loading completed.";
  				myTween = new Tween(snPreloaderText, "alpha", Strong.easeIn, 0, 1, 1, true);
 				myTween.removeEventListener(TweenEvent.MOTION_FINISH, doNextTween);
			}
		}
		


		/**
		 *	Function TODO: Remove preloaders and texts, add sky, background image, paint stars and shooting star.
		 *
		 *  @param: $e - Event: generated by doInitPause(), as 3s countdown is finished
		 *  @return: void
		 */		
		public function init(e:Event):void
		{		
			//	clean stage, removing Preloader and Preloader's Text
			removeChild(snPreloaderText);
			removeChild(snPreloader);
			
			// create alias of loaded backround image
			img = snPreloader.snFileLoader;
			
			// add Sky
			addChild(sky);
			
			// add Background Image, Tween alpha in.
			addChild(img);
			imgTween = new Tween(img, "alpha", Strong.easeIn, 0, 1, 0.7, true);

			// add stars
			paintStarrySky();
			
			// add Control Panel Button 
			showBtnControlPanel(2);		// param: seconds of alpha in tween
			
			// add Shooting Star
			showShootingStar();  
					
		}
		
		
		
		/**
		 *	Function TODO: Clean sky: remove all existing childrends. Initialize stars Array(). Add Stars on Sky.
		 *
		 *  @param: void
		 *  @return: void
		 */
		public function paintStarrySky():void
		{
			// clean sky from existing stars
			if(sky.numChildren!=0)	removeStars(sky.numChildren);
			
			// init stars array
			stars = new Array();	// for eash sky re-paint, it delete and destroy old stars
			
			// add stars, Tween alpha in.		
			addStars(this.snCurrentStarsNum);
			skyTween = new Tween(sky, "alpha", Strong.easeIn, 0, 1, 1, true);

		}
		


		/**
		 *	Function TODO: Begin creating and showing a Shooting Star on sky, setting a timer based on current Frequency.
		 *
		 *  @param: void
		 *  @return: void
		 */
		public function showShootingStar():void
		{
				// create timer, add event on finished countdow
				timer = new Timer((snCurrentSStarsFrequency)*1000);				// current frequencty * 1000 = seconds
				timer.addEventListener (TimerEvent.TIMER, createShootingStar);  
				timer.start ();
		}


		/**
		 *	Function TODO: Create ShootingStar with current values of Speed, Trajectorie and Dimension (star)
		 *
		 *  @param: $e - Event: genetarated by showShootingStar(); on each finished timer countdown.
		 *  @return: void
		 */
		public function createShootingStar(e:TimerEvent):void
		{
			trace("-- createShootingStar()");
			trace("Going to create new Shooting Star");
				
			// create shooting star if frequency >0
			if (snDefaultSStarsFrequency>0)
			{
				// new ShootingStar
				var snShootingStar:ShootingStar = new ShootingStar(snCurrentSStarsSpeed, snCurrentSStarsTrajectorie, snCurrentStarsDimension);
				
				// add this shooting star. (index: 0=sky, 1=shootingStar, 2=img)
				addChildAt(snShootingStar,1);	
				
				// Listen for a "shootingStarOutOfStage" message before removing this shooting star
				snShootingStar.addEventListener("shootingStarOutOfStage", removeShootingStar);
			}
			
		}



		/**
		 *	Function TODO: Remove Shooting Star from stage
		 *
		 *  @param: $e - Event: Shooting Star to be removed. Casting to MovieClip needed.
		 *  @return: 
		 */
		public function removeShootingStar(e:Event):void
		{
			removeChild(MovieClip(e.target));		// cast to MovieClip before remove child.
		}





		/**
		 *	Function TODO: Add nStars on sky
		 *
		 *  @param:	$nStars - Number: Number of Stars to be created and added on sky, using current values of Dimension, Brightness, Twinkling, Movement.
		 *  @return: void
		 */
		private function addStars(nStars:Number):void
		{	
			
			// create stars			
			for (var i:Number = 0; i< nStars; ++i)
			{
				var star:Star = new Star(this.snCurrentStarsDimension, this.snCurrentStarsBrightness, this.snCurrentStarsTwinkling, this.snCurrentStarsMovement);
				sky.addChild(star);
				
				// push element on stars array
				stars.push(star);
				
				// trace
				trace("-- addStars()");
				trace("Stars: " + sky.getChildIndex(star) + " > alpha: " + star.alpha + ", scale: " + star.scaleX + ", rotation: " + star.rotation);
			}
			
		}



		/**
		 *	Function TODO: Remove last nStars on sky (LIFO: Last In, First Out)
		 *
		 *  @param: $nStars - Number: Number of Stars to be removed from sky and stars array.
		 *  @return: void
		 */
		private function removeStars(nStars:Number):void
		{		
				// delete (sky.numChildren-snCurrentStarsNum) stars 
				var j = sky.numChildren;	// current stars on sky
				var s = (j - nStars);		// final stars on sky 
				var r = 0;					// removed stars
				while( j-- > s)
				{
					// remove doTwinkleAndMovement Event before removing
					if((sky.getChildAt(j) as MovieClip) is Star){
						MovieClip(sky.getChildAt(j)).removeEventListener(Event.ENTER_FRAME, MovieClip(sky.getChildAt(j)).doTwinkleAndMovement);
					}
					
					sky.removeChildAt( j );	// remove child j index
					r++;					// incremet removed stars
				}
				
				// starting from j position, remove s Star Obj
				stars.splice(j, r);	 
				
				// trace
				trace("-- removeStars()");
				trace("Current Stars Number: " + this.snCurrentStarsNum);	
				trace("Sky Children: " + sky.numChildren);
		}	
	
					
	
		//- CONTROL PANEL METHODS -----------------------------------------------------------------------
		

		/**
		 *	Function TODO: Open Control Panel on stage, where is possible to set all parameters (bg, stars behaviours...)
		 *
		 *  @param: $e - Event. Mouse Clik.
		 *  @return: void
		 */
		public function openControlPanel(e:MouseEvent):void
		{
			
			// create new control panel
			snControlPanel = new ControlPanel();
			
			// remove Control Panel Opening button
			snBtnControlPanel.removeEventListener(MouseEvent.CLICK, openControlPanel);
			removeChild(snBtnControlPanel);
						
			// Initialize control panel current values with StarryNight current ones.
			snControlPanel.cpXMLUrl = snXMLUrl;											// XML URL with backtrounds data
			snControlPanel.cpCurrentBgImg = this.snCurrentBgImg;						// Background Images
			snControlPanel.cpCurrentStarsNum = this.snCurrentStarsNum;					// Stars Parameters
			snControlPanel.cpCurrentStarsDimension = this.snCurrentStarsDimension;
			snControlPanel.cpCurrentStarsBrightness = this.snCurrentStarsBrightness;
			snControlPanel.cpCurrentStarsTwinkling = this.snCurrentStarsTwinkling;
			snControlPanel.cpCurrentStarsMovement = this.snCurrentStarsMovement;				
			snControlPanel.cpCurrentSStarsFrequency = snCurrentSStarsFrequency;			// Shootings Stars Parameters
			snControlPanel.cpCurrentSStarsSpeed = snCurrentSStarsSpeed;
			snControlPanel.cpCurrentSStarsTrajectorie = snCurrentSStarsTrajectorie;
			
			// positioning control panel in the middle of the stage
			snControlPanel.alpha = 1;
			snControlPanel.x = (stage.stageWidth - snControlPanel.width)/2;
			snControlPanel.y = (stage.stageHeight - snControlPanel.height)/2;
			
			// add Control Panel Closing button
			snButtonClose.x = snControlPanel.width - (snButtonClose.width/2);
			snButtonClose.y = - (snButtonClose.height/2);	
			snControlPanel.addChild(snButtonClose);
			snButtonClose.buttonMode = true;
			snButtonClose.addEventListener(MouseEvent.CLICK, closeControlPanel);		// close control panel on click
			
			// add Control Panel on Stage, Tween elastic in.
			addChild(snControlPanel);
			myTween = new Tween(snControlPanel, "y", Bounce.easeOut, -snControlPanel.height, snControlPanel.y, 0.7, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, doNextTween);
 
 			// on Elastic Motion completed initialize control panel with contents
			function doNextTween(e:TweenEvent):void{
				snControlPanel.init();
			}	
			
			// Event Listener for Settings Changes, dispatched by ControlPanel Class
			snControlPanel.addEventListener("changeBackground", changeBackground);				// change Background images
			snControlPanel.addEventListener("changeStarsNum", changeStarsNum);					// change Number of Stars on sky
			snControlPanel.addEventListener("changeStarsDimension", changeStarsDimension);		// change Dimension
			snControlPanel.addEventListener("changeStarsBrightness", changeStarsBrightness);	// change Brightness
			snControlPanel.addEventListener("changeStarsTwinkling", changeStarsTwinkling);		// change Twinkling
			snControlPanel.addEventListener("changeStarsMovement", changeStarsMovement);		// change Movement
			
			// Event Listener for Shooting Stars Changes, dispatched by ControlPanel Class
			snControlPanel.addEventListener("changeSStarsFrequency", changeSStarsFrequency);	// change Shooting Star frequency
			snControlPanel.addEventListener("changeSStarsSpeed", changeSStarsSpeed);			// change Speed
			snControlPanel.addEventListener("changeSStarsTrajectorie", changeSStarsTrajectorie);// change Trajectorie
			
		}
		


		/**
		 *	Function TODO: Show Control Panel Opening Button on stage
		 *
		 *  @param:	$sec - Number: seconds for the Tween alpha in.
		 *  @return: void
		 */
		public function showBtnControlPanel(sec:Number=0.5):void
		{
			// calculare button position (top right corner)
			snBtnControlPanel.x = stage.stageWidth - snBtnControlPanel.width - 15;
			snBtnControlPanel.y = 15;
			
			// enable click on button
			snBtnControlPanel.buttonMode = true;
			
			// Listen for CLICK event to Open Control Panel
			snBtnControlPanel.addEventListener(MouseEvent.CLICK, openControlPanel);
			
			// add Control Panel Button
			addChild(snBtnControlPanel);			
			myTween = new Tween(snBtnControlPanel, "alpha", Strong.easeIn, 0, 1, sec, true);
		}
		
		

		/**
		 *	Function TODO:	Close Control Panel.
		 *
		 *  @param: $e - Event. Mouse Click on Control Panel Closing Button
		 *  @return: void
		 */
		public function closeControlPanel(e:MouseEvent):void
		{
			
			// remove Event Listener for Settings Changes
			snControlPanel.removeEventListener("changeBackground", changeBackground);				// change Background images
			snControlPanel.removeEventListener("changeStarsNum", changeStarsNum);					// change Number of Stars on sky
			snControlPanel.removeEventListener("changeStarsDimension", changeStarsDimension);		// change Dimension
			snControlPanel.removeEventListener("changeStarsBrightness", changeStarsBrightness);		// change Brightness
			snControlPanel.removeEventListener("changeStarsTwinkling", changeStarsTwinkling);		// change Twinkling
			snControlPanel.removeEventListener("changeStarsMovement", changeStarsMovement);			// change Movement
			
			// remove Event Listener for Shooting Stars Changes	
			snControlPanel.removeEventListener("changeSStarsFrequency", changeSStarsFrequency);		// change Shooting Star frequency
			snControlPanel.removeEventListener("changeSStarsSpeed", changeSStarsSpeed);				// change Speed
			snControlPanel.removeEventListener("changeSStarsTrajectorie", changeSStarsTrajectorie);	// change Trajectorie
			
			
			// remove control panel from stage, Tween alpha out.		
			myTween = new Tween(snControlPanel, "alpha", None.easeNone,1,0,.25,true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, doNextTween);
 
			function doNextTween(e:TweenEvent):void{
				// remove control panel closing button
				snButtonClose.removeEventListener(MouseEvent.CLICK, closeControlPanel);		// remove event listener
				snControlPanel.removeChild(snButtonClose);
				
				// remove control panel
				removeChild(snControlPanel);
				
				// show control panel opening button
				showBtnControlPanel();
			}	
						
		}
		




		//- CHANGE BACKGROUNDS METHODS ------------------------------------------------------------------


		/**
		 *	Function TODO: Load new background image, after new Control Panel Event "changeBackground"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeBackground(e:Event):void
		{
			// Set new Background image value (default if "")
			if(e.target.cpCurrentBgImg==""){
				this.snCurrentBgImg = this.snDefaultBgImg;
				e.target.cpCurrentBgImg = this.snDefaultBgImg;
			} else {
				this.snCurrentBgImg = e.target.cpCurrentBgImg;
			}
			
			// highlight current bg on thumbs preview
			e.target.highlightBackground(this.snCurrentBgImg);
			
			
			// New BgPreloader. BgPreloader informations on BgTextField.
			snBgPreloader = new Preloader(this.snBgPreloaderText);
			snBgPreloaderText.text = "Loading: --%";
			
			// add Preloader and PreloaderText in the middle of the screen
			snBgPreloader.x = (stage.stageWidth)/2;
			snBgPreloader.y = ((stage.stageHeight)/2)-30;
			snBgPreloaderText.x = (stage.stageWidth-snBgPreloaderText.width)/2;
			snBgPreloaderText.y = (stage.stageHeight)/2;
			addChild(snBgPreloader);
			addChild(snBgPreloaderText);	
			
			// load current BG and wait for "loadingCompleted" Event, then replace background (replaceBackground())
			snBgPreloader.loadBgImg(snCurrentBgImg);
			snBgPreloader.addEventListener("loadingImgCompleted", replaceBackground);
			
			// trace
			trace("-- changeBackground()");
			trace("Current Background: " + snCurrentBgImg);
					
		}



		/**
		 *	Function TODO: Replace current background with the new loaded by the caller function changeBackground(). 
		 *
		 *  @param: $e - Event: Preloader. loadingImgCompleted.
		 *  @return: void
		 */
		public function replaceBackground(e:Event):void
		{
			// get ChildIndex of current img
			var childIndex:Number = new Number();
			childIndex = getChildIndex(img);
			
			// remove BgPreloader and BgPreloaderText
			removeChild(snBgPreloaderText);
			removeChild(snBgPreloader);
			removeChild(img);
			
			// add new background image, Tween alpha in.
			img = snBgPreloader.snFileLoader;	
			img.alpha = 0;
			addChildAt(img, childIndex);
			myTween = new Tween(img, "alpha", Strong.easeIn, 0, 1, 0.7, true);
			
			// paint new Starry Night
			sky.alpha = 1;
			paintStarrySky();

		}
		


		//- CHANGE SETTINGS METHODS ---------------------------------------------------------------------


		/**
		 *	Function TODO: Change Stars Number after Control Panel Event "changeStarsNum"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeStarsNum(e:Event):void
		{
			
			// Set Number of Stars value (default if -1)
			if(e.target.cpCurrentStarsNum == -1){
				this.snCurrentStarsNum = this.snDefaultStarsNum;
				e.target.cpCurrentStarsNum = this.snDefaultStarsNum;				
			} else {
				this.snCurrentStarsNum = e.target.cpCurrentStarsNum;
			}
								
			// update control panel slider and text
			snControlPanel.changeStarsNumValue();			
			
			if(snCurrentStarsNum<sky.numChildren){
				removeStars(sky.numChildren-snCurrentStarsNum);		// DELETE (sky.numChildren-snCurrentStarsNum) STARS
			} else if (snCurrentStarsNum>sky.numChildren) {
				addStars(snCurrentStarsNum-sky.numChildren);		// ADD (snCurrentStarsNum-sky.numChildren) STARS
			}		
							
			trace("-- changeStarsNum()");
			trace("Current Stars Number: " + snCurrentStarsNum);
			trace("Sky Children: " + sky.numChildren);
		}



		
		/**
		 *	Function TODO: Change Dimension after Control Panel Event "changeStarsDimension"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeStarsDimension(e:Event):void
		{
			// Set Stars Dimension value (default if -1)
			if(e.target.cpCurrentStarsDimension == -1){
				this.snCurrentStarsDimension = this.snDefaultStarsDimension;
				e.target.cpCurrentStarsDimension = this.snDefaultStarsDimension;		
			} else {
				this.snCurrentStarsDimension = e.target.cpCurrentStarsDimension;
			}
								
			// update control panel slider and text
			snControlPanel.changeStarsDimensionValue();
			
			// change sky's stars scale
			for (var s:uint = 0; s < stars.length; s++ )
			{
				stars[s].setScale(this.snCurrentStarsDimension);
			}
		
			// change existing shooting stars scale
			// cast Object to MovieClip. Verify if Object is ShootingStar
			for (var m:uint = 1; m < numChildren; m++)
			{
				if((getChildAt(m) as MovieClip) is ShootingStar)
				{
					(getChildAt(m) as MovieClip).setSpeed(this.snCurrentStarsDimension);
				}
			}
			
			trace("-- changeStarsDimension()");
			trace("Current Dimension: "+e.target.cpCurrentStarsDimension);		
					
		}
		
		
		
		
		/**
		 *	Function TODO: Change Brightness after Control Panel Event "changeStarsBrightness"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeStarsBrightness(e:Event):void
		{
			// Set Stars Brightness value (default if -1)
			if(e.target.cpCurrentStarsBrightness == -1){
				this.snCurrentStarsBrightness = this.snDefaultStarsBrightness;
				e.target.cpCurrentStarsBrightness = this.snDefaultStarsBrightness;		
			} else {
				this.snCurrentStarsBrightness = e.target.cpCurrentStarsBrightness;
			}
			
			// update control panel slider and text
			snControlPanel.changeStarsBrightnessValue();
			
			// change sky's stars brightness
			for (var s:uint = 0; s < stars.length; s++)
			{
				stars[s].setAlpha(this.snCurrentStarsBrightness);
			}
			
			trace("-- changeStarsBrightness()");
			trace("Current Brightness: "+e.target.cpCurrentStarsBrightness);
			
		
		}
		
		
		
		/**
		 *	Function TODO: Change Twinkling after Control Panel Event "changeStarsTwinkling"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeStarsTwinkling(e:Event):void
		{
			// Set New Stars Twinkling value (default if -1)
			if(e.target.cpCurrentStarsTwinkling == -1){
				this.snCurrentStarsTwinkling = this.snDefaultStarsTwinkling;
				e.target.cpCurrentStarsTwinkling = this.snDefaultStarsTwinkling;		
			} else {
				this.snCurrentStarsTwinkling = e.target.cpCurrentStarsTwinkling;
			}
			
			// update control panel slider and text
			snControlPanel.changeStarsTwinklingValue();
						
			for (var s:uint = 0; s < stars.length; s++ )
			{
				stars[s].setTwinkle(this.snCurrentStarsTwinkling);
				// if twinkling off, reset alpha to default value
				if(this.snCurrentStarsTwinkling==0)	stars[s].setAlpha(this.snCurrentStarsBrightness);	
			}
		
			trace("-- changeStarsTwinkling()");
			trace("Current Twinkling: "+e.target.cpCurrentStarsTwinkling);
		
		}
		
		
		
		
		/**
		 *	Function TODO: Change Movement after Control Panel Event "changeStarsMovement"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeStarsMovement(e:Event):void
		{
			// Set New Stars Movement value (default if 0)
			if(e.target.cpCurrentStarsMovement == -100){
				this.snCurrentStarsMovement = this.snDefaultStarsMovement;
				e.target.cpCurrentStarsMovement = this.snDefaultStarsMovement;		
			} else {
				this.snCurrentStarsMovement = e.target.cpCurrentStarsMovement;
			}
			
			// update control panel slider and text
			snControlPanel.changeStarsMovementValue();
			
			// change sky's stars speed
			for (var s:uint = 0; s < stars.length; s++ )
			{
				stars[s].setSpeed(this.snCurrentStarsMovement);
			}	
		
			trace("-- changeStarsMovement()");
			trace("Current Movement: "+e.target.cpCurrentStarsTwinkling);
		
		}
		
		
	
		//- CHANGE SHOOTING STARS METHODS ---------------------------------------------------------------

	
		
		/**
		 *	Function TODO: Change Shooting Stars Frequency after Control Panel Event "changeSStarsFrequency"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeSStarsFrequency(e:Event):void
		{
			// Set ShootingStars Frequency value (default if -1)
			if(e.target.cpCurrentSStarsFrequency == -1){
				this.snCurrentSStarsFrequency = this.snDefaultSStarsFrequency;
				e.target.cpCurrentSStarsFrequency = this.snDefaultSStarsFrequency;		
			} else {
				this.snCurrentSStarsFrequency = e.target.cpCurrentSStarsFrequency;
			}
			
			// update control panel slider and text
			snControlPanel.changeSStarsFrequencyValue();
						
			// stop running timer and create new one
			timer.stop();
			timer.removeEventListener (TimerEvent.TIMER, createShootingStar);
			
			// show new Shooting Stars, using new timer
			showShootingStar();
				
			trace("-- changeSStarsFrequency()");
			trace("Current Frequency: "+e.target.cpCurrentSStarsFrequency);
				
		}
		
		
		
		/**
		 *	Function TODO: Change Shooting Stars Speed after Control Panel Event "changeSStarsSpeed"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeSStarsSpeed(e:Event):void
		{	
			// Set Shooting Stars Speed value (default if -1)
			if(e.target.cpCurrentSStarsSpeed == -1){
				this.snCurrentSStarsSpeed = this.snDefaultSStarsSpeed;
				e.target.cpCurrentSStarsSpeed = this.snDefaultSStarsSpeed;		
			} else {
				this.snCurrentSStarsSpeed = e.target.cpCurrentSStarsSpeed;
			}
			
			// update control panel slider and text
			snControlPanel.changeSStarsSpeedValue();
			
			// change shooting stars scale
			// cast Object to MovieClip. Verify if Object is ShootingStar
			for (var m:uint = 1; m < numChildren; m++)
			{
				if((getChildAt(m) as MovieClip) is ShootingStar)
				{
					(getChildAt(m) as MovieClip).setSpeed(e.target.cpCurrentSStarsSpeed);
				}
			}			
				
				
			trace("-- changeSStarsSpeed()");
			trace("Current Speed: "+e.target.cpCurrentSStarsSpeed);				
		}
		
	
	
		/**
		 *	Function TODO: Change Shooting Stars Trajectorie after Control Panel Event "changeSStarsTrajectorie"
		 *
		 *  @param: $e - Event: Control Panel generate Event.
		 *  @return: void
		 */
		public function changeSStarsTrajectorie(e:Event):void
		{			
			// Set Shooting Stars Trajectorie value (default if -100)
			if(e.target.cpCurrentSStarsTrajectorie == -100){
				this.snCurrentSStarsTrajectorie = this.snDefaultSStarsTrajectorie;
				e.target.cpCurrentSStarsTrajectorie = this.snDefaultSStarsTrajectorie;		
			} else {
				this.snCurrentSStarsTrajectorie = e.target.cpCurrentSStarsTrajectorie;
			}
			
			// update control panel slider and text
			snControlPanel.changeSStarsTrajectorieValue();
			
			// do not edit current shooting stars
			// current shooting stars will die with initial trajectorie
			
			trace("-- changeSStarsTrajectorie()");
			trace("Current Speed: "+e.target.cpCurrentSStarsTrajectorie);		
				
		}
		
		
	//- END CLASS 
	}
	
//- END PACKAGE 
}