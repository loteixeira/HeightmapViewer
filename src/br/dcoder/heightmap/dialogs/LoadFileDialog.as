// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.dialogs
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	import br.dcoder.console.*;
	
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.Window;
	
	/**
	 * @author lteixeira
	 */
	public class LoadFileDialog
	{
		private static const PROXY_URL:String = "proxy.php?url="; 
		
		private var files:Array;
		private var pointer:uint, count:uint, loaded:uint;
		private var callback:Function;
		private var window:Window;
		private var label:Label;
		private var progressBar:ProgressBar;
		
		private var result:Array;
		
		public function LoadFileDialog(parent:DisplayObjectContainer)
		{
			window = new Window(parent, 0, 0, "Loading File(s)...");
			window.setSize(200, 90);
			window.draggable = false;
			window.visible = false;
			
			label = new Label(window, 10, 10);
			
			progressBar = new ProgressBar(window, 10, 40);
			progressBar.setSize(180, 10);
		}
		
		public function get visible():Boolean
		{
			return window.visible;
		}
		
		public function set visible(flag:Boolean):void
		{
			window.visible = flag;
			
			if (flag)
			{
				pointer = loaded = 0;
				loadFile();
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
		
		public function setFiles(files:Array):void
		{
			this.files = files;
			count = 0;
			result = new Array();
			
			for (var i:uint = 0; i < files.length; i++)
			{
				result.push(null);
				
				if (files[i])
					count++;
			}
		}
		
		public function setCallback(callback:Function):void
		{
			this.callback = callback;
		}
		
		private function loadFile():void
		{
			if (!files[pointer])
			{
				pointer++;
				
				if (pointer < files.length)
				{
					loadFile();
				}
				else
				{
					done();
				}
			}
			else
			{
				label.text = "file " + (loaded + 1) + " of " + count;
				var file:File = files[pointer];
			
				// load local file
				if (file is HDFile)
				{
					try
					{
						var hdFile:HDFile = file as HDFile;
						var loader:Loader;
								
						var progressFunction:Function = function(event:ProgressEvent):void
						{
							progressBar.value = event.bytesLoaded / event.bytesTotal;
						};
						hdFile.file.addEventListener(ProgressEvent.PROGRESS, progressFunction);
				
						var completeFunction:Function = function(event:Event):void
						{
							hdFile.file.removeEventListener(ProgressEvent.PROGRESS, progressFunction);
							hdFile.file.removeEventListener(Event.COMPLETE, completeFunction);
					
							loader = new Loader();
							loader.contentLoaderInfo.addEventListener(Event.INIT, function(event:Event):void
							{
								if (loader.content)
									result[pointer] = (loader.content as Bitmap).bitmapData;
								else
									result[pointer] = null;
								
								loaded++;
								pointer++;
							
								if (pointer < files.length)
								{
									loadFile();
								}
								else
								{
									done();
								}
							});
							loader.loadBytes(hdFile.file.data);
						};
						hdFile.file.addEventListener(Event.COMPLETE, completeFunction);
						hdFile.file.addEventListener(IOErrorEvent.IO_ERROR, completeFunction);
						hdFile.file.load();
					}
					catch (e1:Error)
					{
						cpln("Error loading local file:");
						cpln(e1);
					}
				}
				// load remote file
				else if (file is URLFile)
				{
					try
					{
						var urlFile:URLFile = file as URLFile;
						loader = new Loader();
					
						loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function (event:ProgressEvent):void
						{
							progressBar.value = event.bytesLoaded / event.bytesTotal;
						});
					
						var initFunction:Function = function(event:Event):void
						{
							if (loader.content)
							{
								result[pointer] = (loader.content as Bitmap).bitmapData;
							}
							else
							{
								result[pointer] = null;
								cpln("Error loading remote file:");
								cpln((event as IOErrorEvent).text);
								cpln("");
								Console.instance.show();
							}
								
							loaded++;
							pointer++;
							
							if (pointer < files.length)
							{
								loadFile();
							}
							else
							{
								done();
							}
						};
						
						var url:String;
						
						if (urlFile.url.indexOf("/") == -1)
							url = urlFile.url;
						else
							url = PROXY_URL + urlFile.url;

						loader.contentLoaderInfo.addEventListener(Event.INIT, initFunction);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, initFunction);
						loader.load(new URLRequest(url));
					}
					catch (e2:Error)
					{
						cpln("Error loading remote file:");
						cpln(e2);
					}
				}
			}
		}
		
		private function done():void
		{
			CommonDialogs.hideLoadFile();
			callback(result);
		}
	}
}
