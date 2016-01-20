package world;

import render.Color;
import tile.ITileable;
import tile.TileList;

/**
 * ...
 * @author oscarcs
 */
class WorldGen
{
	public static function generate(w:Int, h:Int, xt:Int, yt:Int, seed:Int, ?octaves:Int=8, ?falloff:Float=0.8):Array<Int>
	{
		var buffer = [for (x in 0...w) for (y in 0...h) TileList.get("floor") ];
		var perlin = new Perlin(seed, octaves, falloff);
		var out = [for (i in 0...(w * h)) 0];
		perlin.generate(out, w, h, xt, yt, 0);
		return out;
	}
	
	public static function resolveHeightmap(val:Int):RLTile
	{
		if(val < 120)
		{
			var t = val % 2 == 0 ? "1" : "2";
			return TileList.get("grass" + t);
		}
		else if (val < 145)
		{
			return TileList.get("tree");
		}
		else
		{
			return TileList.get("mountain");
		}
	}
	
	/**
	 * Generate a chunk.
	 * @param	w	width
	 * @param	h	height
	 * @param	type	the type of this chunk
	 * @param	heightmap
	 * @return
	 */
	public static function resolveChunk(w:Int, h:Int, type:String, heightmap:Array<Int>):Array<RLTile>
	{
		var out:Array<RLTile> = [];
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var val:Int = heightmap[x + y * w];
				switch(type)
				{
					case "tree":
						out.push(rh_tree(val));
						//out.push(TileList.get("tree"));
					case "grass":
						out.push(rh_grass(val));
						//out.push(TileList.get("grass1"));
					case "mountain":
						out.push(rh_mountain(val));
						//out.push(TileList.get("mountain"));
					case "":
						out.push(TileList.get("floor"));
					default:
						out.push(TileList.get("test"));
				}
				//if (x == 0 || y == 0) { out[x + y * w].bg = Color.BLUE; }
			}
		}
		return out;
	}
	
	private static function rh_tree(val:Int):RLTile
	{
		if (val > 130)
		{
			return TileList.get("tree");
		}
		else
		{
			var t = val % 2 == 0 ? "1" : "2";
			return TileList.get("grass" + t);
		}
	}
	
	private static function rh_grass(val:Int):RLTile
	{
		var t = val % 2 == 0 ? "1" : "2";
		return TileList.get("grass" + t);
	}
	
	private static function rh_mountain(val:Int):RLTile
	{
		if (val > 145)
		{
			return TileList.get("mountain");
		}
		else if (val > 130)
		{
			return TileList.get("tree");
		}
		else
		{
			var t = val % 2 == 0 ? "1" : "2";
			return TileList.get("grass" + t);
		}
	}
}