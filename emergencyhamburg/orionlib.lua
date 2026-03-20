-- Orion Glass Pro Library
local OrionLib = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Blur
if not Lighting:FindFirstChild("OrionBlur") then
	local blur = Instance.new("BlurEffect", Lighting)
	blur.Name = "OrionBlur"
	blur.Size = 25
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OrionGlassPro"
gui.Parent = game.CoreGui

-- Main Window
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
Main.BackgroundTransparency = 0.88
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255,255,255)
Stroke.Transparency = 0.6

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "Orion Glass Pro"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Dragging
local dragging, dragInput, dragStart, startPos

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Sidebar
local TabsHolder = Instance.new("Frame", Main)
TabsHolder.Size = UDim2.new(0,150,1,-40)
TabsHolder.Position = UDim2.new(0,0,0,40)
TabsHolder.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabsHolder)
TabLayout.Padding = UDim.new(0,6)

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-150,1,-40)
Content.Position = UDim2.new(0,150,0,40)
Content.BackgroundTransparency = 1

-- Window
function OrionLib:MakeWindow(cfg)
	Title.Text = cfg.Name or "Orion"
	return OrionLib
end

-- Tabs
function OrionLib:MakeTab(name)
	local Btn = Instance.new("TextButton", TabsHolder)
	Btn.Size = UDim2.new(1,-10,0,40)
	Btn.Text = name
	Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Btn.BackgroundTransparency = 0.9
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 14
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,12)

	local Frame = Instance.new("Frame", Content)
	Frame.Size = UDim2.new(1,0,1,0)
	Frame.Visible = false
	Frame.BackgroundTransparency = 1

	local Layout = Instance.new("UIListLayout", Frame)
	Layout.Padding = UDim.new(0,8)

	Btn.MouseButton1Click:Connect(function()
		for _,v in pairs(Content:GetChildren()) do
			if v:IsA("Frame") then v.Visible = false end
		end
		Frame.Visible = true
	end)

	local Tab = {}

	-- Button
	function Tab:AddButton(text, callback)
		local b = Instance.new("TextButton", Frame)
		b.Size = UDim2.new(1,-10,0,40)
		b.Text = text
		b.BackgroundColor3 = Color3.fromRGB(255,255,255)
		b.BackgroundTransparency = 0.85
		b.TextColor3 = Color3.new(1,1,1)
		b.Font = Enum.Font.Gotham
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

		b.MouseEnter:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
		end)

		b.MouseLeave:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
		end)

		b.MouseButton1Click:Connect(callback)
	end

	-- Toggle
	function Tab:AddToggle(text, callback)
		local t = Instance.new("TextButton", Frame)
		t.Size = UDim2.new(1,-10,0,40)
		t.BackgroundTransparency = 0.85
		t.BackgroundColor3 = Color3.fromRGB(255,255,255)
		t.TextColor3 = Color3.new(1,1,1)
		t.Text = text.." : OFF"
		Instance.new("UICorner", t)

		local state = false

		t.MouseButton1Click:Connect(function()
			state = not state
			t.Text = text.." : "..(state and "ON" or "OFF")
			callback(state)
		end)
	end

	-- Slider
	function Tab:AddSlider(text, min, max, callback)
		local frame = Instance.new("Frame", Frame)
		frame.Size = UDim2.new(1,-10,0,50)
		frame.BackgroundTransparency = 1

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1,0,0,20)
		label.Text = text.." : "..min
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1,1,1)

		local bar = Instance.new("Frame", frame)
		bar.Size = UDim2.new(1,0,0,10)
		bar.Position = UDim2.new(0,0,0,30)
		bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
		bar.BackgroundTransparency = 0.8

		local fill = Instance.new("Frame", bar)
		fill.Size = UDim2.new(0,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(255,255,255)

		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local move
				move = UIS.InputChanged:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseMovement then
						local percent = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
						fill.Size = UDim2.new(percent,0,1,0)
						local val = math.floor(min + (max-min)*percent)
						label.Text = text.." : "..val
						callback(val)
					end
				end)
				UIS.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
					end
				end)
			end
		end)
	end

	-- Dropdown
	function Tab:AddDropdown(text, options, callback)
		local d = Instance.new("TextButton", Frame)
		d.Size = UDim2.new(1,-10,0,40)
		d.Text = text
		d.BackgroundTransparency = 0.85
		d.BackgroundColor3 = Color3.fromRGB(255,255,255)
		d.TextColor3 = Color3.new(1,1,1)

		local open = false

		d.MouseButton1Click:Connect(function()
			open = not open
			if open then
				for _,opt in pairs(options) do
					local o = Instance.new("TextButton", Frame)
					o.Size = UDim2.new(1,-20,0,30)
					o.Text = opt
					o.BackgroundTransparency = 0.9
					o.TextColor3 = Color3.new(1,1,1)

					o.MouseButton1Click:Connect(function()
						callback(opt)
					end)
				end
			end
		end)
	end

	return Tab
end

return OrionLib
