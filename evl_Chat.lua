-- All this crap was looted from else where (oChat, Chatter etc.)
local buttons = {"UpButton", "DownButton", "BottomButton"}
local stickyChannels = {"SAY", "YELL", "PARTY", "GUILD", "OFFICER", "RAID", "RAID_WARNING", "BATTLEGROUND", "WHISPER", "CHANNEL"}

local gsub = _G.string.gsub
local find = _G.string.find

-- Buttons
local scroll = function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown()  then
			self:ScrollToTop()
		else
			self:ScrollUp()
			self:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end

local hide = function(self)
	self:Hide()
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame" .. i]
	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", scroll)

	for k, button in pairs(buttons) do
		button = _G["ChatFrame" .. i .. button]
		button:SetScript("OnShow", hide)
		button:Hide()
	end
end

-- Menu
ChatFrameMenuButton:SetScript("OnShow", hide)
ChatFrameMenuButton:Hide()

-- Edit Box
ChatFrameEditBox:SetAltArrowKeyMode(false)

-- Sticky
for k, channel in pairs(stickyChannels) do
	ChatTypeInfo[channel].sticky = 1
end

-- URL links
local origSetItemRef = _G.SetItemRef
local currentLink
local urlStyle = "|cffffffff|Hurl:%1|h[%1]|h|r"
local urlPatterns = {
	"(http://%S+)", -- http://foo.com
	"(www%.%S+)", -- www.foo.com/whatever/index.php
	"(%d+%.%d+%.%d+%.%d+:?%d*)", -- 192.168.1.3, 192.3.4.5:43567
}

local messageTypes = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_RAID",
	"CHAT_MSG_WHISPER",
}

local urlFilter = function(self, event, text, ...)
	for _, pattern in ipairs(urlPatterns) do
		local result, matches = gsub(text, pattern, urlStyle)

		if matches > 0 then
			return false, result, ...
		end
	end
end

for _, event in ipairs(messageTypes) do
	ChatFrame_AddMessageEventFilter(event, urlFilter)
end

local SetItemRefHook = function(link, text, button)
	if link:sub(0, 3) == "url" then
		currentLink = link:sub(5)
		StaticPopup_Show("UrlCopyDialog")
		return
	end
	
	return origSetItemRef(link, text, button)
end

--hooksecurefunc(SetItemRef, SetItemRefHook)
SetItemRef = SetItemRefHook

StaticPopupDialogs["UrlCopyDialog"] = {
	text = "URL",
	button2 = TEXT(CLOSE),
	hasEditBox = 1,
	hasWideEditBox = 1,
	OnShow = function()
		local editBox = _G[this:GetName() .. "WideEditBox"]
		if editBox then
			editBox:SetText(currentLink)
			editBox:SetFocus()
			editBox:HighlightText(0)
		end
		local button = _G[this:GetName() .. "Button2"]
		if button then
			button:ClearAllPoints()
			button:SetWidth(200)
			button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
		end
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

-- Game object links
local origSendChatMessage = _G.SendChatMessage
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

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", incomingLinkFilter)
SendChatMessage = SendChatMessageHook