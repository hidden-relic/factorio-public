local Event = require 'utils.event' --- @dep utils.event
local Global = require 'utils.global' --- @dep utils.global

local arty_fire_count = {}
Global.register(arty_fire_count, function(tbl)
    arty_fire_count = tbl
end)

local function format_time(ticks, options)
    -- Sets up the options
    options = options or {
        days=false,
        hours=true,
        minutes=true,
        seconds=false,
        long=false,
        time=false,
        string=false,
        null=false
    }
    -- Basic numbers that are used in calculations
    local max_days, max_hours, max_minutes, max_seconds = ticks/5184000, ticks/216000, ticks/3600, ticks/60
    local days, hours = max_days, max_hours-math.floor(max_days)*24
    local minutes, seconds = max_minutes-math.floor(max_hours)*60, max_seconds-math.floor(max_minutes)*60
    -- Handles overflow of disabled denominations
    local rtn_days, rtn_hours, rtn_minutes, rtn_seconds = math.floor(days), math.floor(hours), math.floor(minutes), math.floor(seconds)
    if not options.days then
        rtn_hours = rtn_hours + rtn_days*24
    end
    if not options.hours then
        rtn_minutes = rtn_minutes + rtn_hours*60
    end
    if not options.minutes then
        rtn_seconds = rtn_seconds + rtn_minutes*60
    end
    -- Creates the null time format, does not work with long
    if options.null and not options.long then
        rtn_days='--'
        rtn_hours='--'
        rtn_minutes='--'
        rtn_seconds='--'
    end
    -- Format options
    local suffix = 'time-symbol-'
    local suffix_2 = '-short'
    if options.long then
        suffix = ''
        suffix_2 = ''
    end
    local div = options.string and ' ' or 'time-format.simple-format-tagged'
    if options.time then
        div = options.string and ':' or 'time-format.simple-format-div'
        suffix = false
    end
    -- Adds formatting
    if suffix ~= false then
        if options.string then
            -- format it as a string
            local long = suffix == ''
            rtn_days = long and rtn_days..' days' or rtn_days..'d'
            rtn_hours = long and rtn_hours..' hours' or rtn_hours..'h'
            rtn_minutes = long and rtn_minutes..' minutes' or rtn_minutes..'m'
            rtn_seconds = long and rtn_seconds..' seconds' or rtn_seconds..'s'
        else
            rtn_days = {suffix..'days'..suffix_2, rtn_days}
            rtn_hours = {suffix..'hours'..suffix_2, rtn_hours}
            rtn_minutes = {suffix..'minutes'..suffix_2, rtn_minutes}
            rtn_seconds = {suffix..'seconds'..suffix_2, rtn_seconds}
        end
    elseif not options.null then
        -- weather string or not it has same format
        rtn_days = string.format('%02d', rtn_days)
        rtn_hours = string.format('%02d', rtn_hours)
        rtn_minutes = string.format('%02d', rtn_minutes)
        rtn_seconds = string.format('%02d', rtn_seconds)
    end
    -- The final return is construed
    local rtn
    local append = function(dom, value)
        if dom and options.string then
            rtn = rtn and rtn..div..value or value
        elseif dom then
            rtn = rtn and {div, rtn, value} or value
        end
    end
    append(options.days, rtn_days)
    append(options.hours, rtn_hours)
    append(options.minutes, rtn_minutes)
    append(options.seconds, rtn_seconds)
    return rtn
end

local function get_secs ()
    return format_time(game.tick, { hours = true, minutes = true, seconds = true, string = true })
end
local function pos_tostring (pos)
    return tostring(pos.x) .. "," .. tostring(pos.y)
end

local shoot_filepath = "log/shoot.log"

local function add_arty_log(data)
    game.write_file(shoot_filepath, data .. "\n", true, 0) -- write data
end

Event.add(defines.events.on_player_used_capsule, function(event)
    if event.item.name == "artillery-targeting-remote" then
        local player = game.get_player(event.player_index)
        if arty_fire_count[player.index] then
            local arty_fire = arty_fire_count[player.index]
            if arty_fire.count and arty_fire.last_shot_tick then
                if (game.tick - arty_fire.last_shot_tick) < 300 then
                    arty_fire.count = arty_fire.count + 1
                else
                    arty_fire.count = 1
                end
            else
                arty_fire.count = 1
            end
            arty_fire.position = pos_tostring(event.position) -- modify
            arty_fire.last_shot_tick = game.tick
        else
            arty_fire_count[player.index] = {}
            arty_fire_count[player.index].count = 1
            arty_fire_count[player.index].position = pos_tostring(event.position) -- modify
            arty_fire_count[player.index].last_shot_tick = game.tick
        end
    end
end)


Event.on_nth_tick(300, function()
    for index, _ in pairs(arty_fire_count) do
        if (game.tick - arty_fire_count[index].last_shot_tick) >= 300 then
            add_arty_log(get_secs() .. "," .. game.players[index].name .. ",manually_shot_artillery x" .. arty_fire_count[index].count .. "," .. arty_fire_count[index].position)
            arty_fire_count[index] = nil
        end
    end
end)