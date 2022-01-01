local proto = game.item_prototypes

local function stack_size(item)
    return proto[item].stack_size
end

local list = {
    name = {
        "electric-mining-drill", "stone-wall", "gun-turret", "radar",
        "fast-transport-belt", "fast-splitter", "fast-underground-belt",
        "fast-inserter", "medium-electric-pole", "assembling-machine-2",
        "express-transport-belt", "express-splitter",
        "express-underground-belt", "stack-inserter", "substation",
        "assembling-machine-3", "beacon", "big-electric-pole"
    },
    min = {},
    max = {}
}
for i, item in pairs(list.name) do
    list.min[i],  list.max[i] = stack_size(item)
end
for i, item in pairs(list) do
    game.player.set_personal_logistic_slot(i, item)
end