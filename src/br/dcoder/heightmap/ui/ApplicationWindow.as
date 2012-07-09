// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.ui
{
	import flash.events.MouseEvent;
	
	import br.dcoder.console.*;
	import br.dcoder.heightmap.ApplicationMain;
	import br.dcoder.heightmap.dialogs.CommonDialogs;

	import com.bit101.components.PushButton;
	import com.bit101.components.Window;

	/**
	 * @author lteixeira
	 */
	public class ApplicationWindow extends UIWindow
	{
		private var showHideConsoleButton:PushButton;
		private var creditsButton:PushButton;
		private var helpButton:PushButton;
		
		public function ApplicationWindow(proxy:EngineProxy, window:Window)
		{
			super(proxy, window, "Application");
			
			showHideConsoleButton = new PushButton(window, 10, 10, "show/hide console", showHideConsoleButtonAction);
			creditsButton = new PushButton(window, 10, 40, "credits", creditsButtonAction);
			helpButton = new PushButton(window, 10, 70, "help", helpButtonAction);
		}
		
		private function showHideConsoleButtonAction(event:MouseEvent):void
		{
			if (Console.instance.isVisible())
				Console.instance.hide();
			else
				Console.instance.show();
		}
		
		private function creditsButtonAction(event:MouseEvent):void
		{
			var message:String;
			message = ApplicationMain.NAME + " " + ApplicationMain.VERSION + "\n\n";
			
			message += "Create by Lucas Teixeira\n";
			message += "http://disturbedcoder.com/\n\n";
			
			message += "Copyright 2011 Lucas Teixeira\n";
			message += "This software is distribuited under the terms of the GNU Lesser Public License.";
			
			CommonDialogs.showInfo(message, "Credits");
		}
		
		private function helpButtonAction(event:MouseEvent):void
		{
			var message:String;
			message = ApplicationMain.NAME + " is a open source heightmap viewer created with Actionscript3/FlexSDK and Stage3D (molehill) API.\n";
			message += "This software is distribuited under the terms of the GNU Lesser Public License.\n";
			message += "For more information see 'Credits'.\n\n\n";
			
			message += "* Application parameters:\n";
			message += ApplicationMain.NAME + " SWF file can receive parameters in order to adjust how the heightmap mesh should looks and behave.\n";
			message += "Example: HeightmapViewer.swf?texture.dimension=1024x1024&visual.light=point\n\n";
			message += "General parameters:\n";
			message += "- no_ui: If true don't show accordion component with application options.\n";
			message += "- no_fps: If true hide fps counter.\n\n";
			message += "Texture parameters:\n";
			message += "- texture.middle: Set the edge between top and bottom texture when creating result texture. Valid range is [0..255].\n";
			message += "- texture.dimension: Set the size of result texture. Valid values are 64x64, 128x128, 256x256, 512x512 and 1024x1024.\n";
			message += "- texture.top_file: URL to image file to be used as top texture.\n";
			message += "- texture.bottom_file: URL to image file to be used as bottom texture.\n\n";
			message += "Heightmap mesh parameters:\n";
			message += "- heightmap.height: Height of terrain. Valid range is [1..10].\n";
			message += "- heightmap.file: URL to image file to be used to create heightmap mesh.\n\n";
			message += "Visual parameters:\n";
			message += "- visual.light: Set light source type. Valid values are none, directional and point.\n";
			message += "- visual.anti_aliasing: Set anti aliasing. Valid values are 0, 2, 4 and 8.\n";
			message += "- visual.background: Set application background color. Must be specified in hexadecimal.\n\n\n";
			
			message += "* Console:\n";
			message += "AS3Console was created by Lucas Teixeira and is distribuited under the terms of the GNU Lesser Public License.\n";
			message += "Project page: http://code.google.com/p/as3console/\n";
			message += "Press Ctrl+M to show/hide console component.\n";
			message += "Use up/down arrows to navigate through input history.\n\n";
			message += "Console commands:\n";
			message += "- alpha [value]: If value is specified set console alpha to value. Otherwise print current alpha value.\n";
			message += "- clear: Clear console text field.\n";
			message += "- hide: Hide console component.\n";
			message += "- mem: Print amount of memory used by this flash player instance.\n";
			message += "- version: Point console version information.\n";
			
			CommonDialogs.showInfo(message, "Help");
		}
	}
}
