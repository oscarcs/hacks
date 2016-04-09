package hacks.render;

import hacks.RL;
import hacks.render.Color.ARGB;

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
	public var w:Int;		//Width in tiles.
	public var h:Int;		//Height in tiles.
	public var tile_w:Int;	//Width of a tile.
	public var tile_h:Int;	//Height of a tile.
	public var sheet_w:Int;	//Spritesheet width in tiles.
	public var sheet_h:Int;	//Spritesheet height in tiles.
	public var image:String;
	
	var screenBuffer:Array<ScreenTile> = [];
	
	/**
	 * @param	image
	 * @param	wt	width in tiles
	 * @param	ht	height in tiles
	 * @param	tile_w width of a tile
	 * @param	tile_h height of a tile
	 */
	public function new(image:String, wt:Int, ht:Int, tile_w:Int, tile_h:Int) 
	{
		w = wt;
		h = ht;
		this.tile_w = tile_w;
		this.tile_h = tile_h;
		this.image = image;
		
		screenBuffer = [for (x in 0...w) for (y in 0...h) { fg:Color.BLACK, bg:Color.WHITE, value:0, _ch:true } ];
		
		//call framework-specific code
		RL.backend.setup_panel(this);
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
	 * Main rendering function
	 * This code is designed so that any dependency on a rendering library
	 * is abstracted into hacks.backends
	 */
	public function draw()
	{
		//call framework-specific code
		RL.backend.render_panel(this);
	}
	
	/**
	 * Force the Panel to be updated for redrawing by removing mutexes and setting update flags.
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