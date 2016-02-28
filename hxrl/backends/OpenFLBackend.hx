package hxrl.backends;

import openfl.Lib;
import openfl.Assets;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

import hxrl.backends.IBackend;
import hxrl.render.Panel;
import hxrl.render.Color;

/**
 * ...
 * @author oscarcs
 */
class OpenFLBackend implements IBackend
{
	public var surface:BitmapData;
	public var bitmap:Bitmap;
	private var tilemap:BitmapData;
	private var rArr:Array<Int> = [for (i in 0...256) 0];
	private var gArr:Array<Int> = [for (i in 0...256) 0];
	private var bArr:Array<Int> = [for (i in 0...256) 0];
	
	public function new() 
	{
		
	}
	
	public function setup()
	{
		var w = Lib.current.stage.stageWidth;
		var h = Lib.current.stage.stageHeight;
		surface = new BitmapData(w, h, false, 0xFFAAAAAA);
		bitmap = new Bitmap(surface);
	}
	
	public function setup_panel(panel:Panel):Void
	{
		tilemap = Assets.getBitmapData(panel.image);
		panel.sheet_w = Std.int(tilemap.width / panel.tile_w);
		panel.sheet_h = Std.int(tilemap.height / panel.tile_h);
	}
	
	//Currently optimized for OpenFL's flash target, uses copyPixels.
	public function render_panel(panel:Panel):Void 
	{
		for (x in 0...panel.w)
		{
			for (y in 0...panel.h)
			{
				var cur = panel.read(x, y);
				if (cur._ch)
				{
					var xt = cur.value % (panel.sheet_w);
					var yt = Std.int(cur.value / (panel.sheet_w));
					
					surface.copyPixels(tilemap, new Rectangle(xt * panel.tile_w, yt * panel.tile_h, panel.tile_w, panel.tile_h),
						new Point(x * panel.tile_w, y * panel.tile_h));
					
					
					if (cur.bg != Color.BLACK)
					{
						rArr[0] = Color.ARGBtoHex(cur.bg);
						gArr[0] = Color.ARGBtoHex(cur.bg);
						bArr[0] = Color.ARGBtoHex(cur.bg);				
	
						rArr[255] = Color.ARGBtoHex(cur.fg);
						gArr[255] = Color.ARGBtoHex(cur.fg);
						bArr[255] = Color.ARGBtoHex(cur.fg);
						
						surface.paletteMap(surface, new Rectangle(x * panel.tile_w, y * panel.tile_h, panel.tile_w, panel.tile_h),
							new Point(x * panel.tile_w, y * panel.tile_h), rArr, gArr, bArr, null);
					}
					else //faster!
					{
						surface.colorTransform(new Rectangle(x * panel.tile_w, y * panel.tile_h, panel.tile_w, panel.tile_h), 
							new ColorTransform(cur.fg.r / 255, cur.fg.g / 255, cur.fg.b / 255, 1, 0, 0, 0, 0));
					}
					cur._ch = false;
					
				}
			}
		}
	}
	
	public function get_text(filepath:String):String
	{
		return Assets.getText(filepath);
	}
	
}