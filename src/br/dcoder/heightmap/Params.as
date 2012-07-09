// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap
{
	import flash.display.LoaderInfo;
	
	/**
	 * @author lteixeira
	 */
	public class Params
	{
		private var _noUI:Boolean;
		private var _noFPS:Boolean;
		
		private var _textureMiddle:Number;
		private var _textureDimension:String;
		private var _textureTopFile:String;
		private var _textureBottomFile:String;
		
		private var _heightmapHeight:Number;
		private var _heightmapFile:String;
		
		private var _visualLight:String;
		private var _visualAntiAliasing:String;
		private var _visualBackground:uint;
		
		public function Params(loaderInfo:LoaderInfo)
		{
			// no_ui
			if (loaderInfo.parameters["no_ui"] != null)
				_noUI = (loaderInfo.parameters["no_ui"] as String).toLowerCase() == "true";
			else
				_noUI = false;
				
			// no_fps
			if (loaderInfo.parameters["no_fps"] != null)
				_noFPS = (loaderInfo.parameters["no_fps"] as String).toLowerCase() == "true";
			else
				_noFPS = false;
				
			// texture.middle
			if (loaderInfo.parameters["texture.middle"] != null)
				_textureMiddle = parseFloat(loaderInfo.parameters["texture.middle"]);
			else
				_textureMiddle = 170
				
			// texture.dimension
			if (loaderInfo.parameters["texture.dimension"] != null)
				_textureDimension = loaderInfo.parameters["texture.dimension"];
			else
				_textureDimension = "512x512";
				
			// texture.top_file
			if (loaderInfo.parameters["texture.top_file"] != null)
				_textureTopFile = loaderInfo.parameters["texture.top_file"];
			else
				_textureTopFile = "rock.jpg";
			
			// texture.bottom_file
			if (loaderInfo.parameters["texture.bottom_file"] != null)
				_textureBottomFile = loaderInfo.parameters["texture.bottom_file"];
			else
				_textureBottomFile = "grass_3030_norm.jpg";
				
			// heightmap.height
			if (loaderInfo.parameters["heightmap.height"] != null)
				_heightmapHeight = parseFloat(loaderInfo.parameters["heightmap.height"]);
			else
				_heightmapHeight = 5;
				
			// heightmap.file
			if (loaderInfo.parameters["heightmap.file"] != null)
				_heightmapFile = loaderInfo.parameters["heightmap.file"];
			else
				_heightmapFile = "hm1.jpg";
				
			// visual.light
			if (loaderInfo.parameters["visual.light"] != null)
				_visualLight = loaderInfo.parameters["visual.light"];
			else
				_visualLight = "directional";
				
			// visual.anti_aliasing
			if (loaderInfo.parameters["visual.anti_aliasing"] != null)
				_visualAntiAliasing = loaderInfo.parameters["visual.anti_aliasing"];
			else
				_visualAntiAliasing = "0";
				
			// visual.background
			if (loaderInfo.parameters["visual.background"] != null)
				_visualBackground = parseInt(loaderInfo.parameters["visual.background"], 16);
			else
				_visualBackground = 0xa0a0a0;
		}
		
		public function get noUI():Boolean
		{
			return _noUI;
		}
		
		public function get noFPS():Boolean
		{
			return _noFPS;
		}
		
		public function get textureMiddle():Number
		{
			return _textureMiddle;
		}
		
		public function get textureDimension():String
		{
			return _textureDimension;
		}
		
		public function get textureTopFile():String
		{
			return _textureTopFile;
		}
		
		public function get textureBottomFile():String
		{
			return _textureBottomFile;
		}
		
		public function get heightmapHeight():Number
		{
			return _heightmapHeight;
		}
		
		public function get heightmapFile():String
		{
			return _heightmapFile;
		}
		
		public function get visualLight():String
		{
			return _visualLight;
		}
		
		public function get visualAntiAliasing():String
		{
			return _visualAntiAliasing;
		}
		
		public function get visualBackground():uint
		{
			return _visualBackground;
		}
	}
}