local r = 1000
local total = 0
local search = {"water", "deepwater", "water-green", "deepwater-green"}
for _, player in pairs(game.connected_players) do
    for _, watertype in pairs(search) do
        local results = game.player.surface.find_tiles_filtered({name=watertype, position=player.position, radius=r})
        for i = 1, #results, 16 do
            player.force.chart(player.surface.name, {{results[i].position.x, results[i].position.y}, {results[i].position.x+1, results[i].position.y+1}})
            player.surface.create_entity{name="fish", position=results[i].position}
            total = total + 1
        end
    end
end
game.print(total.." fish added")