-- basic 'bot mall'
-- iterates through every recipe
-- creates a setup of an assembler with the recipe set, a requester and a provider chest, an inserter in and an inserter out of assembler, and a medium power pole
-- sets the logistic requests on the requester chest to the product's ingredients * 10
--
-- this handles everything that can be made in an assembler without needing fluid (except science packs and wooden chests). it does not handle any centrifuging, chemistry, or rocket parts.

local items = 31
local pos = {}
local n = 0
local x = 0
local total = 0
local surface = game.player.surface
local ings = {}
pos.start = {x = game.player.position.x+3, y = game.player.position.y}
for _, recipe in pairs(game.player.force.recipes) do
ings = {}
i=0
if recipe.category ~= "chemistry" and recipe.category ~= "centrifuging" and recipe.category ~= "smelting" and recipe.category ~= "oil-processing" and recipe.category ~= "crafting-with-fluid" and recipe.enabled == true and not string.find(recipe.name, "science-pack", 1, true) and not string.find(recipe.name, "small-electric-pole", 1, true) and not string.find(recipe.name, "wooden-chest", 1, true) and not string.find(recipe.name, "rocket-part", 1, true) then
n=n+1
x=x+1
recipename = recipe.name
pos.provider = {pos.start.x+1, pos.start.y}
pos.inserterprovider = {pos.start.x+2, pos.start.y}
pos.requester = {pos.start.x+1, pos.start.y+2}
pos.inserterrequester = {pos.start.x+2, pos.start.y+2}
pos.assembler = {pos.start.x+4, pos.start.y+1}
pos.mediumpole = {pos.start.x+2, pos.start.y+1}

for __, ingredient in pairs(recipe.ingredients) do
i=i+1
ings[i] = {index = i, name = ingredient.name, count = ingredient.amount*10}
end

surface.create_entity{name = "logistic-chest-passive-provider", position = pos.provider, force = game.forces.player, bar = 4}
surface.create_entity{name = "stack-inserter", position = pos.inserterprovider, direction = defines.direction.east, force = game.forces.player}
surface.create_entity{name = "logistic-chest-requester", position = pos.requester, force = game.forces.player, request_filters = ings}
surface.create_entity{name = "stack-inserter", position = pos.inserterrequester, direction = defines.direction.west, force = game.forces.player}
surface.create_entity{name = "assembling-machine-3", position = pos.assembler, direction = defines.direction.east, force = game.forces.player, recipe = recipe.name}
if x == 2 then
surface.create_entity{name = "medium-electric-pole", position = pos.mediumpole, force = game.forces.player}
x=0
end

pos.start.y = pos.start.y+3
if n == items then
pos.start.x = pos.start.x+7
pos.start.y = pos.start.y-items*3
n=0
x=0
end
total = total+1
end
end
game.player.print("Total: " .. total)
