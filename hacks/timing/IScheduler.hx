package hacks.timing;

/**
 * @author oscarcs
 */
interface IScheduler 
{
	/**
	 * Add the entity to (the end of) the scheduler.
	 * @param	entity
	 * @param	repeat	is this a one-time event? 
	 */
	public function add(entity:ITimeable, ?repeat:Bool = false):Void;
	
	/**
	 * Remove an item from the scheduler.
	 * @param	entity
	 * @return
	 */
	public function remove(entity:ITimeable):Bool;
	
	/**
	 * Calls step() on the next entity.
	 * @return	Whether there are items left to update this turn.
	 */
	public function next():Bool;
}