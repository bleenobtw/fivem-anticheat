- This repository serves as a brain dump of concepts to prevent players from exploiting and/or cheating on FiveM server(s).
- In its current state, this is quite literally a brain dump, with no particular structure. I am dumping ideas and concepts to prevent cheaters, but you should DYOR before attempting to implement these ideas into your own server code.

---

### NUI Developer Tools:

_The NUI developer tools are commonly used by cheaters to post malicious events to the server._

- Generic "NUI Blockers" seem to be very common on a lot of servers (even though they're not endorsed by FiveM's team). The idea is that when a player opens the NUI developer tools, it sends a request to the server informing it that they have done so.
- These can be very easily bypassed by cheaters. If an attacker knows what resource has the NUI blocker embedded into it, they can iterate through the DOM until they find the specific iframe (each resource has its own iframe within the DOM) and just delete it from the DOM.
- Another _more advanced_ way to bypass these "NUI Blockers" is to have a local WebSocket connection to the root of the DOM and send payloads (JavaScript code) through the WebSocket and evaluate it on the client—see my implementation of that [here](https://github.com/bleenobtw/fivem-nui-stealth)!
- To prevent the first bypass, you can simply implement a heartbeat into the resource, and if that heartbeat fails, then they've deleted the iframe from the DOM. (You have to be careful because if they're smart, they could fake these heartbeats or, after deleting the iframe, create their own from the DOM in its place without the "NUI Blocker Check.")
- They can also just hook the Message event, or fetch function and prevent it from sending, etc., etc.
- You could also implement your own DOM iteration and check if your blocker is still in the list of iframes. If it isn't, it's likely been deleted by them. You should check the JavaScript code during this to make sure they haven't modified it.
- Implementing an NUI Blocker inside of the loading screen is also a good idea since that's the only place an attacker can drop their code before your blocker iframe is loaded.
- Obfuscating your JavaScript code and hiding it in an inconspicuous resource (e.g., `assets_weapons` instead of `nui_blocker`) is also good practice. Although, if the attacker knows what they're looking for and your code isn't difficult to read through, they will likely find it.
- Ensure that you're validating and sanitizing all data that comes from the client (in the frontend, in the client and on the server); because the client can never be trusted.
- Simply validating the input _only on the frotnend_ is useless because they can bypass that validation by posting their own request. You must validate it on the server also. Other checks like level, rank & job requirements as well as rate limits and distance checks are also advisable.
- You yourself can also hook dom events and fetch functions. An example would be a progress bar resource, where you recieve a message event when it starts and post a message event when it's finished. If you take a timestamp of when it's started, and then hook the fetch function and compare the difference in time and it's not the time you expect, it's likely that they're posting the finished event themselves and it shouldn't be trusted. In which you can return in the finish request and wait for your own.
- In the websocket implementation I posted above, requests from the root DOM are blocked when trying to post from the context of a resource's iframe due to CORS. The way to get around this is to embed the fetch function into the resource. Periodic check of a resource's frontend code through a signature or just checking for foreign functions is smart to prevent them from doing this.
- Cheaters like to also register their own NUI callbacks using lua execution but you can also listen to the event that it calls internally and if it doesn't match an event, you know they're up to no good.

---

### Lua Execution

- `Localstate, exports, ox's lib.*` are all vulnerable to specific cheats that hijack the lua vm of the resource's they're used in. However when a resource is hijacked the code is placed on line 0, so you can simply check what line the function is being called from using `debug.getinfo()` and prevent this, see below;

```lua
local debugInfo = debug.getinfo(2)
if
  debugInfo
  and debugInfo.currentline < 0
then
  print("(Suspicious)\tFunction was called from a hooked resource.")
  return
end
```

- You can do the same with `TriggerEvent` if you overwrite it, see `archive/hook_patch/hook.lua` & `archive/dummy_resource/c_main.lua`
- An implementation of encrypting an event's name during runtime can also be seen in `archive/secure_events`
- Adding a unique event id to each event is also smart.
- Using routing bucket entity lockdown is smart to prevent clients from creating entitites.
- Otherwise use an entity whitelist with `entityCreating` & `entityCreated`.
- Use `onResourceStop` or heartbeats to prevent player's from stopping resoures.
- Use fivem's escrow system to keep your resources protected from being dumped.

---

Created by Trent/Bleeno: 11/03/2025  
Last Updated: 11/03/2025
