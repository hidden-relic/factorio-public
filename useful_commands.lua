-- kill bugs
local r=10 for _, bug in pairs(game.player.surface.find_entities_filtered{type="enemy", position=game.player.position, radius=r}) do bug.destroy() end

-- chart all
game.player.force.chart_all()

-- get total ingredients for 1 of every item
local t = {}

for name, item in pairs(game.item_prototypes) do
    
    if not t[name] then
        t[name] = 1
    end
    
    pcall(function ()
        for _, ingredient in pairs(game.recipe_prototypes[name].ingredients) do        
            if not t[ingredient.name] then         
                if ingredient.amount then
                    t[ingredient.name] = ingredient.amount
                else
                    t[ingredient.name] = 1
                end    
            else        
                if ingredient.amount then
                    t[ingredient.name] = t[ingredient.name] + ingredient.amount
                else
                    t[ingredient.name] = t[ingredient.name] + 1
                end
            end
        end
    end)
end

game.write_file("ingredients.lua", serpent.block(t))
