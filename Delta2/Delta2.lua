-- Press Shift+F1 to display debug output in-game
print("Hello world, this is Delta 2!")
local TimeScale = require "necro.audio.TimeScale"
local Turn = require "necro.cycles.Turn"
local music = require "necro.audio.Music"
local currentLevel = require "necro.game.level.CurrentLevel"
local InstantReplay = require "necro.client.replay.InstantReplay"

scale=1
bps=1
event.levelLoad.add("SetScale", {order = "music", sequence = 1}, function (ev)
	if(currentLevel.getNumber()~=1) then
	local newBps = 1 / (music.getBeatmap()[2] - music.getBeatmap()[1])
    TimeScale.addInfiniteRegion(0, bps / newBps * scale, 0)
	end
end)

event.turn.add("SetDeltaSpeed", {order = "missedBeat", sequence = 1}, function (ev)
	if not InstantReplay.isActive() then
		TimeScale.addInfiniteRegion(Turn.getRawTimestamp(), 1.000888, 0)
	end
end)

event.levelComplete.add("GetDeltaSpeed", {order = "dad", sequence = 1}, function (ev)
	scale=select(2, TimeScale.getTimeAndScale(Turn.getRawTimestamp(Turn.getCurrentTurnID())))
	bps=1/(music.getBeatmap()[2]-music.getBeatmap()[1])
end)

event.gameStateReset.add("ResetScale", {order = "runSummary", sequence=1}, function (ev)
	scale=1
	bps=1
end)