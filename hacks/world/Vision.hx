package hacks.world;

/*
 * Some algorithms ported from the Java implementation in SquidLib.
 * Modifications have been made to this code.
 * See LICENSE.txt for more information.
 */

/**
 * Methods to calculate FOV.
 * Reads from a World but does not write to it directly.
 * @author oscarcs
 */
class Vision
{
	private var lightMap:Array<Array<Float>> = [[]];
	
	public var world:World;
	public var startX:Int;
	public var startY:Int;
	
	/**
	 * Radius of view cone.
	 */
	public var radius:Float;
	
	/**
	 * Variable controlling how fast light 'falls off'.
	 * Default is zero, all visible cells in radius will be 100% lit.
	 */
	public var decay:Float = 0;
	
	public function new(world:World)
	{
		this.world = world;
		lightMap = [for (i in 0...world.w) [for (j in 0...world.h) 0]];
	}
	
	/**
	 * Check if a tile blocks light. Could be changed using inheritance.
	 */
	private function isSolid(xt:Int, yt:Int):Bool
	{
		if (world.read(xt, yt) != null)
		{
			return world.read(xt, yt).solid;
		}
		return false;
	}
	
	/**
	 * Calculate the radius. Could be changed using inheritance.
	 */
	private function calculateRadius(dx:Float, dy:Float):Float
	{
		//circular radius
		return Math.sqrt(dx * dx + dy * dy);
	}
	
	/**
	* Calculates the field of view for the provided world from the given x, y
	* coordinates. Returns a lightmap for a result where the values represent a
	* percentage of fully lit. 
	* Based on SquidLib implementation and ported to Haxe.
	* 
	* @param startx the horizontal component of the starting location
	* @param starty the vertical component of the starting location
	* @param radius the maximum distance to draw the FOV
	* @return the computed light grid as Array<Array<Float>>
	*/
	public function calculateShadowcast(startX:Int, startY:Int, radius:Float):Array<Array<Float>>
	{
		this.startX = startX;
		this.startY = startY;
		this.radius = radius;
		
		lightMap[startX][startY] = 1; //light the starting cell
		
		var diagonals = [
			{deltaX:-1, deltaY:-1},
			{deltaX: 1, deltaY:-1},
			{deltaX:-1, deltaY: 1},
			{deltaX: 1, deltaY: 1},
		];
		for (d in diagonals)
		{
			shadowcast(1, 1.0, 0.0, 0, d.deltaX, d.deltaY, 0);
			shadowcast(1, 1.0, 0.0, d.deltaX, 0, 0, d.deltaY);
		}
	
		return lightMap;
	}
	
	/**
	 * Recursive shadowcasting algorithm implementation.
	 * Based on SquidLib implementation and ported to Haxe.
	 */
	private function shadowcast(row:Int, start:Float, end:Float, xx:Int, xy:Int, yx:Int, yy:Int):Void 
	{	
		var newStart:Float = 0.0;
		if (start < end) 
		{
			return;
		}
		
		var blocked:Bool = false;
		//for (int distance = row; distance <= radius && !blocked; distance++) 
		for(distance in row...(Std.int(radius) + 1))
		{
			if (blocked)
			{
				break;
			}
			
			var deltaY:Int = -distance;

			//for (int deltaX = -distance; deltaX <= 0; deltaX++) 
			for(deltaX in (-distance)...1)
			{
				var currentX:Int = startX + (deltaX * xx) + (deltaY * xy);
				var currentY:Int = startY + (deltaX * yx) + (deltaY * yy);
				var leftSlope:Float= (deltaX - 0.5) / (deltaY + 0.5);
				var rightSlope:Float = (deltaX + 0.5) / (deltaY - 0.5);
	
				if (!(currentX >= 0 && currentY >= 0 && currentX < world.w && currentY < world.h) || start < rightSlope) 
				{
					continue;
				} 
				else if (end > leftSlope)
				{
					break;
				}
				
				//check if it's within the lightable area and light if needed
				var deltaRadius:Float = calculateRadius(deltaX, deltaY);
				if (deltaRadius <= radius)
				{
					var bright:Float = 1 - decay * deltaRadius;
					lightMap[currentX][currentY] = bright;
				}
	
				//previous cell was a blocking one
				if (blocked)
				{ 
					if (isSolid(currentX, currentY)) //hit a wall
					{ 
						newStart = rightSlope;
					} 
					else 
					{
						blocked = false;
						start = newStart;
					}
				} 
				else 
				{
					//hit a wall within sight line
					if (isSolid(currentX, currentY) && distance < radius)
					{
						blocked = true;
						shadowcast(distance + 1, start, leftSlope, xx, xy, yx, yy);
						newStart = rightSlope;
					}
				}
			}
		}
	}
}