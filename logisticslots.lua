--[[-- Commands Module - Quickbar
    - Adds a command that allows players to load Quickbar presets
    @data Quickbar
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
local config = require 'config.preset_player_logistics' --- @dep config.preset_player_quickbar

local proto = game.item_prototypes

local function stack_size(item)
    return proto[item].stack_size
end

--- Stores the quickbar filters for a player
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local PlayerFilters = PlayerData.Settings:combine('LogisticSlotFilters')
PlayerFilters:set_metadata{
    permission = 'command/save-logisticslots',
    stringify = function(value)
        if not value then return 'No filters set' end
        local count = 0
        for _ in pairs(value) do count = count + 1 end
        return count..' filters set'
    end
}

--- Loads your quickbar preset
PlayerFilters:on_load(function(player_name, filters)
    if not filters then filters = config[player_name] end
    if not filters then return end
    local player = game.players[player_name]
    for i, item_name in pairs(filters) do
        if item_name ~= nil and item_name ~= '' then
            local item = {name=item_name, min=stack_size(item_name), max=stack_size(item_name)}
            game.player.set_personal_logistic_slot(i, item)
        end
    end
end)

local ignoredItems = {
    ["blueprint"] = true,
    ["blueprint-book"] = true,
    ["deconstruction-planner"] = true,
    ["spidertron-remote"] = true,
    ["upgrade-planner"] = true
}

--- Saves your quickbar preset to the script-output folder
-- @command save-quickbar
Commands.new_command('save-logisticslots', 'Saves your Logistic Request preset items to file')
:add_alias('save-logistics')
:register(function(player)
    local filters = {}

    for i = 1, 100 do
        local slot = player.get_personal_logistic_slot(i)
        -- Need to filter out blueprint and blueprint books because the slot is a LuaItemPrototype and does not contain a way to export blueprint data
        if slot ~= nil then
            local ignored = ignoredItems[slot.name]
            if ignored ~= true then
                filters[i] = slot.name
            end
        end
    end

    if next(filters) then
        PlayerFilters:set(player, filters)
    else
        PlayerFilters:remove(player)
    end

    return {'logisticslotsbar.saved'}
end)
