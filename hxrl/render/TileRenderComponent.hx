package hxrl.render;
import hxrl.tile.ITileable;
import hxrl.render.Camera;
import hxrl.render.Panel;
import hxrl.tile.TileList.RLTile;

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