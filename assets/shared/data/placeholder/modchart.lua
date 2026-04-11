local defaultScale = 0.7
local posSet = false

function onUpdate(elapsed)
    if posSet then
        for i = 0, 7 do
            local curScale = getPropertyFromGroup('strumLineNotes', i, 'scale.x')
            if curScale > defaultScale then
                local newScale = curScale + (defaultScale - curScale) * (elapsed * 10)
                setPropertyFromGroup('strumLineNotes', i, 'scale.x', newScale)
                setPropertyFromGroup('strumLineNotes', i, 'scale.y', newScale)
            end
        end
    end
end

function onBeatHit()
    if not posSet then
        defaultScale = getPropertyFromGroup('strumLineNotes', 0, 'scale.x')
        posSet = true
    end

    local bop = false
    
    if curBeat >= 64 and curBeat < 96 and curBeat % 4 == 0 then
        bop = true
    elseif curBeat >= 96 and curBeat < 224 then
        bop = true
    elseif curBeat >= 224 and curBeat < 288 and curBeat % 4 == 0 then
        bop = true
    elseif curBeat >= 288 and curBeat < 352 then
        bop = true
    elseif curBeat >= 352 and curBeat % 4 == 0 then
        bop = true
    end

    if bop then
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', defaultScale + 0.15)
            setPropertyFromGroup('strumLineNotes', i, 'scale.y', defaultScale + 0.15)
        end
    end
end