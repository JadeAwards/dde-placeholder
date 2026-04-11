function onCreate()
    makeLuaSprite('blackOverlay', '', 0, 0)
    makeGraphic('blackOverlay', 1280, 720, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay' .. '.alpha', 1)
    addLuaSprite('blackOverlay', true)
end

function onSongStart()
    doTweenAlpha('fadeBlack', 'blackOverlay', 0, 13, 'linear')
end

function onStepHit()
    if curStep == 512 then
        doTweenAlpha('fadeBlack', 'blackOverlay', 0.4, 1.2, 'linear')
        setProperty('defaultCamZoom', 1.2)
        runTimer('zoomHold', 25)
    elseif curStep == 760 then
        doTweenAlpha('fadeBlack', 'blackOverlay', 1, 0.01, 'linear')
        setProperty('defaultCamZoom', 0.95)
        runTimer('zoomHold', 1)
    elseif curStep == 768 then
        doTweenAlpha('fadeBlack', 'blackOverlay', 0, 0.01, 'linear')
    elseif curStep == 1152 then
        setProperty('defaultCamZoom', 1.2)
        runTimer('zoomHold', 2)
    elseif curStep == 1168 then
        doTweenAlpha('fadeBlack', 'blackOverlay', 1, 4, 'linear')
        setProperty('defaultCamZoom', 0.95)
        runTimer('zoomHold', 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'zoomHold' then
        setProperty('defaultCamZoom', 0.95)
    end
end
