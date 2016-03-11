package hacks;

import hacks.backends.IBackend;
import hacks.random.IRandom;
import hacks.random.Random;
import hacks.render.Camera;
import hacks.render.TileRenderComponent;
import hacks.tile.Tiles;

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
#if neko
	// neko has 31-bit(!) ints
	// which probably breaks the RNG anyway
	public static var random:IRandom = new Random(Std.random(0x40000000 - 1));
#else
	public static var random:IRandom = new Random(Std.random(0x7FFFFFFF - 1));
#end

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