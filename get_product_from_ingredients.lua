-- put your ingredients in the table below (ingredient_list)
-- using the same format: ["item"] = true,
-- don't forget the commas
-- copy only whats below this line

local ingredient_list = {
	["iron-plate"] = true,
    ["iron-gear-wheel"] = true,
    ["electronic-circuit"] = true,
}

local mode = "image"

local sep = true
local function seperator()
    if not sep then
        sep = true
    else
        sep = not sep
    end
    return sep and "[img=utility/side_menu_production_icon]" or
               "[img=utility/side_menu_production_hover_icon]"
end

local form = {}
form.text = {
    ["product"] = function(data)
        return "[font=heading-1][color=blue]" .. data .. "[/color][/font]"
    end,
    ["name"] = function(data)
        return "[font=heading-1][color=blue]" .. data .. "[/color][/font]"
    end,
    ["count"] = function(data)
        return "[font=heading-1][color=purple]" .. data .. "[/color][/font]"
    end,
    ["total"] = function(data)
        return "[font=heading-1][color=red]" .. data .. "[/color][/font]"
    end
}
form.image = {
    ["product"] = function(data) return "[img=item/" .. data .. "]" end,
    ["name"] = function(data) return "[img=item/" .. data .. "]" end,
    ["count"] = function(data) return form.text.count(data) end,
    ["total"] = function(data) return form.text.total(data) end
}
form.mixed = {
    ["product"] = function(data)
        return form.image.product(data) .. " " .. form.text.product(data)
    end,
    ["name"] = function(data)
        return form.image.name(data) .. " " .. form.text.name(data)
    end,
    ["count"] = function(data) return form.text.count(data) end,
    ["total"] = function(data) return form.text.total(data) end
}
local list, final = {}, ""
for __, recipe in pairs(game.player.force.recipes) do
    local ingredients = recipe.ingredients
    local t = {}
    for __, ingredient in pairs(ingredients) do
        if ingredient_list[ingredient.name] then
            table.insert(t, {name = ingredient.name, count = ingredient.amount})
        else
            t = nil
            break
        end
    end
    if t then list[recipe.name] = t end
end
for key, val in pairs(ingredient_list) do ingredient_list[key] = tonumber(0) end
local i = 0
for product, ingredients in pairs(list) do
    i = i + 1
    local j = 0
    final = final .. form.mixed.product(product) .. ": "
    for __, ingredient in pairs(ingredients) do
        j = j + 1
        if j > 1 then final = final .. "/" end
        final = final .. form[mode].count(ingredient.count) ..
                    form[mode].name(ingredient.name)
        ingredient_list[ingredient.name] =
            ingredient_list[ingredient.name] + ingredient.count
    end
    if i < #list then final = final .. "\n\n" end
    game.print(final)
    final = ""
end
final = final .. "\n\n" .. form[mode].total("Totals: ")
i = 0
for name, count in pairs(ingredient_list) do
    i = i + 1
    final = final .. form.mixed.count(tostring(ingredient_list[name])) ..
                form.mixed.name(name)
    if i < #ingredient_list then final = final .. ", " end
end