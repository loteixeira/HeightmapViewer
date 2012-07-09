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

	import com.bit101.components.ComboBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	/**
	 * @author lteixeira
	 */
	public class TextureWindow extends UIWindow
	{
		private var middleSlider:HUISlider;
		private var dimensionComboBox:ComboBox;
		private var loadTopButton:PushButton;
		private var loadBottomButton:PushButton;
		private var applyButton:PushButton;
		
		private var topTexFile:File, bottomTexFile:File;

		public function TextureWindow(params:Params, proxy:EngineProxy, window:Window)
		{
			super(proxy, window, "Texture");
			
			new Label(window, 10, 10, "middle:");
			middleSlider = new HUISlider(window, 0, 30);
			middleSlider.setSize(130, 10);
			middleSlider.minimum = 0;
			middleSlider.maximum = 255;
			middleSlider.value = params.textureMiddle;
			
			new Label(window, 10, 50, "dimension:");
			dimensionComboBox = new ComboBox(window, 10, 70, params.textureDimension, [ "64x64", "128x128", "256x256", "512x512", "1024x1024" ]);
			
			new Label(window, 10, 100, "load:");
			loadTopButton = new PushButton(window, 10, 120, "terrain top", loadTopButtonAction);
			loadBottomButton = new PushButton(window, 10, 145, "terrain bottom", loadBottomButtonAction);
			
			applyButton = new PushButton(window, 60, 180, "apply", applyButtonAction);
			applyButton.setSize(50, 20);
		}
		
		private function loadTopButtonAction(event:MouseEvent):void
		{
			CommonDialogs.showSelectFile(function(file:File):void
			{
				topTexFile = file;
			});
		}
		
		private function loadBottomButtonAction(event:MouseEvent):void
		{
			CommonDialogs.showSelectFile(function(file:File):void
			{
				bottomTexFile = file;
			});
		}
		
		private function applyButtonAction(event:MouseEvent):void
		{
			var data:Object =
			{
				texture:
				{
					middle: middleSlider.value,
					dimension: dimensionComboBox.selectedItem
				}
			};
			
			if (topTexFile || bottomTexFile)
			{
				var files:Array = [ topTexFile, bottomTexFile ];
				CommonDialogs.showLoadFile(files, function(bitmaps:Array):void
				{
					if (bitmaps[0])
						data["texture"]["topBitmap"] = bitmaps[0];
					if (bitmaps[1])
						data["texture"]["bottomBitmap"] = bitmaps[1];
						
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
