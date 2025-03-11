/* Ensure that lua 5.4 is enabled before allowing to continue. */

local resourceId = GetCurrentResourceName()
local pendingCallbacks = {}

local function callbackResponse(success, result, ...)
  if not success then
    if result then
      return print("There was an error during event callback - need to add a more descriptive error message..")
    end

    return false
  end

  return result, ...
end

function Listen(event, cb)
  event = exports.secure_events:Encrypt(event)

  RegisterNetEvent(("se_%s"):format(event), function(resource, key, ...)
    TriggerClientEvent(("se_%s"):format(resourceId), source, key, callbackResponse(pcall(cb, source, ...)))
  end)
end