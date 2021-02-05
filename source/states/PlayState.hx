package states;

import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
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
	public var defaultCam:FlxCamera;
	public var outlineCam:FlxCamera;
	public var outlineSprite:FlxSprite;

	var width = 256;
	var height = 224;

	override public function create() {
		super.create();

		defaultCam = new FlxCamera(0, 0, width, height);
		defaultCam.bgColor = FlxColor.BLACK;
		// defaultCam.pixelPerfectRender = true;

		outlineCam = new FlxCamera(0, height, width, height);
		outlineCam.bgColor = FlxColor.TRANSPARENT;
		// outlineCam.pixelPerfectRender = true;
		outlineCam.x = 0;
		outlineCam.y = height;

		FlxG.cameras.reset(defaultCam);
		FlxG.cameras.add(outlineCam);

		for (i in 0...30) {
			var size = FlxG.random.int(10, 30);
			var spr = new FlxSprite();
			spr.makeGraphic(size, size, FlxColor.BLUE);
			spr.setPosition(FlxG.random.int(0, width), FlxG.random.int(0, height));
			spr.camera = outlineCam;
			add(spr);
			FlxTween.linearPath(spr,
				[
					new FlxPoint(FlxG.random.int(0, width), FlxG.random.int(0, height)),
					new FlxPoint(FlxG.random.int(0, width), FlxG.random.int(0, height))
				],
				20,
				false,
				{ type: FlxTweenType.LOOPING});
		}

		outlineSprite = new FlxSprite();
		outlineSprite.useFramePixels = true;
		outlineSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		outlineSprite.shader = new Outline(0xFFFFFFFF, 2, 2);
		outlineSprite.camera = defaultCam;
		add(outlineSprite);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

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
