package hacks.ui;

import hacks.render.Panel;
import hacks.render.Camera;
import hacks.tile.Tiles;
import hacks.ui.UI.UIOptions;
import hacks.world.World;

/**
 * Class for a world map. Reads from the World 'ChunkType' array.
 * @author oscarcs
 */
class UIMap extends UI
{
	public var map_x:Int = 0;
	public var map_y:Int = 0;
	public var world:World;
	
	public function new(xt:Int, yt:Int, w:Int, h:Int, opts:UIOptions, world:World) 
	{
		super(xt, yt, w, h, opts);
		this.world = world;
	}
	
	public function loadChunks()
	{
		var x2:Int = options.hasBorder ? w - 2 : w;
		var y2:Int = options.hasBorder ? h - 2 : h;
		
		for (x in 0...x2)
		{
			for (y in 0...y2)
			{
				var xt = x + map_x;
				var yt = y + map_y;
				var type:String = world.readChunkType(xt, yt);
				
				if (options.hasBorder) { xt++; yt++; }
				write(xt, yt, Tiles.get(type));
			}
		}
	}
	
	override public function draw(p:Panel, c:Camera):Void 
	{
		super.draw(p, c);
	}
	
}