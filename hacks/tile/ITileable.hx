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
	public var buffer:Array<RLTile>;
	
	public function read(xt:Int, yt:Int):RLTile;
	public function write(xt:Int, yt:Int, tile:RLTile):Void;
	
	public function draw(p:Panel, c:Camera):Void;
}