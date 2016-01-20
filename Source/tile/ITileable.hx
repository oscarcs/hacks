package tile;

import tile.TileList.RLTile;

/**
 * @author oscarcs
 */
interface ITileable 
{
  	public var WIDTH:Int;
	public var HEIGHT:Int;
	public var buffer:Array<RLTile>;
	
	public function read(xt:Int, yt:Int):RLTile;
	public function write(xt:Int, yt:Int, tile:RLTile):Void;
}