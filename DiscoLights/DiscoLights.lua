-- Press Shift+F1 to display debug output in-game
print("Hello world, this is Disco Lights!")
local TileRenderer = require "necro.render.level.TileRenderer"
local ObjectEvents = require "necro.game.object.ObjectEvents"
local ecs = require "system.game.Entities"
local player = require "necro.game.character.Player"
local Visibility = require "necro.game.vision.Visibility"
local PlayableCharacters = require "necro.game.data.player.PlayableCharacters"
local Inventory = require "necro.game.item.Inventory"

event.entitySchemaLoadNamedEntity.add("addItemToCadence", "Cadence", function (ev)
    ev.entity.initialInventory.items[#ev.entity.initialInventory.items + 1] = "CharmNazar"
end)


event.visibility.add("discoCheck", {order = "healthBarVisibility", sequence = 1}, function(ev)
	for entity in ecs.entitiesWithComponents {"enemy"} do
		local playerEntity = player.getPlayerEntities()[1]
		if(((playerEntity.beatCounter.counter + entity.position.x + entity.position.y) % 2)==1) then
			entity.visibility.visible=false
		end
	end
end)
