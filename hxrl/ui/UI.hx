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

typedef UIData = {
	var hasBorder:Bool;
	var title:String;
	var fg:ARGB;
	var bg:ARGB;
	var edgeName:String;
	var backName:String;
	
	@:optional var titlefg:ARGB;
	@:optional var titlebg:ARGB;
}

/**
 * ...
 * @author oscarcs
 */
class UI implements IRenderable implements ITileable
{
	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
	public var buffer:Array<RLTile> = [];
	private var uiData:UIData;
	
	public function new(xt:Int, yt:Int, w:Int, h:Int)
	{
		x = xt;
		y = yt;
		this.w = w;
		this.h = h;
		
		buffer = [for (i in 0...w) for (j in 0...h) Tiles.get("none") ];
	}
	
	public function init(ui:UIData)
	{
		uiData = ui;
			
		var backTile:RLTile = Tiles.get(uiData.backName);
		backTile.fg = uiData.fg;
		backTile.bg = uiData.bg;
		
		var borderTile:RLTile = Tiles.get('none');
		if (uiData.hasBorder)
		{
			borderTile = Tiles.get(uiData.edgeName);
			borderTile.fg = uiData.fg;
			borderTile.bg = uiData.bg;
		}
		
		for (i in 0...w)
		{
			for (j in 0...h)
			{
				if (uiData.hasBorder && (i == 0 || i == w - 1 || j == 0 || j == h - 1))
				{
					write(i, j, borderTile);
				}
				else
				{
					write(i, j, backTile);
				}
			}
		}
		if (uiData.title != "")
		{
			var fg:ARGB = uiData.fg;
			var bg:ARGB = uiData.bg;
			trace(uiData.titlefg, uiData.titlebg);
			if (uiData.titlefg != null) fg = uiData.titlefg;
			if (uiData.titlebg != null) bg = uiData.titlebg;
			
			TileUtil.drawText(Std.int((w - uiData.title.length) / 2), 0, this, uiData.title, fg, bg);
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