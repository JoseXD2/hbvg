package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	// version of engine in project.xml :)

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		//BIRDY DECORATIONS YK
		
		var freddybg:FlxSprite = new FlxSprite(0, 0);
		freddybg.frames = Paths.getSparrowAtlas('menuimages/fedy','shared');
		freddybg.animation.addByPrefix('idle', 'BF idle dance white', 24, true);
		freddybg.animation.addByPrefix('confirm', 'BF HEY!!', 24, false);

                var staticeffect:FlxSprite = new FlxSprite(0, 0);
		staticeffect.frames = Paths.getSparrowAtlas('static','shared');
		staticeffect.animation.addByPrefix('idle', 'static_effect', 24, true);



		var songlist:FlxSprite = new FlxSprite(0, 0);
		songlist.loadGraphic(Paths.image('menuimages/songmenu','shared'));

		var nextbutton:FlxSprite = new FlxSprite(900, 80);
		nextbutton.loadGraphic(Paths.image('menuimages/next','shared'));
		nextbutton.setGraphicSize(Std.int(nextbutton.width + 6));
		var prevbutton:FlxSprite = new FlxSprite(850, 80);
		prevbutton.loadGraphic(Paths.image('menuimages/prev','shared'));
		prevbutton.setGraphicSize(Std.int(prevbutton.width + 6));

		var weekname:FlxSprite = new FlxSprite(0, 0);
		weekname.loadGraphic(Paths.image('menuimages/curweekname','shared'));

		var normalmode:FlxSprite = new FlxSprite(0, 0);
		normalmode.loadGraphic(Paths.image('menuimages/normaldif','shared'));
		var easymode:FlxSprite = new FlxSprite(0, 0);
		easymode.loadGraphic(Paths.image('menuimages/easydif','shared'));
		var hardmode = new FlxSprite(0, 0);
		hardmode.loadGraphic(Paths.image('menuimages/harddif','shared'));

		var goback:FlxSprite = new FlxSprite(0, 0);
		goback.loadGraphic(Paths.image('menuimages/xback','shared'));

		var gobutton:FlxSprite = new FlxSprite(500, 600);
		gobutton.loadGraphic(Paths.image('menuimages/go','shared'));

		var fade:FlxSprite = new FlxSprite(0, 0);
		fade.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		fade.width = FlxG.width;
		fade.height = FlxG.height;



		new FlxTimer().start(7, function(tmr:FlxTimer)
		{
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.03}, 3, {ease: FlxEase.circOut, type: ONESHOT});
			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.03}, 3, {ease: FlxEase.circOut, type: ONESHOT});
			});
		}, 0);
		



		


		

		



		
		
		
		add(freddybg);
		add(weekname);
		add(songlist);
		add(goback);
		add(gobutton);
		add(normalmode);
		add(easymode);
		add(hardmode);
		add(nextbutton);
		add(prevbutton);
		add(staticeffect);
		add(fade);


		freddybg.animation.play('idle');
		staticeffect.animation.play('idle');
		staticeffect.alpha = 1;
		normalmode.visible = true;
		easymode.visible = false;
		hardmode.visible = false;
		fade.alpha = 0;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "FNF 0.2.7.1 | Kade Engine 1.5.4" #if mobileC + " | KE Android " + Application.current.meta.get('version') + " - Ported by Nibi" #else + " - Edited by TheLeerName " + "(" + Application.current.meta.get('version') + ")" #end, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		#if mobileC
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
					changeItem(-1);
				if (gamepad.justPressed.DPAD_DOWN)
					changeItem(1);
			}

			if (controls.UP_P)
				changeItem(-1);

			if (controls.DOWN_P)
				changeItem(1);

			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
				FlxG.switchState(new TitleState());

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
