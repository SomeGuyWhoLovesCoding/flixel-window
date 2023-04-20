package;

import flixelwindow.Window;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import lime.app.Application;

import flixelwindow.Window.FlixelWindow;

class Main extends Sprite {
	public function new() {
		super();
		//addChild(new FlxGame(10256, 6016, flixelwindow.Window, true, 120, 60, true));
		addChild(new FlxGame(#if !html5 1282 #else 1920 #end, #if !html5 752 #else 1080 #end, FlixelWindow, #if (flixel < "5.0.0") 1, #end 60, 60, false, false));
	}
}