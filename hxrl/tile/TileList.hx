package hxrl.tile;

import haxe.Json;
import hxrl.render.TileRenderComponent;
import hxrl.tile.TileList.RLTile;
import hxrl.render.Color;
import hxrl.render.Color.ARGB;
import hxrl.render.IRenderComponent;
import hxrl.entity.Entity;

typedef RLTile = {
	var solid:Bool;
	var rc:Array<IRenderComponent>;
	var fg:ARGB;
	var bg:ARGB;
	var _ch:Bool;
	
	//TODO: ECS this too?
	//for world
	@:optional var tiletype:String;
	@:optional var entity:Entity;
}

/**
 * Static list of tiles. Will eventually be loaded from file.
 * @author oscarcs
 */
class TileList
{
	//hardcoded fallback
	public static var none:RLTile = {
		tiletype:"none",
		solid:false,
		rc:[new TileRenderComponent(0)],
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	}
	
	public static var tiles:Map<String, RLTile>;
	
	//TODO load from JSON instead of using statically coded tiles.
	public static function get(name:String):RLTile
	{
		var t:RLTile;
		if (name == 'none') 
		{
			t = TileList.none;
		}   
		else
		{  
			t = TileList.tiles.get(name);
		}
		
		//TODO: deep copy rc
		var wt:RLTile = { tiletype:t.tiletype, solid:t.solid, rc:t.rc, fg:t.fg, bg:t.bg, _ch:t._ch };
		return wt;
	}
}