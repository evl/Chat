ChatFrameEditBox:SetAltArrowKeyMode(false)

if evl_Chat.config.anchorEditBoxTop then
	ChatFrameEditBox:ClearAllPoints()
	ChatFrameEditBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT")
	ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT")	
end
