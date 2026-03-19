-- Script: Floating Toggleable Menu (Arceus X Neo Compatible)
-- Create a beautiful, draggable floating button that toggles a stylish menu.
-- Features: rounded corners, gradients, smooth dragging, and example tabs.

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Determine GUI parent (use CoreGui if available, else fallback to PlayerGui)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ParentGui = CoreGui or Player:WaitForChild("PlayerGui")

-- Main GUI container
local Gui = Instance.new("ScreenGui")
Gui.Name = "FloatingMenu"
Gui.Parent = ParentGui
Gui.Enabled = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- Floating Button (draggable)
local FloatButton = Instance.new("TextButton")
FloatButton.Name = "FloatButton"
FloatButton.Size = UDim2.new(0, 60, 0, 60)
FloatButton.Position = UDim2.new(0, 50, 0, 100)
FloatButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FloatButton.BackgroundTransparency = 0.2
FloatButton.Text = "☰"  -- Menu icon
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 30
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Parent = Gui

-- Rounded corners for button
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)  -- Fully circular
ButtonCorner.Parent = FloatButton

-- Subtle gradient for button
local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 55))
})
ButtonGradient.Parent = FloatButton

-- Main Menu Frame (initially hidden)
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MainMenu"
MenuFrame.Size = UDim2.new(0, 350, 0, 450)
MenuFrame.Position = UDim2.new(0.5, -175, 0.5, -225)  -- Center
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BackgroundTransparency = 0.15
MenuFrame.Visible = false
MenuFrame.Parent = Gui

-- Rounded corners for menu
local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 15)
MenuCorner.Parent = MenuFrame

-- Menu gradient background
local MenuGradient = Instance.new("UIGradient")
MenuGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
})
MenuGradient.Parent = MenuFrame

-- Menu shadow (using ImageLabel with gradient)
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/ImageShadow.png"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.Parent = MenuFrame
Shadow.ZIndex = -1

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BackgroundTransparency = 0.2
TitleBar.Parent = MenuFrame

-- Rounded top corners only
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar
-- Make only top corners rounded
TitleBar.ClipsDescendants = true

-- Title text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✨  FLOATING MENU  ✨"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close button (inside title bar)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

-- Rounded close button
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Close button hover effect
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 100)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
end)

-- Tab buttons container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MenuFrame

-- Tab buttons
local Tabs = {"MAIN", "SETTINGS", "ABOUT"}
local TabButtons = {}
local ActiveTab = "MAIN"

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Size = UDim2.new(1/#Tabs, -5, 0, 35)
    btn.Position = UDim2.new((i-1)/#Tabs, 5 + (i-1)*5, 0, 7)
    btn.BackgroundColor3 = (tabName == "MAIN") and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(40, 40, 55)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    TabButtons[tabName] = btn
end

-- Content container (where tabs show different stuff)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -120)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.Parent = MenuFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Example content for each tab (we'll update visibility later)
local MainContent = Instance.new("Frame")
MainContent.Name = "MainContent"
MainContent.Size = UDim2.new(1, -10, 1, -10)
MainContent.Position = UDim2.new(0, 5, 0, 5)
MainContent.BackgroundTransparency = 1
MainContent.Parent = ContentFrame
MainContent.Visible = true  -- visible by default

local SettingsContent = Instance.new("Frame")
SettingsContent.Name = "SettingsContent"
SettingsContent.Size = UDim2.new(1, -10, 1, -10)
SettingsContent.Position = UDim2.new(0, 5, 0, 5)
SettingsContent.BackgroundTransparency = 1
SettingsContent.Parent = ContentFrame
SettingsContent.Visible = false

local AboutContent = Instance.new("Frame")
AboutContent.Name = "AboutContent"
AboutContent.Size = UDim2.new(1, -10, 1, -10)
AboutContent.Position = UDim2.new(0, 5, 0, 5)
AboutContent.BackgroundTransparency = 1
AboutContent.Parent = ContentFrame
AboutContent.Visible = false

-- Populate MainContent with some sample buttons
local function createButton(parent, name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 100)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
    end)
    
    return btn
end

createButton(MainContent, "Btn1", "🚀 Execute Function 1", 10)
createButton(MainContent, "Btn2", "⚡ Execute Function 2", 60)
createButton(MainContent, "Btn3", "💾 Save Config", 110)
createButton(MainContent, "Btn4", "🔄 Refresh", 160)

-- Settings content: just a slider placeholder
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, -20, 0, 30)
SliderLabel.Position = UDim2.new(0, 10, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Volume Slider (example)"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 16
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.Parent = SettingsContent

-- About content
local AboutLabel = Instance.new("TextLabel")
AboutLabel.Size = UDim2.new(1, -20, 1, -20)
AboutLabel.Position = UDim2.new(0, 10, 0, 10)
AboutLabel.BackgroundTransparency = 1
AboutLabel.Text = "Floating Menu v1.0\nCreated with Luau\nCompatible with Arceus X Neo"
AboutLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
AboutLabel.TextSize = 18
AboutLabel.Font = Enum.Font.Gotham
AboutLabel.TextWrapped = true
AboutLabel.Parent = AboutContent

-- Tab switching logic
for tabName, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Update active tab
        ActiveTab = tabName
        -- Reset all button colors
        for _, b in pairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
        end
        -- Highlight active
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 200)}):Play()
        
        -- Show corresponding content
        MainContent.Visible = (tabName == "MAIN")
        SettingsContent.Visible = (tabName == "SETTINGS")
        AboutContent.Visible = (tabName == "ABOUT")
    end)
end

-- Dragging functionality for floating button
local dragging = false
local dragStart, startPos

FloatButton.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = input.Position
    startPos = FloatButton.Position
    UserInputService.MouseIconEnabled = false  -- optional
end)

UserInputService.InputChanged:Connect(function(input, processed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        -- Keep button within screen bounds (optional)
        local absX = newPos.X.Offset
        local absY = newPos.Y.Offset
        local maxX = ParentGui.AbsoluteSize.X - FloatButton.AbsoluteSize.X
        local maxY = ParentGui.AbsoluteSize.Y - FloatButton.AbsoluteSize.Y
        absX = math.clamp(absX, 0, maxX)
        absY = math.clamp(absY, 0, maxY)
        newPos = UDim2.new(0, absX, 0, absY)
        
        FloatButton.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        dragging = false
        UserInputService.MouseIconEnabled = true
    end
end)

-- Toggle menu when floating button clicked
FloatButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    -- Optional: animate menu appearance
    if MenuFrame.Visible then
        MenuFrame.Size = UDim2.new(0, 0, 0, 0)  -- start small
        TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 350, 0, 450)}):Play()
    else
        TweenService:Create(MenuFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 350, 0, 450)}):Play()  -- keep size
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

-- Also close if user clicks outside? (optional, but can be added)

print("Floating menu loaded successfully!")
