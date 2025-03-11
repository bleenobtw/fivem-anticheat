/* Theory for protecting tables from lua execution. */

State = { first = "John", last = "Doe" }
Proxy = {}

function updateCharacter(key, value)
  /* Add checks to prevent this function from being called by a hooked resource. */
  local debugInfo = debug.getinfo(2)
  if
    debugInfo
    and debugInfo.currentline < 0
  then
    print("(Cheating)\tCharacter update function was called from a hooked resource.")
    return
  end

  State[key] = value
end

setmetatable(Proxy, {
  __index = State,
  __newindex = function(_, key, value)
    /* Get the debug information. */
    local debugInfo = debug.getinfo(2, "f")

    /* Prevent the state from being updated by functions other than `updateCharacter`. */
    if
      debugInfo
      and debugInfo.func == updateCharacter
    then
      rawset(State, key, value)
    else
      print("(Warning)\tAttempted to modify read-only table!")
    end
  end
})










print("hello?")

RegisterCommand("a", function(_, _, _)
  print(Proxy.first)
end)

RegisterCommand("b", function(_, a, _)
  if not a[1] then
    print("Please provide an arguement for the first name!")
    return
  end

  updateCharacter("first", a[1])
end)

/*
MachoInjectResource('dummy_resource', [[
  Proxy.first = "Jacob"
]])

MachoInjectResource('dummy_resource', [[
  updateCharacter("first", "Jacob")
]])
*/