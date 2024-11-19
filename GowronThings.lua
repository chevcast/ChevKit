function GowronAnnounce(msg, emote)
	local targetName = UnitName("target")
	local chatType

	if targetName and CheckInteractDistance("target", 3) then
		chatType = "YELL"
	elseif IsInInstance() then
		chatType = "INSTANCE_CHAT"
	else
		chatType = "PARTY"
	end

	if string.find(msg, "%%s") then
		if targetName then
			SendChatMessage(string.format(msg, string.upper(targetName)), chatType)
		else
			SendChatMessage("Error: No target selected for message.", chatType)
		end
	else
		SendChatMessage(msg, chatType)
	end

	if emote then
		if string.find(emote, "%%s") then
			if targetName then
				SendChatMessage(string.format(emote, string.upper(targetName)), "EMOTE")
			else
				SendChatMessage("Error: No target selected for emote.", "EMOTE")
			end
		else
			SendChatMessage(emote, "EMOTE")
		end
	end
end
