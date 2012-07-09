// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.engine
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author lteixeira
	 */
	public class MouseInput
	{
		private static const MIN_VELOCITY:Number = 0.0001;
		private static const FRICTION_MULT:Number = 0.95;
		private static const ROTX_MAX_ANGLE:Number = 80;
		private static const ROTX_MIN_ANGLE:Number = 35;
		
		private var stage:Stage;
		private var mouseLayer:Sprite;
		private var rotating:Boolean;
		private var pivot:Point, velocity:Point;
		private var rotX:Number, rotY:Number;
		
		public function MouseInput(stage:Stage)
		{
			this.stage = stage;
			stage.addEventListener(Event.RESIZE, stageResize);
			
			mouseLayer = new Sprite();
			mouseLayer.graphics.beginFill(0, 0);
			mouseLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			mouseLayer.graphics.endFill();
			stage.addChild(mouseLayer);
			
			rotating = false;
			pivot = new Point();
			velocity = new Point();
			rotX = 40;
			rotY = 0;
			
			mouseLayer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function transformModelview(modelview:Matrix3D):void
		{
			modelview.prependRotation(rotX, new Vector3D(1, 0, 0));
			modelview.prependRotation(rotY, new Vector3D(0, 1, 0));
		}
		
		private function stageResize(event:Event):void
		{
			mouseLayer.graphics.clear();
			mouseLayer.graphics.beginFill(0, 0);
			mouseLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			mouseLayer.graphics.endFill();
		}
		
		private function mouseDown(event:MouseEvent):void
		{
			rotating = true;
			Mouse.cursor = MouseCursor.HAND;
			pivot.setTo(event.stageX, event.stageY);
		}

		private function mouseUp(event:MouseEvent):void
		{
			if (rotating)
			{
				rotating = false;
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		private function enterFrame(event:Event):void
		{
			// if is rotating update velocity
			if (rotating)
			{
				velocity.x += (stage.mouseX - pivot.x) / stage.stageWidth * 7.5;
				velocity.y += (stage.mouseY - pivot.y) / stage.stageHeight * 7.5;
				pivot.setTo(stage.mouseX, stage.mouseY);
			}
			
			// apply friction
			if (Math.abs(velocity.x) < MIN_VELOCITY)
			{
				velocity.x = 0;
			}
			else
			{
				velocity.x *= FRICTION_MULT;
			}
			
			if (Math.abs(velocity.y) < MIN_VELOCITY)
			{
				velocity.y = 0;
			}
			else
			{
				velocity.y *= FRICTION_MULT;
			}
			
			// update X axis angle rotation
			rotX += velocity.y;
			
			if (rotX >= 360)
				rotX -= 360;
			else if (rotX < 0)
				rotX += 360;
			
			// set min and max angles limit for X axis rotation
			if (rotX > ROTX_MAX_ANGLE)
				rotX = ROTX_MAX_ANGLE;
			else if (rotX < ROTX_MIN_ANGLE)
				rotX = ROTX_MIN_ANGLE;
				
			// update Y axis angle rotation
			rotY += velocity.x;
			
			if (rotY >= 360)
				rotY -= 360;
			else if (rotY < 0)
				rotY += 360;
		}
	}
}
