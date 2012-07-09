// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.dialogs
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import br.dcoder.heightmap.ScreenLocker;
	
	/**
	 * @author lteixeira
	 */
	public class CommonDialogs
	{
		private static var stage:Stage;
		private static var screenLocker:ScreenLocker;
		
		private static var selectFileDialog:SelectFileDialog;
		private static var loadFileDialog:LoadFileDialog;
		private static var infoDialog:InfoDialog;
		
		public static function init(stage:Stage, screenLocker:ScreenLocker):void
		{
			CommonDialogs.stage = stage;
			CommonDialogs.screenLocker = screenLocker;
			
			selectFileDialog = new SelectFileDialog(stage);
			loadFileDialog = new LoadFileDialog(stage);
			infoDialog = new InfoDialog(stage);
			
			stage.addEventListener(Event.RESIZE, function(event:Event):void
			{
				selectFileDialog.x = (stage.stageWidth - selectFileDialog.width) / 2;
				selectFileDialog.y = (stage.stageHeight - selectFileDialog.height) / 2;
				
				loadFileDialog.x = (stage.stageWidth - loadFileDialog.width) / 2;
				loadFileDialog.y = (stage.stageHeight - loadFileDialog.height) / 2;
				
				infoDialog.x = (stage.stageWidth - infoDialog.width) / 2;
				infoDialog.y = (stage.stageHeight - infoDialog.height) / 2;
			});
		}

		public static function showSelectFile(callback:Function):void
		{
			selectFileDialog.setCallback(callback);
			selectFileDialog.x = (stage.stageWidth - selectFileDialog.width) / 2;
			selectFileDialog.y = (stage.stageHeight - selectFileDialog.height) / 2;
			selectFileDialog.visible = true;
			screenLocker.visible = true;
		}
		
		public static function hideSelectFile():void
		{
			selectFileDialog.visible = false;
			screenLocker.visible = false;
		}
		
		public static function showLoadFile(files:Array, callback:Function):void
		{
			loadFileDialog.setFiles(files);
			loadFileDialog.setCallback(callback);
			loadFileDialog.x = (stage.stageWidth - loadFileDialog.width) / 2;
			loadFileDialog.y = (stage.stageHeight - loadFileDialog.height) / 2;
			loadFileDialog.visible = true;
			screenLocker.visible = true;
		}
		
		public static function hideLoadFile():void
		{
			loadFileDialog.visible = false;
			screenLocker.visible = false;
		}
		
		public static function showInfo(message:String, title:String):void
		{
			infoDialog.setContent(message, title);
			infoDialog.x = (stage.stageWidth - infoDialog.width) / 2;
			infoDialog.y = (stage.stageHeight - infoDialog.height) / 2;
			infoDialog.visible = true;
			screenLocker.visible = true;
		}
		
		public static function hideInfo():void
		{
			infoDialog.visible = false;
			screenLocker.visible = false;
		}
	}
}
