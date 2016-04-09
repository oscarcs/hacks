package hacks.tile;

import hacks.render.Panel;
import hacks.render.Camera;
import hacks.render.IRenderable;
import hacks.tile.Tiles.RLTile;

/**
 * Any drawable 'thing' that also holds a datastructure containing RLTiles.
 * @author oscarcs
 */
interface ITileable extends IRenderable
{
  	public var w:Int;
	public var h:Int;
	
	/**
	 * Datastructure containing RLTiles.
	 */
	public var buffer:Array<RLTile>;
	
	/**
	 * Read a tile.
	 * @param	xt	x pos in tiles
	 * @param	yt	y pos in tiles
	 * @return	RLTile
	 */
	public function read(xt:Int, yt:Int):RLTile;
	
	/**
	 * Write a tile.
	 * @param	xt	x pos in tiles
	 * @param	yt	y pos in tiles
	 * @param	tile	tile to write
	 */
	public function write(xt:Int, yt:Int, tile:RLTile):Void;
	
	//inherited from IRenderable
	public function draw(p:Panel, c:Camera):Void;
}