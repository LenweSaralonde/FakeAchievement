--[[
	FakeAchievement

	Version: @project-version@
	Date:    @project-date-iso@
	Author:  @project-author@
]]

--- Display a message in the console
-- @param msg (string)
function FakeAchievement_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

--- Display an error message in the console
-- @param msg (string)
function FakeAchievement_Error(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	PlaySound(32051)
end

--- Get achievement link
-- @param name (string) Achievement name
-- @param id (string) Achievement ID
-- @param guid (string) Player GUID
-- @param day (int) Day
-- @param month (int) Month
-- @param year (int) Year
-- @return link (string)
function FakeAchievement_GetLink(name, id, guid, day, month, year)
	id = tonumber(id, 10)
	day = tonumber(day, 10)
	month = tonumber(month, 10)
	year = tonumber(year, 10) % 100

	return "|cffffff00|Hachievement:"..id..":"..guid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..name.."]|h|r"
end

--- Extract achievement ID and name from link
-- @param link (string) Achievement link or ID
-- @return id (string) Achievement ID
-- @return name (string) Achievement name
function FakeAchievement_ExtractAchievement(link)
	-- Extract achievement link from string
	-- |cffffff00|Hachievement:1789:Player-3714-06447380:0:0:0:-1:0:0:0:0|h[Corvées journalières]|h|r,
	local id, name
	local regexp = "|cffffff00|Hachievement:([0-9]+):(.+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+)|h%[([^]]+)%]|h|r"
	for id, _, _, _, _, _, _, _, _, _, name in string.gmatch(link, regexp) do
		return id, name
	end

	-- Link not found: search by ID
	id = tonumber(link, 10)
	_, name = GetAchievementInfo(id)
	if name ~= nil then
		return id, name
	end

	-- Invalid achievement
	return nil, nil
end

--- Display help
--
function FakeAchievement_Help()
	FakeAchievement_Print("FakeAchievement usage:")
	FakeAchievement_Print("|cFFFFFFFF/fa <achievement link or ID> <day>/<month>/<year>|r")
	FakeAchievement_Print("|cFFFFFFFF<achievement link or ID>|r: Achievement link (Shift+click on achievement from achievement list) or achievement ID (from WoWHead URL).")
	FakeAchievement_Print("|cFFFFFFFF<day>|r/|cFFFFFFFF<month>|r/|cFFFFFFFF<year>|r: Achievement date.")

	local id, name = FakeAchievement_ExtractAchievement(14068)
	local example1 = "|cFFFFFFFF/fa 14068 15/4/2020|r"
	local example2 = "|cFFFFFFFF/fa|r |cffffff00|Hachievement:14068:" .. string.gsub(UnitGUID('player'), '0x', '') .. ":0:0:0:-1:0:0:0:0|h[" .. name .. "]|h|r |cFFFFFFFF15/4/2020|r"

	FakeAchievement_Print("Example: \n" .. example1 .. "\n" .. example2)
end

--- Main /fa command
-- Example: /fa 4999 8/12/10
-- @param s (string)
SlashCmdList["FAKEACHIEVEMENT"] = function(s)
	local success = pcall(function()
		-- Get achievement target
		local targetGuid = UnitGUID('target')
		local targetName = UnitName('target')

		if targetGuid == nil or targetGuid == "" then
			targetGuid = UnitGUID('player')
			targetName = UnitName('player')
		elseif not(UnitIsPlayer("target")) then
			FakeAchievement_Error("The targeted unit |cFFFFFFFF" .. targetName .. "|r is not a player.")
			return
		end

		targetGuid = string.gsub(targetGuid, '0x', '')

		-- Extract fake achievement parameters
		local day, month, year, link
		local a, b, c, d, e

		for a, b, c, d in string.gmatch(s, "(.+)%s+([0-9]+)/([0-9]+)/([0-9]+)") do
			link = a
			day   = b
			month = c
			year  = d
		end

		-- Invalid parameters provided: display help
		if not(link) or not(day) or not(month) or not(year) then
			FakeAchievement_Help()
			return
		end

		-- Extract achievement name and ID
		local id, name = FakeAchievement_ExtractAchievement(link)

		-- Achievement not found
		if not(id) then
			FakeAchievement_Error("Invalid achievement ID or link.")
			return
		end

		-- Display faked achievement link in the console
		local playerLink = "|cFFFFFFFF|Hplayer:" .. targetName .. "|h" .. targetName .. "|h|r"
		local achievementLink = FakeAchievement_GetLink(name, id, targetGuid, day, month, year)
		FakeAchievement_Print("Achievement for " .. playerLink .. ": " .. achievementLink)
	end)

	if not(success) then
		FakeAchievement_Help()
	end
end

SLASH_FAKEACHIEVEMENT1 = "/fa"