local oTriggerEvent = TriggerEvent
TriggerEvent = function(event, ...)
  print(("Triggering an event %s"):format(event))

  local debugInfo = debug.getinfo(2)
  if debugInfo.currentline < 0 then
    -- Function is called from hooked resource.
    print(("Caught someone trying to trigger '%s' through macho's hooking system!"):format(event))
    return
  end

  oTriggerEvent(event, ...)
end