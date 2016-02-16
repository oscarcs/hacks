package hxrl.backends;

import hxrl.render.Panel;

/**
 * @author oscarcs
 */
interface IBackend 
{
	/**
	 * Set up the backend.
	 */
	public function setup():Void;
	
	/**
	 * Perform functions to set up a panel.
	 */
	public function setup_panel(panel:Panel):Void;
	
	/**
	 * Render the contents of a panel.
	 */
	public function render_panel(panel:Panel):Void;
}