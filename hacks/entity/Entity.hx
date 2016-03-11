package hacks.entity;

import hacks.render.IRenderable;
import hacks.render.Panel;
import hacks.render.Camera;
import hacks.render.Color;
import hacks.world.World;

/**
 * ...
 * @author oscarcs
 */
class Entity implements IRenderable
{
	public var x:Int;
	public var y:Int;
	public var world:World;
	
	public function new(x:Int, y:Int, world:World) 
	{
		this.world = world;
		this.x = x;
		this.y = y;
		
		world.read(x, y).entity = null;
		world.read(x, y)._ch = true;
		world.read(x, y).entity = this;
	}
	
	public function draw(p:Panel, c:Camera):Void
	{
		
	}
	
	public function canMove(xt:Int, yt:Int)
	{
		return true;
	}
	
	public function move(xt:Int, yt:Int)
	{
		if(canMove(xt, yt))
		{
			world.read(x, y).entity = null;
			world.read(x, y)._ch = true;
			world.read(xt, yt).entity = this;
		}
	}
}