// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.ui
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import br.dcoder.heightmap.ApplicationMain;
	import br.dcoder.heightmap.Params;
	import br.dcoder.heightmap.engine.Engine;
	
	import com.bit101.components.Accordion;
	import com.bit101.components.FPSMeter;

	/**
	 * @author lteixeira
	 */
	public class UserInterface extends Sprite implements EngineProxy
	{
		private var engine:Engine;
		private var fpsMeter:FPSMeter;
		private var accordion:Accordion;
		private var textureWindow:TextureWindow;
		private var heightmapWindow:HeightmapWindow;
		private var visualWindow:VisualWindow; 
		private var applicationWindow:ApplicationWindow;

		public function UserInterface(params:Params, engine:Engine)
		{
			this.engine = engine;
			
			fpsMeter = new FPSMeter(this, 10, 15);
			fpsMeter.start();
			fpsMeter.visible = !params.noFPS;
			
			accordion = new Accordion(this, 10, 15);
			accordion.setSize(120, 420);
			accordion.addWindow("");
			accordion.addWindow("");
			accordion.visible = !params.noUI;
			
			applicationWindow = new ApplicationWindow(this, accordion.getWindowAt(0));
			heightmapWindow = new HeightmapWindow(params, this, accordion.getWindowAt(1));
			textureWindow = new TextureWindow(params, this, accordion.getWindowAt(2));
			visualWindow = new VisualWindow(params, this, accordion.getWindowAt(3));
			
			if (params.noUI)
			{
				var infoTextField:TextField = new TextField();
				infoTextField.autoSize = TextFieldAutoSize.LEFT;
				infoTextField.mouseEnabled = false;
				infoTextField.selectable = false;
				infoTextField.text = ApplicationMain.NAME + " "  + ApplicationMain.VERSION;
				infoTextField.x = 15;
				infoTextField.y = 15;
				addChild(infoTextField);
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xffffff;
				//textFormat.color = !(params.visualBackground);
				textFormat.font = "_sans";
				textFormat.size = 12;
				infoTextField.setTextFormat(textFormat);
			}
		}
		
		public function resize(rect:Rectangle):void
		{
			fpsMeter.x = rect.width - 55;
			fpsMeter.y = 15;
		}
		
		public function updateEngine(data:Object):void
		{
			engine.update(data);
		}
	}
}
