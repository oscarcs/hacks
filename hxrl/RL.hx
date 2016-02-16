package hxrl;

import hxrl.backends.IBackend;

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
		backend.setup();
	}
}