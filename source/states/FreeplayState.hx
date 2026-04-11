package states;

import backend.Song;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FreeplayState extends MusicBeatState
{
	var btns:FlxTypedGroup<FlxSprite>;
	var icons:FlxTypedGroup<FlxSprite>;
	var btnscale:Float = 1;
	var btnCallbacks:Map<FlxSprite, Void->Void> = new Map();
	var blackTrans:FlxSprite;
	var transitioning:Bool = false;

	var bg:FlxSprite;
	var bgClrs:Array<Int> = [0xFF99E550, FlxColor.WHITE, 0xFFD1D1D1];
	var lastHovered:FlxSprite = null;
	var colorTwn:FlxTween;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg.antialiasing = false;
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = bgClrs[0];
		add(bg);

		btns = new FlxTypedGroup<FlxSprite>();
		icons = new FlxTypedGroup<FlxSprite>();
		add(btns);
		add(icons);

		var btnSpr = Paths.getSparrowAtlas("mainmenu/btns/freeplayBtn");
		var btnX:Float = 190;
		var btnYStart:Float = 90;
		var btnSpacing:Float = 180;

		addButton(btnSpr, "the-necessary", btnX, btnYStart + 0 * btnSpacing, function()
		{
			PlayState.SONG = Song.loadFromJson("the-necessary", "the-necessary");
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			startTrans(new PlayState());
		}, "icon-darn");

		addButton(btnSpr, "placeholder", btnX, btnYStart + 1 * btnSpacing, function()
		{
			PlayState.SONG = Song.loadFromJson("placeholder", "placeholder");
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			startTrans(new PlayState());
		}, "icon-whitedude");

		addButton(btnSpr, "song-1", btnX, btnYStart + 2 * btnSpacing, function()
		{
			PlayState.SONG = Song.loadFromJson("song-1", "song-1");
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			startTrans(new PlayState());
		}, "icon-thegirlslol");

		blackTrans = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTrans.alpha = 1;
		add(blackTrans);

		FlxTween.tween(blackTrans, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	}

	function addButton(btnSpr:FlxAtlasFrames, frameName:String, x:Float, y:Float, onClick:Void->Void, iconName:String):Void
	{
		var btn = makeButton(btnSpr, frameName, x, y, onClick);
		btns.add(btn);

		var icon = new FlxSprite(btn.x + btn.width + 20, btn.y);
		icon.loadGraphic(Paths.image("icons/" + iconName));
		icon.antialiasing = false;
		icon.scale.set(1.12, 1.12);
		icon.updateHitbox();
		icon.clipRect = new FlxRect(0, 0, 150, 150);
		icons.add(icon);

		if (iconName == "icon-darn") // funny capcut icon
		{
			FlxTween.tween(icon.scale, {x: 1.2}, 0.35, {ease: FlxEase.quadInOut, type: PINGPONG});
			FlxTween.tween(icon.scale, {y: 0.7}, 0.32, {ease: FlxEase.quadInOut, type: PINGPONG});

			FlxTween.angle(icon, -8, 8, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
		}
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
		FlxTween.tween(blackTrans, {alpha: 1}, 0.5, {
			ease: FlxEase.quadIn,
			onComplete: function(_) FlxG.switchState(nextState)
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mousePos = FlxG.mouse.getScreenPosition();
		var idx = 0;

		for (btn in btns)
		{
			var isHovered = btn.overlapsPoint(mousePos, true, FlxG.camera);
			var targetScale:Float = isHovered ? btnscale * 1.15 : btnscale;
			
			btn.scale.x = FlxMath.lerp(btn.scale.x, targetScale, FlxMath.bound(elapsed * 12, 0, 1));
			btn.scale.y = FlxMath.lerp(btn.scale.y, targetScale, FlxMath.bound(elapsed * 12, 0, 1));

			if (icons.members[idx] != null)
			{
				icons.members[idx].x = btn.x + btn.width + 20;
				icons.members[idx].y = btn.y + (btn.height / 2 - icons.members[idx].height / 2);
			}

			if (isHovered && lastHovered != btn)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				lastHovered = btn;
				if(colorTwn != null) colorTwn.cancel();
				colorTwn = FlxTween.color(bg, 0.35, bg.color, bgClrs[idx % bgClrs.length], {ease: FlxEase.quartOut});
			}
			else if (!isHovered && lastHovered == btn)
			{
				lastHovered = null;
			}

			if (isHovered && FlxG.mouse.justPressed && btnCallbacks.exists(btn))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				btnCallbacks.get(btn)();
			}

			idx++;
		}

		if ((FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) && !transitioning)
		{
			FlxG.sound.play(Paths.sound("cancelMenu"));
			startTrans(new MainMenuState());
		}
	}
}
