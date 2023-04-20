package flixelwindow;

import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lime.app.Application;

class FlixelWindow extends FlxState {
	var backgroundSpr:FlxSprite;
	var flixelWindow:Window;
	private var windowCaption:FlxCamera;

    override function create() {
		FlxG.cameras.setDefaultDrawTarget(FlxG.camera, true);
		windowCaption = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
		FlxG.cameras.add(windowCaption, true);
		this.cameras = [windowCaption];

		backgroundSpr = new FlxSprite(1, 30).loadGraphic("assets/preview.png");
		backgroundSpr.setGraphicSize(FlxG.width, FlxG.height);
		backgroundSpr.updateHitbox();
		add(backgroundSpr);

        flixelWindow = new Window();
		flixelWindow.cameras = [windowCaption];
        add(flixelWindow);
    }
}

class Window extends FlxSprite {
	// Window outline
	var outline1:FlxSprite;
	var outline2:FlxSprite;
	var outline3:FlxSprite;
	var outline4:FlxSprite;

	// Title bar sprites
	var titleBarSpr:FlxSprite;
	var titleBarText:FlxText;
	var titleBarName:String;
	var titleBarFont:String;
	private var titleBarColor:Null<FlxColor>;
	private var titleBarTextColor:Null<FlxColor>;

	var colorID:Int = 0;

	// Window icon
	public var windowIcon:FlxSprite;
    
    // Window Buttons
    public var minimizeButton:FlxButton;
	public var maximizeButton:FlxButton;
	public var closeButton:FlxButton;

	var windowType:Null<Int> = 0;

	// Initialize a FlxGroup because there are variables in a FlxSprite extension
	@:noStack private var windowGrp:FlxGroup;

	public function new() {
		Application.current.window.width = 1282;
		Application.current.window.height = 752;

		windowGrp = new FlxGroup();
		FlxG.state.add(windowGrp);

		Application.current.window.borderless = true;
		Application.current.window.y = 149;

		titleBarFont = "assets/fonts/segoeui.ttf";
		if (titleBarFont == null) titleBarFont = "_sans";

		// Window outline
		outline1 = new FlxSprite(0, 0).makeGraphic(1, FlxG.height, FlxColor.GRAY);
		outline1.alpha = 1/5*2;
		windowGrp.add(outline1);
		outline2 = new FlxSprite(FlxG.width - 1, 0).makeGraphic(1, FlxG.height, FlxColor.GRAY);
		outline2.alpha = 1/5*2;
		windowGrp.add(outline2);
		outline3 = new FlxSprite(0, FlxG.height - 1).makeGraphic(FlxG.width, 1, FlxColor.GRAY);
		outline3.alpha = 1/5*2;
		windowGrp.add(outline3);
		outline4 = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, FlxColor.GRAY);
		outline4.alpha = 1/5*2;
		windowGrp.add(outline4);

		// Title Bar
		titleBarSpr = new FlxSprite(1, 1).makeGraphic(FlxG.width - 2, 30, titleBarColor);
		windowGrp.add(titleBarSpr);
		windowIcon = new FlxSprite(10, 8).loadGraphic("assets/icon.png");
		// Resize the icon to 16 pixels in case it's too big or small
		windowIcon.setGraphicSize(16, 16);
		windowIcon.antialiasing = true;
		windowGrp.add(windowIcon);
		titleBarText = new FlxText(windowIcon.width + 10, windowIcon.y - 3, FlxG.width - 2, titleBarName, 13);
		titleBarText.setFormat(titleBarFont, 13, titleBarTextColor != null ? titleBarTextColor : FlxColor.BLACK);
		windowGrp.add(titleBarText);

        // Window Buttons
		closeButton = new FlxButton(FlxG.width - 46, 1, "", function() {
			#if sys
			Sys.exit(0);
			#end
		});
		closeButton.loadGraphic("assets/buttons/exit.png", true, 45, 29, true);
		windowGrp.add(closeButton);
		maximizeButton = new FlxButton(closeButton.x - 45, 1, "", function() {
			FlxG.fullscreen = !FlxG.fullscreen;
		});
		maximizeButton.loadGraphic("assets/buttons/maximize-1.png", true, 45, 29, true);
		windowGrp.add(maximizeButton);
		/*minimizeButton = new FlxButton(maximizeButton.x - 45, 1, "", function() {
			// Might be possible but Idk
		});
		minimizeButton.loadGraphic("assets/buttons/minimize.png", true, 45, 29, false);
		windowGrp.add(minimizeButton);*/

		FlxG.mouse.useSystemCursor = true;

		switch (colorID) {
			case 0:
				titleBarColor = FlxColor.WHITE;
				setTitleBarTextColor(FlxColor.BLACK);
			case 1: // Dark Mode
				titleBarColor = FlxColor.BLACK;
				setTitleBarTextColor(FlxColor.WHITE);
			case 2:
				titleBarColor = FlxColor.RED;
				setTitleBarTextColor(FlxColor.WHITE);
			case 3:
				titleBarColor = FlxColor.fromRGB(255, 127, 0);
				setTitleBarTextColor(FlxColor.BLACK);
			case 4:
				titleBarColor = FlxColor.YELLOW;
				setTitleBarTextColor(FlxColor.BLACK);
			case 5:
				titleBarColor = FlxColor.fromRGB(0, 255, 0);
				setTitleBarTextColor(FlxColor.BLACK);
			case 6:
				titleBarColor = FlxColor.fromRGB(0, 255, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 7:
				titleBarColor = FlxColor.fromRGB(0, 0, 255);
				setTitleBarTextColor(FlxColor.WHITE);
			case 8:
				titleBarColor = FlxColor.fromRGB(127, 0, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 9:
				titleBarColor = FlxColor.fromRGB(255, 127, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 10:
				titleBarColor = FlxColor.fromRGB(255, 0, 127);
				setTitleBarTextColor(FlxColor.BLACK);
			default:
				titleBarColor = FlxColor.WHITE;
				setTitleBarTextColor(FlxColor.BLACK);
		}

		setTitleBarColor(colorID);
		setTitleBarName('Project Showdown Funk (BETA)');

		super();
	}

	override public function update(elapsed:Float) {
		if (colorID > 11) colorID = -1;
		if (colorID == 1 || colorID == 2 || colorID == 7) {
			closeButton.color = FlxColor.WHITE;
			maximizeButton.color = FlxColor.WHITE;
			//minimizeButton.color = FlxColor.WHITE;
		} else {
			closeButton.color = FlxColor.WHITE;
			maximizeButton.color = FlxColor.WHITE;
			//minimizeButton.color = FlxColor.WHITE;
		}

		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			if (FlxG.keys.pressed.SHIFT) {
				colorID--;
			} else {
				colorID++;
			}
			//#if sys Sys.command('nircmd.exe savescreenshot "screenshot.png"'); #end
			setTitleBarColor(colorID);
		}
		setTitleBarColor(colorID);
		//setType(0);
		//getType();
	}

	/**
	 * Moves the window.
	 * @param x 
	 * @param y 
	 */
	public function moveWindow(?x, ?y) {
		Application.current.window.x = x;
		Application.current.window.y = y;
	}

	/**
	 * Resizes the window.
	 * @param width 
	 * @param height 
	 */
	public function resizeWindow(?width, ?height) {
		Application.current.window.width = width;
		Application.current.window.height = height;
	}

	public function rotateWindow(angle) {
		// Might be possible
	}

	/**
	 * Sets the window's title bar color.
	 * @param id 
	 */
	public function setTitleBarColor(id:Int) {
		switch (colorID) {
			case 0:
				titleBarColor = FlxColor.WHITE;
				setTitleBarTextColor(FlxColor.BLACK);
			case 1: // Dark Mode
				titleBarColor = FlxColor.BLACK;
				setTitleBarTextColor(FlxColor.WHITE);
			case 2:
				titleBarColor = FlxColor.RED;
				setTitleBarTextColor(FlxColor.WHITE);
			case 3:
				titleBarColor = FlxColor.fromRGB(255, 127, 0);
				setTitleBarTextColor(FlxColor.BLACK);
			case 4:
				titleBarColor = FlxColor.YELLOW;
				setTitleBarTextColor(FlxColor.BLACK);
			case 5:
				titleBarColor = FlxColor.fromRGB(0, 255, 0);
				setTitleBarTextColor(FlxColor.BLACK);
			case 6:
				titleBarColor = FlxColor.fromRGB(0, 255, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 7:
				titleBarColor = FlxColor.fromRGB(0, 0, 255);
				setTitleBarTextColor(FlxColor.WHITE);
			case 8:
				titleBarColor = FlxColor.fromRGB(127, 0, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 9:
				titleBarColor = FlxColor.fromRGB(255, 127, 255);
				setTitleBarTextColor(FlxColor.BLACK);
			case 10:
				titleBarColor = FlxColor.fromRGB(255, 0, 127);
				setTitleBarTextColor(FlxColor.BLACK);
			default:
				titleBarColor = FlxColor.WHITE;
				setTitleBarTextColor(FlxColor.BLACK);
		}
		
		colorID = id;
		windowGrp.remove(titleBarSpr);
		titleBarSpr = new FlxSprite(1, 1).makeGraphic(FlxG.width - 2, 30, titleBarColor);
		windowGrp.add(titleBarSpr);
	}

	/**
	 * Gets the window title bar color.
	 * @return Any
	 */
	public function getTitleBarColor():Any {
		return "Title bar color: " + titleBarColor;
	}

	/**
	 * Gets the window title bar color ID.
	 * @return Any
	 */
	public function getTitleBarColorID():Any {
		return "Title bar color ID: " + colorID;
	}

	/**
	 * Sets the window's title bar text.
	 * @param text 
	 */
	public function setTitleBarText(text:String) {
		titleBarText.text = text;
	}

	/**
	 * Gets the window's title bar text.
	 * @return String
	 */
	public function getTitleBarText():String {
		return "Title bar text: " + titleBarText.text;
	}

	/**
	 * Sets the window's title bar text color.
	 * @param color 
	 */
	public function setTitleBarTextColor(color:FlxColor) {
		titleBarTextColor = color;
		titleBarText.setFormat(titleBarFont, 13, titleBarTextColor);
	}

	/**
	 * Gets the window's title bar text color.
	 * @param color 
	 */
	public function getTitleBarTextColor():Any {
		return "Title bar text color: " + titleBarColor;
	}

	/**
	 * Sets the window's title.
	 * @param name 
	 */
	public function setTitleBarName(name:String) {
		titleBarName = name;
		titleBarText.text = titleBarName;
	}

	/**
	 * Gets the window's title.
	 * @return String
	 */
	public function getTitleBarName():String {
		return "Title bar name: " + titleBarName;
	}

	/**
	 * Sets the window's icon.
	 * @param id 
	 */
	public function setWindowIcon(id:String) {
		windowIcon.loadGraphic("assets/" + id + ".png");
	}

	/**
	 * Sets the window borderless.
	 * @param res 
	 */
	public function setWindowBorderless(?res:Bool) {
		if (res) {
			Application.current.window.x = 320;
			Application.current.window.y = 180;
			Application.current.window.width = 1280;
			Application.current.window.height = 720;
		} else {
			Application.current.window.x = 319;
			Application.current.window.y = 149;
			Application.current.window.width = 1282;
			Application.current.window.height = 752;
		}
		titleBarSpr.visible = !res;
		titleBarText.visible = !res;
		closeButton.visible = !res;
		maximizeButton.visible = !res;
		//minimizeButton.visible = !res;
		windowIcon.visible = !res;
		outline1.visible = !res;
		outline2.visible = !res;
		outline3.visible = !res;
		outline4.visible = !res;
	}

	/**
	 * Sets the window type. (Note: This is for The final release of 1.1.0)
	 * @param id 
	 */
	public function setWindowType(?id:Null<Int>) {
		if (id != null) windowType = id;
	}
	
	/**
	 * Gets the window type. (Note: This is for The final release of 1.1.0)
	 */
	public function getWindowType() {
		return "Window Type " + windowType;
	}

	// DEPRECATED STUFF

	/**
	 * Sets the window type.
	 * @param id 
	 */
	@:deprecated('`setType` is deprecated, use `setWindowType` instead')
	public function setType(?id:Null<Int>) {
		if (id != null) windowType = id;
	}
	
	/**
	 * Gets the window type.
	 */
	@:deprecated('`getType` is deprecated, use `getWindowType` instead')
	public function getType() {
		return windowType;
	}

	// POST FUNCTIONS

	override function destroy() {
		super.destroy();
	}

	override function kill() {
		this.kill();
		#if sys Sys.exit(0); #end
	}
}