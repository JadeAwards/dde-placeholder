local initPlayerStrumY = {}
local initOpponentStrumY = {}
local initPlayerStrumX = {}
local initOpponentStrumX = {}

function onCreatePost()
    for i = 0, 3 do
        initPlayerStrumY[i] = getProperty('playerStrums.members['..i..'].y')
        initOpponentStrumY[i] = getProperty('opponentStrums.members['..i..'].y')
        initPlayerStrumX[i] = getProperty('playerStrums.members['..i..'].x')
        initOpponentStrumX[i] = getProperty('opponentStrums.members['..i..'].x')
    end
end

function onUpdate(elapsed)
    if curStep >= 1088 and curStep < 1216 then
        setProperty('camGame.angle', getProperty('camGame.angle') + elapsed * 180)
    end
end

function onBeatHit()
    if (curBeat >= 48 and curBeat < 208) or (curBeat >= 368) then
        for i = 0, 3 do
            noteTweenY('playerStrumUp' .. i, i + 4, initPlayerStrumY[i] - 10, 0.1, 'quadOut')
            runTimer('playerStrumDownTmr' .. i, 0.1, 1)
            noteTweenY('opponentStrumUp' .. i, i, initOpponentStrumY[i] - 10, 0.1, 'quadOut')
            runTimer('opponentStrumDownTmr' .. i, 0.1, 1)
        end

        if curBeat >= 80 and curBeat < 432 then
            if curBeat % 4 == 0 then
                for i = 0, 1 do
                    local offset = 40
                    noteTweenX('pStrumX'..i, i + 4, initPlayerStrumX[i] - offset, 0.1, 'quadOut')
                    noteTweenX('oStrumX'..i, i, initOpponentStrumX[i] - offset, 0.1, 'quadOut')
                    
                    runTimer('pStrumXReturn'..i, 0.1)
                    runTimer('oStrumXReturn'..i, 0.1)
                end
            elseif curBeat % 4 == 1 then
                for i = 2, 3 do
                    local offset = 40
                    noteTweenX('pStrumX'..i, i + 4, initPlayerStrumX[i] + offset, 0.1, 'quadOut')
                    noteTweenX('oStrumX'..i, i, initOpponentStrumX[i] + offset, 0.1, 'quadOut')
                    
                    runTimer('pStrumXReturn'..i, 0.1)
                    runTimer('oStrumXReturn'..i, 0.1)
                end
            end
        end
    end

    if curBeat >= 208 and curBeat < 368 then
        for i = 0, 3 do
            local range = 50
            noteTweenX('oRandX'..i, i, initOpponentStrumX[i] + math.random(-range, range), 0.01, 'linear')
            noteTweenY('oRandY'..i, i, initOpponentStrumY[i] + math.random(-range, range), 0.01, 'linear')
            
            noteTweenX('pRandX'..i, i + 4, initPlayerStrumX[i] + math.random(-range, range), 0.01, 'linear')
            noteTweenY('pRandY'..i, i + 4, initPlayerStrumY[i] + math.random(-range, range), 0.01, 'linear')
        end
    end

    if curBeat == 368 then
        for i = 0, 3 do
            noteTweenX('pResetX'..i, i + 4, initPlayerStrumX[i], 0.5, 'cubeOut')
            noteTweenY('pResetY'..i, i + 4, initPlayerStrumY[i], 0.5, 'cubeOut')
            noteTweenX('oResetX'..i, i, initOpponentStrumX[i], 0.5, 'cubeOut')
            noteTweenY('oResetY'..i, i, initOpponentStrumY[i], 0.5, 'cubeOut')
        end
    end
end

function onTimerCompleted(tag)
    if string.find(tag, 'playerStrumDownTmr') then
        local index = tonumber(string.match(tag, 'playerStrumDownTmr(%d+)'))
        if index ~= nil then
            noteTweenY('playerStrumDown' .. index, index + 4, initPlayerStrumY[index], 0.1, 'quadOut')
        end
    elseif string.find(tag, 'opponentStrumDownTmr') then
        local index = tonumber(string.match(tag, 'opponentStrumDownTmr(%d+)'))
        if index ~= nil then
            noteTweenY('opponentStrumDown' .. index, index, initOpponentStrumY[index], 0.1, 'quadOut')
        end
    elseif string.find(tag, 'pStrumXReturn') then
        local index = tonumber(string.match(tag, 'pStrumXReturn(%d+)'))
        if index ~= nil then
            noteTweenX('pStrumXBack'..index, index + 4, initPlayerStrumX[index], 0.1, 'quadOut')
        end
    elseif string.find(tag, 'oStrumXReturn') then
        local index = tonumber(string.match(tag, 'oStrumXReturn(%d+)'))
        if index ~= nil then
            noteTweenX('oStrumXBack'..index, index, initOpponentStrumX[index], 0.1, 'quadOut')
        end
    end
end
