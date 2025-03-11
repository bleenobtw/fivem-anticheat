/*
  - Event Key Encryption
  - Resource Hooking Protection
  - Payload Encryption

  TODO?:
    - Collect total lines for each script that uses this event system before the server starts-
    with a python script so that we can use it in our checks.
*/

/* Ensure that lua 5.4 is enabled before allowing to continue. */

local resourceId = GetCurrentResourceName()
local pendingCallbacks = {}

RegisterNetEvent(("se_%s"):format(resourceId), function(key, ...)
  local callback = pendingCallbacks[key]
  if not callback then
    return
  end

  pendingCallbacks[key] = nil
  callback(...)
end)

function Emit(event, ...)
  local key

  /* Prevent the function from being called through resource hooking. */
  local debugInfo = debug.getinfo(2)
  if debugInfo.currentline < 0 then
    print("This function was called from a hooked resource!")
    return
  end

  /* Encrypt the event id. */
  event = exports.secure_events:Encrypt(event)

  /* Generate a unique key for the event. */
  repeat
    key = ("%s:%s"):format(event, math.random(0, 100000))
  until not pendingCallbacks[key]

  TriggerServerEvent(("se_%s"):format(event), resourceId, key, ...)

  local promise = promise.new()

  pendingCallbacks[key] = function(response, ...)
    response = { response, ... }
    if promise then
      return promise:resolve(response)
    end
  end

  if promise then
    SetTimeout(30000, function()
      promise:reject(("Event '%s' timed out!"):format(key))
    end)

    return table.unpack(Citizen.Await(promise))
  end
end