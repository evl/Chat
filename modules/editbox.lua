local addonName, addon = ...
local config = addon.config

for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame" .. i .. "EditBox"]

	editBox:SetAltArrowKeyMode(false)

	if config.anchorEditBoxTop then
		editBox:ClearAllPoints()
		
		local frame = _G["ChatFrame" .. i]
		editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
		editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")	
	end
end
