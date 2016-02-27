package hxrl;

import hxrl.backends.IBackend;
import hxrl.random.IRandom;
import hxrl.random.Random;
import hxrl.render.Camera;
import hxrl.render.TileRenderComponent;
import hxrl.tile.Tiles;

/**
 * This class manages the library functions; abstracts away platform
 * and framework-specific code.
 * @author oscarcs
 */
class RL
{
	//TODO: use a better source of random to set seed.
	/**
	 * Default random.
	 */
	public static var random:IRandom = new Random(Std.random(0x7FFFFFFF - 1));
	
	/**
	 * Default camera.
	 */
	public static var camera = new Camera();
	public static var backend:IBackend;
	
	public static function setup(backend:IBackend)
	{
		RL.backend = backend;
		Tiles.setRenderComponent('TileRenderComponent', TileRenderComponent);
		
		backend.setup();
	}
}