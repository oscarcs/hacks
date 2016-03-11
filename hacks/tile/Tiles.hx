package hacks.tile;

import hacks.RL;
import haxe.Json;
import hacks.render.TileRenderComponent;
import hacks.tile.Tiles.RLTile;
import hacks.render.Color;
import hacks.render.Color.ARGB;
import hacks.render.IRenderComponent;
import hacks.entity	.Entity;

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
class Tiles
{
	private static var tileList:Map<String, RLTile> = ['none' => Tiles.none];
	private static var renderComponentList:Map<String, Class<IRenderComponent>> = new Map<String, Class<IRenderComponent>>();
	
	//hardcoded fallback
	public static var none:RLTile = {
		tiletype:"none",
		solid:false,
		rc:[new TileRenderComponent(0)],
		fg:Color.WHITE,
		bg:Color.BLACK,
		_ch:true
	}
	
	/**
	 * Add a tile definition to the tile list.
	 * @param	name
	 * @param	tile
	 */
	public static function set(name:String, tile:RLTile)
	{
		Tiles.tileList.set(name, tile);
	}
	
	/**
	 * Get an instance of a tile in the tile list.
	 * @param	name
	 * @return
	 */
	public static function get(name:String):RLTile
	{
		var t:RLTile;
		if (name == 'none') 
		{
			t = Tiles.none;
		}   
		else
		{  
			t = Tiles.tileList.get(name);
		}
		
		//TODO: deep copy rc
		var wt:RLTile = { tiletype:t.tiletype, solid:t.solid, rc:t.rc, fg:t.fg, bg:t.bg, _ch:t._ch };
		return wt;
	}
	
	/**
	 * Register a render component type.
	 * @param	name
	 * @param	rc
	 */
	public static function setRenderComponent(name:String, rc:Class<IRenderComponent>)
	{
		Tiles.renderComponentList.set(name, rc);
	}
	
	/**
	 * Create an instance of a render component.
	 * @param	name
	 * @param	args
	 * @return
	 */
	public static function getRenderComponent(name:String, args:Array<Dynamic>):IRenderComponent
	{
		return Type.createInstance(renderComponentList.get(name), args);
	}
	
	/**
	 * Load a tile definition from file.
	 * [Un]serializing arbitrary data isn't very type-safe...
	 * @param	def	The location of a JSON tile definition file.
	 */
	public static function loadTiledef(def:String)
	{
		var text = RL.backend.get_text(def);
		if (text != null)
		{
			var json:Dynamic = Json.parse(text);
			
			var tile:RLTile = get('none');
			tile.tiletype = json.tiletype;
			tile.solid = json.solid;
		
			if (Std.is(json.fg, String))
			{
				tile.fg = Color.get(json.fg);
			}
			else
			{
				tile.fg = json.fg;
			}
			
			if (Std.is(json.bg, String))
			{
				tile.bg = Color.get(json.bg);
			}
			else
			{
				tile.bg = json.bg;
			}
			
			tile.rc = [];
			for (i in 0...json.rc.length)
			{
				var cur = json.rc[i];
				tile.rc.push(getRenderComponent(cur.rc, cur.args));
			}
			Tiles.set(json.name, tile);
		}
		else
		{
			throw('Tiledef ' + def + ' could not be loaded.');
		}
	}
}