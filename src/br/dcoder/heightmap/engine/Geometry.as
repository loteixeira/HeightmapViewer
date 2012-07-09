// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.engine
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	/**
	 * @author lteixeira
	 */
	public class Geometry
	{
		private var context3d:Context3D;
		private var positionBuffer:VertexBuffer3D;
		private var texCoordBuffer:VertexBuffer3D;
		private var normalBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		private var _triangleCount:int;
		
		public function Geometry(context3d:Context3D, position:Vector.<Number>, texCoord:Vector.<Number>, normal:Vector.<Number>, index:Vector.<uint>)
		{
			this.context3d = context3d;

			_triangleCount = index.length / 3;

			positionBuffer = context3d.createVertexBuffer(0xffff, 3);
			positionBuffer = context3d.createVertexBuffer(position.length / 3, 3);
			positionBuffer.uploadFromVector(position, 0, position.length / 3);
			texCoordBuffer = context3d.createVertexBuffer(texCoord.length / 2, 2);
			texCoordBuffer.uploadFromVector(texCoord, 0, texCoord.length / 2);
			normalBuffer = context3d.createVertexBuffer(normal.length / 3, 3);
			normalBuffer.uploadFromVector(normal, 0, normal.length / 3);
			indexBuffer = context3d.createIndexBuffer(index.length);
			indexBuffer.uploadFromVector(index, 0, index.length);
		}
		
		public function dispose():void
		{
			positionBuffer.dispose();
			texCoordBuffer.dispose();
			normalBuffer.dispose();
			indexBuffer.dispose();
		}
		
		public function get triangleCount():uint
		{
			return _triangleCount;
		}
		
		public function render(usePosition:Boolean = true, useTexCoord:Boolean = true, useNormal:Boolean = true):void
		{
			if (usePosition)
				context3d.setVertexBufferAt(0, positionBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			else
				context3d.setVertexBufferAt(0, null);
					
			if (useTexCoord)
				context3d.setVertexBufferAt(1, texCoordBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			else
				context3d.setVertexBufferAt(1, null);
					
			if (useNormal)
				context3d.setVertexBufferAt(2, normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			else
				context3d.setVertexBufferAt(2, null);
				
			context3d.drawTriangles(indexBuffer, 0);
		}
	}
}
