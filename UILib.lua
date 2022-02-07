function GenerateString(x)
	local Letters = ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'):split('')
	local String = ''
	for _ = 1, x do
		String = String..Letters[math.random(1, #Letters)]
	end
	return String
end

local next = next
local floor = math.floor
local clamp = math.clamp
local traceback = debug.traceback
local TweenService = game:GetService("TweenService");

local finity = {}
finity.TipName = 'Bee Swarm 3.0'
finity.checkbox_cache = {}

finity.theme = { -- light
	main_container = Color3.fromRGB(249, 249, 255),
	separator_color = Color3.fromRGB(223, 219, 228),

	text_color = Color3.fromRGB(96, 96, 96),

	category_button_background = Color3.fromRGB(223, 219, 228),
	category_button_border = Color3.fromRGB(200, 196, 204),

	checkbox_checked = Color3.fromRGB(64, 224, 208),
	checkbox_outer = Color3.fromRGB(198, 189, 202),
	checkbox_inner = Color3.fromRGB(249, 239, 255),

	slider_color = Color3.fromRGB(114, 214, 112),
	slider_color_sliding = Color3.fromRGB(114, 214, 112),
	slider_background = Color3.fromRGB(198, 188, 202),
	slider_text = Color3.fromRGB(112, 112, 112),

	textbox_background = Color3.fromRGB(198, 189, 202),
	textbox_background_hover = Color3.fromRGB(215, 206, 227),
	textbox_text = Color3.fromRGB(112, 112, 112),
	textbox_text_hover = Color3.fromRGB(50, 50, 50),
	textbox_placeholder = Color3.fromRGB(178, 178, 178),

	dropdown_background = Color3.fromRGB(198, 189, 202),
	dropdown_text = Color3.fromRGB(112, 112, 112),
	dropdown_text_hover = Color3.fromRGB(50, 50, 50),
	dropdown_scrollbar_color = Color3.fromRGB(198, 189, 202),
	
	button_background = Color3.fromRGB(198, 189, 202),
	button_background_hover = Color3.fromRGB(215, 206, 227),
	button_background_down = Color3.fromRGB(178, 169, 182),
	
	scrollbar_color = Color3.fromRGB(198, 189, 202),
}

finity.dark_theme = { -- dark
	main_container = Color3.fromRGB(44, 53, 57),
	separator_color = Color3.fromRGB(63, 63, 65),

	text_color = Color3.fromRGB(206, 206, 206),

	category_button_background = Color3.fromRGB(63, 62, 65),
	category_button_border = Color3.fromRGB(72, 71, 74),

	checkbox_checked = Color3.fromRGB(64, 224, 208),
	checkbox_outer = Color3.fromRGB(84, 81, 86),
	checkbox_inner = Color3.fromRGB(132, 132, 136),

	slider_color = Color3.fromRGB(177, 177, 177),
	slider_color_sliding = Color3.fromRGB(132, 255, 130),
	slider_background = Color3.fromRGB(88, 84, 90),
	slider_text = Color3.fromRGB(177, 177, 177),

	textbox_background = Color3.fromRGB(103, 103, 106),
	textbox_background_hover = Color3.fromRGB(137, 137, 141),
	textbox_text = Color3.fromRGB(195, 195, 195),
	textbox_text_hover = Color3.fromRGB(232, 232, 232),
	textbox_placeholder = Color3.fromRGB(135, 135, 138),

	dropdown_background = Color3.fromRGB(88, 88, 91),
	dropdown_text = Color3.fromRGB(195, 195, 195),
	dropdown_text_hover = Color3.fromRGB(232, 232, 232),
	dropdown_scrollbar_color = Color3.fromRGB(118, 118, 121),
	
	button_background = Color3.fromRGB(103, 103, 106),
	button_background_hover = Color3.fromRGB(137, 137, 141),
	button_background_down = Color3.fromRGB(70, 70, 81),
	
	scrollbar_color = Color3.fromRGB(118, 118, 121),
}

local mouse = game.Players.LocalPlayer:GetMouse()

function finity:Create(class, properties)
	local object = Instance.new(class)

	for prop, val in next, properties do
		if object[prop] and prop ~= "Parent" then
			object[prop] = val
		end
	end
	if properties['Parent'] then
		object.Parent = properties['Parent']
	end
	return object
end

function finity:addShadow(object, transparency)
	local shadow = self:Create("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 6, 1, 6),
		Image = "rbxassetid://1316045217",
		ImageTransparency = transparency and true or 0.5,
		ImageColor3 = Color3.fromRGB(35, 35, 35),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118)
	})

	shadow.Parent = object
end

function finity.new(TipName, Size, InstanceName, UIFunction, TipID)
	local finityObject = {}
	local self2 = finityObject
	local self = finity
	local thinProject = false;

	local theme = finity.dark_theme

	local toggled = true
	local typing = false
	local firstCategory = true
    local savedposition = UDim2.new(0.5, 0, 0.5, 0)
    finity.TipName = TipName
	if TipID then
		finity.TipID = TipID
	end
	local Size = (type(Size) == 'string' and Size:lower() == 'default' or typeof(Size) ~= 'UDim2') and UDim2.new(0, 700, 0, 400) or Size
	local finityData
	finityData = {
		UpConnection = nil,
		ToggleKey = Enum.KeyCode.Home,
	}

	self2.ChangeToggleKey = function(NewKey)
		finityData.ToggleKey = NewKey
		if finityData.UpConnection then
			finityData.UpConnection:Disconnect()
		end

		finityData.UpConnection = game.UserInputService.InputEnded:Connect(function(Input)
			if Input.KeyCode == finityData.ToggleKey and not typing then
                toggled = not toggled

                pcall(function() self2.modal.Modal = toggled end)

                if toggled then
					pcall(self2.container.TweenPosition, self2.container, savedposition, "Out", "Sine", 0.5, true)
                else
                    savedposition = self2.container.Position;
					pcall(self2.container.TweenPosition, self2.container, UDim2.new(savedposition.Width.Scale, savedposition.Width.Offset, 1.5, 0), "Out", "Sine", 0.5, true)
				end
			end
		end)
	end

	self2.ChangeBackgroundImage = function(ImageID, Transparency)
		self2.container.Image = ImageID

		if Transparency then
			self2.container.ImageTransparency = Transparency
		else
			self2.container.ImageTransparency = 0.8
		end
	end

	finityData.UpConnection = game.UserInputService.InputEnded:Connect(function(Input)
		if Input.KeyCode == finityData.ToggleKey and not typing then
			toggled = not toggled

			if toggled then
				self2.container:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Sine", 0.5, true)
			else
				self2.container:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), "Out", "Sine", 0.5, true)
			end
		end
	end)

	self2.userinterface = self:Create("ScreenGui", {
		Name = InstanceName or "nfkflburxaNwLHvJ4rwm",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
	})

	self2.container = self:Create("ImageLabel", {
		Draggable = true,
		Active = true,
		Name = "Container",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.main_container,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = Size or UDim2.new(0, 700, 0, 400),
		ZIndex = 2,
		ImageTransparency = 1
    })

    self2.modal = self:Create("TextButton", {
        Text = "";
        Transparency = 1;
        Modal = true;
    }) self2.modal.Parent = self2.userinterface;

	function finity:dragify(Frame)
		dragToggle = nil
		local StartPos, DragStart;
		local function updateInput(input)
			local Delta = input.Position - DragStart
			local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
			game.TweenService:Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
		end
		Frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragToggle = true
				DragStart = input.Position
				StartPos = Frame.Position
				input.Changed:Connect(function()
					if (input.UserInputState == Enum.UserInputState.End) then
						dragToggle = false
					end
				end)
			end
		end)
		local DragInput = nil
		Frame.InputChanged:Connect(function(Input)
			if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				DragInput = Input
			end
		end)
		game.UserInputService.InputChanged:Connect(function(Input)
			if (Input == DragInput and dragToggle) then
				updateInput(Input)
			end
		end)
	end

	finity:dragify(self2.container)

	self2.sidebar = self:Create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Color3.new(0.976471, 0.937255, 1),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.new(0.745098, 0.713726, 0.760784),
		Size = UDim2.new(0, 120, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		ZIndex = 2,
	})
	self2.categories = self:Create("Frame", {
		Name = "Categories",
		BackgroundColor3 = Color3.new(0.976471, 0.937255, 1),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderColor3 = Color3.new(0.745098, 0.713726, 0.760784),
		Size = UDim2.new(1, -120, 1, -30),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 30),
		ZIndex = 2,
	})
	self2.categories.ClipsDescendants = true

	self2.topbar = self:Create("Frame", {
		Name = "Topbar",
		ZIndex = 2,
		Size = UDim2.new(1,0,0,30),
		BackgroundTransparency = 2
	})

	self2.tip = self:Create("TextLabel", {
		Name = "TopbarTip",
		ZIndex = 2,
		Size = UDim2.new(1, -30, 0, 30),
		Position = UDim2.new(0, 30, 0, 0),
		RichText = true,
		Text = TipName or "Loading...",
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		TextColor3 = theme.text_color,
	})
	self2.tip.RichText = true
	self2.tip.Text = finity.TipName

	function self2:SetName(Name)
		string.gsub(self2.tip.Text, finity.TipName, Name)
		finity.TipName = Name
		self2.tip.Text = Name
	end

	local Categories = {}
	function self2:SetCategoryStorage(table)
		for i,v in next, Categories do
			table[i] = v
		end
		table.clear(Categories)
		Categories = table
	end
	self2.Categories = Categories

	local Sectors = {}
	function self2:SetSectorStorage(table)
		for i,v in next, Sectors do
			table[i] = v
		end
		table.clear(Sectors)
		Sectors = table
	end
	self2.Sectors = Sectors

	local Features = {}
	function self2:SetCheatStorage(table)
		for i,v in next, Features do
			table[i] = v
		end
		table.clear(Features)
		Features = table
	end
	self2.Features = Features

	local separator = self:Create("Frame", {
		Name = "Separator",
		BackgroundColor3 = theme.separator_color,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 118, 0, 30),
		Size = UDim2.new(0, 1, 1, -30),
		ZIndex = 6,
	})
	separator.Parent = self2.container
	separator = nil

	local separator = self:Create("Frame", {
		Name = "Separator",
		BackgroundColor3 = theme.separator_color,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 30),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 6,
	})
	separator.Parent = self2.container
	separator = nil

	local uipagelayout = self:Create("UIPageLayout", {
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Vertical,
		TweenTime = 0.7,
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.InOut,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	uipagelayout.Parent = self2.categories
	uipagelayout = nil

	local uipadding = self:Create("UIPadding", {
		PaddingTop = UDim.new(0, 3),
		PaddingLeft = UDim.new(0, 2)
	})
	uipadding.Parent = self2.sidebar
	uipadding = nil

	local uilistlayout = self:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	uilistlayout.Parent = self2.sidebar
	uilistlayout = nil

	function self2:Category(name)
		local category = {Sectors = {}}

		category.button = finity:Create("TextButton", {
			Name = name,
			BackgroundColor3 = theme.category_button_background,
			BackgroundTransparency = 1,
			BorderMode = Enum.BorderMode.Inset,
			BorderColor3 = theme.category_button_border,
			Size = UDim2.new(1, -4, 0, 25),
			ZIndex = 2,
			AutoButtonColor = false,
			Font = Enum.Font.GothamSemibold,
			Text = name,
			RichText = true,
			TextColor3 = theme.text_color,
			TextSize = 14
		})

		category.container = finity:Create("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 2,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarImageColor3 = theme.scrollbar_color or Color3.fromRGB(118, 118, 121),
			BottomImage = "rbxassetid://967852042",
			MidImage = "rbxassetid://967852042",
			TopImage = "rbxassetid://967852042",
			ScrollBarImageTransparency = 1 --
		})

		category.hider = finity:Create("Frame", {
			Name = "Hider",
			BackgroundTransparency = 0, --
			BorderSizePixel = 0,
			BackgroundColor3 = theme.main_container,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 5
		})

		category.L = finity:Create("Frame", {
			Name = "L",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 3),
			Size = UDim2.new(0.5, -20, 1, -3),
			ZIndex = 2
		})

		if not thinProject then
			category.R = finity:Create("Frame", {
				Name = "R",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -10, 0, 3),
				Size = UDim2.new(0.5, -20, 1, -3),
				ZIndex = 2
			})
		end

		if thinProject then
			category.L.Size = UDim2.new(1, -20, 1, -3)
		end

		if firstCategory then
			game.TweenService:Create(category.hider, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			game.TweenService:Create(category.container, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()
		end

		do
			local uilistlayout = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local uilistlayout2 = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local function computeSizeChange()
				local largestListSize = 0

				largestListSize = uilistlayout.AbsoluteContentSize.Y

				if uilistlayout2.AbsoluteContentSize.Y > largestListSize then
					largestListSize = largestListSize
				end

				category.container.CanvasSize = UDim2.new(0, 0, 0, largestListSize + 5)
			end

			uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(computeSizeChange)
			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(computeSizeChange)

			uilistlayout.Parent = category.L
			uilistlayout2.Parent = category.R
		end

		category.button.MouseEnter:Connect(function()
			game.TweenService:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
		end)
		category.button.MouseLeave:Connect(function()
			game.TweenService:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end)
		category.button.MouseButton1Down:Connect(function()
			for _, categoryf in next, self2.userinterface["Container"]["Categories"]:GetChildren() do
				if categoryf:IsA("ScrollingFrame") then
					if categoryf ~= category.container then
						game.TweenService:Create(categoryf.Hider, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
						game.TweenService:Create(categoryf, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
					end
				end
			end

			game.TweenService:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
			game.TweenService:Create(category.hider, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			game.TweenService:Create(category.container, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()

			self2.categories["UIPageLayout"]:JumpTo(category.container)
		end)
		category.button.MouseButton1Up:Connect(function()
			game.TweenService:Create(category.button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end)

		category.container.Parent = self2.categories
		category.button.Parent = self2.sidebar

		if not thinProject then
			category.R.Parent = category.container
		end

		category.L.Parent = category.container
		category.hider.Parent = category.container

		local function calculateSector()
			if thinProject then
				return "L"
			end

			local R = #category.R:GetChildren() - 1
			local L = #category.L:GetChildren() - 1

			if L > R then
				return "R"
			else
				return "L"
			end
		end

		function category:Sector(name)
			local sector = {Cheats = {}}

			sector.frame = finity:Create("Frame", {
				Name = name,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25),
				ZIndex = 2
			})

			sector.container = finity:Create("Frame", {
				Name = "Container",
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 22),
				Size = UDim2.new(1, -5, 1, -30),
				ZIndex = 2
			})

			sector.title = finity:Create("TextLabel", {
				Name = "Title",
				Text = name,
				RichText = true,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -5, 0, 25),
				ZIndex = 2,
				Font = Enum.Font.GothamSemibold,
				TextColor3 = theme.text_color,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local uilistlayout = finity:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

            uilistlayout.Changed:Connect(function()
                pcall(function()
                    sector.frame.Size = UDim2.new(1, 0, 0, sector.container["UIListLayout"].AbsoluteContentSize.Y + 25)
                    sector.container.Size = UDim2.new(1, 0, 0, sector.container["UIListLayout"].AbsoluteContentSize.Y)
                end)
			end)
			uilistlayout.Parent = sector.container
			uilistlayout = nil

			function sector:Cheat(kind, name, callback, data)
				local data = data or {}
				local kind = kind:lower()
				local cheat = {type = kind}
				cheat.flags = data.flags
				cheat.func = callback
				cheat.value = nil
				cheat.override = data.kind == 2 and kind == 'button'
				function cheat:Delete()
					for _,v in next, cheat do
						if typeof(v) == 'Instance' then
							v:Destroy()
						end
						v = nil
					end
					cheat = nil
				end
				cheat.frame = finity:Create("Frame", {
					Name = name,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25),
					ZIndex = 2,
				})

				cheat.label = finity:Create(cheat.override and 'TextButton' or 'TextLabel', {
					Name = "Title",
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 2,
					Font = Enum.Font.Gotham,
					TextColor3 = theme.text_color,
					TextSize = 13,
					Text = name,
					TextTruncate = data.truncate,
					RichText = true,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				cheat.container	= finity:Create("Frame", {
					Name = "Container",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 150, 0, 22),
					ZIndex = 2,
				})
				if cheat.override and callback then
					cheat.label.MouseButton1Click:Connect(callback)
				end
				if kind then
					if kind == "checkbox" or kind == "toggle" then
						if data then
							cheat.value = data.rightclick and data.renabled or data.enabled
							cheat.using = data.enabled and 'MouseButtton1' or data.renabled and 'MouseButton2'
							cheat.name = name
							if cheat.value and callback then
								callback(cheat.value, cheat.using)
							end
						end

						cheat.checkbox = finity:Create("Frame", {
							Name = "Checkbox",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0, 0),
							Size = UDim2.new(0, 25, 0, 25),
							ZIndex = 2,
						})

						cheat.outerbox = finity:Create("ImageLabel", {
							Name = "Outer",
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(0, 20, 0, 20),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.checkbox_outer,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.06,
						})

						cheat.checkboxbutton = finity:Create("ImageButton", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Name = "CheckboxButton",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 14, 0, 14),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.checkbox_inner,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.04
						})
						finity.checkbox_cache[#finity.checkbox_cache + 1] = cheat.checkboxbutton
						if data then
							if data.disabled then
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_disabled}):Play()
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_disabled}):Play()
							end
							if cheat.value and not data.disabled then
								if data.renabled then
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_alt}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_alt}):Play()
								else
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
								end
							end
						end

						cheat.checkboxbutton.MouseEnter:Connect(function()
							local lightertheme = Color3.fromRGB((theme.checkbox_outer.R * 255) + 20, (theme.checkbox_outer.G * 255) + 20, (theme.checkbox_outer.B * 255) + 20)
							game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = lightertheme}):Play()
						end)

						cheat.checkboxbutton.MouseLeave:Connect(function()
							if data.disabled then
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_disabled}):Play()
							elseif not cheat.value then
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
							else
								if cheat.using == 'MouseButton2' then
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_alt}):Play()
								else
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
								end
							end
						end)
						cheat.checkboxbutton.MouseButton1Down:Connect(function()
							if data.disabled then
								return
							end
							if cheat.value then
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
							else
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							end
						end)
						cheat.checkboxbutton.MouseButton1Up:Connect(function()
							if data.disabled then
								return
							end
							cheat.value = not cheat.value

							if callback then
								callback(cheat.value, 'MouseButton1')
							end

							if cheat.value then
								cheat.using = 'MouseButton1'
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							else
								cheat.using = nil
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
							end
						end)
						if data.rightclick then
							cheat.checkboxbutton.MouseButton2Down:Connect(function()
								if data.disabled then
									return
								end
								if cheat.value then
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
								else
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_alt}):Play()
								end
							end)
							cheat.checkboxbutton.MouseButton2Up:Connect(function()
								if data.disabled then
									return
								end
								cheat.value = not cheat.value

								if callback then
									callback(cheat.value, 'MouseButton2')
								end

								if cheat.value then
									cheat.using = 'MouseButton2'
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_alt}):Play()
								else
									cheat.using = nil
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
								end
							end)
						end
						function cheat:toggleState(state)
							if type(state) == 'boolean' and not state or cheat.value then
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
							else
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							end
							cheat.value = type(state) == 'boolean' and state or not cheat.value
							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn(traceback().." - error:  : ".. e) end
							end

							if cheat.value then
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
							else
								game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
								game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
							end
						end

						function cheat:pause(state)
							if state == true then
								if cheat.value then
									cheat:toggleState()
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
									cheat.checkboxbutton.Visible = not state
									cheat.paused = true
								else
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
									cheat.checkboxbutton.Visible = not state
								end
							else
								cheat.checkboxbutton.Visible = true
								if cheat.paused then
									cheat:toggleState()
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_checked}):Play()
									cheat.paused = nil
								else
									game.TweenService:Create(cheat.outerbox, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_outer}):Play()
									game.TweenService:Create(cheat.checkboxbutton, TweenInfo.new(0.2), {ImageColor3 = theme.checkbox_inner}):Play()
								end
							end
						end

						function cheat:PauseAllCheats(state)
							for _,v in next, finity.checkbox_cache do
								v:pause(state)
							end
						end

						cheat.checkboxbutton.Parent = cheat.outerbox
                        cheat.outerbox.Parent = cheat.container
                    elseif kind:find("color") then
                        cheat.value = Color3.new(1, 1, 1);
						cheat.lastclick = nil

						if data then
							if data.color then
								cheat.value = data.color
							end
                        end

                        local hsvimage = "rbxassetid://4613607014"
                        local lumienceimage = "rbxassetid://4613627894"

                        cheat.hsvbar = finity:Create("ImageButton", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Name = "HSVBar",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 6),
							ZIndex = 2,
                            Image = hsvimage
                        })

                        cheat.arrowpreview = finity:Create("ImageLabel", {
                            Name = "ArrowPreview",
                            BackgroundColor3 = Color3.new(1, 1, 1),
                            BackgroundTransparency = 1,
                            ImageTransparency = 0.25,
                            Position = UDim2.new(0.5, 0, 0.5, -6),
                            Size = UDim2.new(0, 6, 0, 6),
                            ZIndex = 3,
                            Image = "rbxassetid://2500573769",
                            Rotation = -90
                        })
						cheat.hsvbar.Activated:Connect(function(_, clickCount)
							if clickCount == 1 then
								cheat.rainbow = true
							else
								cheat.rainbow = false
							end
							print(cheat.rainbow)
							while cheat.rainbow and wait() do
								cheat.value = Color3.fromHSV(tick() % 5 / 5, 1, 1)
								callback(cheat.value)
							end
						end)
                        cheat.hsvbar.MouseButton1Down:Connect(function()
							cheat.lastclick = nil
							cheat.rainbow = false
                            local rs = game:GetService("RunService")
                            local uis = game:GetService("UserInputService")
							local last = cheat.value;

                            cheat.hsvbar.Image = hsvimage

                            while uis:IsMouseButtonPressed'MouseButton1' do
                                local mouseloc = uis:GetMouseLocation()
                                local sx = cheat.arrowpreview.AbsoluteSize.X / 2;
                                local offset = (mouseloc.x - cheat.hsvbar.AbsolutePosition.X) - sx
                                local scale = offset / cheat.hsvbar.AbsoluteSize.X
                                local position = clamp(offset, -sx, cheat.hsvbar.AbsoluteSize.X - sx) / cheat.hsvbar.AbsoluteSize.X

                                game.TweenService:Create(cheat.arrowpreview, TweenInfo.new(0.1), {Position = UDim2.new(position, 0, 0.5, -6)}):Play()

                                cheat.value = Color3.fromHSV(clamp(scale, 0, 1), 1, 1)

                                if cheat.value ~= last then
                                    last = cheat.value

                                    if callback then
                                        local s, e = pcall(function()
                                            callback(cheat.value)
                                        end)

                                        if not s then warn(traceback().." - error:  : ".. e) end
                                    end
                                end

                                rs.RenderStepped:wait()
                            end
                        end)
                        cheat.hsvbar.MouseButton2Down:Connect(function()
                            local rs = game.RunService
                            local uis = game.UserInputService
                            local last = cheat.value;

                            cheat.hsvbar.Image = lumienceimage

                            while uis:IsMouseButtonPressed'MouseButton2' do
                                local mouseloc = uis:GetMouseLocation()
                                local sx = cheat.arrowpreview.AbsoluteSize.X / 2
                                local offset = (mouseloc.x - cheat.hsvbar.AbsolutePosition.X) - sx
                                local scale = offset / cheat.hsvbar.AbsoluteSize.X
                                local position = clamp(offset, -sx, cheat.hsvbar.AbsoluteSize.X - sx) / cheat.hsvbar.AbsoluteSize.X

                                game.TweenService:Create(cheat.arrowpreview, TweenInfo.new(0.1), {Position = UDim2.new(position, 0, 0.5, -6)}):Play()

                                cheat.value = Color3.fromHSV(1, 0, 1 - clamp(scale, 0, 1))

                                if cheat.value ~= last then
                                    last = cheat.value

                                    if callback then
                                        local s, e = pcall(function()
                                            callback(cheat.value)
                                        end)

                                        if not s then warn(traceback().." - error:  : ".. e) end
                                    end
                                end

                                rs.RenderStepped:wait()
                            end
                        end)

						cheat.hsvbar.Parent = cheat.container
						cheat.arrowpreview.Parent = cheat.hsvbar
					elseif kind == "dropdown" then
						if data then
							if data.default then
								cheat.value = data.default
							elseif data.options then
								cheat.value = data.options[1]
							else
								cheat.value = "None"
							end
						end

						local options

						if data.options then
							options = data.options
						end

						cheat.dropped = false

						cheat.dropdown = finity:Create("ImageButton", {
							Name = "Dropdown",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.dropdown_background,
							ImageTransparency = data.transparency or 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.selected = finity:Create("TextLabel", {
							Name = "Selected",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0, 0),
							Size = UDim2.new(1, -35, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = tostring(cheat.value),
							RichText = true,
							TextColor3 = theme.dropdown_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left
						})

						cheat.list = finity:Create("ScrollingFrame", {
							Name = "List",
							BackgroundColor3 = Color3.fromRGB(60,60,62),
							BackgroundTransparency = data.transparency or 0.15,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 1, 0),
							Size = UDim2.new(1, 0, 0, 100),
							ZIndex = 3,
							BottomImage = "rbxassetid://967852042",
							MidImage = "rbxassetid://967852042",
							TopImage = "rbxassetid://967852042",
							ScrollBarThickness = 4,
							VerticalScrollBarInset = Enum.ScrollBarInset.None,
							ScrollBarImageColor3 = theme.dropdown_scrollbar_color
						})

						local uilistlayout = finity:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 2)
						})
						uilistlayout.Parent = cheat.list
						uilistlayout = nil
						local uipadding = finity:Create("UIPadding", {
							PaddingLeft = UDim.new(0, 2)
						})
						uipadding.Parent = cheat.list
						uipadding = nil

						local function refreshOptions()
							if cheat.dropped then
								cheat.fadelist()
							end

							for _, child in next, cheat.list:GetChildren() do
								if child:IsA("TextButton") then
									child:Destroy()
								end
							end

							for _, value in next, options do
								local button = finity:Create("TextButton", {
									BackgroundColor3 = Color3.new(1, 1, 1),
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 20),
									ZIndex = 3,
									Font = Enum.Font.Gotham,
									Text = (type(value) == 'table' and data.DisplayIndex) and value[data.DisplayIndex] or value,
									RichText = true,
									TextColor3 = theme.dropdown_text,
									TextSize = 13
								})

								button.Parent = cheat.list

								button.MouseEnter:Connect(function()
									game.TweenService:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
								end)
								button.MouseLeave:Connect(function()
									game.TweenService:Create(button, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
								end)
								button.MouseButton1Click:Connect(function()
									if cheat.dropped then
										cheat.value = type(value) == 'table' and data.DisplayIndex and value[data.DisplayIndex] or value
										cheat.selected.Text = type(value) == 'table' and data.DisplayIndex and value[data.DisplayIndex] or value

										cheat.fadelist()

										if callback then
											local s, e = pcall(function()
												callback(cheat.value, value)
											end)

											if not s then warn(traceback().." - error:  : ".. e) end
										end
									end
								end)


								game.TweenService:Create(button, TweenInfo.new(0), {TextTransparency = 1}):Play()
							end

							game.TweenService:Create(cheat.list, TweenInfo.new(0), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, cheat.list["UIListLayout"].AbsoluteContentSize.Y), ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
						end
						cheat.refreshOptions = refreshOptions

						function cheat.fadelist()
							cheat.dropped = not cheat.dropped

							if cheat.dropped then
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										game.TweenService:Create(button, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
									end
								end

								game.TweenService:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, clamp(cheat.list["UIListLayout"].AbsoluteContentSize.Y, 0, 150)), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 0, BackgroundTransparency = data.transparency or 0.15}):Play()
							else
								for _, button in next, cheat.list:GetChildren() do
									if button:IsA("TextButton") then
										game.TweenService:Create(button, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
									end
								end

								game.TweenService:Create(cheat.list, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), ScrollBarImageTransparency = 1, BackgroundTransparency = 1}):Play()
							end
						end

						cheat.dropdown.MouseEnter:Connect(function()
							game.TweenService:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text_hover}):Play()
						end)
						cheat.dropdown.MouseLeave:Connect(function()
							game.TweenService:Create(cheat.selected, TweenInfo.new(0.1), {TextColor3 = theme.dropdown_text}):Play()
						end)
						cheat.dropdown.MouseButton1Click:Connect(function()
							cheat.fadelist()
						end)

						refreshOptions()

						function cheat:RemoveOption(value)
							local removed = false
							for index, option in next, options do
								if option == value then
									table.remove(options, index)
									removed = true
									break
								end
							end

							if removed then
								refreshOptions()
							end

							return removed
						end

						function cheat:AddOption(value)
							table.insert(options, value)

							refreshOptions()
						end

						function cheat:SetValue(value)
							cheat.selected.Text = value
							cheat.value = value

							if cheat.dropped then
								cheat.fadelist()
							end

							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn(traceback().." - error:  : ".. e) end
							end
						end

						cheat.selected.Parent = cheat.dropdown
						cheat.dropdown.Parent = cheat.container
						cheat.list.Parent = cheat.container
					elseif kind == "textbox" then
						local placeholdertext = data.placeholder
						cheat.value = data.default

						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.textbox_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.textbox = finity:Create("TextBox", {
							Name = "Textbox",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "",
							TextColor3 = theme.textbox_text,
							RichText = true,
							PlaceholderText = placeholdertext or "Value",
							TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            ClearTextOnFocus = false
						})

						cheat.background.MouseEnter:Connect(function()
							game.TweenService:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text_hover}):Play()
						end)
						cheat.background.MouseLeave:Connect(function()
							game.TweenService:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text}):Play()
						end)
						cheat.textbox.Focused:Connect(function()
							typing = true

							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.textbox_background_hover}):Play()
						end)
						cheat.textbox.FocusLost:Connect(function()
							typing = false

							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.textbox_background}):Play()
							game.TweenService:Create(cheat.textbox, TweenInfo.new(0.1), {TextColor3 = theme.textbox_text}):Play()

							cheat.value = cheat.textbox.Text

							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn(traceback().." - error:  : "..e) end
							end
						end)
						if callback and cheat.value then
							local s, e = pcall(callback, cheat.value)
							if not s then
								warn('error: '..e)
							end
						end
						cheat.background.Parent = cheat.container
						cheat.textbox.Parent = cheat.container
					elseif kind == "slider" then
						cheat.value = data.default or 0

						local suffix = data.suffix or ""
						local minimum = data.min or 0
						local maximum = data.max or 1

						local moveconnection
						local releaseconnection

						function cheat:UpdateMin(Min)
							minimum = Min or 0
							cheat.value = data.default or 0
						end

						function cheat:UpdateMax(Max)
							maximum = Max or 0
							cheat.value = data.default or 0
						end

						function cheat:UpdateDefault(Default)
							Default = Default or 0
							data.default = Default
							cheat.value = Default
						end

						cheat.sliderbar = finity:Create("ImageButton", {
							Name = "Sliderbar",
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 6),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.slider_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02,
						})

						cheat.numbervalue = finity:Create("TextLabel", {
							Name = "Value",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 5, 0.5, 0),
							Size = UDim2.new(1, 0, 0, 13),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							TextXAlignment = Enum.TextXAlignment.Left,
							Text = "",
							TextTransparency = 1,
							TextColor3 = theme.slider_text,
							TextSize = 13,
							RichText = true
						})

						cheat.visiframe = finity:Create("ImageLabel", {
							Name = "Frame",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(0.5, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.slider_color,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.sliderbar.MouseButton1Down:Connect(function()
							local size = clamp(mouse.X - cheat.sliderbar.AbsolutePosition.X, 0, 150)
							local percent = size / 150

							cheat.value = floor((minimum + (maximum - minimum) * percent) * 100) / 100
							cheat.numbervalue.Text = tostring(cheat.value) .. suffix

							if callback then
								local s, e = pcall(function()
									callback(cheat.value)
								end)

								if not s then warn(traceback().." - error:  : ".. e) end
							end

							game.TweenService:Create(cheat.visiframe, TweenInfo.new(0.1), {
								Size = UDim2.new(size / 150, 0, 1, 0),
								ImageColor3 = theme.slider_color_sliding
							}):Play()

							game.TweenService:Create(cheat.numbervalue, TweenInfo.new(0.1), {
								Position = UDim2.new(size / 150, 5, 0.5, 0),
								TextTransparency = 0
							}):Play()

							moveconnection = mouse.Move:Connect(function()
								local size = clamp(mouse.X - cheat.sliderbar.AbsolutePosition.X, 0, 150)
								local percent = size / 150

								cheat.value = floor((minimum + (maximum - minimum) * percent) * 100) / 100
								cheat.numbervalue.Text = tostring(cheat.value) .. suffix

								if callback then
									local s, e = pcall(function()
										callback(cheat.value)
									end)

									if not s then warn(traceback().." - error:  : ".. e) end
								end

								game.TweenService:Create(cheat.visiframe, TweenInfo.new(0.1), {
									Size = UDim2.new(size / 150, 0, 1, 0),
								ImageColor3 = theme.slider_color_sliding
                                }):Play()

                                local Position = UDim2.new(size / 150, 5, 0.5, 0);

                                if Position.Width.Scale >= 0.6 then
                                    Position = UDim2.new(1, -cheat.numbervalue.TextBounds.X, 0.5, 10);
                                end

								game.TweenService:Create(cheat.numbervalue, TweenInfo.new(0.1), {
									Position = Position,
									TextTransparency = 0
								}):Play()
							end)

							releaseconnection = game.UserInputService.InputEnded:Connect(function(Mouse)
								if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then

									game.TweenService:Create(cheat.visiframe, TweenInfo.new(0.1), {
										ImageColor3 = theme.slider_color
									}):Play()

									game.TweenService:Create(cheat.numbervalue, TweenInfo.new(0.1), {
										TextTransparency = 1
									}):Play()

									moveconnection:Disconnect()
									moveconnection = nil
									releaseconnection:Disconnect()
									releaseconnection = nil
								end
							end)
						end)

						cheat.visiframe.Parent = cheat.sliderbar
						cheat.numbervalue.Parent = cheat.sliderbar
						cheat.sliderbar.Parent = cheat.container
					elseif kind == "button" and not cheat.override then
						local button_text = data.text

						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.button_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.button = finity:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = button_text or name,
							TextColor3 = theme.textbox_text,
							RichText = true,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Center,
						})

						cheat.button.MouseEnter:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
						end)
						cheat.button.MouseLeave:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
						end)
						cheat.button.MouseButton1Down:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
						end)
						cheat.button.MouseButton1Up:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()

							if callback then
								local s, e = pcall(function()
									callback()
								end)

								if not s then warn(traceback().." - error:  : ".. e) end
							end
						end)

						cheat.background.Parent = cheat.container
						cheat.button.Parent = cheat.container

					elseif kind:find("bind") then
                        local callback_bind = data.bind
                        local connection

						cheat.background = finity:Create("ImageLabel", {
							Name = "Background",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = theme.button_background,
							ImageTransparency = 0.5,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.02
						})

						cheat.button = finity:Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "Click to Bind",
							TextColor3 = theme.textbox_text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Center,
							RichText = true
						})

						cheat.button.MouseEnter:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_hover}):Play()
						end)
						cheat.button.MouseLeave:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
						end)
						cheat.button.MouseButton1Down:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
                        end)
                        cheat.button.MouseButton2Down:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background_down}):Play()
						end)
						cheat.button.MouseButton1Up:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()
							cheat.button.Text = "Press key..."
							connection = game.UserInputService.InputBegan:Connect(function(Input)
								if Input.UserInputType.Name == "Keyboard" and Input.KeyCode ~= Enum.KeyCode.Backspace then
                                    cheat.button.Text = "Bound to " .. tostring(Input.KeyCode.Name)
									connection:Disconnect()
									connection = nil
									callback_bind = Input.KeyCode
								end
							end)
                        end)
                        cheat.button.MouseButton2Up:Connect(function()
							game.TweenService:Create(cheat.background, TweenInfo.new(0.2), {ImageColor3 = theme.button_background}):Play()

							callback_bind = nil
                            cheat.button.Text = "Click to Bind"
                            if connection then
                                connection:Disconnect()
                                connection = nil
                            end
						end)


						game.UserInputService.InputBegan:Connect(function(Input, Process)
							if callback_bind and Input.KeyCode == callback_bind and not Process then
								if callback then
									local s, e = pcall(function()
										callback(Input.KeyCode)
									end)

									if not s then warn(traceback().." - error:  : ".. e) end
								end
							end
						end)

						if callback_bind then
							cheat.button.Text = "Bound to " .. tostring(callback_bind.Name)
						end

						cheat.background.Parent = cheat.container
						cheat.button.Parent = cheat.container
					end
				end

				cheat.frame.Parent = sector.container
				cheat.label.Parent = cheat.frame
				cheat.container.Parent = cheat.frame
				Features[name] = cheat
				sector.Cheats[name] = cheat
				return cheat
			end

			sector.frame.Parent = category[calculateSector()]
			sector.container.Parent = sector.frame
			sector.title.Parent = sector.frame
			return sector
		end

		firstCategory = false

		return category
	end

	self:addShadow(self2.container, 0)

	self2.categories.ClipsDescendants = true

	self2.userinterface.Parent = game.CoreGui

	self2.container.Parent = self2.userinterface
	self2.categories.Parent = self2.container
	self2.sidebar.Parent = self2.container
	self2.topbar.Parent = self2.container
	self2.tip.Parent = self2.topbar
	return self2, finityData
end

function finity:PauseAllCheats(state)
	for _,v in next, finity.checkbox_cache do
		v:pause(state)
	end
end

return finity
