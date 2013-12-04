package classes {
 
	import flash.display.Sprite;
 
	public class Sky extends Sprite {
 
  		//- CONSTRUCTOR -------------------------------------------------------------------------------

		/**
		 *	Function TODO: Create an instance of Sky.
		 *
		 *  @param: void.		 
		 *  @return: void
		 */
		function Sky():void
		{
			// create black rectangle, 800x600
			graphics.beginFill(0x000000);
			graphics.drawRect( 0, 0, 800, 600);
		}
		

	//- END CLASS 
	}
	
//- END PACKAGE 
}