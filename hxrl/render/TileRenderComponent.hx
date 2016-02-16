package hxrl.render;
import hxrl.tile.ITileable;
import hxrl.render.Camera;
import hxrl.render.Panel;
import hxrl.tile.Tiles.RLTile;

/**
 * ...
 * @author oscarcs
 */
class TileRenderComponent implements IRenderComponent
{
	var value:Int;
	
	public static function parseArgs(args:Array<Dynamic>):Array<Dynamic>
	{
		if (args.length > 1) throw('Too many arguments!');
		return args;
	}
	
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