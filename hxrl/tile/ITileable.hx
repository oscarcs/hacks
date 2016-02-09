package hxrl.tile;

import hxrl.tile.TileList.RLTile;

/**
 * @author oscarcs
 */
interface ITileable 
{
  	public var w:Int;
	public var h:Int;
	public var buffer:Array<RLTile>;
	
	public function read(xt:Int, yt:Int):RLTile;
	public function write(xt:Int, yt:Int, tile:RLTile):Void;
}