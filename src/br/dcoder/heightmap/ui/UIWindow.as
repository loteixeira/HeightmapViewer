// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.ui
{
	import com.bit101.components.Window;
	
	/**
	 * @author lteixeira
	 */
	public class UIWindow
	{
		protected var proxy:EngineProxy;
		protected var window:Window;
		
		public function UIWindow(proxy:EngineProxy, window:Window, title:String)
		{
			this.proxy = proxy;
			this.window = window;
			this.window.title = title;
		}
		
		public function getWindow():Window
		{
			return window;
		}
	}
}
