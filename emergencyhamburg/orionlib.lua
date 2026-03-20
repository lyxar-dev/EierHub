-- Orion Glass Modified Source
local OrionLib = {}
OrionLib.Flags = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- BLUR
if not Lighting:FindFirstChild("OrionGlassBlur") then
	local blur = Instance.new("BlurEffect")
	blur.Name = "OrionGlassBlur"
	blur.Size = 25
	blur.Parent = Lighting
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OrionGlass"
gui.Parent = game.CoreGui

-- MAIN WINDOW
function OrionLib:MakeWindow(cfg)
	local Window = {}

	local Main = Instance.new("Frame", gui)
	Main.Size = UDim2.new(0, 600, 0, 400)
	Main.Position = UDim2.new(0.5, -300, 0.5, -200)
	Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Main.BackgroundTransparency = 0.88
	Main.BorderSizePixel = 0
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

	local Stroke = Instance.new("UIStroke", Main)
	Stroke.Transparency = 0.7
	Stroke.Color = Color3.fromRGB(255,255,255)

	-- TITLE
	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1,0,0,40)
	Title.Text = cfg.Name or "Orion Glass"
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.new(1,1,1)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18

	-- DRAG
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- SIDEBAR
	local Tabs = Instance.new("Frame", Main)
	Tabs.Size = UDim2.new(0,150,1,-40)
	Tabs.Position = UDim2.new(0,0,0,40)
	Tabs.BackgroundTransparency = 1

	local Content = Instance.new("Frame", Main)
	Content.Size = UDim2.new(1,-150,1,-40)
	Content.Position = UDim2.new(0,150,0,40)
	Content.BackgroundTransparency = 1

	local Layout = Instance.new("UIListLayout", Tabs)
	Layout.Padding = UDim.new(0,6)

	-- TAB FUNCTION
	function Window:MakeTab(tabCfg)
		local Tab = {}

		local Btn = Instance.new("TextButton", Tabs)
		Btn.Size = UDim2.new(1,-10,0,40)
		Btn.Text = tabCfg.Name
		Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Btn.BackgroundTransparency = 0.85
		Btn.TextColor3 = Color3.new(1,1,1)
		Btn.Font = Enum.Font.Gotham
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,12)

		local Stroke = Instance.new("UIStroke", Btn)
		Stroke.Transparency = 0.8

		local Frame = Instance.new("Frame", Content)
		Frame.Size = UDim2.new(1,0,1,0)
		Frame.Visible = false
		Frame.BackgroundTransparency = 1

		local Layout = Instance.new("UIListLayout", Frame)
		Layout.Padding = UDim.new(0,6)

		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
		end)

		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
		end)

		Btn.MouseButton1Click:Connect(function()
			for _,v in pairs(Content:GetChildren()) do
				if v:IsA("Frame") then v.Visible = false end
			end
			Frame.Visible = true
		end)

		-- BUTTON
		function Tab:AddButton(cfg)
			local b = Instance.new("TextButton", Frame)
			b.Size = UDim2.new(1,-10,0,40)
			b.Text = cfg.Name
			b.BackgroundTransparency = 0.8
			b.BackgroundColor3 = Color3.fromRGB(255,255,255)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", b)

			b.MouseEnter:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
			end)

			b.MouseLeave:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
			end)

			b.MouseButton1Click:Connect(cfg.Callback)
		end

		-- TOGGLE
		function Tab:AddToggle(cfg)
			local state = cfg.Default or false

			local t = Instance.new("TextButton", Frame)
			t.Size = UDim2.new(1,-10,0,40)
			t.BackgroundTransparency = 0.8
			t.BackgroundColor3 = Color3.fromRGB(255,255,255)
			t.TextColor3 = Color3.new(1,1,1)
			t.Text = cfg.Name.." : "..(state and "ON" or "OFF")
			Instance.new("UICorner", t)

			t.MouseButton1Click:Connect(function()
				state = not state
				t.Text = cfg.Name.." : "..(state and "ON" or "OFF")
				cfg.Callback(state)
			end)
		end

		return Tab
	end

	return Window
end

-- INIT
function OrionLib:Init() end

return OrionLib
