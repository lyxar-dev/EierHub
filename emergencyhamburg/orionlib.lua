-- LOAD REAL ORION
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Blur Effekt (GLASS LOOK)
local Lighting = game:GetService("Lighting")

if not Lighting:FindFirstChild("GlassBlur") then
	local blur = Instance.new("BlurEffect")
	blur.Name = "GlassBlur"
	blur.Size = 25
	blur.Parent = Lighting
end

-- WINDOW (ECHT ORION)
local Window = OrionLib:MakeWindow({
	Name = "Glass Orion",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "GlassUI"
})

-- TAB
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- SECTION
local Section = Tab:AddSection({
	Name = "Glass Controls"
})

-- ELEMENTS
Tab:AddButton({
	Name = "Button",
	Callback = function()
		print("clicked")
	end
})

Tab:AddToggle({
	Name = "Toggle",
	Default = false,
	Callback = function(v)
		print(v)
	end
})

Tab:AddSlider({
	Name = "Slider",
	Min = 0,
	Max = 100,
	Default = 50,
	Increment = 1,
	ValueName = "Value",
	Callback = function(v)
		print(v)
	end
})

Tab:AddDropdown({
	Name = "Dropdown",
	Default = "1",
	Options = {"1","2","3"},
	Callback = function(v)
		print(v)
	end
})

-- NOTIFICATION
OrionLib:MakeNotification({
	Name = "Glass UI",
	Content = "Loaded successfully",
	Time = 3
})

-- INIT (WICHTIG)
OrionLib:Init()
