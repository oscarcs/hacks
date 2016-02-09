package hxrl.render;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

import hxrl.render.Color.ARGB;

typedef ScreenTile = {
	var fg:ARGB;	//foreground
	var bg:ARGB;	//background
	var value:Int;	//reference to a tile or ASCII char.
	var _ch:Bool;	//whether this tile needs redrawing
	@:optional var _lock:IRenderable;	//mutex
}
	
/**
 * ASCII/Tile 'Panel' for rendering.
 * @author oscarcs
 */
class Panel
{
	public var w:Int = 64;		//Width in tiles.
	public var h:Int = 48;		//Height in tiles.
	public var tile_w:Int = 9;		//Width of a tile.
	public var tile_h:Int = 16;	//Height of a tile.
	public var sheet_w:Int;			//Spritesheet width in tiles.
	public var sheet_h:Int;		//Spritesheet height in tiles.
	
	var screenBuffer:Array<ScreenTile> = [];

	//framework-specific
	public var surface:BitmapData;
	private var tilemap:BitmapData;
	private var rArr:Array<Int> = [for (i in 0...256) 0];
	private var gArr:Array<Int> = [for (i in 0...256) 0];
	private var bArr:Array<Int> = [for (i in 0...256) 0];
	
	public function new(image:String) 
	{
		w = Std.int(640 / tile_w);
		h = Std.int(480 / tile_h);
		
		screenBuffer = [for (x in 0...w) for (y in 0...h) { fg:Color.BLACK, bg:Color.WHITE, value:0, _ch:true } ];
		
		//framework-specific
		tilemap = Assets.getBitmapData(image);
		sheet_w = Std.int(tilemap.width / tile_w);
		sheet_h = Std.int(tilemap.height / tile_h);
	}
	
	public function read(xt:Int, yt:Int):ScreenTile
	{
		return screenBuffer[xt + yt * w];
	}
	
	public function write(xt:Int, yt:Int, fg:ARGB, bg:ARGB, value:Int, ?accessor:IRenderable)
	{
		if (xt >= 0 && yt >= 0 && xt < w && yt < h)
		{
			var cur = read(xt, yt);
			if (cur._lock == null || cur._lock == accessor)
			{
				if (cur.value != value || cur.fg != fg || cur.bg != bg)
				{
					cur._ch = true;
				}
				cur.fg = fg;
				cur.bg = bg;
				cur.value = value;
			}
		}
	}
	
	/**
	 * Main rendering function. Currently optimized for OpenFL's flash target, uses copyPixels.
	 * This code class is designed so that any dependency on a rendering library
	 * needs only to be coupled to this method.
	 */
	public function draw()
	{
		//framework-specific
		for (x in 0...w)
		{
			for (y in 0...h)
			{
				var cur = read(x, y);
				if (cur._ch)
				{
					var xt = cur.value % (sheet_w);
					var yt = Std.int(cur.value / (sheet_w));
					
					surface.copyPixels(tilemap, new Rectangle(xt * tile_w, yt * tile_h, tile_w, tile_h), new Point(x * tile_w, y * tile_h));
					
					
					if (cur.bg != Color.BLACK)
					{
						rArr[0] = Color.ARGBtoHex(cur.bg);
						gArr[0] = Color.ARGBtoHex(cur.bg);
						bArr[0] = Color.ARGBtoHex(cur.bg);				
	
						rArr[255] = Color.ARGBtoHex(cur.fg);
						gArr[255] = Color.ARGBtoHex(cur.fg);
						bArr[255] = Color.ARGBtoHex(cur.fg);
						
						surface.paletteMap(Main.inst.surface, new Rectangle(x * tile_w, y * tile_h, tile_w, tile_h), new Point(x * tile_w, y * tile_h), rArr, gArr, bArr, null);
					}
					else //faster!
					{
						surface.colorTransform(new Rectangle(x * tile_w, y * tile_h, tile_w, tile_h), new ColorTransform(cur.fg.r / 255, cur.fg.g / 255, cur.fg.b / 255, 1, 0, 0, 0, 0));
					}
					cur._ch = false;
					
				}
			}
		}
	}
	
	/**
	 * Force the Panel to be updated by removing mutexes and setting update flags.
	 */
	public function forceRedraw()
	{
		for (x in 0...w)
		{
			for (y in 0...h)
			{
				read(x, y)._ch = true;
				read(x, y)._lock = null;
			}
		}
	}
	
	/**
	 * Allow a render context to lock a rect of tiles.
	 * Useful for z-indexing, for example.
	 * @param	xt
	 * @param	yt
	 * @param	w
	 * @param	h
	 * @param	lock
	 */
	public function setLock(xt:Int, yt:Int, w:Int, h:Int, lock:IRenderable)
	{
		for (x in xt...(xt + w))
		{
			for (y in yt...(yt + h))
			{
				read(x, y)._lock = lock;
			}
		}
	}
	
}