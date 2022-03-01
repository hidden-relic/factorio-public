local function getchr(str)
	local final = ""
	for i=1, #str, 1 do
		local char = string.sub(str, i)
		if string.byte(char) == 32 then
			final = final .. "\n"
		else
		final = final .. string.byte(char) .. " "
		end
		i = i + 1
	end
	return final
end