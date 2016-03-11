package hxrl.render;
import haxerl.*;

typedef HSV = {
	var h:Float; //0-360
	var s:Float; //0-100
	var v:Float; //0-100
}

//0-255
typedef ARGB = {
	var a:Float;
	var r:Float;
	var g:Float;
	var b:Float;
}

/**
 * Color conversion class.
 * @author oscarcs
 */
class Color
{
	public static var WHITE:ARGB = 	{	a:255,	r:255, 	g:255, 	b:255 	};
	public static var BLACK:ARGB = 	{	a:255,	r:0, 	g:0, 	b:0 	};
	public static var RED:ARGB = 	{	a:255,	r:255, 	g:0, 	b:0 	};
	public static var GREEN:ARGB = 	{	a:255,	r:0, 	g:255, 	b:0 	};
	public static var BLUE:ARGB = 	{	a:255,	r:0, 	g:0, 	b:255 	};
	
	private static var colorList:Map<String, ARGB> =
	[
		'white' => Color.WHITE,
		'black' => Color.BLACK,
		'red'	=> Color.RED,
		'green' => Color.GREEN,
		'blue'	=> Color.BLUE
	];
	
	private static function set(name:String, color:ARGB)
	{
		Color.colorList.set(name, color);
	}
	
	public static function get(name:String):ARGB
	{
		return Color.colorList.get(name);
	}
	
	public static function ARGBtoHex(rgb:ARGB):Int
	{
		var x:String = '0x' + StringTools.hex(Std.int(rgb.a), 2)
							+ StringTools.hex(Std.int(rgb.r), 2)
							+ StringTools.hex(Std.int(rgb.g), 2)
							+ StringTools.hex(Std.int(rgb.b), 2);
		return Std.parseInt(x);
	}
	
	public static function HexToARGB(hex:Int):ARGB
	{
		var cs:String = StringTools.hex(hex, 8);

		var a:Float = Std.parseInt("0x" + cs.substr(0, 2));
		var r:Float = Std.parseInt("0x" + cs.substr(2, 2));
		var g:Float = Std.parseInt("0x" + cs.substr(4, 2));
		var b:Float = Std.parseInt("0x" + cs.substr(6, 2));
		
		
		var conv:ARGB = { a:a, r:r, g:g, b:b };
		return conv;
	}
	
	public static function HSVtoARGB(hsv:HSV):ARGB
	{
		var H:Float = hsv.h / 360;
		var S:Float = hsv.s / 100;
		var V:Float = hsv.v / 100;
		
		var R:Float;
		var G:Float;
		var B:Float;
		var hVar:Float, iVar:Float, var1:Float, var2:Float, var3:Float, rVar:Float, gVar:Float, bVar:Float;
		
		if (S == 0) 
		{
			R = V * 255;
			G = V * 255;
			B = V * 255;
		}
		else 
		{
			hVar = H * 6;
			iVar = Math.floor(hVar);
			var1 = V * (1 - S);
			var2 = V * (1 - S * (hVar - iVar));
			var3 = V * (1 - S * (1 - (hVar - iVar)));

			if (iVar == 0) { rVar = V; gVar = var3; bVar = var1; }
			else if (iVar == 1) { rVar = var2; gVar = V; bVar = var1; }
			else if (iVar == 2) { rVar = var1; gVar = V; bVar = var3; }
			else if (iVar == 3) { rVar = var1; gVar = var2; bVar = V; }
			else if (iVar == 4) { rVar = var3; gVar = var1; bVar = V; }
			else { rVar = V; gVar = var1; bVar = var2; };

			R = rVar * 255;
			G = gVar * 255;
			B = bVar * 255;
		}
		return { a:255, r:R, g:G, b:B };
	}
	
	public static function ARGBtoHSV(argb:ARGB):HSV
	{
		var r:Float, g:Float, b:Float;
		r = argb.r / 255;
		g = argb.g / 255;
		b = argb.b / 255;

		var h:Float, s:Float, v:Float;
		var min:Float, max:Float, delta:Float;

		min = Math.min(r, Math.min(g, b));
		max = Math.max(r, Math.max(g, b));

		v = max;
		delta = max - min;
		
		if (max != 0)
		{
			s = delta / max;
		}
		else
		{
			s = 0;
			h = -1;
			return {h:h, s:s, v:v};
		}
		
		if (r == max)
		{
			h = (g - b) / delta;
		}
		else if (g == max)
		{
			h = 2 + (b - r) / delta;
		}
		else
		{
			h = 4 + (r - g) / delta;
		}
		
		h *= 60;
		
		if (h < 0)
		{
			h += 360;
		}

		return { h:h, s:s * 100, v:v * 100 };
	}
}