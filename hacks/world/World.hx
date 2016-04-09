package hacks.world;

import hacks.random.Random;
import hacks.render.Color;
import hacks.render.Color.ARGB;
import hacks.render.IRenderable;
import hacks.render.Panel;
import hacks.render.Panel.ScreenTile;
import hacks.render.Camera;
import hacks.tile.ITileable;
import hacks.tile.Tiles;
import hacks.tile.Tiles.RLTile;
import hacks.tile.TileUtil;
import hacks.timing.ITimeable;

/**
 * Represents and renders the currently-loaded 'static' map.
 * Extend this class to generate and load a world.
 * @author oscarcs
 */
class World implements IRenderable implements ITileable implements ITimeable
{
	public var w:Int;
	public var h:Int;
	public var chunk_w:Int = 8;
	public var chunk_h:Int = 8;
	public var buffer:Array<RLTile> = []; //the whole map!
	public var chunkTypes:Array<String> = [];
	
	public function new(w:Int, h:Int) 
	{
		this.w = w;
		this.h = h;
		
		buffer = [for (i in 0...w) for (j in 0...h) Tiles.get("none") ];
		
		//set up chunk types.
		chunkTypes = [for (i in 0...Std.int(w / chunk_w)) for (j in 0...Std.int(h / chunk_h)) "none" ];
	}
	
	/**
	 * Get the type of a chunk from the tiles.
	 * @param	xc
	 * @param	yc
	 */
	public function getChunkType(xc:Int, yc:Int):String
	{
		return "none";
	}
	
	/**
	 * Read the type of a chunk to the cache.
	 * @param	xc
	 * @param	yc
	 * @return
	 */
	public function readChunkType(xc:Int, yc:Int):String
	{
		return chunkTypes[xc + yc * Std.int(w / chunk_w)];
	}
	
	/**
	 * Write the type of a chunk to the cache.
	 * @param	xc
	 * @param	yc
	 * @param	type
	 */
	public function writeChunkType(xc:Int, yc:Int, type:String):Void
	{
		chunkTypes[xc + yc * Std.int(w / chunk_w)] = type;
	}
	
	public function read(xt:Int, yt:Int):RLTile
	{
		if (xt >= 0 && yt >= 0 && xt < w && yt < h)
		{
			return buffer[xt + yt * w];
		}
		return null;
	}
	
	public function write(xt:Int, yt:Int, tile:RLTile):Void
	{
		if (xt >= 0 && yt >= 0 && xt < w && yt < h)
		{
			var cur = buffer[xt + yt * w];
			if (cur.rc != tile.rc || 
				cur.fg != tile.fg || 
				cur.bg != tile.bg || 
				cur.solid != tile.solid ||
				cur.tiletype != tile.tiletype)
			{
				cur._ch = true;
			}
			cur.bg = tile.bg;
			cur.fg = tile.fg;
			cur.rc = tile.rc;
			cur.solid = tile.solid;
			cur.tiletype = tile.tiletype;
		}
	}
	
	public function draw(p:Panel, c:Camera):Void
	{
		for (i in 0...p.w)
		{
			for (j in 0...p.h)
			{
				var xt:Int = c.x + i;
				var yt:Int = c.y + j;
				
				var cur = read(xt, yt);
				if (cur != null && (cur._ch || c.moved))
				{
					for (k in 0...cur.rc.length)
					{
						cur.rc[k].render(p, c, cur, this, xt, yt, i, j);
					}
				}
			}
		}
	}
	
	public function step():Void
	{
		
	}
	
	public function forceRedraw()
	{
		for (i in 0...w)
		{
			for (j in 0...h)
			{
				read(i, j)._ch = true;
			}
		}
	}
}