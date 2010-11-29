local addonName, addon = ...
local config = addon.config

local function updateEditBox(frame)
	local editBox = frame.editBox
	editBox:SetAltArrowKeyMode(false)

	if config.anchorEditBoxTop then
		editBox:ClearAllPoints()
		editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
		editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")
	end
	
	if config.hideEditBoxBackground then
		local name = editBox:GetName()
		
		_G[name .. "Left"]:Hide()
		_G[name .. "Mid"]:Hide()
		_G[name .. "Right"]:Hide()		
	end
	
	if config.hideEditBoxFocus then
		editBox.focusLeft:SetTexture(nil)
		editBox.focusMid:SetTexture(nil)
		editBox.focusRight:SetTexture(nil)
	end	
end

for i = 1, NUM_CHAT_WINDOWS do
	updateEditBox(_G["ChatFrame" .. i])
end
