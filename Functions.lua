local chevFrame = CreateFrame("FRAME", "ChevFrame");
local characterName = string.lower(UnitName("player"));
local accountName = select(2, BNGetInfo());
local faction = string.lower(UnitFactionGroup("player"));

C_ChatInfo.RegisterAddonMessagePrefix("ChevKit");

chevFrame:RegisterEvent("CHAT_MSG_SAY");
chevFrame:RegisterEvent("CHAT_MSG_YELL");
chevFrame:RegisterEvent("CHAT_MSG_PARTY");
chevFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER");
chevFrame:RegisterEvent("CHAT_MSG_RAID");
chevFrame:RegisterEvent("CHAT_MSG_RAID_LEADER");
chevFrame:RegisterEvent("CHAT_MSG_RAID_WARNING");
chevFrame:RegisterEvent("CHAT_MSG_GUILD");
chevFrame:RegisterEvent("CHAT_MSG_WHISPER");
chevFrame:RegisterEvent("CHAT_MSG_BN_WHISPER");
chevFrame:RegisterEvent("CHAT_MSG_EMOTE");
chevFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
chevFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL");
chevFrame:RegisterEvent("CHAT_MSG_INSTANCE_CHAT");
chevFrame:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER");
chevFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
chevFrame:RegisterEvent("CHAT_MSG_ADDON");

local spamTimer = false;

local EventHandlers = {

  CHAT_MSG_ADDON = function (prefix, message, type, sender)
    if (prefix == "ChevKit") then
      local target, cmd = string.match(message, "^(.+):(.+)$");
      if (target == characterName or target == "all") then
        DEFAULT_CHAT_FRAME.editBox:SetText(cmd);
        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0);
      end
    end
  end,

  PLAYER_ENTERING_WORLD = function ()
    if (accountName == "Chev#1231" or accountName == "Mei#12422") then
      local isInstance, instanceType = IsInInstance();
      if (isInstance and instanceType == "pvp") then
        toggleNameplates("ALL");
      else
        toggleNameplates("BLIZZARD");
      end
    end
  end,

  CHAT_MSG_ = function (msg, author, ...)
    local name, cmd, args = string.match(msg, "^[hH][eE][yY] ([a-zA-Z]+),? ([^ !\.\?]+) ?([^!\.\?]*).*$");
    if (cmd == nil) then
      name, cmd, args = string.match(msg, "^([a-zA-Z]+),? ([^ !\.\?]+) ?([^!\.\?]*).*$");
    end

    author = string.match(author, "^([a-zA-Z]+)-");

    if (cmd ~= nil and (string.lower(name) == characterName or string.lower(name) == "all")) then
      cmd = string.lower(cmd);
      if (cmd == "cluck") then
        cmd = "chicken";
      end
      print("Command '" .. cmd .. "' received from '" .. author .. "'.");
      if (cmd == "say") then
        SendChatMessage(args, "SAY");
      elseif (cmd == "yell") then
        SendChatMessage(args, "YELL");
      elseif (cmd == "emote") then
        SendChatMessage(args, "EMOTE");
      elseif (cmd == "tell" and (string.lower(args) == "a joke" or string.lower(args) == "me a joke")) then
        DoEmote('joke', author);
      elseif (cmd == "summon") then
        if (string.lower(args) == "a random mount") then
          CallCompanion("MOUNT", random(GetNumCompanions("MOUNT")));
        elseif (string.lower(args) == "a random pet") then
          C_PetJournal.SummonRandomPet();
        end
      elseif (cmd == "dismount") then
        Dismount();
      elseif (cmd == "follow") then
        FollowUnit(author);
      else
        DoEmote(cmd, author);
      end
    elseif (string.match(string.lower(msg), "for the horde" or string.match(string.lower(msg), "for d[ae] horde")) and faction == "horde") then
      if not spamTimer then
        DoEmote("forthehorde");
        spamTimer = true;
        C_Timer.After(15, function ()
          spamTimer = false;
        end);
      end
    elseif (string.match(string.lower(msg), "for the alliance" or string.match(string.lower(msg), "for d[ae] alliance")) and faction == "alliance") then
      if not spamTimer then
        DoEmote("forthealliance");
        spamTimer = true;
        C_Timer.After(15, function ()
          spamTimer = false;
        end);
      end
    end
  end

};

local function eventHandler(self, event, ...)
  if (string.match(event, "^CHAT_MSG_") and event ~= "CHAT_MSG_ADDON") then
    EventHandlers.CHAT_MSG_(...);
  elseif (EventHandlers[event] ~= nil) then
    EventHandlers[event](...);
  end
end
chevFrame:SetScript("OnEvent", eventHandler);


function toggleNameplates(displayStyle)
  local E = unpack(ElvUI);
  local NP = E:GetModule('NamePlates');
  local ds = E.db.nameplates.displayStyle;
  if (displayStyle == nil) then
    if ds == "ALL" then
      ds = "BLIZZARD";
    elseif ds == "BLIZZARD" then
      ds = "ALL";
    end
  else
    ds = displayStyle;
  end
  E.db.nameplates.displayStyle = ds;
  NP:ConfigureAll();
  print("Nameplates set to: " .. ds);
end