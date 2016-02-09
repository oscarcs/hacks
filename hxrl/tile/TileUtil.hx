package hxrl.tile;
import hxrl.render.Color;

import hxrl.render.Color.ARGB;
import hxrl.tile.TileList.RLTile;
import hxrl.tile.TileList.BorderValues;
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
				context.write(x, yt, { solid:false, rt:Tile(char), fg:fg, bg:bg, _ch:true } );
				x++;
			}
		}
	}
	
	public static function borderAutoTile(xt:Int, yt:Int, context:ITileable, cur:RLTile, values:BorderValues):Int
	{
		var val:Int = 1;
		
		var u:RLTile = context.read(xt, yt - 1);
		var r:RLTile = context.read(xt + 1, yt);
		var d:RLTile = context.read(xt, yt + 1);
		var l:RLTile = context.read(xt - 1, yt);
		
		//check the surrounding tiles.
		var UP:Bool = false;
		var RIGHT:Bool = false;
		var DOWN:Bool =	false;
		var LEFT:Bool = false;
		if(u != null) UP =		u.tiletype == cur.tiletype;
		if(r != null) RIGHT =	r.tiletype == cur.tiletype;
		if(d != null) DOWN =	d.tiletype == cur.tiletype;
		if(l != null) LEFT = 	l.tiletype == cur.tiletype;
		
			 if( UP && !RIGHT &&  DOWN && !LEFT) val = values.oxox;	// │	
		else if( UP && !RIGHT &&  DOWN &&  LEFT) val = values.oxoo;	// ┤
		else if(!UP && !RIGHT &&  DOWN &&  LEFT) val = values.xxoo;	// ┐
		else if( UP &&  RIGHT && !DOWN && !LEFT) val = values.ooxx;	// └
		else if( UP &&  RIGHT && !DOWN &&  LEFT) val = values.ooxo;	// ┴
		else if(!UP &&  RIGHT &&  DOWN &&  LEFT) val = values.xooo;	// ┬
		else if( UP &&  RIGHT &&  DOWN && !LEFT) val = values.ooox;	// ├
		else if(!UP &&  RIGHT && !DOWN &&  LEFT) val = values.xoxo;	// ─
		else if( UP &&  RIGHT &&  DOWN &&  LEFT) val = values.oooo;	// ┼
		else if( UP && !RIGHT && !DOWN &&  LEFT) val = values.oxxo;	// ┘
		else if(!UP &&  RIGHT &&  DOWN && !LEFT) val = values.xoox;	// ┌
		//special cases
		else if (UP || DOWN) 	val = values.oxox;
		else if (LEFT || RIGHT)	val = values.xoxo;
		else 					val = values.oxox;
		return val;
	}
	
	public static function waterAutoTile(xt:Int, yt:Int, context:ITileable, cur:RLTile, values:BorderValues):Int
	{
		var val:Int = 1;
		
		var u:RLTile = context.read(xt, yt - 1);
		var r:RLTile = context.read(xt + 1, yt);
		var d:RLTile = context.read(xt, yt + 1);
		var l:RLTile = context.read(xt - 1, yt);
		
		var ur:RLTile = context.read(xt + 1, yt - 1);
		var rd:RLTile = context.read(xt + 1, yt + 1);
		var dl:RLTile = context.read(xt - 1, yt + 1);
		var lu:RLTile = context.read(xt - 1, yt - 1);
		
		//check the surrounding tiles.
		var UP:Bool = false;
		var RIGHT:Bool = false;
		var DOWN:Bool =	false;
		var LEFT:Bool = false;
		
		if (u != null && r != null &&
			d != null && l != null &&
			ur != null && rd != null &&
			dl != null && lu != null && 
			u.tiletype == cur.tiletype &&
			r.tiletype == cur.tiletype &&
			d.tiletype == cur.tiletype &&
			l.tiletype == cur.tiletype &&
			ur.tiletype == cur.tiletype &&
			rd.tiletype == cur.tiletype &&
			dl.tiletype == cur.tiletype &&
			lu.tiletype == cur.tiletype)
		{
			cur.rt = Tile(values.oooo);
			cur._ch = true;
			return values.oooo;
		}
		
		if(u != null) UP =		u.rt == cur.rt;
		if(r != null) RIGHT =	r.rt == cur.rt;
		if(d != null) DOWN =	d.rt == cur.rt;
		if(l != null) LEFT = 	l.rt == cur.rt;
		
			 if( UP && !RIGHT &&  DOWN && !LEFT) val = values.oxox;	// │	
		else if( UP && !RIGHT &&  DOWN &&  LEFT) val = values.oxoo;	// ┤
		else if(!UP && !RIGHT &&  DOWN &&  LEFT) val = values.xxoo;	// ┐
		else if( UP &&  RIGHT && !DOWN && !LEFT) val = values.ooxx;	// └
		else if( UP &&  RIGHT && !DOWN &&  LEFT) val = values.ooxo;	// ┴
		else if(!UP &&  RIGHT &&  DOWN &&  LEFT) val = values.xooo;	// ┬
		else if( UP &&  RIGHT &&  DOWN && !LEFT) val = values.ooox;	// ├
		else if(!UP &&  RIGHT && !DOWN &&  LEFT) val = values.xoxo;	// ─
		else if( UP &&  RIGHT &&  DOWN &&  LEFT) val = values.oooo;	// ┼
		else if( UP && !RIGHT && !DOWN &&  LEFT) val = values.oxxo;	// ┘
		else if(!UP &&  RIGHT &&  DOWN && !LEFT) val = values.xoox;	// ┌
		//special cases
		else if (UP || DOWN) 	val = values.oxox;
		else if (LEFT || RIGHT)	val = values.xoxo;
		else 					val = values.oxox;
		return val;
	}
}