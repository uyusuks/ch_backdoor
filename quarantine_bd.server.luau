--!nonstrict

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
	
    local int_1 = tonumber(str_1)
    local int_2 = tonumber(str_2)

	if not (int_1 and operator and int_2) then return 0 end
	
	--if not table.find({"+", "*", "/", "-"}, operator) then return 0 end
	
	return calculate[operator](int_1, int_2)
end

check_btn(check).Click:Connect(function()

	for _, self in pairs(game:GetDescendants()) do

		if not table.find(wanted_instance, self.ClassName) then continue end

		local src = self.Source :: string

        local variables: {[string]: number} = {}

		for defined_name, defined_value in src:gmatch("local%s*(%w+)%s*=%s*(%d+)") do

		    variables[defined_name] = defined_value
		end

		for str in src:gmatch("char%.string%((.-)%)") do

			local log = self.Name .. ": " :: string
			local decoded_format = "" :: string

			for str in str:gmatch("%d+") do

				local expressed_int = express(str)

				decoded_format ..= string.char(expressed_int)
				log ..= "numeric literal/"
			end

            for potential_var in str:gmatch("%w+") do
                
                if not table.find(variables, potential_var) then break end

				log ..= "var manip/"
            end
		end
	end
end)
