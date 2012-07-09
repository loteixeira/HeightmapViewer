// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.dialogs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;

	/**
	 * @author lteixeira
	 */
	public class InfoDialog
	{
		private var window:Window;
		private var textArea:TextArea;
		private var okButton:PushButton;
		
		public function InfoDialog(parent:DisplayObjectContainer)
		{
			window = new Window(parent, 0, 0, "Information");
			window.setSize(400, 300);
			window.draggable = false;
			window.visible = false;
			
			textArea = new TextArea(window, 10, 10);
			textArea.setSize(380, 230);
			textArea.editable = false;
			
			okButton = new PushButton(window, 290, 250, "ok", okButtonAction);
		}
		
		public function get visible():Boolean
		{
			return window.visible;
		}
		
		public function set visible(flag:Boolean):void
		{
			window.visible = flag;
		}
		
		public function get x():Number
		{
			return window.x;
		}
		
		public function set x(x:Number):void
		{
			window.x = x;
		}
		
		public function get y():Number
		{
			return window.y;
		}
		
		public function set y(y:Number):void
		{
			window.y = y;
		}
		
		public function get width():Number
		{
			return window.width;
		}
		
		public function set width(width:Number):void
		{
			window.width = width;
		}
		
		public function get height():Number
		{
			return window.height;
		}
		
		public function set height(height:Number):void
		{
			window.height = height;
		}
		
		public function setContent(message:String, title:String):void
		{
			window.title = title;
			textArea.text = message;
		}
		
		private function okButtonAction(event:MouseEvent):void
		{
			CommonDialogs.hideInfo();
		}
	}
}
