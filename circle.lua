
function getCircle(radius, center)
local results = {["inside"] = {}, ["edge"] = {}}
local radius, radius_sq = radius, radius ^ 2
local edge = radius*math.pi
local center = center or game.player.position
local area = {top_left={x=center.x-radius, y=center.y-radius}, bottom_right={x=center.x+radius, y=center.y+radius}}

game.player.print("\nradius = " .. radius .. "\nradius_sq = " .. radius_sq .. "\ncenter = x" .. center.x .. ", y" .. center.y .. "\narea = x" .. area.top_left.x .. ", y" .. area.top_left.y .. " to x" .. area.bottom_right.x .. ", y" .. area.bottom_right.y)

for i = area.top_left.x, area.bottom_right.x, 1 do
    for j = area.top_left.y, area.bottom_right.y, 1 do
        local distance = math.floor((center.x - i) ^ 2 + (center.y - j) ^ 2)
        if (distance < radius_sq) then
            table.insert(results.inside, {i,j})
        end
        if ((distance < radius_sq) and
          (distance > radius_sq-32)) then
        table.insert(results[edge],
        game.player.surface.create_entity({name="stone-wall", amount=1, position={i, j}})
        end
    end
end

game.player.surface.set_tiles(results)
game.player.force.chart(game.player.surface, area)