package hxrl.random;

/**
 * @author oscarcs
 */
interface IRandom 
{
	public var seed:Int;
	
	public function setSeed(x:Int):Void;
	public function next(?bits:Int):Int;
	public function nextFloat():Float;
	public function nextRangedInt(min:Int, max:Int):Int;
	public function nextBool():Bool;
}