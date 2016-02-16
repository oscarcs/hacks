package hxrl.random;

/**
 * Haxe xorshift PRNG implementation.
 * Ensure the seed is set before use.
 * @see http://excamera.com/sphinx/article-xorshift.html
 * @author oscarcs
 */
class Random
{
	public static var seed:Int = 4; //chosen by fair dice roll. 
									//guaranteed to be random.
	
	public static function setSeed(x:Int)
	{
		seed = x;
	}
	
	/**
	 * Return a random 32-bit int
	 */
	public static function nextInt()
	{
		seed ^= seed << 13;
		seed ^= seed >> 17;
		seed ^= seed << 5;
		return seed;
	}
	
	/**
	 * Generate int in range [min, max].
	 * Based on Java implementation from
	 * https://stackoverflow.com/questions/363681/generating-random-integers-in-a-specific-range
	 * @param	min
	 * @param	max
	 */
	public static function nextRangedInt(min:Int, max:Int)
	{
		return min + Std.int((nextFloat() * ((max - min) + 1)));
	}
	
	/**
	 * Get a random value between 0 and 1.
	 * Not thoroughly tested, but probably sufficient.
	 */
	public static function nextFloat()
	{
		return Math.abs(nextInt() / 0x7FFFFFFF);
	}
}