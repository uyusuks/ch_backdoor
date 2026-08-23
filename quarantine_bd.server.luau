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

local summary = {} :: any

local variables: {[string]: number} = {}

local nl = false :: boolean

check_btn(check).Click:Connect(function()

	for _, instance in pairs(game:GetDescendants()) do

		if not table.find(wanted_instance, instance.ClassName) then continue end

		local src = instance.Source :: string

		for defined_name, defined_value in src:gmatch("local%s*(%w+)%s*=%s*(%d+)") do

			variables[defined_name] = defined_value
		end

		for str in src:gmatch("string%.char%s*%(%s*(.-)%s*%)") do

			summary["log"] = instance.Name .. ": " :: string
			summary["sc_df"] = "" :: string

			for str in str:gmatch("%d+") do

				local expressed_int = express(str)

				summary["sc_df"] ..= string.char(expressed_int)
				
				nl = true
			end
			
			if nl then summary["log"] ..= "numeric literal/" nl = false end

			for potential_var in str:gmatch("%w+") do

				if not variables[potential_var] then continue end

				summary["log"] ..= "var manip/"
			end
		end
	end
	
	for variable in variables do variables[variable] = nil end
end)
