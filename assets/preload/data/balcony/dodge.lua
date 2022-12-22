function onCreate() --This is to utilize the built in Dodge Mechanic on other Stages
	setProperty('hasSpacebarGimmick', true);
	setProperty('healthTaken', 0.5);
end

function onCreatePost()
	makeAnimatedLuaSprite('king','characters/QuoteBlade', 450, 900)
	addAnimationByPrefix('king', 'idle', 'KingIdle', 24, true)
	addAnimationByPrefix('king', 'dash', 'KingDash', 24, true)
	addAnimationByPrefix('king', 'attack', 'KingAttack', 24, false)
	objectPlayAnimation('king','idle',true)
	setProperty('king.alpha', 0.001)
	addLuaSprite('king', false)
end

function onBeatHit()
--spacecountdown is the countdown on the space bar gimmick.
--Ideally countdown from 3 so you can take advantage of the timing.
	if getProperty('hasSpacebarGimmick') == true and getProperty('enablespacebargimmick') == true then --long :(
		if getProperty('spacecountdown') == 2 then
			runTimer('dash', 0.5);
			objectPlayAnimation('king','dash',true)
		end
		if getProperty('spacecountdown') == 1 then
			runTimer('attack', 0.5); -- needs a delay unfort
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'attack' then
		--playSound('polar_star_Shoot',2)
		objectPlayAnimation('king','attack',true)
		playSound('bladeSwing',2)
		runTimer('complete', 0.2);
		triggerEvent('Play Animation', 'attack', 'dad');
	end
	if tag == 'complete' then
		objectPlayAnimation('king','idle',true)
		doTweenAlpha('hueh', 'king', 0, 0.2, 'linear')
	end
	if tag == 'dash' then
		setProperty('king.x', 450)
		doTweenAlpha('hueh', 'king', 1, 0.2, 'linear')
		setProperty('king.velocity.x', 2000)	
	end
end