package ui;

import render.Color;
import render.IRenderable;
import render.Panel;
import render.Camera;
import tile.ITileable;
import tile.TileList;
import tile.TileList.RLTile;
import tile.TileUtil;

/**
 * ...
 * @author oscarcs
 */
class UI implements IRenderable implements ITileable
{
	public var X:Int;
	public var Y:Int;
	public var WIDTH:Int;
	public var HEIGHT:Int;
	public var buffer:Array<RLTile> = [];
	private var border:Bool = false;
	
	public function new(xt:Int, yt:Int, w:Int, h:Int)
	{
		X = xt;
		Y = yt;
		WIDTH = w;
		HEIGHT = h;
		
		buffer = [for (x in 0...WIDTH) for (y in 0...HEIGHT) TileList.get("ui_transparent") ];
	}
	
	public function init(border:Bool, fg:ARGB, bg:ARGB, title:String)
	{
		this.border = border;
		
		var borderTile:RLTile = TileList.get("border");
		borderTile.fg = fg;
		borderTile.bg = bg;
			
		var backTile:RLTile = TileList.get("ui_back");
		backTile.fg = fg;
		backTile.bg = bg;
		
		for (x in 0...WIDTH)
		{
			for (y in 0...HEIGHT)
			{
				if (border && (x == 0 || x == WIDTH - 1 || y == 0 || y == HEIGHT - 1))
				{
					write(x, y, borderTile);
				}
				else
				{
					write(x, y, backTile);
				}
			}
		}
		if (title != "")
		{
			TileUtil.drawText(Std.int((WIDTH - title.length) / 2), 0, this, title, fg, bg);
		}
	}
	
	public function read(xt:Int, yt:Int):RLTile
	{
		if (xt >= 0 && yt >= 0 && xt < WIDTH && yt < HEIGHT)
		{
			return buffer[xt + yt * WIDTH];
		}
		return null;
	}
	
	public function write(xt:Int, yt:Int, tile:RLTile):Void
	{
		if (xt >= 0 && yt >= 0 && xt < WIDTH && yt < HEIGHT)
		{
			var cur = buffer[xt + yt * WIDTH];
			if (cur.rt != tile.rt || 
				cur.fg != tile.fg || 
				cur.bg != tile.bg || 
				cur.solid != tile.solid ||
				cur.tiletype != tile.tiletype)
			{
				cur._ch = true;
			}
			cur.bg = tile.bg;
			cur.fg = tile.fg;
			cur.rt = tile.rt;
			cur.solid = tile.solid;
			cur.tiletype = tile.tiletype;
			cur._ch = true;
		}
	}
	
	public function draw(p:Panel, c:Camera):Void
	{
		for (x in 0...WIDTH)
		{
			for (y in 0...HEIGHT)
			{
				var cur = read(x, y);
				if (cur._ch)
				{
					switch(cur.rt)
					{
						case Tile(value):
							if (value != 0) //transparency!
							{
								p.write(x + X, y + Y, cur.fg, cur.bg, value, this);
							}
						
						case Border(values):
							var val = TileUtil.borderAutoTile(x, y, this, cur, values);
							p.write(x + X, y + Y, cur.fg, cur.bg, val, this);
						
						case Water(values, shorefg, shorebg):	
							var val = values.oooo;//TileUtil.waterAutoTile(x, y, this, cur, values);
							if (val == values.oooo)
							{
								p.write(x + X, y + Y, cur.fg, cur.bg, val, this);
							}
							else
							{
								p.write(x + X, y + Y, shorefg, shorebg, val, this);
							}
					}
					cur._ch = false;
				}
			}
		}
	}
}