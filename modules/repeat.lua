local lastMessage
local repeatMessageFilter = function(self, event, text, sender, ...)
	if self.repeatFilter then
		if not self.repeatMessages or self.repeatCount > 100 then
			self.repeatCount = 0
			self.repeatMessages = {}
		end
		
		lastMessage = self.repeatMessages[sender]
		
		if lastMessage == text then
			return true
		end
		
		self.repeatMessages[sender] = text
		self.repeatCount = self.repeatCount + 1
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", repeatMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", repeatMessageFilter)
