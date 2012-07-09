// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.dialogs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	import com.bit101.components.Accordion;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;

	/**
	 * @author lteixeira
	 */
	public class SelectFileDialog
	{
		private var callback:Function;
		private var window:Window;
		private var accordion:Accordion;
		private var okButton:PushButton;
		private var cancelButton:PushButton;
		private var loadFromHDWindow:Window;
		private var loadFromUrlWindow:Window;
		private var urlFileText:Text;
		private var selectFileButton:PushButton;
		
		private var hdFile:HDFile;
		
		
		//
		// constructor
		//
		public function SelectFileDialog(parent:DisplayObjectContainer)
		{
			window = new Window(parent, 0, 0, "Select File...");
			window.setSize(300, 190);
			window.draggable = false;
			window.visible = false;
			
			accordion = new Accordion(window, 10, 10);
			accordion.setSize(275, 110);

			okButton = new PushButton(window, 135, 135, "ok", okButtonAction);
			okButton.setSize(70, 20);
			cancelButton = new PushButton(window, 215, 135, "cancel", cancelButtonAction);
			cancelButton.setSize(70, 20);
			
			loadFromHDWindow = accordion.getWindowAt(0);
			loadFromUrlWindow = accordion.getWindowAt(1);
			loadFromHDWindow.title = "from hard disk";
			loadFromUrlWindow.title = "from url";

			new Label(loadFromHDWindow, 10, 10, "click to select a file from your computer.");
			selectFileButton = new PushButton(loadFromHDWindow, 10, 35, "select file", selectFileButtonAction);
			
			new Label(loadFromUrlWindow, 10, 10, "file url:");
			urlFileText = new Text(loadFromUrlWindow, 10, 30);
			urlFileText.textField.multiline = false;
			urlFileText.setSize(250, 21);
		}


		//
		// public interface
		//
		public function get visible():Boolean
		{
			return window.visible;
		}
		
		public function set visible(flag:Boolean):void
		{
			window.visible = flag;
			
			if (flag)
			{
				urlFileText.text = "";
				hdFile = null;
			}
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
		
		public function setCallback(callback:Function):void
		{
			this.callback = callback;
		}


		//
		// private methods
		//
		private function okButtonAction(event:MouseEvent):void
		{
			CommonDialogs.hideSelectFile();
			
			if (!loadFromHDWindow.minimized)
			{
				callback(hdFile);
			}
			else if (!loadFromUrlWindow.minimized)
			{
				var urlFile:URLFile = new URLFile();
				urlFile.url = urlFileText.text;
				callback(urlFile);
			}
			
			hdFile = null;
		}
		
		private function cancelButtonAction(event:MouseEvent):void
		{
			CommonDialogs.hideSelectFile();
			hdFile = null;
		}
		
		private function selectFileButtonAction(event:MouseEvent):void
		{
			hdFile = new HDFile();
			hdFile.file = new FileReference();
			hdFile.file.browse([ new FileFilter("Images (GIF, JPG, PNG)", "*.jpg;*.gif;*.png"), new FileFilter("GIF", "*.gif"), new FileFilter("JPG", "*.jpg"), new FileFilter("PNG", "*.png") ]);
		}
	}
}
