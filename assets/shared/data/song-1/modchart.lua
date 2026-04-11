local intensity = 12
local floatSpeed = 0.5

function onUpdate(elapsed)
    local songPos = getSongPosition()
    local curBeatFloat = (songPos / 1000) * (curBpm / 60)

    for i = 0, 7 do
        local name = (i < 4) and 'defaultOpponentStrum' or 'defaultPlayerStrum'
        local id = i % 4
        
        local defX = _G[name .. 'X' .. id]
        local defY = _G[name .. 'Y' .. id]

        if defX and defY then
            local offsetX = math.sin(curBeatFloat * floatSpeed + (i * 0.4)) * intensity
            local offsetY = math.cos(curBeatFloat * floatSpeed * 0.8 + (i * 0.4)) * (intensity * 1.5)
            
            setPropertyFromGroup('strumLineNotes', i, 'x', defX + offsetX)
            setPropertyFromGroup('strumLineNotes', i, 'y', defY + offsetY)

            local breathing = 0.7 + (math.sin(curBeatFloat + (i * 0.2)) * 0.05)
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', breathing)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', breathing)
        end
    end

    local camTilt = math.sin(curBeatFloat * 0.25) * 1.2
    setProperty('camGame.angle', camTilt)
    setProperty('camHUD.angle', -camTilt * 0.5)
end