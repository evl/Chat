local gsub = _G.string.gsub
local find = _G.string.find

local incomingLinkPattern = "{CLINK:"
local incomingLinkFilter = function(self, event, text, ...)
	if find(text, incomingLinkPattern) then
		text = gsub(text, "{CLINK:(%x+):([%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:achievement:(%x+):(%-?%d-:%-?%x-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-):([^}]-)}", "|c%1|Hachievement:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:enchant:(%x+):([%d-]-):([^}]-)}", "|c%1|Henchant:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:glyph:(%x+):([%d-]-:[%d-]-):([^}]-)}", "|c%1|Hglyph:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:item:(%x+):([%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-:[%d-]-):([^}]-)}", "|c%1|Hitem:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:quest:(%x+):([%d-]-):([%d-]-):([^}]-)}", "|c%1|Hquest:%2:%3|h[%4]|h|r")
		text = gsub(text, "{CLINK:spell:(%x+):([%d-]-):([^}]-)}", "|c%1|Hspell:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:talent:(%x+):([%d-]-:[%d-]-):([^}]-)}", "|c%1|Htalent:%2|h[%3]|h|r")
		text = gsub(text, "{CLINK:trade:(%x+):(%-?%d-:%-?%d-:.*:.*):([^}]-)}", "|c%1|Htrade:%2|h[%3]|h|r")
		
		return false, text, ...
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", incomingLinkFilter)

local origSendChatMessage = _G.SendChatMessage
local SendChatMessageHook = function(text, chatType, ...)
	if text and chatType == "CHANNEL" then
		text = gsub(text, "|c(%x+)|H(achievement):([0-9A-F:-]+)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		text = gsub(text, "|c(%x+)|H(enchant):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		text = gsub(text, "|c(%x+)|H(glyph):(%-?%d-:%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		text = gsub(text, "|c(%x+)|H(item):(%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-:%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		text = gsub(text, "|c(%x+)|H(quest):(%-?%d-):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4:%5}")
		text = gsub(text, "|c(%x+)|H(spell):(%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")	
		text = gsub(text, "|c(%x+)|H(talent):(%-?%d-:%-?%d-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
		text = gsub(text, "|c(%x+)|H(trade):(%-?%d-:%-?%d-:%-?%d-:.-:.-)|h%[([^%]]-)%]|h|r", "{CLINK:%2:%1:%3:%4}")
	end
	
	origSendChatMessage(text, chatType, ...)
end

SendChatMessage = SendChatMessageHook
