local placeConfig = {
    defaultCamZoom = 1.5,
    ['dadGroup.x'] = 285,
    ['dadGroup.y'] = 75,
    ['boyfriendGroup.x'] = 900,
    ['boyfriendGroup.y'] = 80,
    ['opponentCameraOffset'] = {115, -50},
    ['boyfriendCameraOffset'] = {0, -38},
    ['cameraSpeed'] = 10,
    ['gf.visible'] = false
}

local scrappedConfig = {
    defaultCamZoom = 0.8,
    ['dadGroup.x'] = 735,
    ['dadGroup.y'] = 140,
    ['boyfriendGroup.x'] = 910,
    ['boyfriendGroup.y'] = 320,
    ['opponentCameraOffset'] = {13, 141},
    ['boyfriendCameraOffset'] = {110, 275},
    ['cameraSpeed'] = 10,
    ['gf.visible'] = false
}

local circles = {}
local circleSpeed = 200
local circleBopAmt = 0.2
local circleBopTime = 0.1
local circleBopNextBeat = 4

local circleScr = {}
local circleScrSpeed = 200
local circleScrWidth = 1529

local function safeSet(prop, val)
    pcall(function()
        setProperty(prop, val)
    end)
end

local function applyStageConfig(cfg)
    if not cfg then return end
    for prop, val in pairs(cfg) do
        if type(val) == "table" then
            safeSet(prop .. "[0]", val[1])
            safeSet(prop .. "[1]", val[2])
        else
            safeSet(prop, val)
        end
    end
end

local function clearSprites(list)
    for _, id in ipairs(list) do
        removeLuaSprite(id, true)
    end
end

local function clearList(list)
    for _, item in ipairs(list) do
        removeLuaSprite(item.id, true)
    end
    return {}
end

local function buildCircles()
    circles = clearList(circles)
    local dadOrder = getObjectOrder('dadGroup') or 1
    local id, size, x, y = 'circle', 1, -200, 484

    makeLuaSprite(id, 'fuckingcircle', x, y)
    scaleObject(id, size, size)
    setObjectCamera(id, 'game')
    setProperty(id .. '.antialiasing', false)
    addLuaSprite(id, false)
    setObjectOrder(id, dadOrder - 1)

    local circle = {
        id = id,
        x = x,
        speedX = circleSpeed,
        bopTimer = 0,
        scaleX = size,
        scaleY = size
    }
    circle.propX = id .. ".x"
    circle.propScaleX = id .. ".scale.x"
    circle.propScaleY = id .. ".scale.y"

    table.insert(circles, circle)
end

local function updateCircles(elapsed)
    for _, c in ipairs(circles) do
        c.x = c.x + c.speedX * elapsed
        if c.x > 1280 + 50 then
            c.x = -200
        end
        setProperty(c.propX, c.x)

        if c.bopTimer > 0 then
            c.bopTimer = c.bopTimer - elapsed
            local scale = 1 + circleBopAmt * (c.bopTimer / circleBopTime)
            setProperty(c.propScaleX, c.scaleX * scale)
            setProperty(c.propScaleY, c.scaleY * scale)
        end
    end
end

local function buildCircleScroll()
    circleScr = clearList(circleScr)
    local dadOrder = getObjectOrder('dadGroup') or 1

    for i = 0, 1 do
        local id = 'circleScr' .. i
        makeLuaSprite(id, 'fuckingcirclescroll', i * circleScrWidth, 0)
        setObjectCamera(id, 'hud')
        setProperty(id .. '.antialiasing', false)
        addLuaSprite(id, true)
        setObjectOrder(id, dadOrder - 1)

        local scroll = {
            id = id,
            x = i * circleScrWidth,
            bopTimer = 0
        }
        scroll.propX = id .. ".x"
        scroll.propScaleX = id .. ".scale.x"
        scroll.propScaleY = id .. ".scale.y"

        table.insert(circleScr, scroll)
    end
end

local function updateCircleScroll(elapsed)
    local minX
    for _, c in ipairs(circleScr) do
        c.x = c.x + circleScrSpeed * elapsed
    end

    minX = math.huge
    for _, c in ipairs(circleScr) do
        if c.x < minX then
            minX = c.x
        end
    end

    for _, c in ipairs(circleScr) do
        if c.x >= circleScrWidth then
            c.x = minX - circleScrWidth
        end
        setProperty(c.propX, c.x)

        if c.bopTimer > 0 then
            c.bopTimer = c.bopTimer - elapsed
            local scale = 1 + circleBopAmt * (c.bopTimer / circleBopTime)
            setProperty(c.propScaleX, scale)
            setProperty(c.propScaleY, scale)
        end
    end
end

local function buildStage(stage)
    clearSprites({'scrapped', 'place', 'fuckingchair'})
    circles, circleScr = clearList(circles), clearList(circleScr)

    if stage == 'scrapped' then
        makeAnimatedLuaSprite('scrapped', 'bgscrapped', -82, 19)
        addAnimationByPrefix('scrapped', 'idle', 'bgscrapped idle', 12, true)
        objectPlayAnimation('scrapped', 'idle', true)
        setScrollFactor('scrapped', 1, 1)
        setProperty('scrapped.antialiasing', false)
        addLuaSprite('scrapped', false)
        local dadOrder = getObjectOrder('dadGroup')
        if dadOrder then
            setObjectOrder('scrapped', dadOrder - 1)
        end
        applyStageConfig(scrappedConfig)
    elseif stage == 'place' then
        makeAnimatedLuaSprite('place', 'place', 238, 245)
        addAnimationByPrefix('place', 'idle', 'place idle', 12, true)
        objectPlayAnimation('place', 'idle', true)
        setScrollFactor('place', 1, 1)
        setProperty('place.antialiasing', false)
        addLuaSprite('place', false)

        makeAnimatedLuaSprite('fuckingchair', 'fuckingchair', 238, 245)
        addAnimationByPrefix('fuckingchair', 'idle', 'fuckingchair idle', 12, true)
        objectPlayAnimation('fuckingchair', 'idle', true)
        setScrollFactor('fuckingchair', 1, 1)
        setProperty('fuckingchair.antialiasing', false)
        addLuaSprite('fuckingchair', false)

        local dadOrder = getObjectOrder('dadGroup')
        if dadOrder then
            setObjectOrder('place', dadOrder - 2)
            buildCircles()
            setObjectOrder('fuckingchair', dadOrder - 1)
            buildCircleScroll()
        end

        applyStageConfig(placeConfig)
    end
end

function onCreate()
    math.randomseed(os.time())
    buildStage('place')

    makeLuaSprite('evilImg', 'theevilfuckingimage', 0, 0)
    setObjectCamera('evilImg', 'hud')
    scaleObject('evilImg', 1.25, 1.25)
    setProperty('evilImg.antialiasing', false)
    addLuaSprite('evilImg', true)

    makeLuaSprite('blackOverlay', '', 0, 0)
    makeGraphic('blackOverlay', 1280, 720, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay' .. '.alpha', 1)
    addLuaSprite('blackOverlay', true)

    makeLuaText('placeholderTxt', "THIS SONG IS A PLACEHOLDER.", 0, 0, 0)
    setTextAlignment('placeholderTxt', 'center')
    setTextSize('placeholderTxt', 64)
    setObjectCamera('placeholderTxt', 'hud')
    screenCenter('placeholderTxt', 'x')
    setProperty('placeholderTxt.alpha', 0)
    setProperty('placeholderTxt.scale.x', 0)
    setProperty('placeholderTxt.scale.y', 0)
    setProperty('placeholderTxt.antialiasing', false)
    addLuaText('placeholderTxt')
end

function onSongStart()
    doTweenAlpha('black', 'blackOverlay', 0, 12, 'linear')
end

function onUpdate(elapsed)
    updateCircles(elapsed)
    updateCircleScroll(elapsed)
end

function onBeatHit()
    if curBeat % circleBopNextBeat == 0 then
        for _, c in ipairs(circles) do
            c.bopTimer = circleBopTime
        end
    end
end

function onStepHit()
    if (curStep == 384) then
        doTweenAlpha('black', 'blackOverlay', 0, 0.5, 'linear')
        cameraFlash('game', 'FFFFFF', 1, true)
        doTweenZoom('zoomOut', 'camGame', 1.5, 0.7, 'cubeOut')

        for _, c in ipairs(circles) do
            c.speedX = c.speedX * 2
        end
        circleBopNextBeat = 1
    end

    if curStep == 87 then
        doTweenAngle('evilImgTweenAngle', 'evilImg', 360, 8, 'quartInOut')
        doTweenY('evilImgTweenY', 'evilImg', 1400, 6, 'quartInOut')
    elseif curStep == 96 then
        screenCenter('placeholderTxt', 'xy')
        doTweenAlpha('placeholderAlpha', 'placeholderTxt', 1, 0.4, 'quartOut')
        doTweenX('placeholderTxtXScale', 'placeholderTxt.scale', 1.1, 1.2, 'elasticOut');
        doTweenY('placeholderTxtYScale', 'placeholderTxt.scale', 1.1, 1.2, 'elasticOut');
        runTimer('dropTxt', 1.8)
    elseif curStep == 251 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.4, 'linear')
        doTweenZoom('zoomIn', 'camGame', 2, 0.4, 'linear')
    elseif curStep == 256 or curStep == 640 then
        doTweenAlpha('black', 'blackOverlay', 0, 0.5, 'linear')
        doTweenZoom('zoomOut', 'camGame', 1.5, 0.7, 'cubeOut')
        cameraFlash('game', 'FFFFFF', 1, true)
    elseif curStep == 376 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.6, 'linear')
        doTweenZoom('zoomIn', 'camGame', 2, 0.6, 'linear')
    elseif curStep == 512 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.6, 'linear')
    elseif curStep == 560 or curStep == 566 or curStep == 572 or curStep == 576 or curStep == 624 or curStep == 630 or curStep == 636 or curStep == 640 then
        cameraFlash('game', 'FFFFFF', 0.5, true)
    elseif curStep == 896 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.6, 'linear')
        for _, c in ipairs(circles) do
            c.speedX = c.speedX
        end
        circleBopNextBeat = 4
    elseif curStep == 1152 then
        doTweenAlpha('black', 'blackOverlay', 0, 0.5, 'linear')
        cameraFlash('game', 'FFFFFF', 1, true)
        buildStage('scrapped')
    elseif curStep == 1408 then
        cameraFlash('game', 'FFFFFF', 1, true)
        buildStage('place')
        setProperty('defaultCamZoom', 1.5)
        doTweenZoom('zoomOut', 'camGame', 1.5, 0.7, 'cubeOut')
    elseif curStep == 1664 then
        cameraFlash('game', 'FFFFFF', 1, true)
        doTweenAlpha('black', 'blackOverlay', 1, 15, 'linear')
    end
end

function onTimerCompleted(tag)
    if tag == 'dropTxt' then
        doTweenAngle('placeholderDropAngle', 'placeholderTxt', 360, 4, 'quartInOut')
        doTweenY('placeholderDropTweenY', 'placeholderTxt', 1400, 3, 'quartInOut')
    end
end
