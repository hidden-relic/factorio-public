---------------------------------------------------------------------------------------------------------
--                                  FACTORIO USEFUL COMMANDS                                           --
--      all of these can be used by an admin or in your single player game, through the console        --
--              note that using any of these will disable achievements in your save                    --
--                                                                                                     --
--      USAGE: just copy any of the commands, no matter if they are multiple lines or single lines,    --
-- and paste them into the console (the chat window) after typing /c (command) or /sc (silent command) --
--                                                                                                     --
--                          EXAMPLE: /sc game.player.force.chart_all()                                 --
--                                                                                                     --
---------------------------------------------------------------------------------------------------------

-- kill bugs in radius 'r' around your player

local r = 100
for _, bug in pairs(game.player.surface.find_entities_filtered{force = "enemy", position = game.player.position, radius = r}) do
    bug.destroy()
end

-- chart all chunks for a force

game.player.force.chart_all()

-- get total ingredients for 1 of every item written to "ingredients.lua" in /factorio/script-output/
-- each item will be surrounded in [brackets], followed by it's ingredients and their amounts, and the current total of said ingredient
-- at the bottom of the file will be the total's table

local t = {}
game.write_file("ingredients.lua", "")

local function w(string)
	game.write_file("ingredients.lua", string.."\n", true)
end

for name, item in pairs(game.item_prototypes) do
	w("["..name.."]")
    if not t[name] then t[name] = {} end
    pcall(function()
        for item, _ in pairs(t) do
            for _, ingredient in pairs(game.recipe_prototypes[item].ingredients) do
                if not t[ingredient.name] then
                    t[ingredient.name] = ingredient.amount
                else
                    t[ingredient.name] = t[ingredient.name] + ingredient.amount
                end
				w(ingredient.name.."\t+"..ingredient.amount.."\t="..t[ingredient.name])
            end
        end
    end)
end

