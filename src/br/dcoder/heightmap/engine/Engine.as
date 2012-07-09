// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.engine
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import br.dcoder.console.*;
	
	import com.adobe.utils.PerspectiveMatrix3D;

	/**
	 * @author lteixeira
	 */
	public class Engine
	{
		private static const MAX_BITMAP_SIZE:uint = 128;
		
		private var stage:Stage;
		private var stage3d:Stage3D;
		private var context3d:Context3D;
		
		private var reconfigureBackBuffer:Boolean;
		private var antiAliasing:uint;
		private var fieldOfView:Number;
		private var aspect:Number;
		private var red:Number, green:Number, blue:Number;
		
		private var mouseInput:MouseInput;
		private var mesh:Mesh;
		
		private var bitmapData:BitmapData, topBitmapData:BitmapData, bottomBitmapData:BitmapData;
		private var textureBitmapData:BitmapData;
		private var textureWidth:uint, textureHeight:uint;
		private var heightValue:Number;
		private var middle:uint;
		private var programType:String;
		
		
		//
		// constructor
		//
		public function Engine(stage:Stage)
		{
			this.stage = stage;
			
			reconfigureBackBuffer = false;
			antiAliasing = 0;
			fieldOfView = 45.0 * (Math.PI / 180.0);
			aspect = stage.stageWidth / stage.stageHeight;
			red = green = blue = 0;
			
			this.stage.addEventListener(Event.RESIZE, resize);
			mouseInput = new MouseInput(stage);
			
			stage3d = stage.stage3Ds[0];
			stage3d.x = stage3d.y = 0;
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, context3dCreate);
			stage3d.requestContext3D();
		}
		
		
		//
		// public interface
		//
		public function update(data:Object):void
		{
			try
			{
				var updateGeometry:Boolean = false;
				var updateTexture:Boolean = false;
				var updateProgram:Boolean = false;
			
				var textureData:Object = data["texture"];
				var heightmapData:Object = data["heightmap"];
				var visualData:Object = data["visual"];
			
				// texture window
				if (textureData)
				{
					if (textureData["middle"])
					{
						middle = Math.round(textureData["middle"]);
						
						if (isNaN(middle) || middle < 0 || middle > 255)
							throw new Error("Invalid texture middle value (" + middle + ").");
						
						updateTexture = true;
					}
				
					if (textureData["dimension"])
					{
						if (textureData["dimension"] == "64x64")
							textureWidth = textureHeight = 64;
						else if (textureData["dimension"] == "128x128")
							textureWidth = textureHeight = 128;
						else if (textureData["dimension"] == "256x256")
							textureWidth = textureHeight = 256;
						else if (textureData["dimension"] == "512x512")
							textureWidth = textureHeight = 512;
						else if (textureData["dimension"] == "1024x1024")
							textureWidth = textureHeight = 1024;
						else
							throw new Error("Invalid texture dimension (" + textureData["dimension"] + ").");
						
						updateTexture = true;	
					}
				
					if (textureData["topBitmap"])
					{
						topBitmapData = textureData["topBitmap"];
						updateTexture = true;
					}
				
					if (textureData["bottomBitmap"])
					{
						bottomBitmapData = textureData["bottomBitmap"];
						updateTexture = true;
					}
				}
			
				// heightmap window
				if (heightmapData)
				{
					if (heightmapData["height"])
					{
						heightValue = (heightmapData["height"] * 0.000078125) / 5;
						
						if (isNaN(heightmapData["height"]) || heightmapData["height"] < 1 || heightmapData["height"] > 10)
							throw new Error("Invalid heightmap height value (" + heightmapData["height"] + ").");
						
						updateGeometry = true;
					}
				
					if (heightmapData["bitmap"])
					{
						bitmapData = heightmapData["bitmap"];
						updateGeometry = true;
						updateTexture = true;
					
						// if bitmap width or height is bigger than MAX_BITMAP_SIZE (128 pixels)
						// let's scale it to fit a 128x128 rectangle.
						if (bitmapData.width > MAX_BITMAP_SIZE || bitmapData.height > MAX_BITMAP_SIZE)
						{
							//cpln("transparent = " + bitmapData.transparent);
							var scale:Number = MAX_BITMAP_SIZE / Math.max(bitmapData.width, bitmapData.height);
							var matrix:Matrix = new Matrix();
							matrix.scale(scale, scale);
						
							var scaledBitmap:BitmapData = new BitmapData(Math.min(bitmapData.width * scale, MAX_BITMAP_SIZE), Math.min(bitmapData.height * scale, MAX_BITMAP_SIZE));
							scaledBitmap.draw(bitmapData, matrix);
							bitmapData = scaledBitmap;
							cpln("w = " + scaledBitmap.width + ", h = " + scaledBitmap.height); 
						}
					}
				}
			
				// visual window
				if (visualData)
				{
					if (visualData["light"])
					{
						if (visualData["light"] == "none")
							programType = Factory.NO_LIGHT_PROGRAM;
						else if (visualData["light"] == "directional")
							programType = Factory.DIRECTIONAL_LIGHT_PROGRAM;
						else if (visualData["light"] == "point")
							programType = Factory.POINT_LIGHT_PROGRAM;
						else
							throw new Error("Invalid light type (" + visualData["light"] + ").");
						
						updateProgram = true;
					}
				
					if (visualData["antiAliasing"])
					{
						if (antiAliasing != parseInt(visualData["antiAliasing"]))
						{
							antiAliasing = parseInt(visualData["antiAliasing"]);
							
							if (isNaN(antiAliasing) || (antiAliasing != 0 && antiAliasing != 2 && antiAliasing != 4 && antiAliasing != 8))
								throw new Error("Invalid anti aliasing value (" + antiAliasing + ").");
							
							reconfigureBackBuffer = true;
						}
					}
				
					if (visualData["background"])
					{
						if (isNaN(visualData["background"]))
							throw new Error("Invalid background value (" + (visualData["background"] as uint).toString(16) + ").");
						
						red = (visualData["background"] >> 16 & 0xFF) / 255;
						green = (visualData["background"] >> 8 & 0xFF) / 255;
						blue = (visualData["background"] & 0xFF) / 255;
					}
				}
			
				// update terrain geometry
				if (updateGeometry)
				{
					var geometry:Geometry = Factory.createGeometry(context3d, bitmapData, heightValue);
					mesh.setGeometry(geometry);
				}
			
				// update terrain texture
				if (updateTexture)
				{
					textureBitmapData = Factory.createTexture(bitmapData, topBitmapData, bottomBitmapData, middle, textureWidth, textureHeight);
					mesh.setTexture(textureBitmapData);
				}
			
				// update terrain gpu program
				if (updateProgram)
				{
					var shaders:Array = Factory.createProgram(programType);
					mesh.setProgram(shaders[0], shaders[1], shaders[2]);
				}
			}
			catch (e:Error)
			{
				cpln("An error was caught:");
				cpln(e);
				cpln("");
				Console.instance.show();
			}
		}
		
		
		//
		// private methods
		//
		private function resize(event:Event):void
		{
			aspect = stage.stageWidth / stage.stageHeight;

			if (context3d != null)
				reconfigureBackBuffer = true;
		}
		
		private function context3dCreate(event:Event):void
		{
			context3d = stage3d.context3D;
			context3d.enableErrorChecking = true;
			context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, antiAliasing);
			
			cpln("driver info:");
			cpln(context3d.driverInfo);
			cpln("");

			mesh = new Mesh(context3d);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(event:Event):void
		{
			if (reconfigureBackBuffer)
			{
				context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, antiAliasing);
				reconfigureBackBuffer = false;
			}
			
			context3d.clear(red, green, blue);
	
			if (bitmapData)
			{
				var maxSize:uint = Math.max(bitmapData.width, bitmapData.height);
				var distance:Number = (maxSize / 10) + ((4 * maxSize) / 64);
				
				var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
				projection.perspectiveFieldOfViewRH(fieldOfView, aspect, 1, 100);
				var modelview:PerspectiveMatrix3D = new PerspectiveMatrix3D();
				modelview.prependTranslation(0, 1, -distance);
				mouseInput.transformModelview(modelview);
				
				mesh.render(projection, modelview);
			}
			
			context3d.present();
		}
	}
}
