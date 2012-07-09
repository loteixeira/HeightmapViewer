// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.engine
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import br.dcoder.console.*;
	import br.dcoder.heightmap.TimeCounter;
	
	import com.adobe.utils.AGALMiniAssembler;

	/**
	 * @author lteixeira
	 */
	public class Factory
	{
		//
		// public constants
		//
		public static const NO_LIGHT_PROGRAM:String = "noLightProgram";
		public static const DIRECTIONAL_LIGHT_PROGRAM:String = "directionalLightProgram";
		public static const POINT_LIGHT_PROGRAM:String = "pointLightProgram";
		
		
		//
		// private constants
		//
		private static const TEXTURE_TRANSITION_MIDRANGE:uint = 50;
		
		
		//
		// public static methods
		//
		public static function createGeometry(context3d:Context3D, heightmap:BitmapData, heightValue:Number):Geometry
		{
			TimeCounter.start("createGeometry");
			
			var i:int, j:int;
			
			var width:uint = heightmap.width;
			var height:uint = heightmap.height;
			
			// create vertices
			var startX:Number = -width / 20;
			var startY:Number = -height / 20;
			var heightMult:Number = heightValue * (Math.max(width, height));
			var bytes:ByteArray = heightmap.getPixels(new Rectangle(0, 0, width, height));

			var position:Vector.<Number> = new Vector.<Number>();
			var texCoord:Vector.<Number> = new Vector.<Number>();
			var normal:Vector.<Number> = new Vector.<Number>();
			
			for (i = 0; i < width; i++)
			{
				for (j = 0; j < height; j++)
				{
					bytes.position = (j * width + i) * 4;
					var pixel:uint = bytes.readUnsignedInt();
					var x:Number = startX + (i / 10);
					var y:Number = (((pixel >> 16 & 0xff) + (pixel >> 8 & 0xff) + (pixel & 0xff)) / 3) * heightMult;
					var z:Number = startY + (j / 10);
					
					position.push(x, y, z);
					texCoord.push(i / width, j / height);
					normal.push(1.0, 0.0, 0.0);
				}
			}

			// create indices
			var index:Vector.<uint> = new Vector.<uint>();
			var offset:int = 0;
			
			for (i = 0; i < width - 1; i++)
			{
				for (j = 0; j < height - 1; j++)
				{
					var vert1:uint = (j * width) + i;
					var vert2:uint = (j * width) + i + 1;
					var vert3:uint = ((j + 1) * width) + i;
					index.push(vert1 - offset, vert2 - offset, vert3 - offset);
					
					vert1 = (j * width) + i + 1;
					vert2 = ((j + 1) * width) + i + 1;
					vert3 = ((j + 1) * width) + i;
					index.push(vert1 - offset, vert2 - offset, vert3 - offset);
				}
			}
			
			// calculate normals
			var n:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			for (i = 0; i < width; i++)
			{
				for (j = 0; j < height; j++)
				{
					var currentIndex:uint = j * width + i;
					var adjacency:Array = new Array();
				
					if (i > 0 && j > 0)
					{
						adjacency.push([ (j - 1) * width + i, currentIndex, j * width + i - 1 ]);
					}
					if (i < width - 1 && j > 0)
					{
						adjacency.push([ (j - 1) * width + i, (j - 1) * width + i + 1, currentIndex ]);
						adjacency.push([ (j - 1) * width + i + 1, j * width + i + 1, currentIndex ]);
					}
					if (i < width - 1 && j < height - 1)
					{
						adjacency.push([ currentIndex, j * width + i + 1, (j + 1) * width + i + 1 ]);
					}
					if (i > 0 && j < height - 1)
					{
						adjacency.push([ currentIndex, (j + 1) * width + i, (j + 1) * width + i - 1 ]);
						adjacency.push([ j * width + i - 1, currentIndex, (j + 1) * width + i - 1 ]);
					}
					
					n.setTo(0, 0, 0);
				
					for (var k:uint = 0; k < adjacency.length; k++)
					{
						var i1:uint = adjacency[k][0] * 3;
						var i2:uint = adjacency[k][1] * 3;
						var i3:uint = adjacency[k][2] * 3;
						v1.setTo(position[i2] - position[i1], position[i2 + 1] - position[i1 + 1], position[i2 + 2] - position[i1 + 2]);
						v2.setTo(position[i3] - position[i1], position[i3 + 1] - position[i1 + 1], position[i3 + 2] - position[i1 + 2]);
						var r:Vector3D = v1.crossProduct(v2);
						r.negate();
						n = n.add(r);
					}
				
					n.normalize();
					normal[currentIndex * 3] = n.x;
					normal[currentIndex * 3 + 1] = n.y;
					normal[currentIndex * 3 + 2] = n.z;
				}
			}
			
			// return geometry
			var geometry:Geometry = new Geometry(context3d, position, texCoord, normal, index);
			cpln("Geometry created in " + TimeCounter.stop("createGeometry") + "ms");
			return geometry;
		}
		
		public static function createTexture(heightmap:BitmapData, topTexture:BitmapData, bottomTexture:BitmapData, middle:uint, textureWidth:uint, textureHeight:uint):BitmapData
		{
			TimeCounter.start("createTexture");
			
			var result:BitmapData = new BitmapData(textureWidth, textureHeight, false);
			var resultWidth:uint = result.width, resultHeight:uint = result.height;
			var heightmapWidth:uint = heightmap.width, heightmapHeight:uint = heightmap.height;
			var factorX:Number = heightmapWidth / resultWidth;
			var factorY:Number = heightmapHeight / resultHeight;
			
			for (var i:uint = 0; i < resultWidth; i++)
			{
				for (var j:uint = 0; j < resultHeight; j++)
				{
					var heightmapX:uint = Math.ceil(i * factorX);
					var heightmapY:uint = Math.ceil(j * factorY);
					var pixel:uint = heightmap.getPixel(heightmapX, heightmapY);
					var value:uint = ((pixel >> 16 & 0xff) + (pixel >> 8 & 0xff) + (pixel & 0xff)) / 3;
					var resultPixel:uint;
				
					if (value < middle - TEXTURE_TRANSITION_MIDRANGE)
					{
						resultPixel = bottomTexture.getPixel(i % bottomTexture.width, j % bottomTexture.height);
					}
					else if (value > middle + TEXTURE_TRANSITION_MIDRANGE)
					{
						resultPixel = topTexture.getPixel(i % topTexture.width, j % topTexture.height);
					}
					else
					{
						var d:Number = ((middle + TEXTURE_TRANSITION_MIDRANGE) - value) / (TEXTURE_TRANSITION_MIDRANGE * 2);
						var dInv:Number = 1.0 - d;
						var topPixel:uint = topTexture.getPixel(i % topTexture.width, j % topTexture.height);
						var bottomPixel:uint = bottomTexture.getPixel(i % bottomTexture.width, j % bottomTexture.height);
						var topRed:uint = topPixel >> 16 & 0xFF;
						var topGreen:uint = topPixel >> 8 & 0xFF;
						var topBlue:uint = topPixel & 0xFF;
						var bottomRed:uint = bottomPixel >> 16 & 0xFF;
						var bottomGreen:uint = bottomPixel >> 8 & 0xFF;
						var bottomBlue:uint = bottomPixel & 0xFF;
						resultPixel = ((topRed * dInv + bottomRed * d) << 16 | (topGreen * dInv + bottomGreen * d) << 8 | (topBlue * dInv + bottomBlue * d));
					}
				
					result.setPixel(i, j, resultPixel);
				}
			}
			
			cpln("Texture created in " + TimeCounter.stop("createTexture") + "ms");
		
			return result;
		}
		
		public static function createProgram(type:String):Array
		{
			TimeCounter.start("createProgram");
			
			var vertexShader:AGALMiniAssembler;
			var fragShader:AGALMiniAssembler;
			var usedStreams:Array = new Array();
			
			// no light gpu program
			if (type == NO_LIGHT_PROGRAM)
			{
				vertexShader = new AGALMiniAssembler();
				vertexShader.assemble(Context3DProgramType.VERTEX,
					// copy uv texture coordinates to pixel program
					"mov v0, va1 \n" +
					// transform vertex position
					"m44 vt0, va0, vc4 \n" +
					"m44 vt1, vt0, vc0 \n" +
					// copy position to output
					"mov op, vt1 \n"
				);
			
				fragShader = new AGALMiniAssembler();
				fragShader.assemble(Context3DProgramType.FRAGMENT,
					// get texture pixel
					"mov ft0, v0 \n" +
					"tex ft1, ft0, fs0 <2d,clamp,linear> \n" +
					// set fragment color
					"mov oc, ft1 \n"
				);
				
				usedStreams.push(0);
				usedStreams.push(1);
			}
			// directional light gpu program
			else if (type == DIRECTIONAL_LIGHT_PROGRAM)
			{
				vertexShader = new AGALMiniAssembler();
				vertexShader.assemble(Context3DProgramType.VERTEX,
					// copy uv texture coordinates to pixel program
					"mov v0, va1 \n" +
					// transform vertex position and copy it to pixel program
					"m44 vt0, va0, vc4 \n" +
					"m44 vt0, vt0, vc0 \n" +
					"mov op, vt0 \n" +
					// transform normal using normal matrix
					"m44 vt1, va2, vc8 \n" +
					"nrm vt1.xyz, vt1.xyz \n" +
					"mov vt1, vt1.xyz \n" +
					// calculate diffuse intensity
					"dp4 vt1, vt1, vc12 \n" +
					// copy color to pixel shader
					"mov v2, vt1 \n"
				);
				
				fragShader = new AGALMiniAssembler();
				fragShader.assemble(Context3DProgramType.FRAGMENT,
					// get texture pixel
					"mov ft0, v0 \n" +
					"tex ft1, ft0, fs0 <2d,clamp,linear> \n" +
					// calculate light color using vertex attribute (diffuse component)
					"mul ft2, ft1, v2 \n" +
					"mul ft3, ft2, fc1 \n" +
					// add ambient component
					"mul ft4, ft1, fc0 \n" +
					"add ft5, ft3, ft4 \n" +
					// set fragment color
					"mov oc, ft5 \n"
				);
				
				usedStreams.push(0);
				usedStreams.push(1);
				usedStreams.push(2);
			}
			// point light gpu program
			else if (type == POINT_LIGHT_PROGRAM)
			{
				vertexShader = new AGALMiniAssembler();
				vertexShader.assemble(Context3DProgramType.VERTEX,
					// copy uv texture coordinates to pixel program
					"mov v0, va1 \n" +
					// transform vertex position and copy it to pixel program
					"m44 vt0, va0, vc4 \n" +
					"m44 vt0, vt0, vc0 \n" +
					"mov op, vt0 \n" +
					// transform normal using normal matrix
					"m44 vt1, va2, vc8 \n" +
					"nrm vt1.xyz, vt1.xyz \n" +
					// calculate diffuse intensity and copy it to pixel program
					"sub vt2, vc12, vt0 \n" + 
					"nrm vt2.xyz, vt2.xyz \n" +
					"dp3 vt3, vt1, vt2 \n" +
					"mov v2, vt3 \n"
				);
			
				fragShader = new AGALMiniAssembler();
				fragShader.assemble(Context3DProgramType.FRAGMENT,
					// get texture pixel
					"mov ft0, v0 \n" +
					"tex ft1, ft0, fs0 <2d,clamp,linear> \n" +
					// calculate light color using vertex attribute (diffuse component)
					"mul ft2, ft1, v2 \n" +
					"mul ft3, ft2, fc1 \n" +
					// add ambient component
					"mul ft4, ft1, fc0 \n" +
					"add ft5, ft3, ft4 \n" +
					// set fragment color
					"mov oc, ft5 \n"
				);
				
				usedStreams.push(0);
				usedStreams.push(1);
				usedStreams.push(2);
			}
			else
			{
				throw new Error("Invalid program type: " + type);
			}
			
			cpln("Program created in " + TimeCounter.stop("createProgram") + "ms");
			
			return [ vertexShader.agalcode, fragShader.agalcode, usedStreams ];
		}
	}
}
