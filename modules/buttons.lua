local addonName, addon = ...
local config = addon.config

local hide = function(self)
	self:Hide()
end

local hideButton = function(button)
	button:SetScript("OnShow", hide)
	button:Hide()
end

if config.hideNavigationButtons then
	local buttons = {"UpButton", "DownButton", "BottomButton"}

	for i = 1, NUM_CHAT_WINDOWS do
		for _, name in pairs(buttons) do
			local button = _G["ChatFrame" .. i .. "ButtonFrame" .. name]
			hideButton(button)
		end
	end
end

if config.hideMenuButton then
	hideButton(ChatFrameMenuButton)
end

if config.hideSocialButton then
	hideButton(FriendsMicroButton)
end
