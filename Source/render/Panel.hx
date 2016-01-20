package render;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

import render.Color.ARGB;

typedef ScreenTile = {
	var fg:ARGB;
	var bg:ARGB;
	var value:Int;
	var _ch:Bool;
}

/**
 * ...
 * @author oscarcs
 */
class Panel
{
	public var WIDTH:Int = 64;		//Width in tiles.
	public var HEIGHT:Int = 48;		//Height in tiles.
	public var T_WIDTH:Int = 9;		//Width of a tile.
	public var T_HEIGHT:Int = 16;	//Height of a tile.
	public var S_WIDTH:Int;			//Spritesheet width in tiles.
	public var S_HEIGHT:Int;		//Spritesheet height in tiles.
	
	var screenBuffer:Array<ScreenTile> = [];

	var tilemap:BitmapData;
	var rArr:Array<Int> = [for (i in 0...256) 0];
	var gArr:Array<Int> = [for (i in 0...256) 0];
	var bArr:Array<Int> = [for (i in 0...256) 0];
	
	var bytes:ByteArray;
	var offset:Int = 0;
	
	public function new(image:String) 
	{
		WIDTH = Std.int(640 / T_WIDTH);
		HEIGHT = Std.int(480 / T_HEIGHT);
		
		screenBuffer = [for (x in 0...WIDTH) for (y in 0...HEIGHT) { fg:Color.BLACK, bg:Color.WHITE, value:0, _ch:true } ];
		
		tilemap = Assets.getBitmapData(image);
		S_WIDTH = Std.int(tilemap.width / T_WIDTH);
		S_HEIGHT = Std.int(tilemap.height / T_HEIGHT);
		
		bytes = new ByteArray();
	}
	
	public function read(xt:Int, yt:Int):ScreenTile
	{
		return screenBuffer[xt + yt * WIDTH];
	}
	
	public function write(xt:Int, yt:Int, fg:ARGB, bg:ARGB, value:Int)
	{
		if (xt >= 0 && yt >= 0 && xt < WIDTH && yt < HEIGHT)
		{
			var cur = read(xt, yt);
			if (cur.value != value || cur.fg != fg || cur.bg != bg)
			{
				cur._ch = true;
			}
			cur.fg = fg;
			cur.bg = bg;
			cur.value = value;
		}
	}
	
	/**
	 * Main rendering function. Currently optimized for Flash target, uses copyPixels.
	 */
	public function draw()
	{
		for (x in 0...WIDTH)
		{
			for (y in 0...HEIGHT)
			{
				var cur = read(x, y);
				if (cur._ch)
				{
					var xt = cur.value % (S_WIDTH);
					var yt = Std.int(cur.value / (S_WIDTH));
					
					Main.inst.surface.copyPixels(tilemap, new Rectangle(xt * T_WIDTH, yt * T_HEIGHT, T_WIDTH, T_HEIGHT), new Point(x * T_WIDTH, y * T_HEIGHT));
					
					
					if (cur.bg != Color.BLACK)
					{
						rArr[0] = Color.ARGBtoHex(cur.bg);
						gArr[0] = Color.ARGBtoHex(cur.bg);
						bArr[0] = Color.ARGBtoHex(cur.bg);				
	
						rArr[255] = Color.ARGBtoHex(cur.fg);
						gArr[255] = Color.ARGBtoHex(cur.fg);
						bArr[255] = Color.ARGBtoHex(cur.fg);
						
						Main.inst.surface.paletteMap(Main.inst.surface, new Rectangle(x * T_WIDTH, y * T_HEIGHT, T_WIDTH, T_HEIGHT), new Point(x * T_WIDTH, y * T_HEIGHT), rArr, gArr, bArr, null);
					}
					else //faster!
					{
						Main.inst.surface.colorTransform(new Rectangle(x * T_WIDTH, y * T_HEIGHT, T_WIDTH, T_HEIGHT), new ColorTransform(cur.fg.r / 255, cur.fg.g / 255, cur.fg.b / 255, 1, 0, 0, 0, 0));
					}
					cur._ch = false;
					
				}
			}
		}
		
	}
	
}