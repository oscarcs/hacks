package hxrl.render;

import hxrl.tile.ITileable;
import hxrl.tile.Tiles.RLTile;

/**
 * @author oscarcs
 */
interface IRenderComponent 
{
	//note: all render component types need a parseArgs function
	
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
	 */
	public function render(p:Panel, c:Camera, cur:RLTile, context:ITileable, xt:Int, yt:Int, xr:Int, yr:Int, ?lock:Bool):Void;
}