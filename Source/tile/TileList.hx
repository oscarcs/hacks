package tile;

import haxe.Json;
import openfl.Assets;
import tile.TileList.RLTile;
import tile.TileList.RenderType;
import render.Color;
import render.Color.ARGB;
import entity.Entity;

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
	//oxox:Int, oxoo:Int, xxoo:Int, ooxx:Int, ooxo:Int, xooo:Int, ooox:Int, xoxo:Int, oooo:Int, oxxo:Int, xoox:Int;
	
	public static var blank:RLTile = {
		solid:false,
		rt:Tile(0),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	public static var test:RLTile = {
		solid:false,
		rt:Tile(1),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	/* ********** Indoors ********** */
	
	public static var floor:RLTile = {
		solid:false,
		rt:Tile(249),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	public static var border:RLTile = { 
		solid:true, 
		rt:Border({oxox: 0xB3, oxoo: 0xB4, xxoo: 0xBF, ooxx: 0xC0, 
			ooxo: 0xC1, xooo: 0xC2, ooox: 0xC3, xoxo: 0xC4, 
			oooo: 0xC5, oxxo: 0xD9, xoox: 0xDA}),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	/* ********** Overworld ********** */
	
	public static var grass1:RLTile = {
		tiletype:"grass",
		solid:false,
		rt:Tile(34),
		fg: { a:255, r:108, g:217, b:0 },
		bg: Color.BLACK,
		_ch:true,
	};
	
	public static var grass2:RLTile = {
		tiletype:"grass",
		solid:false,
		rt:Tile(58),
		fg: { a:255, r:89, g:178, b:0 },
		bg: Color.BLACK,
		_ch:true
	};
	
	public static var tree:RLTile = {
		tiletype:"tree",
		solid:false,
		rt:Tile(5),
		fg: { a:255, r:0, g:102, b:0 },
		bg: Color.BLACK,
		_ch:true
	};
	
	
	public static var mountain:RLTile = {
		tiletype:"mountain",
		solid:true,
		rt:Tile(30),
		fg: { a:255, r:102, g:102, b:102 },
		bg: Color.BLACK,
		_ch:true
	};
	
	/* ********** UI ********** */
	
	public static var ui_transparent:RLTile = {
		solid:false,
		rt:Tile(0),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	public static var ui_back:RLTile = {
		solid:false,
		rt:Tile(32),
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	};
	
	//TODO load from JSON instead of using statically coded tiles.
	public static function get(name:String):RLTile
	{
		var t:RLTile = Reflect.field(TileList, name);
		var wt:RLTile = { tiletype:t.tiletype, solid:t.solid, rt:t.rt, fg:t.fg, bg:t.bg, _ch:t._ch };
		return wt;
	}
}