package states;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import backend.MusicBeatState;
import states.MainMenuState;

class CreditsState extends MusicBeatState
{
	var images:Array<FlxSprite> = [];
	var labels:Array<FlxText> = [];
	var velocities:Array<{x:Float, y:Float}> = [];

	var entries:Array<
		{
			path:String,
			name:String,
			credit:String,
			socials:Array<String>,
			description:String
		}>;

	var popupBG:FlxSprite;
	var popupBox:FlxSprite;
	var popupTitle:FlxText;
	var popupTxt:FlxText;
	var popupDesc:FlxText;
	var popupSocials:Array<FlxText> = [];
	var closeBtn:FlxText;
	var popupVisible:Bool = false;

	var blackTrans:FlxSprite;
	var transitioning:Bool = false;

	override public function create():Void
	{
		super.create();

		FlxG.mouse.visible = true;

		FlxG.cameras.bgColor = FlxColor.BLACK;

		persistentUpdate = persistentDraw = true;

		entries = [
			{
				path: "credits/2arryy_",
				name: "2arryy_",
				credit: "Composer, Animator",
				socials: ["https://www.youtube.com/@2aRRyy"],
				description: "hello i'm 2arry from friday night funkin' and i made music for ts mod, and uhh bf sprs in placeholder"
			},
			{
				path: "credits/jadeawards",
				name: "JadeAwards",
				credit: "Coder, Artist",
				socials: ["https://www.youtube.com/@jadeawards"],
				description: "hello everyone! hoping you guys liked the mod and had fun playing it. i'm glad to be a part of this team with my wonderful friends and have fun doing i know best for this mod! (*cough, programming, cough*)\n\n\nthank you for playing!"
			},
			{
				path: "credits/melonman",
				name: "MelonMan",
				credit: "Composer",
				socials: ["https://www.youtube.com/@RealMelonMan", "https://x.com/RealMelonMan"],
				description: "I'm MelonMan! If anyone is reading this, necesarry got kinda weird due to time contraints, look foward to a more polished version in future updates!"
			},
			{
				path: "credits/realbradytgn",
				name: "RealBradyTGN",
				credit: "Composer",
				socials: [
					"https://www.youtube.com/@RealBradyTGN",
					"https://steamcommunity.com/profiles/76561199206311997/"
				],
				description: "Yeah so I basically made the majority of the soundtrack here. Pretty cool, right? I do hope you enjoy the songs, I put my soul into these songs, and thank you MelonMan for the base for Necessary, I had no fuckin idea what I was doing. yeah please make videos on this I like attention"
			},
			{
				path: "credits/tanrake",
				name: "tanrake",
				credit: "Co-Director, Animator",
				socials: ["https://www.youtube.com/@tangerinelmao", "https://www.tiktok.com/@tanrakev2"],
				description: "yo i did most of the art! it was stressful but rlly fun to make. thank you left for giving me the opportunity to join the mod! tchau :3"
			},
			{
				path: "credits/eve",
				name: "eve",
				credit: "Animator, Charter",
				socials: [
					"https://www.youtube.com/@Adamusiqu3",
					"https://steamcommunity.com/id/Adamusique/"
				],
				description: "Sup guys its me eve\n\nI do art\n\nAnd i love source engine\n\nj'aime la merde"
			},
			{
				path: "credits/thebigleft",
				name: "TheBigLeft",
				credit: "Director, Animator",
				socials: ["https://x.com/ReatlL"],
				description: "Buuuuurps\n\nyea im the director and main artist or something ehhh\n\nim the true villain of this game HAHAHAHAHAHAHAHAHAHA\n\ncollect my pages"
			},
			{
				path: "credits/milk_with_rice",
				name: "Milk_With_Rice",
				credit: "Composer",
				socials: ["https://www.youtube.com/@MilkWithRice"],
				description: "the residencial guy"
			}
		];

		for (entry in entries)
		{
			var spr = new FlxSprite();
			spr.loadGraphic(Paths.image(entry.path));
			spr.x = FlxG.random.float(0, FlxG.width - spr.width);
			spr.y = FlxG.random.float(0, FlxG.height - spr.height);
			add(spr);
			images.push(spr);

			var label = new FlxText(0, 0, spr.width, entry.name, 12);
			label.setFormat(Paths.font('upheavtt.ttf'), 12, FlxColor.WHITE, "center");
			label.x = spr.x;
			label.y = spr.y + spr.height + 2;
			add(label);
			labels.push(label);

			velocities.push({
				x: FlxG.random.float(-200, 200) / 60,
				y: FlxG.random.float(-200, 200) / 60
			});
		}

		popupBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		popupBG.alpha = 0.8;
		popupBG.visible = false;
		add(popupBG);

		popupBox = new FlxSprite(Std.int(FlxG.width / 6),
			Std.int(FlxG.height / 6)).makeGraphic(Std.int(FlxG.width * 2 / 3), Std.int(FlxG.height * 2 / 3), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(popupBox, 0, 0, popupBox.width, popupBox.height, 40, 40, 0xFF212121, {thickness: 4, color: FlxColor.YELLOW});
		popupBox.visible = false;
		add(popupBox);

		popupTitle = new FlxText(popupBox.x, popupBox.y + 20, popupBox.width, "", 24);
		popupTitle.setFormat(Paths.font('upheavtt.ttf'), 24, FlxColor.YELLOW, "center");
		popupTitle.visible = false;
		add(popupTitle);

		popupTxt = new FlxText(popupBox.x + 40, popupBox.y + 70, popupBox.width - 80, "", 18);
		popupTxt.setFormat(Paths.font('upheavtt.ttf'), 18, 0xFFCCCCCC, "center");
		popupTxt.visible = false;
		add(popupTxt);

		popupDesc = new FlxText(popupBox.x + 40, popupBox.y + 110, popupBox.width - 80, "", 16);
		popupDesc.setFormat(Paths.font('upheavtt.ttf'), 16, FlxColor.WHITE, "center");
		popupDesc.visible = false;
		add(popupDesc);

		closeBtn = new FlxText(0, 0, 40, "X", 20);
		closeBtn.setFormat(Paths.font('upheavtt.ttf'), 20, FlxColor.WHITE, "center");
		closeBtn.color = FlxColor.RED;
		closeBtn.visible = false;
		add(closeBtn);

		blackTrans = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTrans.alpha = 1;
		add(blackTrans);

		FlxTween.tween(blackTrans, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	}

	function startTrans(nextState:FlxState):Void
	{
		if (transitioning)
			return;

		transitioning = true;
		FlxTween.tween(blackTrans, {alpha: 1}, 0.5, {ease: FlxEase.quadIn, onComplete: function(_) FlxG.switchState(nextState)});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			if (popupVisible)
				hidePopup();
			else
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				startTrans(new MainMenuState());
			}
		}

		if (!popupVisible)
		{
			for (i in 0...images.length)
			{
				var spr = images[i];
				var label = labels[i];
				var vel = velocities[i];

				spr.x += vel.x;
				spr.y += vel.y;
				label.x = spr.x;
				label.y = spr.y + spr.height + 2;

				if (spr.x < 0 || spr.x + spr.width > FlxG.width)
				{
					vel.x *= -1;
					spr.x = Math.max(0, Math.min(FlxG.width - spr.width, spr.x));
				}
				if (spr.y < 0 || spr.y + spr.height > FlxG.height)
				{
					vel.y *= -1;
					spr.y = Math.max(0, Math.min(FlxG.height - spr.height, spr.y));
				}

				if (FlxG.mouse.overlaps(spr) || FlxG.mouse.overlaps(label))
					spr.color = FlxColor.GRAY;
				else
					spr.color = FlxColor.WHITE;

				if (FlxG.mouse.justPressed && (FlxG.mouse.overlaps(spr) || FlxG.mouse.overlaps(label)))
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					showPopup(entries[i]);
				}
			}
		}
		else
		{
			for (s in popupSocials)
			{
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(s))
					FlxG.openURL(s.text);
			}

			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(closeBtn))
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				hidePopup();
			}
		}
	}

	function showPopup(entry:
		{
			path:String,
			name:String,
			credit:String,
			socials:Array<String>,
			description:String
		}):Void
	{
		popupTitle.text = entry.name;
		popupTxt.text = entry.credit;
		popupDesc.text = entry.description;

		for (s in popupSocials)
			remove(s);
		popupSocials = [];

		var startY = popupBox.y + popupBox.height - 100;
		for (i in 0...entry.socials.length)
		{
			var social = new FlxText(popupBox.x + 40, startY + i * 22, popupBox.width - 80, entry.socials[i], 16);
			social.setFormat(Paths.font('upheavtt.ttf'), 16, FlxColor.CYAN, "center");
			add(social);
			popupSocials.push(social);
		}

		popupBG.visible = true;
		popupBox.visible = true;
		popupTitle.visible = true;
		popupTxt.visible = true;
		popupDesc.visible = true;
		for (s in popupSocials)
			s.visible = true;

		closeBtn.x = popupBox.x + popupBox.width - closeBtn.width - 25;
		closeBtn.y = popupBox.y + 10;
		closeBtn.visible = true;

		popupVisible = true;
	}

	function hidePopup():Void
	{
		popupBG.visible = false;
		popupBox.visible = false;
		popupTitle.visible = false;
		popupTxt.visible = false;
		popupDesc.visible = false;
		for (s in popupSocials)
			s.visible = false;
		closeBtn.visible = false;
		popupVisible = false;
	}
}
