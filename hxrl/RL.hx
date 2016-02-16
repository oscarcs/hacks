package hxrl;

import hxrl.backends.IBackend;
import hxrl.render.TileRenderComponent;
import hxrl.tile.Tiles;

/**
 * This class manages the library functions; abstracts away platform
 * and framework-specific code.
 * @author oscarcs
 */
class RL
{
	public static var backend:IBackend;
	
	public static function setup()
	{
		Tiles.setRenderComponent('TileRenderComponent', TileRenderComponent);
		
		backend.setup();
	}
}