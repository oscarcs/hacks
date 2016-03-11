package hxrl.tile;

import hxrl.render.Panel;
import hxrl.render.Camera;
import hxrl.render.IRenderable;
import hxrl.tile.Tiles.RLTile;

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