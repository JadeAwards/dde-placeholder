function onSpawnNote(i)
    if not getPropertyFromGroup('notes', i, 'mustPress') then
        setPropertyFromGroup('notes', i, 'multSpeed', 1.71)
    end
end

-- animated icon poo
-- wouldve hardcoded but everything i did wasnt working and this does sooo yea
function onCreatePost()
	makeAnimatedLuaSprite('YES', 'icons/icon-YES', getProperty('iconP2.x'), getProperty('iconP2.y'))
	addAnimationByPrefix('YES', 'loop', 'icon-YES ICON', 12, true)
	setScrollFactor('YES', 0, 0)
	setObjectCamera('YES', 'hud')
	setProperty('YES.offset.y', 85)
	addLuaSprite('YES', true)
	setObjectOrder('YES', 99)
	objectPlayAnimation('YES', 'loop', true)
	setProperty('YES.antialiasing', false) -- last minute add lol
end

function onUpdate(elapsed)
	local isCrazyDarn = (dadName == 'crazydarn')
	setProperty('YES.visible', isCrazyDarn)
	
	if isCrazyDarn then
		setProperty('iconP2.alpha', 0)
		setProperty('YES.x', getProperty('iconP2.x') + 15)
		setProperty('YES.y', getProperty('iconP2.y') + 70)
		setProperty('YES.scale.x', getProperty('iconP2.scale.x'))
		setProperty('YES.scale.y', getProperty('iconP2.scale.y'))
		setProperty('YES.angle', getProperty('iconP2.angle'))
	else
		setProperty('iconP2.alpha', 1)
	end
end