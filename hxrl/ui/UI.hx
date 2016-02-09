package hxrl.ui;

import hxrl.render.Color;
import hxrl.render.Color.ARGB;
import hxrl.render.Camera;
import hxrl.render.IRenderable;
import hxrl.render.Panel;
import hxrl.tile.ITileable;
import hxrl.tile.TileList;
import hxrl.tile.TileList.RLTile;
import hxrl.tile.TileUtil;

typedef UIData = {
	var hasBorder:Bool;
	var title:String;
	var fg:ARGB;
	var bg:ARGB;
	@optional var edgeName:String;
	@optional var backName:String;
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
		
		buffer = [for (i in 0...w) for (j in 0...h) TileList.get("none") ];
	}
	
	public function init(ui:UIData)
	{
		uiData = ui;
			
		var backTile:RLTile = TileList.get(uiData.backName);
		backTile.fg = uiData.fg;
		backTile.bg = uiData.bg;
		
		var borderTile:RLTile = TileList.get('none');
		if (uiData.hasBorder)
		{
			borderTile = TileList.get(uiData.edgeName);
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
			TileUtil.drawText(Std.int((w - uiData.title.length) / 2), 0, this, uiData.title, uiData.fg, uiData.bg);
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
			if (cur.rt != tile.rt || 
				cur.fg != tile.fg || 
				cur.bg != tile.bg || 
				cur.solid != tile.solid ||
				cur.tiletype != tile.tiletype)
			{
				cur._ch = true;
			}
			cur.bg = tile.bg;
			cur.fg = tile.fg;
			cur.rt = tile.rt;
			cur.solid = tile.solid;
			cur.tiletype = tile.tiletype;
			cur._ch = true;
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
					switch(cur.rt)
					{
						case Tile(value):
							if (value != 0) //transparency!
							{
								p.write(i + x, j + y, cur.fg, cur.bg, value, this);
							}
						
						case Border(values):
							var val = TileUtil.borderAutoTile(i, j, this, cur, values);
							p.write(i + x, j + y, cur.fg, cur.bg, val, this);
						
						case Water(values, shorefg, shorebg):	
							var val = values.oooo;//TileUtil.waterAutoTile(i, j, this, cur, values);
							if (val == values.oooo)
							{
								p.write(i + x, j + y, cur.fg, cur.bg, val, this);
							}
							else
							{
								p.write(i + x, j + y, shorefg, shorebg, val, this);
							}
					}
					cur._ch = false;
				}
			}
		}
	}
}