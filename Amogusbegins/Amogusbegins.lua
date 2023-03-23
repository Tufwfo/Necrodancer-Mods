-- Press Shift+F1 to display debug output in-game
print("Hello world, this is Amogus begins!")
local customEntities = require "necro.game.data.CustomEntities"
local components = require "necro.game.data.Components"
local menu = require "necro.menu.Menu"
local customAction = require "necro.game.data.CustomActions"
local input = require "system.game.Input"
local renderUI = require "necro.cycles.RenderUI"
local timer = require "system.utils.Timer"
local affectorItem = require "necro.game.item.AffectorItem"
local action = require "necro.game.system.Action"
local inventory = require "necro.game.item.Inventory"
local object = require "necro.game.object.Object"
local color = require "system.utils.Color"
local tick = require "necro.cycles.Tick"

clickableCard = {}
cardSwipeStage = 1
card = {}
closemenu = false
greenLightVisible = false
redLightVisible = false
tooSlow = false
tooFast = false
badRead = false
scannerRed = {}
scannerGreen = {}
scannerTooSlow = {}
scannerTooFast = {}
scannerBadRead = {}
scannerCompleted = {}
event.menu.add("cardSwipeMenu", "Amogusbegins_cardSwipeMenu", function(ev)
	doneMoving = false
	resetTask = false
	greenLightVisible = false
	redLightVisible = false
	cardHasMoved = false
	tooSlow = false
	tooFast = false
	badRead = false
	local menu = {}
	local task = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/Card_Swipe.png",
		imageRect = {0, 0, 934, 935},
		width = 934 * 0.2,
		height = 935 * 0.2,
	}
	local cardIcon = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/Card.png",
		imageRect = {0, 0, 227, 138},
		width = 227 * 0.286,
		height = 138 * 0.286,
	}
	local wallet = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/wallet.png",
		imageRect = {0, 0, 889, 310},
		width = 889 * 0.2083,
		height = 310 * 0.2083,
	}
	local scanner = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/Card_Swipe_Top.png",
		imageRect = {0, 0, 929, 306},
		width = 929* 0.2,
		height = 306 * 0.2,
	}
	scannerGreen = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/GreenLight.png",
		imageRect = {0, 0, 73, 73},
		width = 73 * 0.17,
		height = 73 * 0.17,
	}
	scannerRed = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/RedLight.png",
		imageRect = {0, 0, 74, 74},
		width = 74 * 0.17,
		height = 74 * 0.17,
	}
	scannerTooSlow = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/TooSlowText.png",
		imageRect = {0, 0, 550, 55},
		width = 550 * 0.17,
		height = 55 * 0.17,
	}
	scannerTooFast = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/TooFastText.png",
		imageRect = {0, 0, 548, 59},
		width = 548 * 0.17,
		height = 59 * 0.17,
	}
	scannerBadRead = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/BadReadText.png",
		imageRect = {0, 0, 554, 60},
		width = 554 * 0.17,
		height = 60 * 0.17,
	}
	scannerCompleted = {
		image = "mods/Amogusbegins/TaskScreens/CardSwipe/CompletedText.png",
		imageRect = {0, 0, 579, 57},
		width = 579 * 0.17,
		height = 57 * 0.17,
		color = color.rgba(255,255,255,0)
	}
	clickableCard = {
		id = "cardSwipe",
		label = "        |",
		y = 220,
		x = -82,
    }
	card = {
		icon = cardIcon,
		x = -80,
		y = 243,
		sticky = true,
		action = function() end,
	}
	xDiff = card.x - -180
	yDiff = card.y - 30
	ev.menu = {
		escapeAction = function()
			cardSwipeStage = 1
			resetTask = false
			cardSwipeWon = false
			closemenu = true
		end,
		width = 300,
		entries = {
			clickableCard,
			{
				label = "boundary",
				y = 243,
			},
			{
				icon = task,
				y = 100,
				action = function() end,
			},
			card,
			{
				icon = wallet,
				x = 0.6,
				y = 221,
				sticky = true,
				action = function() end,
			},
			{
				icon = scanner,
				y = -24,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerGreen,
				x = 162,
				y = 13,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerRed,
				x = 131,
				y = 13,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerTooSlow,
				x = -60,
				y = -62,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerTooFast,
				x = -60,
				y = -62,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerBadRead,
				x = -60,
				y = -62,
				sticky = true,
				action = function() end,
			},
			{
				icon = scannerCompleted,
				x = -54,
				y = -62,
				sticky = true,
				action = function() end,
			},
		}
	}
		
	
end)

local closeMenuLater = tick.registerDelay(function ()
    menu.close()
	cardSwipeWon = false
	cardSwipeStage = 1
end, "closeMenu")

dragging = false
cardTimer=0
event.tick.add("checkClick", "debugKeys", function (ev)
	-- Click on card swipe
	if not(menu.getCurrent()==nil) then
		if menu.getCurrent().name=="Amogusbegins_cardSwipeMenu" then
			if input.mousePress(1) and input.mouseX()>clickableCard.textRect.x and cardSwipeStage == 1
			and input.mouseX()<clickableCard.textRect.x+clickableCard.textRect.width
			and input.mouseY()>clickableCard.textRect.y 
			and input.mouseY()<clickableCard.textRect.y+clickableCard.textRect.height then
				clickableCard.x = -180
				clickableCard.y = 35
				cardSwipeStage = 2
			end
			
			if input.mousePress(1) and input.mouseX()>clickableCard.textRect.x and cardSwipeStage == 2 and doneMoving
			and input.mouseX()<clickableCard.textRect.x+clickableCard.textRect.width
			and input.mouseY()>clickableCard.textRect.y 
			and input.mouseY()<clickableCard.textRect.y+clickableCard.textRect.height then
				cardTimer = timer.getGlobalTime()
				greenLightVisible=false
			end
			
			if input.mouseDown(1) and input.mouseX()>clickableCard.textRect.x and cardSwipeStage == 2 and doneMoving
			and input.mouseX()<clickableCard.textRect.x+clickableCard.textRect.width
			and input.mouseY()>clickableCard.textRect.y 
			and input.mouseY()<clickableCard.textRect.y+clickableCard.textRect.height then
				dragging = true
			else
				if cardSwipeStage==2 and doneMoving and not cardSwipeWon then
					resetTask = true
				end
				if not (input.mouseDown(1)) then
					dragging = false
				end
			end
			
			if cardSwipeWon then
				scannerCompleted.color = color.rgba(255,255,255,255)
				closeMenuLater(nil, 2)
			end
		end
	end
	
	
	if closemenu then
		menu.close()
		closemenu=false
	end
end)


xDiff=0
yDiff=0
doneMoving = false
resetTask = false
relativePosition=0
cardSwipeWon = false
cardHasMoved = false
setScannerText = false
event.renderUI.add("cardAnimate", "renderGame", function(ev)
	if (cardSwipeStage==2 and card.x > -180 and card.y > 30) then
		card.x = card.x - (xDiff/100)
		card.y = card.y - (yDiff/100)
		if card.x < -170 then
			doneMoving = true
			greenLightVisible = true
		end
	end
	if resetTask and card.x > -180 then
		if card.x == 170 and timer.getGlobalTime()-cardTimer>0.5 and timer.getGlobalTime()-cardTimer<1 then
			cardSwipeWon = true
			greenLightVisible = true
			local cardSwipe = affectorItem.getItem(interactor, "Amogusbegins_cardSwipe")
			if cardSwipe then
				object.convert(cardSwipe, "Amogusbegins_CardItemComplete")
			end
		elseif not cardSwipeWon and not dragging then
			card.x = card.x - (xDiff/30)
			if cardHasMoved then
				redLightVisible = true
				if not setScannerText then
					if card.x<165 then
						tooFast = false
						tooSlow = false
						badRead = true
						setScannerText = true
					elseif timer.getGlobalTime()-cardTimer<0.5  then
						tooFast = true
						tooSlow = false
						badRead = false
						setScannerText = true
					elseif timer.getGlobalTime()-cardTimer>1 then
						tooFast = false
						tooSlow = true
						badRead = false
						setScannerText = true
					end
				end
			end
		end
	end
	if dragging and doneMoving and card.x > -181 and card.x < 170 then
		if  relativePosition==0 then
			relativePosition = input.mouseX() - card.x
		end
		card.x = input.mouseX() - relativePosition
		redLightVisible = false
		cardHasMoved = true
		setScannerText = false
	end
	if dragging and doneMoving and (card.x < -181 or card.x > 170) then
		if card.x < -181 then
			card.x=-180
		else
			card.x=170
		end
	end
	
	if cardHasMoved and not cardSwipeWon then
		greenLightVisible = false
	end
	if greenLightVisible then
		scannerGreen.color = color.rgba(255,255,255,255)
	else
		scannerGreen.color = color.rgba(255,255,255,0)
	end
	if redLightVisible then
		scannerRed.color = color.rgba(255,255,255,255)
	else
		scannerRed.color = color.rgba(255,255,255,0)
	end
	if tooSlow then
		scannerTooSlow.color = color.rgba(255,255,255,255)
	else
		scannerTooSlow.color = color.rgba(255,255,255,0)
	end
	if tooFast then
		scannerTooFast.color = color.rgba(255,255,255,255)
	else
		scannerTooFast.color = color.rgba(255,255,255,0)
	end
	if badRead then
		scannerBadRead.color = color.rgba(255,255,255,255)
	else
		scannerBadRead.color = color.rgba(255,255,255,0)
	end
end)

interactor=nil
event.objectInteract.add("cardSwipeTask", {order = "consumeItem", filter = "Amogusbegins_cardSwipe"}, function(ev)
	if not (affectorItem.entityHasItem(ev.interactor, "Amogusbegins_cardSwipe")) then
		ev.suppressed = true
	else 
		interactor = ev.interactor
		menu.open("Amogusbegins_cardSwipeMenu")
	end
end)

components.register {
	Amogusbegins_cardSwipe = {},
	Amogusbegins_taskItem = {},
}



customEntities.extend{
	name = "ShrineTaskCardSwipe",
	template = customEntities.template.enemy(),
	components = {
		sprite = {
		texture = "mods/Amogusbegins/TaskScreens/CardSwipe/Card_Swipe_Sprite.png",
		},
		friendlyName = {
			name = "Card Swipe"
		},
		collision = {
			mask = 2
		},
		attackable = {flags = 16},
		interactable = {},
		interactableNegateLowPercent = {},
		shrine = {
			name = "task",
		},
		storage = {},
		Amogusbegins_cardSwipe = {},
	},
}

customEntities.extend{
	name = "CardItem",
	template = customEntities.template.item(),
	data = {
		slot = "misc",
	},
	components = {
		sprite = {
			texture = "mods/Amogusbegins/TaskScreens/CardSwipe/CardItem.png",
			width = 24,
			height = 15,
		},
		Amogusbegins_cardSwipe = {},
	}
}

customEntities.extend{
	name = "CardItemComplete",
	template = customEntities.template.item(),
	data = {
		slot = "misc",
	},
	components = {
		sprite = {
			texture = "mods/Amogusbegins/TaskScreens/CardSwipe/CardItemComplete.png",
			width = 24,
			height = 15,
		},
	}
}