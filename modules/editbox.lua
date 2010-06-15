local addonName, addon = ...

ChatFrameEditBox:SetAltArrowKeyMode(false)

if addon.config.anchorEditBoxTop then
	ChatFrameEditBox:ClearAllPoints()
	ChatFrameEditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT")
	ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT")	
end
