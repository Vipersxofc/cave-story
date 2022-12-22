local allowCountdown = false

function onEndSong()
    if not seenCutscene then
        makeAnimatedLuaSprite('misery', 'Misery', 1000, 450);
		addAnimationByPrefix('misery', 'idle', 'MiseryAppear', 24, false);
		addAnimationByPrefix('misery', 'teleport', 'MiseryTeleport01', 24, false);
		objectPlayAnimation('misery', 'idle');
		addLuaSprite('misery', true);
		playSound('teleport',1)
		doTweenAlpha('hud', 'camHUD', 0, 0.5, 'linear');
		runTimer('hate', 0.1);
		seenCutscene = true
        return Function_Stop
    end
    return Function_Continue
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hate' then
		runTimer('wein', 1.2);
		runTimer('tele', 1.7);
		runTimer('goku', 3);
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.y', 800);
		setProperty('camFollow.x', 1250);
	end
	if tag == 'wein' then
		objectPlayAnimation('misery', 'teleport');
	end
	if tag == 'tele' then
		playSound('teleportout',1)
		makeLuaSprite('whitehueh', 'whitehueh', 0, 0);
		setScrollFactor('whitehueh', 0, 0);
		addLuaSprite('whitehueh', true);
		setObjectCamera('whitehueh', 'other');
		doTweenColor('hueh', 'whitehueh', 0xff000000, 0.5);
	end
	if tag == 'goku' then
		endSong();
	end
end