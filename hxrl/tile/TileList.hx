package hxrl.tile;

import haxe.Json;
import hxrl.tile.TileList.RLTile;
import hxrl.tile.TileList.RenderType;
import hxrl.render.Color;
import hxrl.render.Color.ARGB;
import hxrl.entity.Entity;

typedef RLTile = {
	var solid:Bool;
	var rt:RenderType;
	var fg:ARGB;
	var bg:ARGB;
	var _ch:Bool;
	
	//for world
	@:optional var tiletype:String;
	@:optional var entity:Entity;
}

enum RenderType
{
	Tile(value:Int);
	Border(value:BorderValues);
	Water(value:BorderValues, shorefg:ARGB, shorebg:ARGB);
}

typedef BorderValues = {
	var oxox:Int;	// │	
	var oxoo:Int;	// ┤
	var xxoo:Int;	// ┐
	var ooxx:Int;	// └
	var ooxo:Int;	// ┴
	var xooo:Int;	// ┬
	var ooox:Int;	// ├
	var xoxo:Int;	// ─
	var oooo:Int;	// ┼
	var oxxo:Int;	// ┘
	var xoox:Int;	// ┌
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
		rt:Tile(0),
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
		var wt:RLTile = { tiletype:t.tiletype, solid:t.solid, rt:t.rt, fg:t.fg, bg:t.bg, _ch:t._ch };
		return wt;
	}
}