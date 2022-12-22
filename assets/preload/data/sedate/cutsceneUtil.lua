local timers={
		[1]={'sceneLength', 10},
		[2]={'init', 0.15},
		[3]={'gfAct', 0.75},
		[4]={'pan1', 2},
		[5]={'bfAct', 3.25},
		[6]={'pan2', 4},
		[7]={'quoteAct', 5.5},
		[8]={'shake01', 5.75},
		[9]={'curlyAct', 6.15},
		[10]={'shake02', 6.15+0.15},
		[11]={'curlyAct2', 7},
		[12]={'pan3', 8},
		[13]={'cheer', 9},
	}
local cutsceneCallbacks={
		['sceneLength']=function()
			startCountdown()
			doTweenAlpha('hudIN', 'camHUD', 1, 1, 'linear')
		end,
		['init']=function() playSound('cutscene/outerwallcutscene01',1) end,
		['gfAct']=function()
			setProperty('gorf.animation.curAnim.curFrame', 0)
			setProperty('gorf.animation.curAnim.paused', false)
			objectPlayAnimation('gorf','intro1',true)
		end,
		['pan1']=function()
			doTweenX('camX', 'camGame.target', getCenter('boyfriend', 'x')-200, 1, 'sineInOut')
			doTweenY('camY', 'camGame.target', getCenter('boyfriend', 'y')-100, 1, 'sineInOut')
		end,
		['bfAct']=function()
			setProperty('gorf.alpha', 0.0001)
			setProperty('gf.alpha', 1)
			triggerEvent('Play Animation', 'cheer', 'GF')
			setProperty('barm.alpha', 1)
			setProperty('boyfriend.alpha', 0.0001)
			objectPlayAnimation('barm', 'intro1', true)
		end,
		['pan2']=function()
			doTweenX('camX', 'camGame.target', getCenter('dad', 'x'), 0.75, 'sineInOut')
			doTweenY('camY', 'camGame.target', getCenter('dad', 'y')-400, 0.75, 'sineInOut')
			doTweenZoom('camZ', 'camGame', 0.8, 1, 'sineInOut')
		end,
		['quoteAct']=function()
			setProperty('quotation.alpha', 1)
			objectPlayAnimation('quotation', 'intro1', true)
		end,
		['shake01']=function() 
			cameraShake('camGame', 0.02, 0.1) 
		end,
		['curlyAct']=function()
			setProperty('bracket.alpha', 1)
			objectPlayAnimation('bracket', 'intro1', true)
		end,
		['shake02']=function() 
			cameraShake('camGame', 0.02, 0.1) 
		end,
		['curlyAct2']=function()
			setProperty('bracket.alpha', 1)
			objectPlayAnimation('bracket', 'intro2', true)
		end,
		['pan3']=function()
			setProperty('boyfriend.alpha', 1)
			setProperty('barm.alpha', 0.0001)
			
			setProperty('extrachar1.alpha', 1)
			setProperty('bracket.alpha', 0.0001)
			setProperty('dad.alpha', 1)
			setProperty('quotation.alpha', 0.0001)
			
			doTweenX('camX', 'camGame.target', getCenter('gf', 'x'), 1, 'sineInOut')
			doTweenY('camY', 'camGame.target', getCenter('gf', 'y'), 1, 'sineInOut')
			doTweenZoom('camZ', 'camGame', 0.65, 1, 'sineInOut')
		end,
		['cheer']=function()
			triggerEvent('Play Animation', 'cheer', 'GF')
		end,
	}
local start=false

function onCreatePost()
	if isStoryMode and not seenCutscene then
		createCutsceneAssets()
	end
end

function createCutsceneAssets()
	setProperty('camera.target.x', getCenter('gf', 'x'))
	setProperty('camera.target.y', getCenter('gf', 'y')-50)
	
	makeAnimatedLuaSprite('barm','characters/cutscene_assets/CutsceneBoyfriend', getProperty('boyfriend.x'), getProperty('boyfriend.y')-250)
		addAnimationByPrefix('barm', 'intro1', 'BoyfriendMicTwirl', 24, false)
	addLuaSprite('barm', true)
	
	makeAnimatedLuaSprite('gorf','characters/cutscene_assets/CutsceneGirlfriend', getProperty('gf.x')-15, getProperty('gf.y')-570)
		addAnimationByPrefix('gorf', 'intro1', 'GFSpeakerJumpFULL', 24, false)
	addLuaSprite('gorf', true)
	
	makeAnimatedLuaSprite('bracket','characters/cutscene_assets/CutsceneCurly', getProperty('extrachar1.x')-85, getProperty('extrachar1.y')-990)
		addAnimationByIndices('bracket', 'intro1', 'CurlyDropIn', '0,1,2,3,4,5,6,7', 24)
		addAnimationByIndices('bracket', 'intro2', 'CurlyDropIn', '8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41', 24)
	addLuaSprite('bracket', true)
	
	makeAnimatedLuaSprite('quotation','characters/cutscene_assets/CutsceneQuote', getProperty('dad.x')-500, getProperty('dad.y')-125)
		addAnimationByPrefix('quotation', 'intro1', 'QuoteDropIn', 24, false)
		scaleObject('quotation', 1.05, 1.05)
	addLuaSprite('quotation', true)
	
	setProperty('boyfriend.alpha', 1)
	setProperty('barm.alpha', 0.001)
	
	setProperty('gf.alpha', 0.001)
	setProperty('gorf.animation.curAnim.curFrame', 7)
	setProperty('gorf.animation.curAnim.paused', true)
	
	setProperty('camHUD.alpha', 0.001)
	
	setProperty('dad.alpha', 0.001)
	setProperty('extrachar1.alpha', 0.001)
	
	setProperty('quotation.alpha', 0.001)
	setProperty('bracket.alpha', 0.001)
end

function getCenter(obj, axis)
	if axis=='x' then return getProperty(obj..'.x')+(getProperty(obj..'.width')*0.5)
	elseif axis=='y' then return getProperty(obj..'.y')+(getProperty(obj..'.height')*0.5) end
end

function startCutscene()
	debugPrint('scene_load')
	doTweenZoom('camZ', 'camGame', 1, 1, 'circOut')
end

function onSongStart()
	removeLuaSprite('barm', true)
	removeLuaSprite('gorf', true)
	removeLuaSprite('quotation', true)
	removeLuaSprite('bracket', true)
end

function onStartCountdown()
	if not start and isStoryMode and not seenCutscene then
		setProperty('inCutscene',true)
		for aaa=1,table.maxn(timers) do
			runTimer(timers[aaa][1], timers[aaa][2], 1)
		end
		startCutscene()
		start=true
		return Function_Stop;
	else
		setProperty('seenCutscene',true)
	end
	return Function_Continue;
end
	
function onTimerCompleted(tag,loops,left)
	if cutsceneCallbacks[tag] then cutsceneCallbacks[tag]() end
end