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
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import br.dcoder.console.*;
	
	import com.adobe.utils.AGALMiniAssembler;

	/**
	 * @author lteixeira
	 */
	public class Mesh
	{
		private var context3d:Context3D;
		
		private var geometry:Geometry;
		
		private var texture:Texture;
		private var program:Program3D;
		private var usedStreams:Array;
		
		public function Mesh(context3d:Context3D)
		{
			this.context3d = context3d;
		}
		
		public function setGeometry(geometry:Geometry):void
		{
			if (this.geometry)
				this.geometry.dispose();
				
			this.geometry = geometry;
			cpln("Triangle count: " + this.geometry.triangleCount);
		}
		
		public function setTexture(bitmap:BitmapData):void
		{
			if (texture)
				texture.dispose();
				
			texture = context3d.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmap);
		}
		
		public function setProgram(vertexByteCode:ByteArray, fragByteCode:ByteArray, usedStreams:Array):void
		{
			this.usedStreams = usedStreams;
			
			if (program)
				program.dispose();
			
			program = context3d.createProgram();
			program.upload(vertexByteCode, fragByteCode);
		}
		
		public function render(projection:Matrix3D, modelview:Matrix3D):void
		{
			if (geometry && program && texture)
			{
				// calculate normal matrix
				var zero:Vector3D = new Vector3D();
				var normal:Matrix3D = new Matrix3D(modelview.rawData);
				normal.copyColumnFrom(3, zero);
				normal.copyRowFrom(3, zero);
				normal.invert();
			
				// set program
				context3d.setProgram(program);

				// set program constants
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelview, true);
				context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, normal, true);
				context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([ 0.0, -1.0, 0.0, 0.0 ]));
				context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([ 0.3, 0.3, 0.3, 1 ]));
				context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([ 0.7, 0.7, 0.7, 1 ]));
			
				// set texture
				context3d.setTextureAt(0, texture);
			
				// render geometry
				geometry.render(useStream(0), useStream(1), useStream(2));
			}
		}
		
		private function useStream(index:uint):Boolean
		{
			for (var i:uint = 0; i < usedStreams.length; i++)
				if (usedStreams[i] == index)
					return true;
					
			return false;
		}
	}
}
