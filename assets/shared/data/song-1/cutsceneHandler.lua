local allowCountdown = false

function onStartCountdown()
    if not allowCountdown then
        setProperty('blackOverlay.visible', false)
        startVideo('song1')
        allowCountdown = true
        return Function_Stop
    end
    setProperty('blackOverlay.visible', true)
    return Function_Continue
end
