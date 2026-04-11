package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import options.OptionsState;
import states.editors.MasterEditorMenu;

class MainMenuState extends MusicBeatSubstate
{
	public static var psychEngineVersion:String = "1.0.4";

	var btns:FlxTypedGroup<FlxSprite>;
	var btnscale:Float = 1.92;
	var btnCallbacks:Map<FlxSprite, Void->Void> = new Map();
	var blackTrans:FlxSprite;
	var transitioning:Bool = false;

	var glombo:FlxSprite;
	var ogScale:FlxPoint;

	var stretchSnd:FlxSound = null;

	var dragging:Bool = false;
	var dragStart:FlxPoint = null;
	var lastHovered:FlxSprite = null;

	var bg2:FlxSprite;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var bg1:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg1.antialiasing = false;
		bg1.scrollFactor.set();
		bg1.updateHitbox();
		bg1.screenCenter();
		bg1.color = 0xFFFDE871;
		add(bg1);

		bg2 = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg2.antialiasing = false;
		bg2.scrollFactor.set();
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.color = 0xFFfd719b;
		bg2.visible = false;
		add(bg2);

		glombo = new FlxSprite(FlxG.width - 650, FlxG.height / 2 - 525).loadGraphic(Paths.image("mainmenu/glombo"));
		glombo.antialiasing = false;
		glombo.origin.set(glombo.width / 2, glombo.height / 2);
		glombo.x += glombo.origin.x;
		glombo.y += glombo.origin.y;
		add(glombo);
		ogScale = new FlxPoint(glombo.scale.x, glombo.scale.y);

		btns = new FlxTypedGroup<FlxSprite>();
		add(btns);

		var btnSpr = Paths.getSparrowAtlas("mainmenu/btns/menuBtn");
		var btnX:Float = 25;
		var btnYStart:Float = 5;
		var btnSpacing:Float = 180;

		addButton(btnSpr, "play", btnX, btnYStart + 0 * btnSpacing, FreeplayState);
		var optionsBtn = makeButton(btnSpr, "confi", btnX, btnYStart + 1 * btnSpacing, function()
		{
			startTrans(new OptionsState());
			OptionsState.onPlayState = false;
			if (PlayState.SONG != null)
			{
				PlayState.SONG.arrowSkin = null;
				PlayState.SONG.splashSkin = null;
				PlayState.stageUI = "normal";
			}
		});
		addButton(btnSpr, "creds", btnX, btnYStart + 2 * btnSpacing, CreditsState);
		var exitBtn = makeButton(btnSpr, "nah", btnX, btnYStart + 3 * btnSpacing, function()
		{
			Sys.exit(0);
		});
		btns.add(optionsBtn);
		btns.add(exitBtn);

		var wantedBtn:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("mainmenu/btns/wantedBtn"));
		wantedBtn.antialiasing = false;
		wantedBtn.updateHitbox();
		wantedBtn.x = FlxG.width - (wantedBtn.width * 0.5) - 100;
		wantedBtn.y = FlxG.height - (wantedBtn.height * 0.5) - 100;
		wantedBtn.origin.set(wantedBtn.width / 2, wantedBtn.height / 2);
		wantedBtn.x += wantedBtn.width / 2;
		wantedBtn.y += wantedBtn.height / 2;
		wantedBtn.scale.set(0.5, 0.5);
		btns.add(wantedBtn);
		btnCallbacks.set(wantedBtn, function()
		{
			startTrans(new FindTheDevState());
		});

		var engineVersion:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		engineVersion.scrollFactor.set();
		engineVersion.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineVersion);

		var ddeVersion:FlxText = new FlxText(12, FlxG.height - 24, 0, "DDE: Placeholder (" + Application.current.meta.get("version") + ")", 12);
		ddeVersion.scrollFactor.set();
		ddeVersion.setFormat(Paths.font("upheavtt.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(ddeVersion);

		blackTrans = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTrans.alpha = 1;
		add(blackTrans);

		FlxTween.tween(blackTrans, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	}

	function addButton(btnSpr:FlxAtlasFrames, frameName:String, x:Float, y:Float, stateClass:Class<FlxState>):Void
	{
		var btn = makeButton(btnSpr, frameName, x, y, function()
		{
			startTrans(Type.createInstance(stateClass, []));
		});
		btns.add(btn);
	}

	function makeButton(btnSpr:FlxAtlasFrames, frameName:String, x:Float, y:Float, onClick:Void->Void):FlxSprite
	{
		var btn = new FlxSprite(x, y);
		btn.frames = btnSpr;
		btn.animation.addByPrefix("idle", frameName, 0, false);
		btn.animation.play("idle");
		btn.origin.set(btn.width / 2, btn.height / 2);
		btn.x += btn.width / 2;
		btn.y += btn.height / 2;
		btn.scale.set(btnscale, btnscale);
		btn.setGraphicSize(Std.int(btn.width * btnscale));
		btn.updateHitbox();
		btn.antialiasing = false;

		btnCallbacks.set(btn, onClick);
		return btn;
	}

	function startTrans(nextState:FlxState):Void
	{
		if (transitioning)
			return;

		transitioning = true;
		FlxTween.tween(blackTrans, {alpha: 1}, 0.5, {ease: FlxEase.quadIn, onComplete: function(_) FlxG.switchState(nextState)});
	}

	override function update(elapsed:Float)
	{
		#if desktop
		if (controls.justPressed('debug_1'))
		{
			FlxG.mouse.visible = false;
			startTrans(new MasterEditorMenu());
		}
		#end

		super.update(elapsed);

		var mousePos = FlxG.mouse.getScreenPosition();

		if (FlxG.mouse.justPressed && glombo.overlapsPoint(mousePos, true))
		{
			dragging = true;
			dragStart = new FlxPoint(mousePos.x, mousePos.y);
			stretchSnd = FlxG.sound.play(Paths.sound('stretch'), 1, true);
		}

		if (FlxG.mouse.justReleased && dragging)
		{
			dragging = false;
			dragStart = null;

			if (stretchSnd != null)
			{
				stretchSnd.stop();
				stretchSnd = null;
			}

			FlxG.sound.play(Paths.sound('wobble'));
			FlxTween.tween(glombo.scale, {x: ogScale.x, y: ogScale.y}, 1, {ease: FlxEase.elasticOut});
		}

		if (dragging && dragStart != null)
		{
			var deltaX = (dragStart.x - mousePos.x) * 0.01;
			var deltaY = (dragStart.y - mousePos.y) * 0.01;
			glombo.scale.x = Math.max(0.1, ogScale.x + deltaX);
			glombo.scale.y = Math.max(0.1, ogScale.y + deltaY);
		}

		for (btn in btns)
		{
			var isHovered = btn.overlapsPoint(mousePos, true, FlxG.camera);
			var targetScale:Float = isHovered ? btnscale * 1.15 : btnscale;
			
			btn.scale.x = FlxMath.lerp(btn.scale.x, targetScale, FlxMath.bound(elapsed * 12, 0, 1));
			btn.scale.y = FlxMath.lerp(btn.scale.y, targetScale, FlxMath.bound(elapsed * 12, 0, 1));

			if (isHovered && lastHovered != btn)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				lastHovered = btn;
			}
			else if (!isHovered && lastHovered == btn)
			{
				lastHovered = null;
			}

			if (isHovered && FlxG.mouse.justPressed && btnCallbacks.exists(btn))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (!transitioning)
				{
					transitioning = true;
					FlxFlicker.flicker(bg2, 1, 0.06, false, true, function(_)
					{
						transitioning = false;
						btnCallbacks.get(btn)();
					});
				}
			}
		}

		if ((FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) && !transitioning)
		{
			FlxG.sound.play(Paths.sound("cancelMenu"));
			startTrans(new TitleState());
		}
	}
}
