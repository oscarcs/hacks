package hacks.tile;

import hacks.render.Color;
import hacks.render.Color.ARGB;
import hacks.render.TileRenderComponent;
import hacks.tile.Tiles.RLTile;
import hacks.world.World;

/**
 * ...
 * @author oscarcs
 */
class TileUtil
{
	/**
	 * The index of the first character in the set
	 */
	public static var offset:Int = 32;
	
	/**
	 * String containing every character by tileset index.
	 * Defaults is IBM code page 437.
	 */
	public static var chars = " !\"#$%&'()*+,-./0123456789:;<=>?" +
							  "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_" +
							  "`abcdefghijklmnopqrstuvwxyz{|}~";
	
	/**
	 * Draws text to a tileable context.
	 * @param	xt
	 * @param	yt
	 * @param	context
	 * @param	text
	 * @param	fg
	 * @param	bg
	 * @param	wrapWidth
	 */
	public static function drawText(xt:Int, yt:Int, context:ITileable, text:String, fg:ARGB, bg:ARGB, ?wrapWidth:Int):Void
	{
		if (wrapWidth == null) wrapWidth = context.w - 1;
		var x:Int = xt;
		for (i in 0...text.length)
		{
			var char:Int = chars.indexOf(text.charAt(i));
			
			if (char == -1 || x > wrapWidth + xt - 1)
			{
				yt++;
				x = xt;
			}
			if (char != -1)
			{
				char += offset;
				context.write(x, yt, { solid:false, rc:[new TileRenderComponent(char)], fg:fg, bg:bg, _ch:true } );
				x++;
			}
		}
	}
	
	/**
	 * Get all tiles on a Bresenham line.
	 * @param	x0
	 * @param	y0
	 * @param	x1
	 * @param	y1
	 * @return array of tiles
	 */
	public static function bresenham(x0:Int, y0:Int, x1:Int, y1:Int, context:ITileable):Array<RLTile>
	{
		var dx:Int = Std.int(Math.abs(x1 - x0));
		var dy:Int = Std.int(Math.abs(y1 - y0));
		var sx:Int = x0 < x1 ? 1 : -1;
		var sy:Int = y0 < y1 ? 1 : -1;
		var err:Int = dx - dy;
		
		var out:Array<RLTile> = [];
		while (true)
		{
			out.push(context.read(x0, y0));
 
			if (x0 == x1 && y0 == y1)
			{
				break;
			}
			
			var e2:Int = err * 2;
			if (e2 > -dx) 
			{
				err -= dy;
				x0 += sx;
			}
			
			if (e2 < dx)
			{
				err += dx;
				y0 += sy;
			}
		}
		return out;
	}
}