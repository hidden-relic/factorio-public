local proto = game.item_prototypes

local function stack_size(item)
    return proto[item].stack_size
end

local list = {
        "electric-mining-drill", "stone-wall", "gun-turret", "radar",
        "fast-transport-belt", "fast-splitter", "fast-underground-belt",
        "fast-inserter", "medium-electric-pole", "assembling-machine-2",
        "express-transport-belt", "express-splitter",
        "express-underground-belt", "stack-inserter", "substation",
        "assembling-machine-3", "beacon", "big-electric-pole"
}
for i = 1, #list do
    item = {name=list[i], min=stack_size(list[i]), max=stack_size(list[i])*2}
    game.player.set_personal_logistic_slot(i, item)
end
