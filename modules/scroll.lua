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
end