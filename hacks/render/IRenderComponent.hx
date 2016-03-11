package hacks.render;
import hacks.tile.Tiles;

import hacks.tile.ITileable;
import hacks.tile.Tiles.RLTile;

/**
 * Render component base interface.
 * @author oscarcs
 */
interface IRenderComponent 
{
	//TODO: this method signature is an unwieldy, ungodly behemoth
	/**
	 * 
	 * @param	p	Panel
	 * @param	c	Camera
	 * @param	cur	Current RLTile.
	 * @param	context
	 * @param	xt	Tile position x
	 * @param	yt	Tile position y
	 * @param	xr	Render position x
	 * @param	yr	Render position y
	 * @param	lock	Lock the panel on render?
	 */
	public function render(p:Panel, c:Camera, cur:RLTile, context:ITileable, xt:Int, yt:Int, xr:Int, yr:Int, ?lock:Bool):Void;
}