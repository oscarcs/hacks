package hacks.render;
import hacks.render.Panel;

/**
 * Grouping and render list class.
 * @author oscarcs
 */
class Camera
{
	public var x:Int = 0;
	public var y:Int = 0;
	public var moved:Bool = false;
	private var prev_x:Int = 0;
	private var prev_y:Int = 0;
	
	private var renderList:Array<IRenderable> = [];
	
	public function new() 
	{
		
	}
	
	public function add(obj:IRenderable)
	{
		renderList.push(obj);
	}
	
	public function draw(p:Panel):Void 
	{
		for (i in 0...renderList.length)
		{
			renderList[i].draw(p, this);
		}
		if (prev_x != x || prev_y != y)
		{
			prev_x = x;
			prev_y = y;
			moved = true;
		}
		else
		{
			moved = false;
		}
		
		//render view to screen (muy caro!)
		p.draw();
	}
	
}