package entity;

import render.Camera;
import render.Panel;
import render.Color;
import world.World;

/**
 * ...
 * @author oscarcs
 */
class Player extends Entity
{

	public function new(x:Int, y:Int, world:World) 
	{
		super(x, y, world);
	}

	override public function draw(p:Panel, c:Camera):Void 
	{
		super.draw(p, c);
		p.write(x - c.x, y - c.y, Color.WHITE, Color.RED, 64);
	}
}