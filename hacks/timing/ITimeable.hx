package hacks.timing;

/**
 * Anything that requires updating on a frame-independent interval.
 * @author oscarcs
 */
interface ITimeable 
{
	/**
	 * Function called after every interval; normally turns in a turn-based game.
	 */
	public function step():Void;
}