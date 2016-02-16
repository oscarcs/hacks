package hxrl.tile;

import hxrl.render.Color;
import hxrl.render.Color.ARGB;
import hxrl.render.TileRenderComponent;
import hxrl.tile.Tiles.RLTile;
import hxrl.world.World;

/**
 * ...
 * @author oscarcs
 */
class TileUtil
{
	//code page 437
	public static var chars = " !\"#$%&'()*+,-./0123456789:;<=>?@" +
							  "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`" +
							  "abcdefghijklmnopqrstuvwxyz{|}~";
	
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
			else {
				char += 32;
				context.write(x, yt, { solid:false, rc:[new TileRenderComponent(char)], fg:fg, bg:bg, _ch:true } );
				x++;
			}
		}
	}
}