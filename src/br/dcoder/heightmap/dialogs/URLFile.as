// Molehill Heightmap Viewer Copyright 2012 Lucas Teixeira
// disturbedcoder.com
//
// This software is distribuited under the terms of the GNU Lesser Public License.
// See license.txt for more information.

package br.dcoder.heightmap.dialogs
{
	/**
	 * @author lteixeira
	 */
	public class URLFile extends File
	{
		public var url:String;
		
		public function URLFile(url:String = "")
		{
			this.url = url;
		}
	}
}
