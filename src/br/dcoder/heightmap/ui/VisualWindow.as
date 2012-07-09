// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.ui
{
	import flash.events.MouseEvent;
	
	import br.dcoder.heightmap.Params;

	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;

	/**
	 * @author lteixeira
	 */
	public class VisualWindow extends UIWindow
	{
		private var lightComboBox:ComboBox;
		private var antiAliasingComboBox:ComboBox;
		private var backgroundColorChooser:ColorChooser;
		private var applyButton:PushButton;
		
		public function VisualWindow(params:Params, proxy:EngineProxy, window:Window)
		{
			super(proxy, window, "Visual");
			
			new Label(window, 10, 10, "light:");
			lightComboBox = new ComboBox(window, 10, 30, params.visualLight, [ "none", "directional", "point" ]);
			
			new Label(window, 10, 60, "anti aliasing:");
			antiAliasingComboBox = new ComboBox(window, 10, 80, params.visualAntiAliasing, [ "0", "2", "4", "8" ]);
			
			new Label(window, 10, 110, "background:");
			backgroundColorChooser = new ColorChooser(window, 10, 130, params.visualBackground);
			backgroundColorChooser.usePopup = true;
			
			applyButton = new PushButton(window, 60, 165, "apply", applyButtonAction);
			applyButton.setSize(50, 20);
		}
		
		private function applyButtonAction(event:MouseEvent):void
		{
			var data:Object =
			{
				visual:
				{
					light: lightComboBox.selectedItem,
					antiAliasing: antiAliasingComboBox.selectedItem,
					background: backgroundColorChooser.value
				}
			};
			
			proxy.updateEngine(data);
		}
	}
}
