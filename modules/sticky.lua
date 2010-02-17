local stickyChannels = {"SAY", "YELL", "PARTY", "GUILD", "OFFICER", "RAID", "RAID_WARNING", "BATTLEGROUND", "WHISPER", "CHANNEL"}

for k, channel in pairs(stickyChannels) do
	ChatTypeInfo[channel].sticky = 1
end
