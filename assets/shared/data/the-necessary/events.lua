local allowHunglings = false
local spawnCount = 0
local hunglings = {}
local jungries = {}
local spawnTmr = 0
local spawnInt = 4
local startXLeft = -200
local startXRight = 1500
local baseY = 560

function onCreate()
    if luaSpriteExists('hungling1') then
        setProperty('hungling1.visible', false)
    end
    if luaSpriteExists('hungling2') then
        setProperty('hungling2.visible', false)
    end
    if luaSpriteExists('Jungry') then
        setProperty('Jungry.visible', false)
    end

    makeLuaSprite('blackOverlay', '', 0, 0)
    makeGraphic('blackOverlay', 1280, 720, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay.alpha', 1)
    setProperty('defaultCamZoom', 3.0)
    setProperty('camGame.zoom', 3.0)
    addLuaSprite('blackOverlay', true)
end

function onUpdate(elapsed)
    if not allowHunglings then return end

    spawnTmr = spawnTmr + elapsed
    if spawnTmr >= spawnInt then
        spawnTmr = 0
        spawnHungling()
        if math.random() < 0.4 then spawnHungling() end
        if math.random() < 0.25 then spawnJungry() end
    end

    moveAndCleanup(hunglings, elapsed)
    moveAndCleanup(jungries, elapsed)
end

function moveAndCleanup(list, elapsed)
    for i = #list, 1, -1 do
        local item = list[i]
        local tag = item.tag
        local speed = item.speed
        local x = getProperty(tag .. '.x')
        
        setProperty(tag .. '.x', x + speed * elapsed)

        if (speed > 0 and x > startXRight + 100) or (speed < 0 and x < startXLeft - 100) then
            removeLuaSprite(tag, true)
            table.remove(list, i)
        end
    end
end

function spawnHungling()
    local type = (math.random(1, 100) <= 50) and 'hungling1' or 'hungling2'
    local anim = (type == 'hungling1') and 'hungling1 jump' or 'hungling2 eatatakirun'
    setupEntity(type, anim, hunglings, math.random(160, 320), 577)
end

function spawnJungry()
    setupEntity('Jungry', 'Jungry', jungries, math.random(120, 240), 623)
end

function setupEntity(tagPrefix, anim, list, speedBase, yPos)
    local rightChungus = math.random(1, 100) <= 50
    local startX = (rightChungus and startXLeft or startXRight) + math.random(-50, 50)
    local dir = rightChungus and 1 or -1
    
    local tag = tagPrefix .. '_ent_' .. spawnCount
    spawnCount = spawnCount + 1

    makeAnimatedLuaSprite(tag, tagPrefix, startX, yPos)
    addAnimationByPrefix(tag, 'move', anim, 12, true)
    objectPlayAnimation(tag, 'move', true)
    
    setProperty(tag .. '.antialiasing', false)
    setProperty(tag .. '.flipX', not rightChungus)
    setObjectCamera(tag, 'game')
    scaleObject(tag, 0.7, 0.7)

    addLuaSprite(tag, false)
    local gfOrder = getObjectOrder('gfGroup')
    if gfOrder > 0 then
        setObjectOrder(tag, gfOrder - 1)
    end

    table.insert(list, {tag = tag, speed = speedBase * dir})
end

function onStepHit()
    if (curStep == 320) then
        allowHunglings = true
    end

    if curStep == 1 then
        local dur = (stepCrochet * 64) / 1000
        doTweenAlpha('black', 'blackOverlay', 0, dur, 'linear')
        doTweenZoom('introZoomOut', 'camGame', 1.5, dur, 'linear')
    elseif curStep == 64 then
        setProperty('defaultCamZoom', 1.5)
    elseif curStep == 184 or curStep == 312 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.7, 'linear')
        doTweenZoom('zoomIn', 'camGame', 2, 0.7, 'linear')
    elseif curStep == 192 or curStep == 320 then
        doTweenAlpha('black', 'blackOverlay', 0, 1, 'linear')
        doTweenZoom('zoomOut', 'camGame', 1.5, 0.7, 'cubeOut')
        cameraFlash('game', 'FFFFFF', 1, true)
    elseif curStep == 576 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.7, 'linear')
        cameraFlash('game', 'FFFFFF', 1, true)
    elseif curStep == 832 then
        doTweenAlpha('black', 'blackOverlay', 0, 0.7, 'linear')
        cameraFlash('game', 'FFFFFF', 1, true)
        cameraShake('game', 0.005, 0.35)
    elseif curStep == 1216 then
        doTweenAngle('camReturn', 'camGame', 0, 0.6, 'cubeOut')
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.7, 'linear')
    elseif curStep == 1472 then
        doTweenAngle('camReturn', 'camGame', 0, 0.6, 'cubeOut')
        doTweenAlpha('black', 'blackOverlay', 0, 0.7, 'linear')
    elseif curStep == 1728 then
        doTweenAlpha('black', 'blackOverlay', 0.6, 0.7, 'linear')
    elseif curStep == 1856 then
        doTweenAlpha('black', 'blackOverlay', 0, 0.7, 'linear')
    elseif curStep == 1984 then
        doTweenAlpha('black', 'blackOverlay', 1, 0.01, 'linear')
    end
end
