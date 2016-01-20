package world;
import render.Camera;
import render.IRenderable;
import render.Panel;
import tile.ITileable;
import tile.TileList;
import world.World;
import world.WorldGen;

/**
 * Controls the overall 'overworld' world display; is not renderable.
 * Uses RLTiles for convenience, but any data type could be substituted - Ints etc.
 * @author oscarcs
 */
class WorldMap implements ITileable
{
	public var WIDTH:Int;
	public var HEIGHT:Int;
	public var heightmap:Array<Int>;
	public var buffer:Array<RLTile>;
	public var seed:Int = Std.random(100000);
	
	public function new(w:Int, h:Int)
	{
		WIDTH = w;
		HEIGHT = h;
		
		buffer = [for (x in 0...WIDTH) for (y in 0...HEIGHT) TileList.get("floor") ];

		heightmap = WorldGen.generate(WIDTH, HEIGHT, 0, 0, seed, 8, 0.9);
		load(heightmap);
	}
	
	public function load(arr:Array<Int>):Void
	{
		for (x in 0...WIDTH)
		{
			for (y in 0...HEIGHT)
			{
				var val:Int = arr[x + y * WIDTH];
				write(x, y, WorldGen.resolveHeightmap(val));
			}
		}
		
	}
	
	public function readHeight(xt:Int, yt:Int):Int
	{
		return heightmap[xt + yt * WIDTH];
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
}