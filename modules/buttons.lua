local hide = function(self)
	self:Hide()
end

local buttons = {"UpButton", "DownButton", "BottomButton"}

for i = 1, NUM_CHAT_WINDOWS do
	for _, name in pairs(buttons) do
		button = _G["ChatFrame" .. i .. name]
		button:SetScript("OnShow", hide)
		button:Hide()
	end
end

ChatFrameMenuButton:SetScript("OnShow", hide)
ChatFrameMenuButton:Hide()
