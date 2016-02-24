package hxrl;

import hxrl.backends.IBackend;
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
	public static var camera = new Camera();
	public static var backend:IBackend;
	
	public static function setup(backend:IBackend)
	{
		RL.backend = backend;
		Tiles.setRenderComponent('TileRenderComponent', TileRenderComponent);
		
		backend.setup();
	}
}