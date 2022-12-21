local QuoteAnims={'shootLEFT', 'shootDOWN', 'shootRIGHT'}
local PicoAnims={'shootBus', 'shoot', 'shoot1', 'shoot2'}

function onEvent(tag, v1, v2)
	if tag=='Shoot' then
		if v1=='pico' then
			triggerEvent('Play Animation', PicoAnims[math.random(1,4)], 1)
		elseif v1=='quote' then
			triggerEvent('Play Animation', QuoteAnims[math.random(1,3)], 0)
		end
		playSound('onlineVS_shoot', 0.5)
	end
end