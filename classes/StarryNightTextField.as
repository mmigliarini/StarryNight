package classes
{
	import flash.display.MovieClip;
	import flash.text.*;
	
	public class StarryNightTextField extends TextField
	{
		
		//- PUBLIC & PRIVATE VARIABLES ------------------------------------------------------------------
		 
		// Font size
		var myTextSize:uint;
		
		// Font Family
		var myFont:Font = new FontHumanst521_BT();		// Exported from Flash
		var myFormat:TextFormat = new TextFormat();
		
		
		
		
		//- CONSTRUCTOR ---------------------------------------------------------------------------------

		/**
		 *	Function TODO: Create an instance of StarryNightTextField with the given parameters.
		 *
		 *  @param: $myTextSize - uint: default value = 12. Create TextField with 12px text size
		 *  @param: $myTextAlign - String: default is Center.
		 *  @param: $dimension - Number: default value = 0.		
		 *  @return: void
		 */
		public function StarryNightTextField(myTextSize:uint=12, myTextAlign:String = ""):void
		{
			
			// set font size and name
			myFormat.font = myFont.fontName;
			myFormat.size = myTextSize;
			
			// set align
			if(myTextAlign=="left"){	
				myFormat.align = "left";
			} else {
				this.autoSize = TextFieldAutoSize.CENTER;
			}
						
			// text anti-aliasing
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.defaultTextFormat = myFormat;
			this.embedFonts = true;
			// set color
			this.textColor = 0xFFFFFF;
			// disable mouse (prevent underling on button)
			this.mouseEnabled = false;
		
		}
		
		

	//- END CLASS 
	}
	
//- END PACKAGE 
}