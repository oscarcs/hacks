package world;

import random.Random;
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
	
	public static function resolveHeightmap(val:Float):RLTile
	{	
		if (val > 160)
		{
			//var t = val % 2 == 0 ? "tree" : "mountain";
			return TileList.get('mountain');
		}
		else if (val > 133)
		{
			return TileList.get("tree");
		}
		else if (val > 115)
		{
			var t = val % 2 == 0 ? "1" : "2";
			return TileList.get("grass" + t);
		}
		else
		{
			return TileList.get("water");
		}
	}
	
	public static function resolveWorld(w:Int, h:Int, heightmap:Array<Int>):Array<RLTile>
	{
		var out:Array<RLTile> = [];
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var val:Float = heightmap[x + y * w];
				var cur:RLTile = resolveHeightmap(Std.int(val));
				out.push(cur);
				//if (x == 0 || y == 0) { out[x + y * w].bg = Color.BLUE; }
			}
		}
		return out;
	}
	
	public static function spawnRivers(heightmap:Array<Int>, number:Int, context:World)
	{
		var h = context.HEIGHT;
		var w = context.WIDTH;
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var val:Float = heightmap[x + y * w];
				if (val > 155 && Random.nextFloat() > 0.9)
				{
					var next = { x:x, y:y };
					var iter:Int = 0;
					var arr = [];
					var success = true;
					
					while (context.read(next.x, next.y).tiletype != 'water')
					{
						arr.push({x:next.x, y:next.y});
						var r = heightmap[(next.x + 1) + (next.y) * w];
						var d = heightmap[(next.x) + (next.y + 1) * w];
						var l = heightmap[(next.x - 1) + (next.y) * w];
						var u = heightmap[(next.x) + (next.y - 1) * w];
						
						var min:Float = Math.min(Math.min(r, d), Math.min(l, u));
						//add some random salt
						if (Random.nextFloat() > 0.7)
						{
							switch(Random.nextRangedInt(0, 3))
							{
								case 0:
									min = r;
								case 1:
									min = d;
								case 2:
									min = l;
								case 3:
									min = u;
							}
						}
						if (min == r)		next.x++;
						else if (min == d)	next.y++;
						else if (min == l)	next.x--;
						else if (min == u)	next.y--;
						
						if (context.read(next.x, next.y) == null) { break; }
						if (context.read(next.x, next.y).tiletype == 'river')
						{
							success = false;
							break;
						}
						
						if (iter > 100) { success = false; break; }
						iter++;
					}
					
					if (success)
					{ 
						for (next in arr)
						{
							var xc = Math.round(next.x / context.C_WIDTH);
							var yc = Math.round(next.y / context.C_HEIGHT);
							if (context.readChunkType(xc - 1, yc) != 'river' ||
								context.readChunkType(xc, yc - 1) != 'river')
							{
								context.writeChunkType(xc, yc, 'river');
							}
							
							context.write(next.x, next.y, TileList.get('river'));
						}
					}
				}
			}
		}
	}
}