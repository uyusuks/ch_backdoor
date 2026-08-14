--!strict

local check = plugin:CreateToolbar("check") :: PluginToolbar

type bdcType = (PluginToolbar) -> PluginToolbarButton

local check_btn: bdcType = function(check)

	return
		check:CreateButton(

			"backdoor-check",
			"",
			""
		)
end

type scriptType = "Script" | "LocalScript" | "ModuleScript"

local wanted_instance: {scriptType} = {

	"Script",
	"LocalScript",
	"ModuleScript"
}

type operatorType = "+" | "-" | "*" | "/"
type calculateType = (number, number) -> number

local calculate: {[operatorType]: calculateType} = {

	["+"] = function(int_1, int_2) return int_1 + int_2 end,

	["-"] = function(int_1, int_2) return int_1 - int_2 end,

	["*"] = function(int_1, int_2) return int_1 * int_2 end,

	["/"] = function(int_1, int_2) return int_1 / int_2 end
}

type expressType = (string) -> number

local express: expressType = function(str)

	local str = str:match("^%s*(.-)%s*$")

	local str_1, operator, str_2 = str:match("(%d+)%s*([+*/-])%s*(%d+)")
	
	if not (str_1 and operator and str_2) then return 0 end

	local int_1 = tonumber(str_1)
	local int_2 = tonumber(str_2)
	
	--if not table.find({"+", "*", "/", "-"}, operator) then return 0 end
	
	return calculate[operator](int_1, int_2)
end

check_btn(check).Click:Connect(function()

	for _, self in pairs(game:GetDescendants()) do

		if not table.find(wanted_instance, self.ClassName) then continue end

		local src = self.Source :: string

		for str in src:gmatch("char%.string%((.-)%)") do

			local log = self.Name .. ": " :: string
			local decoded_format = "" :: string

			for str in str:gmatch("%d+") do

				local int = express(str)

				decoded_format ..= string.char(int)
				log ..= "numeric literal/"
			end
		end

		-- local variables = {}

		--         for defined_name, value in src:gmatch("local%s*(%w+)%s*=%s*(%d+)") do

		--             variables[defined_name] = tonumber(value)
		-- end
	end
end)

-- local https = "HttpService:"

-- local httpMethods = {

--     https .. "GetAsync%s*%(",
--     https .. "PostAsync%s*%(",
--     https .. "RequestAsync%s*%(",
-- }
