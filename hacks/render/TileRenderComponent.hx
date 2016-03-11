package hacks.render;
import hacks.tile.ITileable;
import hacks.tile.Tiles;
import hacks.render.Camera;
import hacks.render.Panel;
import hacks.tile.Tiles.RLTile;

/**
 * ...
 * @author oscarcs
 */
class TileRenderComponent implements IRenderComponent
{
	var value:Int;
	
	public function new(value:Int) 
	{
		this.value = value;
	}
	
	public function render(p:Panel, c:Camera, cur:RLTile, context:ITileable, xt:Int, yt:Int, xr:Int, yr:Int, ?lock:Bool):Void
	{
		if (lock != null && lock)
			p.write(xr, yr, cur.fg, cur.bg, value, context);
		else
			p.write(xr, yr, cur.fg, cur.bg, value);
	}
	
}