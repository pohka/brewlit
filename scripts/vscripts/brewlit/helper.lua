

if Helper == nil then
	Helper = class ({})
end



--[[
converts all tables that have indexing starting at 1 to start at zero
As ALL programmers are supposed to start counting from zero REEEEEE
original:
tbl = { 1 = "item 1", 2 = "item 2", .... }
converts to:
tbl  = { 0 = "item 1", 1 = "item 2", .... }

]]
function Helper:ConvertTableToStartAtZero(tbl)
	if tbl[0] == nil then
		local i =1
		while tbl[i] ~= nil do
			tbl[i-1] = tbl[i]
			i = i + 1
		end
		tbl[i-1] = nil
	end
	return tbl
end


--prints the key and the type of each variable in the table
function Helper:PrintTable(tbl)
	table.foreach(tbl, 
		function(k,v)
			local vType
			
			if type(v) == "table" then
				vType = v:GetClassname()
			else
				vType = type(v)
			end
			
			print(k .. ": " .. vType)
		end)
end