package hacks.render;
import haxerl.*;

typedef HSV = {
	var h:Float; //0-360
	var s:Float; //0-1
	var v:Float; //0-1
}

typedef RGB = {
	var r:Float; //0-255
	var g:Float; //0-255
	var b:Float; //0-255
}

/**
 * Color conversion class.
 * @author oscarcs
 */
class Color
{
	public static var WHITE:RGB = 	{	r:255, 	g:255, 	b:255 	};
	public static var BLACK:RGB = 	{	r:0, 	g:0, 	b:0 	};
	public static var RED:RGB = 	{	r:255, 	g:0, 	b:0 	};
	public static var GREEN:RGB = 	{	r:0, 	g:255, 	b:0 	};
	public static var BLUE:RGB = 	{	r:0, 	g:0, 	b:255 	};
	
	private static var colorList:Map<String, RGB> =
	[
		'white' => Color.WHITE,
		'black' => Color.BLACK,
		'red'	=> Color.RED,
		'green' => Color.GREEN,
		'blue'	=> Color.BLUE
	];
	
	private static function set(name:String, color:RGB)
	{
		Color.colorList.set(name, color);
	}
	
	public static function get(name:String):RGB
	{
		return Color.colorList.get(name);
	}
	
	public static function RGBtoHex(rgb:RGB):Int
	{
		var x:String = '0x'	+ StringTools.hex(Std.int(rgb.r), 2)
							+ StringTools.hex(Std.int(rgb.g), 2)
							+ StringTools.hex(Std.int(rgb.b), 2);
		return Std.parseInt(x);
	}
	
	public static function HexToRGB(hex:Int):RGB
	{
		var cs:String = StringTools.hex(hex, 8);

		var r:Float = Std.parseInt("0x" + cs.substr(0, 2));
		var g:Float = Std.parseInt("0x" + cs.substr(2, 2));
		var b:Float = Std.parseInt("0x" + cs.substr(4, 2));
		
		
		var conv:RGB = { r:r, g:g, b:b };
		return conv;
	}
	
	public static function HSVtoRGB(hsv:HSV):RGB
	{
		var H:Float = hsv.h / 360;
		var S:Float = hsv.s;
		var V:Float = hsv.v;
		
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
		return { r:R, g:G, b:B };
	}
	
	public static function RGBtoHSV(rgb:RGB):HSV
	{
		var r:Float, g:Float, b:Float;
		r = rgb.r / 255;
		g = rgb.g / 255;
		b = rgb.b / 255;

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

		return { h:h, s:s, v:v };
	}
}