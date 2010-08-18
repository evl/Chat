local addonName, addon = ...
local config = addon.config

for i = 1, NUM_CHAT_WINDOWS do
	local prefix = "ChatFrame" .. i
	local editBox = _G[prefix .. "EditBox"]

	editBox:SetAltArrowKeyMode(false)

	if config.anchorEditBoxTop then
		editBox:ClearAllPoints()
		
		local frame = _G[prefix]
		editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
		editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")
	end
	
	if config.hideEditBoxBackground then
		_G[prefix .. "EditBoxLeft"]:Hide()
		_G[prefix .. "EditBoxMid"]:Hide()
		_G[prefix .. "EditBoxRight"]:Hide()		
	end
	
	if config.hideEditBoxFocus then
		_G[prefix .. "EditBoxFocusLeft"]:SetTexture(nil)
		_G[prefix .. "EditBoxFocusMid"]:SetTexture(nil)
		_G[prefix .. "EditBoxFocusRight"]:SetTexture(nil)		
	end
end
