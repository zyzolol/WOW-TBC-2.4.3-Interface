local ipairs = _G.ipairs
local fnd = _G.string.find
local lower = _G.string.lower
local rep = _G.strreplace

local triggers = {
	--Random/Art
	"^%.o+%.$", --[.ooooO Ooooo.]
	"%(only%d+%.?%d*eur?o?s?%)",
	"%+%=+%+",
	"gold%�%=%�power",
	"%+%=%@%-%=%@%-%+",
	"^www$",
	"^%.com$",
	"^\92%(only%d+%.?%d*pounds%)%/$",
	"^\92%_%)for%d+g%(%_%/$",
	"^$",

	--Phrases
	"%d+%.?%d*pounds?[/\92=]?p?e?r?%d%d%d+g",
	"%d+%.?%d*eur?o?s?[/\92=]?p?e?r?%d%d%d+",
	"%d+%.?%d*dollars?[/\92=]?p?e?r?%d%d%d+g",
	"gold.*power%-?le?ve?l",
	"%d+%.?%d*%l*forle?ve?l%d+%-%d+",
	"%d+go?l?d?[/\92=]%d+[%-%.]?%d*eu",
	"%d+g?o?l?d?s?[/\92=]%d+%.?%d*usd",
	"%d+go?l?d?[/\92=]%d+%.?%d*[\194\165\194\163%$\226\130\172]",
	"[\194\165\194\163%$\226\130\172]%d+%.?%d*[/\92=]%d+g",
	"%d+%.?%d*usd[/\92=]%d+g",
	"%d+%.%d+gbp[/\92=]%d%d%d+",
	"%d+%.%d+[/\92=]%d%d%d+g",
	"%d+go?l?d?[/\92=]eur?%d+",
	"%d+g%l*ab%d+%.?%d*eu", --deDE
	"%d+g%l*only%d+%.?%d*[\194\165\194\163%$\226\130\172]",
	"%d+g%l*for[\194\165\194\163%$\226\130\172]%d+",
	"%d+g%l*only%d+%.?%d*eu",
	"%d+g%l*only%d+%.?%d*usd",
	"%d+go?l?d?[/\92=][\194\165\194\163%$\226\130\172]%d+",
	"gold.*%d+[/\92=]%d+%.?%d*eu",
	"gold.*%d+%.%d%dper%d+g",
	"%d+%.?%d*per%d%d%d+g.*gold",
	"only%d+[\194\165\194\163%$\226\130\172]for%d%d%d+g.*safe", --fast delivery, safe trade
	"gold.*[\194\165\194\163%$\226\130\172]%d+%.?%d*per%l*%d%d%d+g", --deliver
	"gold.*%d+%.?%d*[\194\165\194\163%$\226\130\172][/\92=]%d%d%d+g",
	"gold.*cheap.*safe",
	"company.*%d+.*gold.*buysome",

	--URL's
	"15freelevels%.c", --26 July 08 ##
	"2joygame%.c", --18 May 08 ## (deDE)
	"5uneed%.c", --6 June 08 ##
	"925fancy%.c", --20 May 08 ##
	"beatwow%.c", --14 June 08 ##
	"cfsgold%.c", --20 May 08 ## (deDE)
	"cwowgold%.c", --13 June 08 ##
	"cheapleveling%.c", --28 May 08 ##
	"dewowgold%.c", --26 April 08 ~~
	"fast70%.c", --27 April 08 ~~
	"fastgg%.c", --20 May 08 ##
	"games%-level%.n+e+t", --9May 08 ~~
	"get%-levels%.c", --29 April 08 ~~
	"god%-moddot", --25 April 08 god-mod DOT com ~~
	"gold4guild", --9 May 08 .com ##
	"happygolds%.", --08 July 08 ## (com)
	"helpgolds%.c", --14 July 08 ## (deDE)
	"kgsgold", --16 May 08 .com ##
	"klanexecute%.dk", --29 June 08 ##
	"mmobusiness%.c", --04 August 08 ##
	"mmowned%(dot%)c", --21 May 08 ##
	"pkpkg%.c", --17 June 08 ##
	"pvp365%.c", --21 May 08 ## (frFR)
	"rollhack%.c", --5 July 08 ##
	"sevengold%.c", --24 May 08 ##
	"ssegames%.c", --20 July 08 ##
	"supplier2008%.c", --30 May 08 forward tradewowgold ##
	"torchgame%.c", --16 June 08 ## (deDE)
	"tpsale", --2 June 08 .com ##
	"upgold%.net", --10 June 08 ##
	"vovgold%.c", --22 May 08 ##
	"worldofwarcraf%l?hacks%.net", --28 June 08 ##
	"wow7gold%.c", --29 May 08 ##
	"wow%-?hackers%.c", --5 May 08 forward god-mod | wow-hackers / wowhackers ~~
	"wowgamelife", --14 July 08 ##
	"wowgold%-de%.c", --16 August 08 ##
	"wowhax%.c", --5 May 08 ~~
	"wowplayer%.de", --11 May 08 ~~
	"wowseller%.c", --25 May 08 ##
	"wowsogood%.c", --20 July 08 ##
	"yesdaq%.", --16 June 08 ##
}

local info, prev, savedID, result = _G.COMPLAINT_ADDED, 0, 0, nil
local function filter(msg)
	if arg11 == savedID then return result else savedID = arg11 end --to work around a blizz bug
	if not _G.CanComplainChat(savedID) then result = nil return end
	msg = lower(msg)
	msg = rep(msg, " ", "")
	msg = rep(msg, ",", ".")
	for k, v in ipairs(triggers) do
		if fnd(msg, v) then
			--ChatFrame1:AddMessage("|cFF33FF99BadBoy|r: "..v.." - "..msg) --Debug
			local time = GetTime()
			if k > 10 and (time - prev) > 20 then
				prev = time
				if not _G.BADBOY_POPUP then
					_G.COMPLAINT_ADDED = "|cFF33FF99BadBoy|r: " .. info .. " ("..arg2..")"
					ComplainChat(savedID)
				else
					local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", arg2)
					if dialog then
						dialog.data = savedID
					end
				end
			end
			result = true
			return true
		end
	end
	result = nil
end
local bb = CreateFrame("Frame", "BadBoy")
bb:SetScript("OnEvent", function() _G.COMPLAINT_ADDED = info end)
bb:RegisterEvent("CHAT_MSG_SYSTEM")

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
SetCVar("spamFilter", 1)
