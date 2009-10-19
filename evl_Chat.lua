-- All this crap was looted from else where (oChat, Chatter etc.)
local blacklist = {
	[ChatFrame2] = true,
}

local buttons = {"UpButton", "DownButton", "BottomButton"}
local stickyChannels = {"SAY", "YELL", "PARTY", "GUILD", "OFFICER", "RAID", "RAID_WARNING", "BATTLEGROUND", "WHISPER", "CHANNEL"}

local noop = function() end

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

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame" .. i]
	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", scroll)

	for k, button in pairs(buttons) do
		button = _G["ChatFrame" .. i .. button]
		button:Hide()
		button.Show = noop
	end

	if not blacklist[frame] then
		frame.AddMessage = AddMessage
	end
end

-- Menu
ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = noop

-- Edit Box
ChatFrameEditBox:SetAltArrowKeyMode(false)

-- Sticky
for k, channel in pairs(stickyChannels) do
	ChatTypeInfo[channel].sticky = 1
end

-- URL copy
local origSetItemRef = _G.SetItemRef
local currentLink
local urlStyle = "|cffffffff|Hurl:%1|h[%1]|h|r"
local urlPatterns = {
	"(http://%S+)", -- http://foo.com
	"(www%.%S+)", -- www.foo.com/whatever/index.php
	"(%d+%.%d+%.%d+%.%d+:?%d*)", -- 192.168.1.3, 192.3.4.5:43567
}

local messageTypes = {
	"CHAT_MSG_WHISPER", 
	"CHAT_MSG_GUILD", 
	"CHAT_MSG_PARTY"
}

local urlFilter = function(self, event, text, ...)
	for _, pattern in ipairs(urlPatterns) do
		local result, matches = string.gsub(text, pattern, urlStyle)

		if matches > 0 then
			return false, result, ...
		end
	end
end

for _, event in ipairs(messageTypes) do
	ChatFrame_AddMessageEventFilter(event, urlFilter)
end

local setItemRefHook = function(link, text, button)
	if link:sub(0, 3) == "url" then
		currentLink = link:sub(5)
		StaticPopup_Show("UrlCopyDialog")
		return
	end
	
	return origSetItemRef(link, text, button)
end

_G.SetItemRef = setItemRefHook

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