package entity;

import render.IRenderable;
import render.Panel;
import render.Camera;
import render.Color;
import world.World;

/**
 * ...
 * @author oscarcs
 */
class Entity implements IRenderable
{
	public var x(default, set):Int;
	public var y(default, set):Int;
	public var world:World;
	
	public function new(x:Int, y:Int, world:World) 
	{
		this.world = world;
		this.x = x;
		this.y = y;
		
		move(x, y);
	}
	
	public function draw(p:Panel, c:Camera):Void
	{
		
	}
	
	function set_x(nx:Int)
	{
		if (!world.read(nx, y).solid)
		{
			move(x, y);
			return x = nx;
		}
		return x;
	}
	
	function set_y(ny:Int)
	{
		if (!world.read(x, ny).solid)
		{
			move(x, y);
			return y = ny;
		}
		return y;
	}
	
	private function move(xt:Int, yt:Int)
	{
		world.read(x, y).entity = null;
		world.read(x, y)._ch = true;
		world.read(xt, yt).entity = this;
	}
}