package hacks.random;

/**
 * Haxe xorshift PRNG implementation.
 * Ensure the seed is set before use.
 * @see http://excamera.com/sphinx/article-xorshift.html
 * @author oscarcs
 */
class Random implements IRandom
{
	public var seed:Int = 4;//chosen by fair dice roll. 
							//guaranteed to be random.
							
	public function new(?seed:Int)
	{
		if (seed != null)
		{
			this.seed = seed;
		}
	}
	
	public function setSeed(x:Int):Void
	{
		seed = x;
	}
	
	/**
	 * Return a random Int.
	 * @param	bits	Number of random bits to generate.
	 */
	public function next(?bits:Int = 32):Int
	{
		seed ^= seed << 13;
		seed ^= seed >> 17;
		seed ^= seed << 5;
		
		return seed >>> (32 - bits);
	}
	
	/**
	 * Get a random value between 0 and 1.
	 * This implementation is imperfect but probably sufficient.
	 */
	public function nextFloat():Float
	{
		return Math.abs(next() / 0x7FFFFFFF);
	}
		
	/**
	 * Generate int in range [min, max].
	 * Based on Java implementation from
	 * https://stackoverflow.com/questions/363681/generating-random-integers-in-a-specific-range
	 * @param	min
	 * @param	max
	 */
	public function nextRangedInt(min:Int, max:Int):Int
	{
		return min + Std.int((nextFloat() * ((max - min) + 1)));
	}
	
	public function nextBool():Bool
	{
		return next(1) == 1 ? true : false;
	}
}