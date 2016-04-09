package hacks.timing;

/**
 * Simple scheduler that maintains an entity list 
 * and calls step() on each of them sequentially.
 * @author oscarcs
 */
class LinearScheduler implements IScheduler
{	
	private var queue:Array<ITimeable> = [];
	private var entityList:Array<ITimeable> = [];
	
	public function new() 
	{
		
	}
	
	/**
	 * Add the entity to (the end of) the scheduler.
	 * @param	entity
	 * @param	repeat	is this a one-time event? 
	 */
	public function add(entity:ITimeable, ?repeat:Bool = true):Void
	{
		if (repeat)
		{
			entityList.push(entity);
			queue.push(entity);
		}
		else
		{
			queue.push(entity);
		}
	}

	/**
	 * Remove an item from the scheduler.
	 * @param	entity
	 * @return
	 */
	public function remove(entity:ITimeable):Bool
	{
		return entityList.remove(entity);
	}
	
	/**
	 * Calls step() on the next entity.
	 * @return	Whether there are items left to update this turn.
	 */
	public function next():Bool
	{
		if (queue.length > 0)
		{
			queue[0].step();
			queue.remove(queue[0]);
		}
		
		if (queue.length > 0)
		{	
			return true;
		}
		else
		{
			//reset the queue to the permanent entities
			queue = entityList.copy();
			return false;
		}
	}
	
}