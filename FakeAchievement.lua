--[[
	FakeAchievement

	Version: @project-version@
	Date:    @project-date-iso@
	Author:  @project-author@
]]

SlashCmdList["FAKEACHIEVEMENT"] = function(s)

	local day, month, year, aLink, name, id
	local a, b, c, d, e

	local myGuid = UnitGUID("target")
	local myName = UnitName("target")

	if (myGuid == nil) or (myGuid == "") then
		myGuid = UnitGUID("player")
		myName = UnitName("player")
	end

	myGuid = string.gsub(myGuid, '0x', '')

	for id, day, month, year in string.gmatch(s, "([0-9]+)%s+([0-9]+)/([0-9]+)/([0-9]+)") do
		_, name = GetAchievementInfo(id)
		if (name == nil) then
			return
		end

		DEFAULT_CHAT_FRAME:AddMessage("Achievement for "..myName..": |cffffff00|Hachievement:"..id..":"..myGuid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..name.."]|h|r")
		return
	end

	for a, b, c, d in string.gmatch(s, "(.+)%s+([0-9]+)/([0-9]+)/([0-9]+)") do
		aLink = a
		day   = b
		month = c
		year  = d
	end

	if (aLink == nil) then
		return
	end

	local aId, playerGuid, aDone, aMonth, aDay, aYear, aName
	local regexp = "|cffffff00|Hachievement:([0-9]+):(.+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+)|h%[([^]]+)%]|h|r"
	-- |cffffff00|Hachievement:1789:Player-3714-06447380:0:0:0:-1:0:0:0:0|h[Corvées journalières]|h|r,

	for aId, playerGuid, aDone, aMonth, aDay, aYear, _, _, _, _, aName in string.gmatch(aLink, regexp) do
		DEFAULT_CHAT_FRAME:AddMessage("Achievement for "..myName..": |cffffff00|Hachievement:"..aId..":"..myGuid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..aName.."]|h|r")
	end
end

SLASH_FAKEACHIEVEMENT1 = "/fa"