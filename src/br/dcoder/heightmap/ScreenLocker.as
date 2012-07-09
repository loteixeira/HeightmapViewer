// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author lteixeira
	 */
	public class ScreenLocker
	{
		private var stage:Stage;
		private var layer:Sprite;
		
		public function ScreenLocker(stage:Stage)
		{
			this.stage = stage;
			
			stage.addEventListener(Event.RESIZE, resize);
			
			layer = new Sprite();
			layer.visible = false;
			stage.addChild(layer);
			drawLayer();
		}

		public function get visible():Boolean
		{
			return layer.visible;
		}
		
		public function set visible(flag:Boolean):void
		{
			layer.visible = flag;
		}
		
		private function drawLayer():void
		{
			layer.graphics.clear();
			layer.graphics.beginFill(0, 0.5);
			layer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			layer.graphics.endFill();
		}
		
		private function resize(event:Event):void
		{
			drawLayer();
		}
	}
}
