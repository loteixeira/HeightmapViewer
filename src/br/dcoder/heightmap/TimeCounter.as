// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap
{
	import flash.utils.getTimer;
	
	/**
	 * @author lteixeira
	 */
	public class TimeCounter
	{
		private static var data:Object = {};
		
		public static function start(key:String):void
		{
			data[key] = getTimer();
		}
		
		public static function stop(key:String):uint
		{
			if (data[key] == null)
				return 0;
			
			var result:uint = getTimer() - data[key];
			data[key] = null;
			return result;
		}
	}
}
