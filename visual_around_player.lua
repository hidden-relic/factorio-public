  local results = {}
  local r = 5
  local r_sq = r ^ 2
  local outer_edge = r*math.pi
  local center = {x=0, y=0}
  local area = {top_left={x=center.x-r, y=center.y-r}, bottom_right={x=center.x+r, y=center.y+r}}

  for i = area.top_left.x, area.bottom_right.x, 1 do
    for j = area.top_left.y, area.bottom_right.y, 1 do
  
        local dist = math.floor((center.x - i) ^ 2 + (center.y - j) ^ 2)
  
            if ((dist < r_sq) and
            (dist > r_sq-outer_edge)) then
				local pos = {x=game.player.position.x+i, y=game.player.position.y+j}
                table.insert(results, #results+1, pos)
            end
        end
    end
	for __, pos in pairs(results) do
		game.player.surface.create_entity{name="atomic-nuke-shockwave", position=pos, target=game.player.character}
	end
  
