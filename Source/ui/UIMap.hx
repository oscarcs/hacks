package ui;

import render.Panel;
import render.Camera;
import tile.TileList;
import world.World;

/**
 * ...
 * @author oscarcs
 */
class UIMap extends UI
{
	public var MAP_X:Int = 0;
	public var MAP_Y:Int = 0;
	public var world:World;
	
	public function new(xt:Int, yt:Int, w:Int, h:Int, world:World) 
	{
		super(xt, yt, w, h);
		this.world = world;
	}
	
	public function readChunks()
	{
		var x1:Int = border ? 1 : 0;
		var x2:Int = border ? WIDTH - 1 : WIDTH;
		var y1:Int = border ? 1 : 0;
		var y2:Int = border ? HEIGHT - 1 : HEIGHT;
		
		for (x in x1...x2)
		{
			for (y in y1...y2)
			{
				var xt = x + MAP_X;
				var yt = y + MAP_Y;
				
				var type:String = world.readChunkType(xt, yt);
				if (border)
				{
					write(xt, yt, TileList.get(type));
				}
				else
				{
					write(xt, yt, TileList.get(type));
				}
				
			}
		}
	}
	
	override public function draw(p:Panel, c:Camera):Void 
	{

		super.draw(p, c);
	}
	
}