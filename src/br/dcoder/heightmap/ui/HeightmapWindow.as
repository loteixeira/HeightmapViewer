// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.ui
{
	import flash.events.MouseEvent;

	import br.dcoder.heightmap.Params;
	import br.dcoder.heightmap.dialogs.CommonDialogs;
	import br.dcoder.heightmap.dialogs.File;

	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;

	/**
	 * @author lteixeira
	 */
	public class HeightmapWindow extends UIWindow
	{
		private var heightSlider:HUISlider;
		private var loadButton:PushButton;
		private var applyButton:PushButton;
		
		private var heightmapFile:File;
		
		public function HeightmapWindow(params:Params, proxy:EngineProxy, window:Window)
		{
			super(proxy, window, "Heightmap");

			new Label(window, 10, 10, "height:");
			heightSlider = new HUISlider(window, 0, 30);
			heightSlider.setSize(130, 10);
			heightSlider.minimum = 1;
			heightSlider.maximum = 10;
			heightSlider.value = params.heightmapHeight;
			
			new Label(window, 10, 50, "load:");
			loadButton = new PushButton(window, 10, 70, "heightmap image", loadButtonAction);
			
			applyButton = new PushButton(window, 60, 105, "apply", applyAction);
			applyButton.setSize(50, 20);
		}
		
		private function loadButtonAction(event:MouseEvent):void
		{
			CommonDialogs.showSelectFile(function(file:File):void
			{
				heightmapFile = file;
			});
		}
		
		private function applyAction(event:MouseEvent):void
		{
			var data:Object =
			{
				heightmap:
				{
					height: heightSlider.value
				}
			};
			
			if (heightmapFile)
			{
				CommonDialogs.showLoadFile([ heightmapFile ], function(bitmaps:Array):void
				{
					if (bitmaps[0])
						data["heightmap"]["bitmap"] = bitmaps[0];
						
					proxy.updateEngine(data);
				});
			}
			else
			{
				proxy.updateEngine(data);
			}
		}
	}
}
