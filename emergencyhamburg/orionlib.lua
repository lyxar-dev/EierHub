-- Orion Glass (REAL STRUCTURE)
local OrionLib = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Blur
if not Lighting:FindFirstChild("OrionBlur") then
	local blur = Instance.new("BlurEffect", Lighting)
	blur.Name = "OrionBlur"
	blur.Size = 20
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OrionGlass"
gui.Parent = game.CoreGui

-- Window Creator
function OrionLib:MakeWindow(cfg)
	local Window = {}

	-- Main Frame
	local Main = Instance.new("Frame", gui)
	Main.Size = UDim2.new(0, 600, 0, 400)
	Main.Position = UDim2.new(0.5, -300, 0.5, -200)
	Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Main.BackgroundTransparency = 0.88
	Main.BorderSizePixel = 0
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

	local Stroke = Instance.new("UIStroke", Main)
	Stroke.Transparency = 0.6

	-- Title
	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1,0,0,40)
	Title.Text = cfg.Name or "Orion"
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.new(1,1,1)

	-- Drag
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

	-- Tabs holder
	local TabsHolder = Instance.new("Frame", Main)
	TabsHolder.Size = UDim2.new(0,150,1,-40)
	TabsHolder.Position = UDim2.new(0,0,0,40)
	TabsHolder.BackgroundTransparency = 1

	local Content = Instance.new("Frame", Main)
	Content.Size = UDim2.new(1,-150,1,-40)
	Content.Position = UDim2.new(0,150,0,40)
	Content.BackgroundTransparency = 1

	local UIList = Instance.new("UIListLayout", TabsHolder)
	UIList.Padding = UDim.new(0,5)

	-- MakeTab (ECHT ORION STYLE)
	function Window:MakeTab(tabCfg)
		local Tab = {}

		local Button = Instance.new("TextButton", TabsHolder)
		Button.Size = UDim2.new(1,-10,0,40)
		Button.Text = tabCfg.Name
		Button.BackgroundTransparency = 0.9
		Button.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Button.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", Button)

		local Frame = Instance.new("Frame", Content)
		Frame.Size = UDim2.new(1,0,1,0)
		Frame.Visible = false
		Frame.BackgroundTransparency = 1

		local Layout = Instance.new("UIListLayout", Frame)
		Layout.Padding = UDim.new(0,6)

		Button.MouseButton1Click:Connect(function()
			for _,v in pairs(Content:GetChildren()) do
				if v:IsA("Frame") then v.Visible = false end
			end
			Frame.Visible = true
		end)

		-- BUTTON
		function Tab:AddButton(cfg)
			local Btn = Instance.new("TextButton", Frame)
			Btn.Size = UDim2.new(1,-10,0,40)
			Btn.Text = cfg.Name
			Btn.BackgroundTransparency = 0.85
			Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", Btn)

			Btn.MouseButton1Click:Connect(function()
				cfg.Callback()
			end)
		end

		-- TOGGLE
		function Tab:AddToggle(cfg)
			local state = cfg.Default or false

			local Toggle = Instance.new("TextButton", Frame)
			Toggle.Size = UDim2.new(1,-10,0,40)
			Toggle.Text = cfg.Name.." : "..(state and "ON" or "OFF")
			Toggle.BackgroundTransparency = 0.85
			Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Toggle.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", Toggle)

			Toggle.MouseButton1Click:Connect(function()
				state = not state
				Toggle.Text = cfg.Name.." : "..(state and "ON" or "OFF")
				cfg.Callback(state)
			end)
		end

		-- SLIDER
		function Tab:AddSlider(cfg)
			local value = cfg.Min

			local FrameS = Instance.new("Frame", Frame)
			FrameS.Size = UDim2.new(1,-10,0,50)
			FrameS.BackgroundTransparency = 1

			local Label = Instance.new("TextLabel", FrameS)
			Label.Size = UDim2.new(1,0,0,20)
			Label.Text = cfg.Name.." : "..value
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.new(1,1,1)

			local Bar = Instance.new("Frame", FrameS)
			Bar.Size = UDim2.new(1,0,0,10)
			Bar.Position = UDim2.new(0,0,0,30)
			Bar.BackgroundTransparency = 0.8

			local Fill = Instance.new("Frame", Bar)
			Fill.Size = UDim2.new(0,0,1,0)

			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local move
					move = UIS.InputChanged:Connect(function(i)
						if i.UserInputType == Enum.UserInputType.MouseMovement then
							local percent = math.clamp((i.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
							Fill.Size = UDim2.new(percent,0,1,0)

							value = math.floor(cfg.Min + (cfg.Max-cfg.Min)*percent)
							Label.Text = cfg.Name.." : "..value
							cfg.Callback(value)
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

		return Tab
	end

	return Window
end

return OrionLib
