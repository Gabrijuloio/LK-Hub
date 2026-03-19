-- Script: Troll Menu Supremo (Arceus X Neo Compatible)
-- Um menu flutuante com funções troll para zoar com os amigos no Roblox.
-- Divirta-se com moderação! (Ou não.)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chat = game:GetService("Chat")
local CoreGui = game:GetService("CoreGui")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Head = Character:WaitForChild("Head")

-- GUI parent (CoreGui para executors que permitem, senão PlayerGui)
local ParentGui = CoreGui or Player:WaitForChild("PlayerGui")

-- Main GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "TrollMenu"
Gui.Parent = ParentGui
Gui.Enabled = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

-- Variáveis de estado para funções toggle
local TrollStates = {
    InvertControls = false,
    Tiny = false,
    Giant = false,
    Rainbow = false,
    LoopJump = false,
    ScreenShake = false,
    FollowMouse = false,
    SpamChat = false,
    Invisible = false,
    Freeze = false,
    Gravity = false,
    NoClip = false,
    -- Adicione mais estados aqui
}

-- Conexões para loop (RunService)
local LoopConnections = {}

-- === FUNÇÕES TROLL ===

-- 1. Dançar (emote aleatório)
local function Dance()
    local emotes = {"rbxasset://animations/dance.zip", "rbxasset://animations/dance2.zip", "rbxasset://animations/dance3.zip"} -- só exemplos, use IDs reais se quiser
    -- No Roblox, para tocar animação precisa carregar Animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://123456789" -- Substitua por um ID de animação de dança real
    local track = Humanoid:LoadAnimation(anim)
    track:Play()
    task.wait(5)
    track:Stop()
end

-- 2. Ficar pequeno
local function SetTiny()
    TrollStates.Tiny = not TrollStates.Tiny
    if TrollStates.Tiny then
        Humanoid.HeadScale = 0.5
        Humanoid.BodyProportionScale = 0.5
        Humanoid.BodyWidthScale = 0.5
        Humanoid.BodyDepthScale = 0.5
    else
        Humanoid.HeadScale = 1
        Humanoid.BodyProportionScale = 1
        Humanoid.BodyWidthScale = 1
        Humanoid.BodyDepthScale = 1
    end
end

-- 3. Ficar gigante
local function SetGiant()
    TrollStates.Giant = not TrollStates.Giant
    if TrollStates.Giant then
        Humanoid.HeadScale = 2
        Humanoid.BodyProportionScale = 2
        Humanoid.BodyWidthScale = 2
        Humanoid.BodyDepthScale = 2
    else
        Humanoid.HeadScale = 1
        Humanoid.BodyProportionScale = 1
        Humanoid.BodyWidthScale = 1
        Humanoid.BodyDepthScale = 1
    end
end

-- 4. Inverter controles
UserInputService.InputBegan:Connect(function(input, processed)
    if TrollStates.InvertControls and not processed then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then
                Humanoid:Move(Vector3.new(0,0,-1), false)
            elseif input.KeyCode == Enum.KeyCode.S then
                Humanoid:Move(Vector3.new(0,0,1), false)
            elseif input.KeyCode == Enum.KeyCode.A then
                Humanoid:Move(Vector3.new(1,0,0), false)
            elseif input.KeyCode == Enum.KeyCode.D then
                Humanoid:Move(Vector3.new(-1,0,0), false)
            end
        end
    end
end)
local function ToggleInvert()
    TrollStates.InvertControls = not TrollStates.InvertControls
    if TrollStates.InvertControls then
        -- Já tratado no InputBegan
    end
end

-- 5. Spam de mensagem no chat
local function SpamChatFunc()
    TrollStates.SpamChat = not TrollStates.SpamChat
    if TrollStates.SpamChat then
        LoopConnections.SpamChat = RunService.Heartbeat:Connect(function()
            local args = {
                [1] = "EU SOU UM TROLL! HAHAHA!",
                [2] = "All"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
            task.wait(0.5)
        end)
    else
        if LoopConnections.SpamChat then
            LoopConnections.SpamChat:Disconnect()
            LoopConnections.SpamChat = nil
        end
    end
end

-- 6. Arco-íris (mudar cor do personagem)
local function RainbowFunc()
    TrollStates.Rainbow = not TrollStates.Rainbow
    if TrollStates.Rainbow then
        LoopConnections.Rainbow = RunService.Heartbeat:Connect(function()
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.random()
                end
            end
        end)
    else
        if LoopConnections.Rainbow then
            LoopConnections.Rainbow:Disconnect()
            LoopConnections.Rainbow = nil
        end
    end
end

-- 7. Pulo infinito
local function ToggleLoopJump()
    TrollStates.LoopJump = not TrollStates.LoopJump
    if TrollStates.LoopJump then
        LoopConnections.LoopJump = RunService.Heartbeat:Connect(function()
            Humanoid.Jump = true
            task.wait(0.3)
            Humanoid.Jump = false
            task.wait(0.1)
        end)
    else
        if LoopConnections.LoopJump then
            LoopConnections.LoopJump:Disconnect()
            LoopConnections.LoopJump = nil
        end
    end
end

-- 8. Tremor de tela (shake)
local function ScreenShakeFunc()
    TrollStates.ScreenShake = not TrollStates.ScreenShake
    if TrollStates.ScreenShake then
        local camera = Workspace.CurrentCamera
        LoopConnections.ScreenShake = RunService.RenderStepped:Connect(function()
            local shake = Vector3.new(math.random(-1,1), math.random(-1,1), 0) * 2
            camera.CFrame = camera.CFrame + shake
        end)
    else
        if LoopConnections.ScreenShake then
            LoopConnections.ScreenShake:Disconnect()
            LoopConnections.ScreenShake = nil
        end
    end
end

-- 9. Seguir o mouse (fly to mouse)
local function FollowMouseFunc()
    TrollStates.FollowMouse = not TrollStates.FollowMouse
    if TrollStates.FollowMouse then
        LoopConnections.FollowMouse = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local unitRay = Workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
            local targetPos = unitRay.Origin + unitRay.Direction * 10
            local root = Humanoid.RootPart
            if root then
                root.CFrame = CFrame.new(targetPos)
            end
        end)
    else
        if LoopConnections.FollowMouse then
            LoopConnections.FollowMouse:Disconnect()
            LoopConnections.FollowMouse = nil
        end
    end
end

-- 10. Invisível
local function InvisibleFunc()
    TrollStates.Invisible = not TrollStates.Invisible
    for _, part in ipairs(Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = TrollStates.Invisible and 1 or 0
        end
    end
end

-- 11. Congelar (imobilizar)
local function FreezeFunc()
    TrollStates.Freeze = not TrollStates.Freeze
    local root = Humanoid.RootPart
    if root then
        root.Anchored = TrollStates.Freeze
    end
    Humanoid.PlatformStand = TrollStates.Freeze
end

-- 12. Gravidade zero (local)
local function ZeroGravity()
    TrollStates.Gravity = not TrollStates.Gravity
    local root = Humanoid.RootPart
    if root then
        root.Velocity = Vector3.new(0, TrollStates.Gravity and 0 or Workspace.Gravity, 0)
        -- Para manter gravidade zero, precisamos aplicar força contrária constantemente?
        -- Melhor usar BodyForce
        if TrollStates.Gravity then
            local bf = Instance.new("BodyForce")
            bf.Force = Vector3.new(0, Workspace.Gravity * root:GetMass(), 0)
            bf.Parent = root
            LoopConnections.Gravity = bf
        else
            if LoopConnections.Gravity then
                LoopConnections.Gravity:Destroy()
                LoopConnections.Gravity = nil
            end
        end
    end
end

-- 13. NoClip (atravessar paredes)
local function NoClipFunc()
    TrollStates.NoClip = not TrollStates.NoClip
    if TrollStates.NoClip then
        LoopConnections.NoClip = RunService.Stepped:Connect(function()
            local root = Humanoid.RootPart
            if root then
                root.CanCollide = false
            end
        end)
    else
        if LoopConnections.NoClip then
            LoopConnections.NoClip:Disconnect()
            LoopConnections.NoClip = nil
        end
        local root = Humanoid.RootPart
        if root then
            root.CanCollide = true
        end
    end
end

-- 14. Explodir em confetes
local function ConfettiExplosion()
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Position = Character.PrimaryPart.Position
    part.Anchored = true
    part.Transparency = 1
    part.Parent = Workspace

    for i = 1, 50 do
        local confetti = Instance.new("Part")
        confetti.Size = Vector3.new(0.2, 0.2, 0.2)
        confetti.Position = part.Position + Vector3.new(math.random(-10,10), math.random(0,20), math.random(-10,10))
        confetti.BrickColor = BrickColor.random()
        confetti.Shape = Enum.PartType.Ball
        confetti.Material = Enum.Material.Neon
        confetti.Velocity = Vector3.new(math.random(-50,50), math.random(50,100), math.random(-50,50))
        confetti.Parent = Workspace
        game:GetService("Debris"):AddItem(confetti, 5)
    end
    part:Destroy()
end

-- 15. Spawnar banana (faz tropeçar)
local function SpawnBanana()
    local banana = Instance.new("Part")
    banana.Size = Vector3.new(0.5, 0.2, 0.2)
    banana.Position = Character.PrimaryPart.Position + Vector3.new(0, -3, 0)
    banana.BrickColor = BrickColor.new("Bright yellow")
    banana.Material = Enum.Material.SmoothPlastic
    banana.Anchored = false
    banana.CanCollide = true
    banana.Parent = Workspace

    -- Script para fazer escorregar
    local script = Instance.new("Script")
    script.Source = [[
        script.Parent.Touched:Connect(function(hit)
            local hum = hit.Parent:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                wait(1)
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                script.Parent:Destroy()
            end
        end)
    ]]
    script.Parent = banana
end

-- 16. Teleporte aleatório
local function RandomTeleport()
    local pos = Vector3.new(math.random(-500,500), math.random(50,200), math.random(-500,500))
    local root = Humanoid.RootPart
    if root then
        root.CFrame = CFrame.new(pos)
    end
end

-- 17. Spam de som "Oof"
local function SpamOof()
    for i = 1, 10 do
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/uuhhh.mp3" -- som padrão de dano, mas troque por ID de oof
        sound.Parent = Head
        sound:Play()
        task.wait(0.1)
        sound:Destroy()
    end
end

-- 18. Fazer um clone seguir
local function CreateClone()
    local clone = Character:Clone()
    clone.Parent = Workspace
    clone.Humanoid.DisplayName = "Clone Troll"
    clone.PrimaryPart = clone.HumanoidRootPart
    clone:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame * CFrame.new(0,0,5))
    local cloneHum = clone.Humanoid
    -- Fazer clone seguir o jogador
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if cloneHum and cloneHum.Health > 0 then
            local targetPos = Character.PrimaryPart.Position
            local root = clone.HumanoidRootPart
            if root then
                root.CFrame = CFrame.lookAt(root.Position, targetPos)
                cloneHum:MoveTo(targetPos)
            end
        else
            connection:Disconnect()
            clone:Destroy()
        end
    end)
end

-- 19. Inverter cores da tela (post-effect) - difícil sem efeitos, mas podemos usar ScreenGui com cor?
-- 20. Mandar mensagem falsa de admin
local function FakeAdminMessage()
    local msg = Instance.new("Message")
    msg.Text = "ADMIN: " .. Player.Name .. " foi banido por trollagem!"
    msg.Parent = Workspace
    game:GetService("Debris"):AddItem(msg, 5)
end

-- 21. Fazer todos os jogadores dançarem (se possível via RemoteEvent? Talvez não)
-- Vamos pular alguns que dependem de outros jogadores

-- 22. Mudar a música do jogo (se houver SoundService)
local function ChangeMusic()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1837609655" -- Rickroll
    sound.Volume = 1
    sound.Looped = true
    sound.Parent = Workspace
    sound:Play()
    task.wait(10)
    sound:Stop()
    sound:Destroy()
end

-- 23. Fazer o personagem sentar em uma cadeira invisível
local function ForceSit()
    local seat = Instance.new("Part")
    seat.Size = Vector3.new(2, 0.5, 2)
    seat.Position = Character.PrimaryPart.Position + Vector3.new(0, -2, 0)
    seat.Anchored = true
    seat.Transparency = 1
    seat.CanCollide = false
    seat.Parent = Workspace
    local weld = Instance.new("Weld")
    weld.Part0 = Character.PrimaryPart
    weld.Part1 = seat
    weld.Parent = seat
    Humanoid.Sit = true
    task.wait(3)
    weld:Destroy()
    seat:Destroy()
    Humanoid.Sit = false
end

-- 24. Fazer chover vacas (spawnar parts de vaca)
local function CowRain()
    for i = 1, 20 do
        local cow = Instance.new("Part")
        cow.Size = Vector3.new(1, 1, 2)
        cow.Position = Character.PrimaryPart.Position + Vector3.new(math.random(-30,30), 50, math.random(-30,30))
        cow.BrickColor = BrickColor.new("Brown")
        cow.Shape = Enum.PartType.Block
        cow.Velocity = Vector3.new(math.random(-20,20), -50, math.random(-20,20))
        cow.Parent = Workspace
        game:GetService("Debris"):AddItem(cow, 10)
    end
end

-- 25. Fazer o jogador falar frases engraçadas (usando Chat)
local function SayRandom()
    local frases = {
        "Eu sou um pão de queijo!",
        "Alguém viu meu controle?",
        "Mamãe, estou na TV!",
        "Sou um pato disfarçado.",
        "O Roblox é meu quintal.",
        "Vou virar youtuber.",
        "Comi muito feijão.",
        "Xô, peste!",
        "O Luba tá online?",
        "HUEHUEHUE BR",
    }
    local frase = frases[math.random(#frases)]
    local args = {[1] = frase, [2] = "All"}
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
end

-- === CRIAÇÃO DA INTERFACE ===

-- Botão flutuante
local FloatButton = Instance.new("TextButton")
FloatButton.Name = "FloatButton"
FloatButton.Size = UDim2.new(0, 60, 0, 60)
FloatButton.Position = UDim2.new(0, 50, 0, 100)
FloatButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FloatButton.BackgroundTransparency = 0.2
FloatButton.Text = "😂"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 40
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Parent = Gui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = FloatButton

-- Menu principal
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MainMenu"
MenuFrame.Size = UDim2.new(0, 500, 0, 400)
MenuFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.Visible = false
MenuFrame.Parent = Gui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 15)
MenuCorner.Parent = MenuFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.Parent = MenuFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar
TitleBar.ClipsDescendants = true

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🎉  MENU TROLL SUPREMO  🎉"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MenuFrame

local Tabs = {"PLAYER", "MUNDO", "DIVERSÃO", "CHAT"}
local TabButtons = {}
local ActiveTab = "PLAYER"

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Size = UDim2.new(1/#Tabs, -5, 0, 30)
    btn.Position = UDim2.new((i-1)/#Tabs, 5 + (i-1)*5, 0, 5)
    btn.BackgroundColor3 = (tabName == ActiveTab) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(40, 40, 55)
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

-- Frame de conteúdo
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.ScrollBarThickness = 8
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MenuFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- Layout para organizar os botões
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ContentFrame

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = ContentFrame

-- Função para criar botões dentro da ScrollingFrame
local function CreateButton(parent, text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 450, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 100)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Efeito hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 140)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or Color3.fromRGB(70, 70, 100)}):Play()
    end)
end

-- Preencher abas
local function PopulateTab(tabName)
    -- Limpar conteúdo anterior
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if tabName == "PLAYER" then
        CreateButton(ContentFrame, "Dançar", Dance)
        CreateButton(ContentFrame, "Pequeno (Toggle)", SetTiny, Color3.fromRGB(100, 150, 100))
        CreateButton(ContentFrame, "Gigante (Toggle)", SetGiant, Color3.fromRGB(150, 100, 100))
        CreateButton(ContentFrame, "Inverter Controles (Toggle)", ToggleInvert, Color3.fromRGB(200, 100, 100))
        CreateButton(ContentFrame, "Arco-íris (Toggle)", RainbowFunc, Color3.fromRGB(255, 200, 100))
        CreateButton(ContentFrame, "Pulo Infinito (Toggle)", ToggleLoopJump)
        CreateButton(ContentFrame, "Seguir Mouse (Toggle)", FollowMouseFunc)
        CreateButton(ContentFrame, "Invisível (Toggle)", InvisibleFunc)
        CreateButton(ContentFrame, "Congelar (Toggle)", FreezeFunc)
        CreateButton(ContentFrame, "Gravidade Zero (Toggle)", ZeroGravity)
        CreateButton(ContentFrame, "NoClip (Toggle)", NoClipFunc)
        CreateButton(ContentFrame, "Teleporte Aleatório", RandomTeleport)
        CreateButton(ContentFrame, "Forçar Sentar", ForceSit)
    elseif tabName == "MUNDO" then
        CreateButton(ContentFrame, "Chover Vaca", CowRain)
        CreateButton(ContentFrame, "Explosão de Confete", ConfettiExplosion)
        CreateButton(ContentFrame, "Criar Banana", SpawnBanana)
        CreateButton(ContentFrame, "Criar Clone Seguidor", CreateClone)
        CreateButton(ContentFrame, "Tremor de Tela (Toggle)", ScreenShakeFunc)
        CreateButton(ContentFrame, "Tocar Música (Rickroll)", ChangeMusic)
    elseif tabName == "DIVERSÃO" then
        CreateButton(ContentFrame, "Spam de Som Oof", SpamOof)
        CreateButton(ContentFrame, "Mensagem Falsa de Admin", FakeAdminMessage)
        CreateButton(ContentFrame, "Falar Frase Aleatória", SayRandom)
        -- Adicione mais
    elseif tabName == "CHAT" then
        CreateButton(ContentFrame, "Spam de Chat (Toggle)", SpamChatFunc, Color3.fromRGB(200, 50, 50))
    end
end

-- Inicializar primeira aba
PopulateTab("PLAYER")

-- Troca de abas
for tabName, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        ActiveTab = tabName
        PopulateTab(tabName)
    end)
end

-- Arrastar botão flutuante
local dragging = false
local dragStart, startPos

FloatButton.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = input.Position
    startPos = FloatButton.Position
end)

UserInputService.InputChanged:Connect(function(input, processed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        -- Limitar à tela
        local maxX = ParentGui.AbsoluteSize.X - FloatButton.AbsoluteSize.X
        local maxY = ParentGui.AbsoluteSize.Y - FloatButton.AbsoluteSize.Y
        newPos = UDim2.new(0, math.clamp(newPos.X.Offset, 0, maxX), 0, math.clamp(newPos.Y.Offset, 0, maxY))
        FloatButton.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        dragging = false
    end
end)

-- Toggle menu ao clicar no botão
FloatButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    if MenuFrame.Visible then
        -- Animação de aparecer
        MenuFrame.Size = UDim2.new(0, 0, 0, 0)
        MenuFrame.Visible = true
        TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 500, 0, 400)}):Play()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

-- Lidar com respawn do personagem
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Head = newChar:WaitForChild("Head")
    -- Reaplicar estados toggle que dependem do personagem? (opcional)
    -- Por simplicidade, não reaplicamos, mas poderíamos.
end)

print("Menu Troll carregado! Divirta-se (com responsabilidade) 😈")
