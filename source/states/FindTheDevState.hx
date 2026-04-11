package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

//completely redid this since the other hx file for this was broken lmao
class FindTheDevState extends FlxState
{
    public static var personalBest:Int = 0;

    private var devs:Array<String> = [
        '2arryy_', 'eve', 'jadeawards', 'tanrake', 
        'thebigleft', 'milk_with_rice', 'realbradytgn', 'melonman'
    ];
    
    private var targetDev:String;
    private var icons:FlxTypedGroup<FlxSprite>;
    private var wantedPoster:FlxSprite;
    
    private var timerTxt:FlxText;
    private var scoreTxt:FlxText;
    private var pbInGameTxt:FlxText;

    private var blackTrans:FlxSprite;
    private var transitioning:Bool = false;
    
    private var gameTime:Float = 30.0;
    private var baseTime:Float = 30.0;

    private var retryGroup:FlxTypedGroup<FlxText>;
    private var retryTxt:FlxText;
    private var pbTxt:FlxText;
    private var yesBtn:FlxText;
    private var noBtn:FlxText;

    private var score:Int = 0;
    private var isGameOver:Bool = false;

    override public function create():Void
    {
        super.create();

        persistentUpdate = persistentDraw = true;

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();
            
        FlxG.sound.playMusic(Paths.music('findthedev'), 1, true);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        icons = new FlxTypedGroup<FlxSprite>();
        add(icons);

        wantedPoster = new FlxSprite(20, 20);
        add(wantedPoster);

        timerTxt = new FlxText(0, 20, FlxG.width, "TIME: 30", 32);
        timerTxt.setFormat(Paths.font("upheavtt.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(timerTxt);

        scoreTxt = new FlxText(FlxG.width - 220, 20, 200, "SCORE: 0", 32);
		scoreTxt.setFormat(Paths.font("upheavtt.ttf"), 22, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(scoreTxt);

        pbInGameTxt = new FlxText(FlxG.width - 220, 45, 200, "BEST: " + personalBest, 22);
        pbInGameTxt.setFormat(Paths.font("upheavtt.ttf"), 22, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(pbInGameTxt);

        retryGroup = new FlxTypedGroup<FlxText>();
        retryGroup.visible = false;
        add(retryGroup);

        pbTxt = new FlxText(0, FlxG.height * 0.3, FlxG.width, "PERSONAL BEST: 0", 32);
        pbTxt.setFormat(Paths.font("upheavtt.ttf"), 32, FlxColor.YELLOW, CENTER, OUTLINE, FlxColor.BLACK);
        retryGroup.add(pbTxt);

        retryTxt = new FlxText(0, FlxG.height * 0.4, FlxG.width, "RETRY?", 64);
        retryTxt.setFormat(Paths.font("upheavtt.ttf"), 64, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        retryGroup.add(retryTxt);

        yesBtn = new FlxText(FlxG.width * 0.3, FlxG.height * 0.6, 200, "YES", 48);
        yesBtn.setFormat(Paths.font("upheavtt.ttf"), 48, FlxColor.LIME, CENTER, OUTLINE, FlxColor.BLACK);
        retryGroup.add(yesBtn);

        noBtn = new FlxText(FlxG.width * 0.5, FlxG.height * 0.6, 200, "NO", 48);
        noBtn.setFormat(Paths.font("upheavtt.ttf"), 48, FlxColor.RED, CENTER, OUTLINE, FlxColor.BLACK);
        retryGroup.add(noBtn);

        blackTrans = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackTrans.alpha = 1;
        add(blackTrans);

        FlxTween.tween(blackTrans, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});

        startLevel();
        
        FlxG.mouse.visible = true;
    }

    function startLevel():Void
    {
        icons.clear();
        
        targetDev = devs[FlxG.random.int(0, devs.length - 1)];
        
        wantedPoster.loadGraphic(Paths.image('findthedev/wanted_' + targetDev));
        wantedPoster.setGraphicSize(150);
        wantedPoster.updateHitbox();

        var spawnCount:Int = 30 + Math.floor(score / 1.2);
        if (spawnCount > 100) spawnCount = 100;

        spawnIcon(targetDev, true);

        var decoyPool:Array<String> = devs.filter(name -> name != targetDev);

        for (i in 0...spawnCount - 1)
        {
            var randomDecoy = decoyPool[FlxG.random.int(0, decoyPool.length - 1)];
            spawnIcon(randomDecoy, false);
        }
    }

    function spawnIcon(name:String, isTarget:Bool):Void
    {
        var icon:FlxSprite = new FlxSprite();
        icon.loadGraphic(Paths.image('findthedev/' + name));
        icon.antialiasing = false;
        icon.setGraphicSize(64);
        icon.updateHitbox();
        
        icon.x = FlxG.random.float(50, FlxG.width - 100);
        icon.y = FlxG.random.float(150, FlxG.height - 100);
        
        var speed:Float = 40 + (score * 2);
        if (speed > 120) speed = 120;
        icon.velocity.set(FlxG.random.float(-speed, speed), FlxG.random.float(-speed, speed));
        
        icon.ID = isTarget ? 1 : 0;
        
        icons.add(icon);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!isGameOver)
        {
            gameTime -= elapsed;
            timerTxt.text = "TIME: " + Math.ceil(gameTime);

            if (gameTime <= 0)
            {
                gameTime = 0;
                timerTxt.text = "TIME: 0";
                isGameOver = true;
                FlxG.sound.play(Paths.sound('missnote1'));
                FlxG.camera.shake(0.01, 0.2);
                showRetry();
            }
        }

        icons.forEachAlive(function(icon:FlxSprite) {
            if (icon.x < 0) {
                icon.x = 0;
                icon.velocity.x *= -1;
            } else if (icon.x > FlxG.width - icon.width) {
                icon.x = FlxG.width - icon.width;
                icon.velocity.x *= -1;
            }
            
            if (icon.y < 150) {
                icon.y = 150;
                icon.velocity.y *= -1;
            } else if (icon.y > FlxG.height - icon.height) {
                icon.y = FlxG.height - icon.height;
                icon.velocity.y *= -1;
            }
        });

        if ((FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) && !transitioning)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            exitGame();
        }

        if (FlxG.mouse.justPressed && !transitioning)
        {
            if (isGameOver)
            {
                if (FlxG.mouse.overlaps(yesBtn)) {
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    restartGame();
                } else if (FlxG.mouse.overlaps(noBtn)) {
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    exitGame();
                }
                return;
            }
            
            icons.forEachAlive(function(icon:FlxSprite) {
                if (FlxG.mouse.overlaps(icon) && !isGameOver) {
                    if (icon.ID == 1) {
                        score++;
                        gameTime = 30;
                        scoreTxt.text = "SCORE: " + score;
                        if (score > personalBest) personalBest = score;
                        pbInGameTxt.text = "BEST: " + personalBest;

                        FlxG.sound.play(Paths.sound('confirmMenu'));
                        startLevel();
                    } else {
                        gameTime -= 3;
                        FlxG.sound.play(Paths.sound('cancelMenu'));
                        icon.kill();
                    }
                }
            });
        }
    }

    function showRetry():Void
    {
        if (score > personalBest) personalBest = score;
        pbTxt.text = "PERSONAL BEST: " + personalBest;

        icons.visible = false;
        wantedPoster.visible = false;
        retryGroup.visible = true;
    }

    function restartGame():Void
    {
        score = 0;
        gameTime = baseTime;
        scoreTxt.text = "SCORE: 0";
        isGameOver = false;
        retryGroup.visible = false;
        icons.visible = true;
        wantedPoster.visible = true;
        startLevel();
    }

    function exitGame():Void
    {
        if (transitioning)
            return;

        transitioning = true;

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
        FlxTween.tween(blackTrans, {alpha: 1}, 0.5, {
            ease: FlxEase.quadIn,
            onComplete: function(_) FlxG.switchState(new MainMenuState())
        });
    }
}
