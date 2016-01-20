package world;

import render.Color;
import render.Color.ARGB;
import render.IRenderable;
import render.Panel;
import render.Panel.ScreenTile;
import render.Camera;
import tile.ITileable;
import tile.TileList;
import tile.TileList.RLTile;
import tile.TileUtil;


/**
 * Represents and renders the currently-loaded static map.
 * @author oscarcs
 */
class World implements IRenderable implements ITileable
{
	public var WIDTH:Int;
	public var HEIGHT:Int;
	public var C_WIDTH:Int = 8;
	public var C_HEIGHT:Int = 8;
	public var buffer:Array<RLTile> = []; //the whole map!
	public var worldMap:WorldMap;
	public var seed:Int = Std.int(1000000);
	
	public function new(w:Int, h:Int, worldMap:WorldMap) 
	{
		WIDTH = w;
		HEIGHT = h;
		this.worldMap = worldMap;
		
		buffer = [for (x in 0...WIDTH) for (y in 0...HEIGHT) TileList.get("floor") ];
		for (x in 0...10)
		{
			for (y in 0...3)
			{
				loadChunk(x * C_WIDTH, y * C_HEIGHT, x, y);
			}
		}
	}
	
	public function loadChunk(xt:Int, yt:Int, xc:Int, yc:Int)
	{
		var wt:RLTile = worldMap.read(xc, yc);
		trace(xc, yc, wt.tiletype);
		var arr:Array<Int> = [for (i in 0...(C_WIDTH * C_HEIGHT)) Std.random(30) + 110];//WorldGen.generate(C_WIDTH, C_HEIGHT, xc * C_WIDTH, yc * C_HEIGHT, seed);
		trace(arr);
		
		var chunk:Array<RLTile> = WorldGen.resolveChunk(C_WIDTH, C_HEIGHT, wt.tiletype, arr);
		for (x in 0...C_WIDTH)
		{
			for (y in 0...C_HEIGHT)
			{
				var tile:RLTile = chunk[x + y * C_WIDTH];
				write(xt + x, yt + y, tile);
			}
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
		for (xt in 0...p.WIDTH)
		{
			for (yt in 0...p.HEIGHT)
			{
				var x:Int = c.x + xt;
				var y:Int = c.y + yt;
				
				var cur = read(x, y);
				if (cur != null && (cur._ch || c.moved))
				{
					if (x % 8 == 0 && y % 8 == 0) {
						//cur.bg = Color.WHITE;
					}
					
					switch(cur.rt)
					{
						case Tile(value):
							p.write(xt, yt, cur.fg, cur.bg, value);
						case Border(values):
							var val = TileUtil.borderAutoTile(x, y, this, cur, values);
							p.write(xt, yt, cur.fg, cur.bg, val);
					}
					if (cur.entity != null)
					{
						cur.entity.draw(p, c);
					}
					cur._ch = false;
				}
			}
		}
	}
}