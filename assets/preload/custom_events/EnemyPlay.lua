--Configurations
local SingLengthDad=4 --hold time for dad
local SingLengthBF=4 --hold time for bf
local hasMissAnims=false --enable if your dad character has miss animations
local singStrength=0.02 --amount of health gained or lost on sing or miss
local NewHealthSys=false --toggles if dad singing pushes the bar towards the right
local freezeFrame=6 --frame for note being held down or animation being paused
local noteOffsetShit=10 --just some offset shit because auhdsuhdauhsd
local MissColor='0000FF' --the color that the dad turns when missing a note (Only used if hasMissAnims is false)
--Configurations

--Cleaned Up Script Below!!

local EnemyPlay=false
function onEvent(n, v1, v2)
	
	if n=='EnemyPlay' and v1=='true' then--Enable EnemyPlay
		noteTweenX('PlayerTween1', 4, defaultOpponentStrumX0+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('PlayerTween2', 5, defaultOpponentStrumX1+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('PlayerTween3', 6, defaultOpponentStrumX2+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('PlayerTween4', 7, defaultOpponentStrumX3+noteOffsetShit, 0.3, 'circOut')
		
		noteTweenX('EnemyTween1', 0, defaultPlayerStrumX0+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('EnemyTween2', 1, defaultPlayerStrumX1+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('EnemyTween3', 2, defaultPlayerStrumX2+noteOffsetShit, 0.3, 'circOut')
		noteTweenX('EnemyTween4', 3, defaultPlayerStrumX3+noteOffsetShit, 0.3, 'circOut')
	
		for i = 0, getProperty('unspawnNotes.length')-1 do
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true) --removes le animation
		end
		EnemyPlay=true
		SwapNotes(true)
		
	elseif n=='EnemyPlay' and v1=='false' then--Disable EnemyPlay
		noteTweenX('PlayerTween1', 4, defaultPlayerStrumX0+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('PlayerTween2', 5, defaultPlayerStrumX1+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('PlayerTween3', 6, defaultPlayerStrumX2+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('PlayerTween4', 7, defaultPlayerStrumX3+noteOffsetShit, 0.2, 'circOut')
		
		noteTweenX('EnemyTween1', 0, defaultOpponentStrumX0+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('EnemyTween2', 1, defaultOpponentStrumX1+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('EnemyTween3', 2, defaultOpponentStrumX2+noteOffsetShit, 0.2, 'circOut')
		noteTweenX('EnemyTween4', 3, defaultOpponentStrumX3+noteOffsetShit, 0.2, 'circOut')
	
		for i = 0, getProperty('unspawnNotes.length')-1 do
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true) --removes le animation
		end
		EnemyPlay=false
		SwapNotes(false)
		
	end
	
end

local DadHealth=1

function onUpdate()
	if not inGameOver and NewHealthSys==true and EnemyPlay==true then
		setProperty('health', DadHealth)
		
		if getProperty('dad.animation.curAnim.curFrame')==freezeFrame and StepTimeDad>0 then
			setProperty('dad.specialAnim', true)
			setProperty('dad.animation.curAnim.curFrame', freezeFrame)
			setProperty('dad.animation.curAnim.paused', true)
			
		elseif StepTimeDad==0 then
			setProperty('dad.specialAnim', false)
			setProperty('dad.animation.curAnim.paused', false)
		
		end
	end
end

local StepTimeDad=0
local StoredDir=0
local singAnims={'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
local missAnims={'singLEFTmiss', 'singDOWNmiss', 'singUPmiss', 'singRIGHTmiss'}
function goodNoteHit(id, direction, noteType, isSustainNote)
	
	-- Function called when you hit a note (after note hit calculations)
	-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
	-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
	-- noteType: The note type string/tag
	-- isSustainNote: If it's a hold note, can be either true or false
	if EnemyPlay==true then
		if DadHealth>0.1 and NewHealthSys==true then
			DadHealth=DadHealth-singStrength
		end
		
		StoredDir=direction
		setProperty('dad.specialAnim', false)
		setProperty('dad.color', getColorFromHex('FFFFFF'))
		if altAnim or noteType=='Alt Animation' then
			characterPlayAnim('dad', singAnims[direction+1]..'-alt', true)
		else
			characterPlayAnim('dad', singAnims[direction+1], true)
		end
		setProperty('dad.specialAnim', true)
		StepTimeDad=SingLengthDad
	end
end

local holdKeys={'left', 'down', 'up', 'right'}
function onStepHit()
	if EnemyPlay==true then
		if StepTimeDad==2 then
			setProperty('dad.animation.curAnim.curFrame', freezeFrame)
			setProperty('dad.animation.curAnim.paused', true)
		end

		if StepTimeDad>0 then
			StepTimeDad=StepTimeDad-1
		
		elseif StepTimeDad==0 and (keyPressed('left') or keyPressed('down') or keyPressed('up') or keyPressed('right')) then
	
			StepTimeDad=1
			
			setProperty('dad.specialAnim', true)
			setProperty('dad.animation.curAnim.curFrame', freezeFrame)
			setProperty('dad.animation.curAnim.paused', true)
		
		elseif StepTimeDad==0 then
			setProperty('dad.animation.curAnim.paused', false)
			setProperty('dad.specialAnim', false)
			setProperty('dad.color', getColorFromHex('FFFFFF'))
		
		end
	
		if StepTimeBF>0 then
			StepTimeBF=StepTimeBF-1
		elseif StepTimeBF==0  then
			setProperty('boyfriend.specialAnim', false)
			characterPlayAnim('boyfriend', 'idle', false)
		end
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	-- Works the same as goodNoteHit, but for Opponent's notes being hit
	if EnemyPlay==true then
		setProperty('boyfriend.specialAnim', false)
		if altAnim or noteType=='Alt Animation' then
			characterPlayAnim('boyfriend', singAnims[direction+1]..'-alt', true)
		else
			characterPlayAnim('boyfriend', singAnims[direction+1], true)
		end
		setProperty('boyfriend.specialAnim', true)
		StepTimeBF=SingLengthBF
	
		if DadHealth<1.9 and NewHealthSys==true then
			DadHealth=DadHealth+singStrength
		end
	end
end

function noteMissPress(direction)
	-- Called after the note press miss calculations
	-- Player pressed a button, but there was no note to hit (ghost miss)
	if EnemyPlay==true then
		characterPlayAnim('boyfriend', 'idle', false)
	
		StoredDir=direction
		setProperty('dad.specialAnim', false)
	
		if hasMissAnims==true then
			characterPlayAnim('dad', missAnims[direction+1], true)
		else
			characterPlayAnim('dad', singAnims[direction+1], true)
			setProperty('dad.color', getColorFromHex(MissColor))
		end
	
		setProperty('dad.specialAnim', true)
		StepTimeDad=SingLengthDad
	
		if NewHealthSys==true then
			DadHealth=DadHealth+(singStrength*2)
			if DadHealth>=2 then
				DadHealth=0
			end
		end
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	-- Called after the note miss calculations
	-- Player missed a note by letting it go offscreen
	if EnemyPlay==true then
		characterPlayAnim('boyfriend', 'idle', false)
	
		StoredDir=direction
		setProperty('dad.specialAnim', false)
	
		if hasMissAnims==true then
			characterPlayAnim('dad', missAnims[direction+1], true)
		else
			characterPlayAnim('dad', singAnims[direction+1], true)
			setProperty('dad.color', getColorFromHex(MissColor))
		end
	
		setProperty('dad.specialAnim', true)
		StepTimeDad=SingLengthDad
	
		if NewHealthSys==true then
			DadHealth=DadHealth+(singStrength*2)
			if DadHealth>=2 then
				DadHealth=0
			end
		end
	end
end

function SwapNotes(bool)
	
	for i = 0, getProperty('unspawnNotes.length')-1 do
		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', bool)
		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress')==bool then --Check
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', bool) --Set
		else
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', not bool) --Set
		end
	end
		
	for j = 0, getProperty('notes.length')-1 do
		setPropertyFromGroup('notes', j, 'noAnimation', bool)
		if not getPropertyFromGroup('notes', j, 'mustPress')==bool  then --Check
			setPropertyFromGroup('notes', j, 'mustPress', bool) --Set
		else
			setPropertyFromGroup('notes', j, 'mustPress', not bool) --Set
		end
	end

end