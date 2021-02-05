package states;

import openfl.display.BlendMode;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import openfl.display.StageQuality;
import openfl.geom.Rectangle;
import flixel.util.FlxSpriteUtil;
import shaders.Outline;
import openfl.geom.Matrix;
import openfl.geom.Point;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	public var one:FlxSprite;
	public var two:FlxSprite;
	public var three:FlxSprite;

	public var defaultCam:FlxCamera;
	public var outlineCam:FlxCamera;
	public var outlineSprite:FlxSprite;

	var size = 50;

	override public function create() {
		super.create();

		defaultCam = new FlxCamera(0, 0, size, size);
		defaultCam.bgColor = FlxColor.BLACK;

		outlineCam = new FlxCamera(0, size, size, size);
		outlineCam.bgColor = FlxColor.TRANSPARENT;
		outlineCam.x = 0;
		outlineCam.y = size;

		FlxG.cameras.reset(defaultCam);
		FlxG.cameras.add(outlineCam);

		one = new FlxSprite();
		one.makeGraphic(10, 10, FlxColor.BLUE);
		one.setPosition(20, 20);
		one.camera = outlineCam;
		add(one);

		two = new FlxSprite();
		two.makeGraphic(20, 20, FlxColor.BROWN);
		two.setPosition(25, 25);
		two.camera = outlineCam;
		two.angle = 35;
		add(two);

		three = new FlxSprite();
		three.makeGraphic(25, 25, FlxColor.BROWN);
		three.setPosition(30, 30);
		three.camera = outlineCam;
		add(three);

		outlineSprite = new FlxSprite();
		outlineSprite.useFramePixels = true;
		outlineSprite.antialiasing = false;
		outlineSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		outlineSprite.camera = defaultCam;
		add(outlineSprite);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		one.angle++;
		two.angle--;

		three.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		outlineSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		outlineSprite.drawFrame();
		var screenPixels = outlineSprite.framePixels;

		if (FlxG.renderBlit)
			screenPixels.copyPixels(outlineCam.buffer, FlxG.camera.buffer.rect, new Point(), true);
		else
			screenPixels.draw(outlineCam.canvas, new Matrix(1, 0, 0, 1, 0, 0));
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
