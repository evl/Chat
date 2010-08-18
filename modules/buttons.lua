local addonName, addon = ...
local config = addon.config

local hideButton = function(button)
	button:SetScript("OnShow", button.Hide)
	button:Hide()
end

local updateBottomButton = function(frame)
	local button = frame.buttonFrame.bottomButton

	if frame:AtBottom() then
		button:Hide()
	else
		button:Show()
	end
end

local bottomButtonClick = function(button)
	PlaySound("igChatBottom")
	
	local frame = button:GetParent()
	frame:ScrollToBottom()

	updateBottomButton(frame)
end

if config.hideNavigationButtons then
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame" .. i]
		frame:HookScript("OnShow", updateBottomButton)
		frame.buttonFrame:Hide()
		
		local bottom = frame.buttonFrame.bottomButton
		bottom:SetParent(frame)
		bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
		bottom:SetScript("OnClick", bottomButtonClick)
		bottom:SetAlpha(0.6)

		updateBottomButton(frame)
	end
	
	hooksecurefunc("FloatingChatFrame_OnMouseScroll", updateBottomButton)
end

if config.hideMenuButton then
	hideButton(ChatFrameMenuButton)
end

if config.hideSocialButton then
	hideButton(FriendsMicroButton)
end
