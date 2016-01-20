package;

import haxe.Timer;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class FPSMem extends TextField
{
	public var times:Array<Float>;
	public var mem:Float;
	public var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) 
	{
		super();
		
		x = inX;
		y = inY;
		selectable = false;
		
		defaultTextFormat = new TextFormat("_sans", 12, inCol);
		
		text = "FPS: ";
		
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 150;
		height = 70;
	}
	
	private function onEnter(_)
	{	
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
			
		mem = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		
		if (visible)
		{	
			text = "FPS: " + times.length + "\nMem: " + mem + " MB\nMem peak: " + memPeak + " MB";	
		}
	}
	
}