package hxrl.ui;

import hxrl.render.Color;
import hxrl.render.Color.ARGB;
import hxrl.render.Camera;
import hxrl.render.IRenderable;
import hxrl.render.Panel;
import hxrl.tile.ITileable;
import hxrl.tile.Tiles;
import hxrl.tile.Tiles.RLTile;
import hxrl.tile.TileUtil;

/**
 * Javascript-style options type.
 */
typedef UIOptions = {
	@:optional var hasBorder:Bool;
	@:optional var title:String;
	@:optional var fg:ARGB;
	@:optional var bg:ARGB;
	@:optional var edgeName:String;
	@:optional var backName:String;
	
	//title
	@:optional var title_fg:ARGB;
	@:optional var title_bg:ARGB;
	@:optional var title_x:Int;
}

/**
 * General UI element class.
 * @author oscarcs
 */
class UI implements IRenderable implements ITileable
{
	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
	public var buffer:Array<RLTile> = [];
	private var options:UIOptions;
	
	public function new(xt:Int, yt:Int, w:Int, h:Int, ?opts:UIOptions)
	{
		x = xt;
		y = yt;
		this.w = w;
		this.h = h;
		
		buffer = [for (i in 0...w) for (j in 0...h) Tiles.get("none") ];
		
		// initialize options:
		opts != null ? options = opts : options = { };
		
		if (options.hasBorder == null) options.hasBorder = false;
		if (options.title == null) options.title = '';
		if (options.fg == null) options.fg = Color.get('white');
		if (options.bg == null) options.bg = Color.get('black');
		if (options.backName == null) options.backName = 'none';
		if (options.edgeName == null) options.edgeName = 'none';
		
		var backTile:RLTile = Tiles.get(options.backName);
		backTile.fg = options.fg;
		backTile.bg = options.bg;
		
		var borderTile:RLTile = Tiles.get('none');
		if (options.hasBorder)
		{
			borderTile = Tiles.get(options.edgeName);
			borderTile.fg = options.fg;
			borderTile.bg = options.bg;
		}
		
		for (i in 0...w)
		{
			for (j in 0...h)
			{
				if (options.hasBorder && (i == 0 || i == w - 1 || j == 0 || j == h - 1))
				{
					write(i, j, borderTile);
				}
				else
				{
					write(i, j, backTile);
				}
			}
		}
		if (options.title != "")
		{
			var fg:ARGB = options.fg;
			var bg:ARGB = options.bg;
			var title_x:Int = Std.int((this.w - options.title.length) / 2);
			
			if (options.title_fg != null) fg = options.title_fg;
			if (options.title_bg != null) bg = options.title_bg;
			if (options.title_x != null) title_x = options.title_x;
			
			TileUtil.drawText(title_x, 0, this, options.title, fg, bg);
		}
	}
	
	public function read(xt:Int, yt:Int):RLTile
	{
		if (xt >= 0 && yt >= 0 && xt < w && yt < h)
		{
			return buffer[xt + yt * w];
		}
		return null;
	}
	
	public function write(xt:Int, yt:Int, tile:RLTile):Void
	{
		if (xt >= 0 && yt >= 0 && xt < w && yt < h)
		{
			var cur = buffer[xt + yt * w];
			if (cur.rc != tile.rc || 
				cur.fg != tile.fg || 
				cur.bg != tile.bg || 
				cur.solid != tile.solid ||
				cur.tiletype != tile.tiletype)
			{
				cur._ch = true;
			}
			cur.bg = tile.bg;
			cur.fg = tile.fg;
			cur.rc = tile.rc;
			cur.solid = tile.solid;
			cur.tiletype = tile.tiletype;
		}
	}
	
	public function draw(p:Panel, c:Camera):Void
	{
		for (i in 0...w)
		{
			for (j in 0...h)
			{
				var cur = read(i, j);
				if (cur._ch)
				{
					for (k in 0...cur.rc.length)
					{
						cur.rc[k].render(p, c, cur, this, i, j, i + x, j + y, true);
					}
				}
			}
		}
	}
}