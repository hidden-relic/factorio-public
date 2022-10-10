-- kill bugs
local r=10 for _, bug in pairs(game.player.surface.find_entities_filtered{type="enemy", position=game.player.position, radius=r}) do bug.destroy() end

-- chart all
game.player.force.chart_all()
