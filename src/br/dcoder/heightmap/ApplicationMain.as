// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import br.dcoder.console.*;
	import br.dcoder.heightmap.dialogs.CommonDialogs;
	import br.dcoder.heightmap.dialogs.URLFile;
	import br.dcoder.heightmap.engine.Engine;
	import br.dcoder.heightmap.ui.UserInterface;

	/**
	 * @author lteixeira
	 */
	public class ApplicationMain extends Sprite
	{
		public static const NAME:String = "Molehill Heightmap Viewer";
		public static const VERSION:String = "1.1";
		
		private var params:Params;
		private var engine:Engine;
		private var ui:UserInterface;
		private var screenLocker:ScreenLocker;
		
		private var topTexture:BitmapData, bottomTexture:BitmapData, heightmap:BitmapData;
		
		public function ApplicationMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			params = new Params(loaderInfo);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resize);
			
			Console.create(stage);
			Console.instance.area = new Rectangle(200, 100, 500, 400);
			Console.instance.caption = NAME + " " + VERSION;
			cpln("Starting " + NAME + " " + VERSION);
			cpln("by Lucas Teixeira (http://disturbedcoder.com/)");
			cpln("Press Ctrl+M to show/hide console window.");
			cpln("");
			Console.instance.hide();
			
			engine = new Engine(stage);
			
			ui = new UserInterface(params, engine);
			stage.addChild(ui);
			resize(null);
			
			screenLocker = new ScreenLocker(stage);
			CommonDialogs.init(stage, screenLocker);
			
			loadFiles();
		}
		
		private function resize(event:Event):void
		{
			ui.resize(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
		}
		
		private function loadFiles():void
		{
			CommonDialogs.showLoadFile([ new URLFile(params.heightmapFile), new URLFile(params.textureTopFile), new URLFile(params.textureBottomFile) ], function(bitmaps:Array):void
			{
				heightmap = bitmaps[0];
				topTexture = bitmaps[1];
				bottomTexture = bitmaps[2];
				updateEngine();
			});
		}
		
		private function updateEngine():void
		{
			var data:Object =
			{
				texture:
				{
					middle: params.textureMiddle,
					dimension: params.textureDimension,
					topBitmap: topTexture,
					bottomBitmap: bottomTexture
				},
				heightmap:
				{
					height: params.heightmapHeight,
					bitmap: heightmap
				},
				visual:
				{
					light: params.visualLight,
					antiAliasing: params.visualAntiAliasing,
					background: params.visualBackground
				}
			};
			
			heightmap = null;
			topTexture = null;
			bottomTexture = null;
			
			engine.update(data);
		}
	}
}
