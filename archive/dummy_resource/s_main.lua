Listen("example:getCharacter", function(source, characterId)
  /* Check the character id. */
  if characterId ~= 69420 then
    return nil, "The character's id wasn't correct!"
  end

  return {
    firstName = "John",
    lastName = "Doe",
    isDead = false
  }, nil
end)