function onSpawnNote(i)
    if not getPropertyFromGroup('notes', i, 'mustPress') then
        setPropertyFromGroup('notes', i, 'multSpeed', 1.71)
    end
end