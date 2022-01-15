-- basic 'bot mall'
-- iterates through every recipe
-- creates a setup of an assembler with the recipe set, a requester and a provider chest, an inserter in and an inserter out of assembler, and a medium power pole
-- sets the logistic requests on the requester chest to the product's ingredients * 3
-- and creates 10 constant combinators with all the items being made and all their ingredients summed as signals across them. if there are more than 200 items,
-- you will have to modify the block at line 58:
--[[
    for i = 1, <ITEMS/20> do
        const_combs[i] = surface.create_entity {
            name = "constant-combinator",
            position = {pos.start.x - 3 + i, pos.start.y - 3},
            force = p.force
        }
        if i == <NUMBERABOVE/2> then
            pos.start.y = pos.start.y + 1
            pos.start.x = pos.start.x - 5
        end
    end
--]]
-- this handles everything that can be made in an assembler except for things that need wood, science packs, and rocket parts.
-- it does not handle any centrifuging, chemistry, smelting, or oil processing, but it can barrel and unbarrel fluids if you do the piping yourself
-- assemblers will be in alphabetical order according to recipe's in-game name ('personal-laser-defense-equipment')

local p = game.player
local pos = {}
pos.start = {x = p.position.x + 3, y = p.position.y}
local n = 0
local x = 0
local total = 0
local surface = p.surface
local ings = {}
local r = ""
local const_combs = {}

local total_ings = {}

local function get_factors(n)
    local factors = {}
    for possible_factor = 1, math.sqrt(n), 1 do
        local remainder = n % possible_factor
        if remainder == 0 then
            local factor, factor_pair = possible_factor, n / possible_factor
            table.insert(factors, factor)
            if factor ~= factor_pair then
                table.insert(factors, factor_pair)
            end
        end
    end
    table.sort(factors)
    return factors
end

local function round(num, dp)
    local mult = 10 ^ (dp or 0)
    return math.floor(num * mult + 0.5) / mult
end

for i = 1, 10 do
    const_combs[i] = surface.create_entity {
        name = "constant-combinator",
        position = {pos.start.x - 3 + i, pos.start.y - 3},
        force = p.force
    }
    if i == 5 then
        pos.start.y = pos.start.y + 1
        pos.start.x = pos.start.x - 5
    end
end

local items = 0
for i, recipe in pairs(p.force.recipes) do
    if recipe.category ~= "chemistry" and recipe.category ~= "centrifuging" and
        recipe.category ~= "smelting" and recipe.category ~= "oil-processing" and
        recipe.enabled == true and
        not string.find(recipe.name, "science-pack", 1, true) and
        not string.find(recipe.name, "small-electric-pole", 1, true) and
        not string.find(recipe.name, "wooden-chest", 1, true) and
        not string.find(recipe.name, "rocket-part", 1, true) then
        items = items + 1
    end
end

local rows = get_factors(items)
p.print("factors:\n" .. serpent.block(rows))
local per_row = round(#rows / 2, 0) + 1
p.print("middle index: " .. per_row .. "\nresult: " .. rows[per_row])

for _, recipe in pairs(p.force.recipes) do
    if recipe.category ~= "chemistry" and recipe.category ~= "centrifuging" and
        recipe.category ~= "smelting" and recipe.category ~= "oil-processing" and
        recipe.enabled == true and
        not string.find(recipe.name, "science-pack", 1, true) and
        not string.find(recipe.name, "small-electric-pole", 1, true) and
        not string.find(recipe.name, "wooden-chest", 1, true) and
        not string.find(recipe.name, "rocket-part", 1, true) then
        ings = {}
        local i = 0
        n = n + 1
        x = x + 1
        local recipename = recipe.name
        pos.provider = {pos.start.x + 1, pos.start.y}
        pos.inserterprovider = {pos.start.x + 2, pos.start.y}
        pos.requester = {pos.start.x + 1, pos.start.y + 2}
        pos.inserterrequester = {pos.start.x + 2, pos.start.y + 2}
        pos.assembler = {pos.start.x + 4, pos.start.y + 1}
        pos.mediumpole = {pos.start.x + 2, pos.start.y + 1}
        for __, ingredient in pairs(recipe.ingredients) do
            if not game.fluid_prototypes[ingredient.name] and
                not string.find(ingredient.name, "fill-", 1, true) and
                not string.find(ingredient.name, "empty-", 1, true) then
                i = i + 1
                ings[i] = {
                    index = i,
                    name = ingredient.name,
                    count = ingredient.amount
                }
                if not total_ings[ingredient.name] then
                    total_ings[ingredient.name] = 0
                end
                total_ings[ingredient.name] =
                    total_ings[ingredient.name] + ingredient.amount
            end
        end
        if not string.find(recipe.name, "fill-", 1, true) and
            not string.find(recipe.name, "empty-", 1, true) then
            if not total_ings[recipe.name] then
                total_ings[recipe.name] = 0
            end
            total_ings[recipe.name] = total_ings[recipe.name] + 1
        end
        surface.create_entity {
            name = "logistic-chest-passive-provider",
            position = pos.provider,
            force = p.force,
            bar = 4
        }
        surface.create_entity {
            name = "stack-inserter",
            position = pos.inserterprovider,
            direction = defines.direction.east,
            force = p.force
        }
        surface.create_entity {
            name = "logistic-chest-requester",
            position = pos.requester,
            force = p.force,
            request_filters = ings
        }
        surface.create_entity {
            name = "stack-inserter",
            position = pos.inserterrequester,
            direction = defines.direction.west,
            force = p.force
        }
        surface.create_entity {
            name = "assembling-machine-3",
            position = pos.assembler,
            direction = defines.direction.east,
            force = p.force,
            recipe = recipe.name
        }
        if x == 2 then
            surface.create_entity {
                name = "medium-electric-pole",
                position = pos.mediumpole,
                force = p.force
            }
            x = 0
        end
        pos.start.y = pos.start.y + 3
        if n == rows[per_row] then
            pos.start.x = pos.start.x + 7
            pos.start.y = pos.start.y - (rows[per_row] * 3)
            n = 0
            x = 0
        end
        total = total + 1
    end
end

local x, y = 1, 1

for name, count in pairs(total_ings) do
    const_combs[x].get_or_create_control_behavior().set_signal(y, {
        signal = {type = "item", name = name},
        count = count
    })
    y = y + 1
    if y == 21 then
        y = 1
        x = x + 1
    end
end
