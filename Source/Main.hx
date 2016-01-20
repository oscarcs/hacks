package;

import openfl.display.FPS;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

import render.Panel;
import render.Camera;
import render.Color;
import ui.UI;
import ui.UIMap;
import world.World;
import world.WorldMap;
import tile.TileList;
import tile.TileUtil;
import entity.Player;


typedef KeyData = {
	var isPressed:Bool;
	var justPressed:Bool;
	var justReleased:Bool;
	var _hasReleased:Bool;
}

class Main extends Sprite
{
	public static var inst:Main;
	
	public var panel:Panel;
	public var worldmap:WorldMap;
	public var world:World;
	public var ui:UI;
	public var player:Player;
	public var camera:Camera;
	
	//framework-specific
	public var surface:BitmapData;
	public var keys:Array<KeyData> = [for (i in 0...222) {isPressed:false, justPressed:false, justReleased:false, _hasReleased:true}];
	public var fps:FPSMem;
	
	public function new()
	{	
		super();
		//framework garbage
		{
			surface = new BitmapData(Std.int(640), Std.int(480), false, 0xFFAAAAAA);
			var bitmap = new Bitmap(surface);
			addChild(bitmap);
			fps = new FPSMem(10, 10, 0x00FF00);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		inst = this;
		
		panel = new Panel("assets/tiles9x16.png");
		panel.draw();
		
		worldmap = new WorldMap(40, 40);
		
		world = new World(panel.WIDTH, panel.HEIGHT, worldmap);
		
		ui = new UI(0, panel.HEIGHT - 6, panel.WIDTH, 6);
		ui.init(true, Color.WHITE, Color.BLACK, "| INFO |");
		
		var uimap = new UIMap(panel.WIDTH - 14, panel.HEIGHT - 8, 14, 8, worldmap);
		uimap.init(true, Color.WHITE, Color.BLACK, "| MAP |");
		
		player = new Player(2, 2, world);
		
		camera = new Camera();
		camera.x = camera.y = 0;
		camera.add(world);
		camera.add(ui);
		camera.add(uimap);
		
		addChild(fps); //add last, duh
		fps.visible = false;
	}
	
	public function onEnterFrame(e:Event)
	{
		TileUtil.drawText(1, 1, ui, "FPS: " + fps.times.length + "\nMem: " + fps.mem + " MB\nMem peak: " + fps.memPeak + " MB", Color.WHITE, Color.BLACK, ui.WIDTH - 2); 
		/*
		switch(Std.random(4))
		{
			case 0:
				if(c.y > 0) c.y --;
			case 1:
				if(c.x < w.WIDTH) c.x ++;
			case 2:
				if(c.y < w.HEIGHT) c.y ++;
			case 3:
				if(c.x > 0) c.x --;
		}
		*/
		if (keys[Keyboard.UP].isPressed)
		{
			if (camera.y > 0)
			{
				//a.y --;
				camera.y --;
			}
		}
		if (keys[Keyboard.RIGHT].isPressed)
		{
			if (camera.x < world.WIDTH - panel.WIDTH)
			{
				//a.x ++;
				camera.x ++;
			}
		}
		if (keys[Keyboard.DOWN].isPressed)
		{
			if (camera.y < world.HEIGHT - panel.HEIGHT)
			{
				//a.y ++;
				camera.y ++;
			}
		}
		if (keys[Keyboard.LEFT].isPressed)
		{
			if (camera.x > 0)
			{
				//a.x --;
				camera.x --;
			}
		}
		
		camera.draw(panel);
		
		for (i in 0...keys.length)
		{
			keys[i].justReleased = false;
			keys[i].justPressed = false;
		}
	}
	
	public function onKeyUp(e:KeyboardEvent)
	{
		var cur = keys[e.keyCode];
		cur.isPressed = false;
		cur.justReleased = true;
		cur._hasReleased = true;
	}
	
	public function onKeyDown(e:KeyboardEvent)
	{
		var cur = keys[e.keyCode];
		cur.isPressed = true;
		if (cur._hasReleased) cur.justPressed = true;
		cur._hasReleased = false;
	}
}