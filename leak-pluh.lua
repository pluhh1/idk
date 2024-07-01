-- Load necessary libraries
Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vKhonshu/intro2/main/ui2"))()
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vKhonshu/intro/main/ui"))()

NotifyLib.prompt('Notification', 'Created by: Pluh;', 5)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local isTouchEnabled = UserInputService.TouchEnabled
local isMouseEnabled = UserInputService.MouseEnabled
local isKeyboardEnabled = UserInputService.KeyboardEnabled
local isGamepadEnabled = UserInputService.GamepadEnabled

local Settings = {   
    pluh = {
        Enabled = true,
        Key = "v", -- for pc only 
        DOT = true,
        AIRSHOT = true,
        NOTIF = true,           
        Display = true,
        AUTOPRED = true,       
        Smoothness = 0.5,
        FOV = math.huge, -- Don't touch this
    }
}

local SelectedPart = "HumanoidRootPart"
local Prediction = true
local PredictionValue = 0.1357363

local CC = game:GetService("Workspace").CurrentCamera
local Plr
local enabled = false
local accomidationfactor = 0.136
local mouse = game.Players.LocalPlayer:GetMouse()
local data = game.Players:GetPlayers()

local placemarker = Instance.new("Part", game.Workspace)
placemarker.Material = Enum.Material.ForceField
placemarker.Reflectance = 0
placemarker.Shape = Enum.PartType.Ball
placemarker.TopSurface = Enum.SurfaceType.Smooth
placemarker.BottomSurface = Enum.SurfaceType.Smooth
placemarker.FrontSurface = Enum.SurfaceType.Smooth
placemarker.BackSurface = Enum.SurfaceType.Smooth
placemarker.LeftSurface = Enum.SurfaceType.Smooth
placemarker.RightSurface = Enum.SurfaceType.Smooth

local hue = 0

-- Update function to change the part's color over time
RunService.Heartbeat:Connect(function(deltaTime)
    hue = (hue + deltaTime * 0.1) % 1
    local color = Color3.fromHSV(hue, 1, 1)
    placemarker.Color = color
end)

function makemarker(Parent, Adornee, Color, Size, Size2)
    local e = Instance.new("BillboardGui", Parent)
    e.Name = "PP"            
    e.Adornee = Adornee            
    e.Size = UDim2.new(Size, Size2, Size, Size2)            
    e.AlwaysOnTop = Settings.pluh.DOT
    local a = Instance.new("Frame", e)            
    if Settings.pluh.DOT == true then                
        a.Size = UDim2.new(2, 0, 2, 0)
    else
        a.Size = UDim2.new(0, 0, 0, 0)
    end
    if Settings.pluh.DOT == true then
        a.Transparency = 0                
        a.BackgroundTransparency = 0
    else
        a.Transparency = 1
        a.BackgroundTransparency = 1
    end
    a.BackgroundColor3 = Color
    local hue = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        hue = (hue + deltaTime * 0.1) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        a.BackgroundColor3 = color
    end)    
    local g = Instance.new("UICorner", a) 
        if Settings.pluh.DOT == false then
            g.CornerRadius = UDim.new(0, 0)
        else
            g.CornerRadius = UDim.new(1, 1) 
        end    
    return(e)
end

function noob(player)
    local character
    repeat wait() until player.Character
    local handler = makemarker(guimain, player.Character:WaitForChild(SelectedPart), Color3.fromRGB(0, 0, 0), 0.3, 3)
    handler.Name = player.Name            
    player.CharacterAdded:connect(function(Char) handler.Adornee = Char:WaitForChild(SelectedPart) end)
            
    spawn(function()                                
        while wait() do      
            if player.Character then
            end
        end
    end)
end

for i = 1, #data do
    if data[i] ~= game.Players.LocalPlayer then
        noob(data[i])
    end
end

game.Players.PlayerAdded:connect(function(Player)
    noob(Player)
end)

spawn(function()
    placemarker.Anchored = true
    placemarker.CanCollide = false
    
    if Settings.pluh.DOT == true then
        placemarker.Size = Vector3.new(8, 8, 8)
    else
        placemarker.Size = Vector3.new(0, 0, 0)
    end
        
    placemarker.Transparency = 0.50
            
    if Settings.pluh.DOT then
        makemarker(placemarker, placemarker, Color3.fromRGB(255, 0, 0), 0.40, 0)
    end
end)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(k)
    if k == Settings.pluh.Key and Settings.pluh.Enabled then
        if enabled == true then
            enabled = false

            if Settings.pluh.NOTIF == true then
                Plr = FindNearestEnemy()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Unlocked",
                    Text = "Unlocked: "..tostring(Plr and Plr.Parent.Name or "No Target"),
                    Duration = 1.5,
                    Icon = "",
                    Button1 = "OK",
                })
            end
        else
            Plr = FindNearestEnemy()
            enabled = true
            if Settings.pluh.NOTIF == true then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Locked",
                    Text = "Locked on "..tostring(Plr and Plr.Parent.Name or "No Target"),
                    Duration = 2.5,
                    Icon = "",
                    Button1 = "OK",
                })
            end
        end
    end
end)

function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition =
        Vector2.new(
        game:GetService("GuiService"):GetScreenResolution().X / 2,
        game:GetService("GuiService"):GetScreenResolution().Y / 2
    )

    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= game.Players.LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport =
                    game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local lastNotificationTime = 0
local pingvalue = nil
local split = nil
local ping = nil

local function generatePredictionValue(ping)
    local baseValues = {
        {maxPing = 10, base = 0.1},
        {maxPing = 30, base = 0.11},
        {maxPing = 50, base = 0.12},
        {maxPing = 70, base = 0.13},
        {maxPing = 90, base = 0.14},
        {maxPing = 110, base = 0.15},
        {maxPing = 130, base = 0.16},
        {maxPing = 150, base = 0.17},
        {maxPing = 170, base = 0.18},
        {maxPing = 190, base = 0.19},
        {maxPing = 210, base = 0.20},
        {maxPing = 230, base = 0.21},
        {maxPing = 250, base = 0.22},
        -- Add more if needed
    }

    local predictionGenerator = 0.236
    for _, range in ipairs(baseValues) do
        if ping <= range.maxPing then
            predictionGenerator = range.base
            break
        end
    end

    local numberOfDigits = math.random(12, 15)
    predictionGenerator = tostring(predictionGenerator)
    for _ = 1, numberOfDigits do
        local randomDigit = tostring(math.random(0, 9))
        predictionGenerator = predictionGenerator .. randomDigit
    end

    return predictionGenerator
end
local lastNotificationTime = 0
game:GetService("RunService").Stepped:connect(function()
    if enabled and Plr and Plr.Parent and Plr.Parent:FindFirstChild("HumanoidRootPart") then
        placemarker.CFrame = CFrame.new(Plr.Position + (Plr.Velocity * accomidationfactor))
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    end
    if Settings.pluh.AUTOPRED == true then
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingvalue, '(')
        local ping = tonumber(split[1])

        local predictionValue = generatePredictionValue(ping)
        PredictionValue = tonumber(predictionValue)
    end
end)

-- Silent aim logic
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)        
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if enabled and getnamecallmethod() == "FireServer" and Settings.pluh.Enabled and Plr then            
        if args[2] == "UpdateMousePos" then        
            
            if Prediction == true then            
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position + (Plr.Velocity * PredictionValue)
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position + (Plr.Velocity * PredictionValue)
                end
                    
            else
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position
                end
            end  
                
        elseif args[2] == "MOUSE" then
                
            if Prediction == true then
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position + (Plr.Velocity * PredictionValue)
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position + (Plr.Velocity * PredictionValue)
                end
                    
            else
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position
                end            
            end
                
        elseif args[2] == "MousePos" then
            if Prediction == true then
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position + (Plr.Velocity * PredictionValue)
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position + (Plr.Velocity * PredictionValue)
                end
                    
            else
                if type(args[3]) == "table" then
                    args[3] = {
                        Plr.Position
                    }
                elseif type(args[3]) ~= "table" then
                    args[3] = Plr.Position
                end            
            end
        end                
        return old(unpack(args))            
    end                 
    return old(...)
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Notification",
    Text = "Loaded Pluh's Lock!",
    Duration = 5
})

-- GUI Code
local Pluh = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Logo = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local PingDisplay = Instance.new("TextLabel")
local PredictionDisplay = Instance.new("TextLabel")
local UIStroke = Instance.new("UIStroke") -- Create UIStroke

-- Properties
Pluh.Name = "Pluh"
Pluh.Parent = game.CoreGui
Pluh.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = Pluh
Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26) -- Updated color
Frame.BackgroundTransparency = 0.30 -- 25% opacity (1.0 - 0.25)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 202, 0, 70)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame
UIStroke.Parent = Frame -- Set parent to Frame
UIStroke.Thickness = 2 -- Thickness of the stroke
UIStroke.Transparency = 0.5 -- Semi-transparent stroke
UIStroke.Color = Color3.fromRGB(255, 255, 255) -- Initial color

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(51, 50, 50)
TextButton.BorderSizePixel = 0
TextButton.BackgroundTransparency = 0.40
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Position = UDim2.new(0.03, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 190, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Pluh Lock"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18.000
TextButton.TextWrapped = true

UICorner_2.Parent = TextButton

local state = false
local RunService = game:GetService("RunService")

TextButton.MouseButton1Click:Connect(function()
    state = not state
    if state then
        TextButton.Text = "Lock • On"
        enabled = true
        Plr = FindNearestEnemy()
        if Plr then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Locked onto:",
                Text = tostring(Plr.Parent.Name),
                Duration = 2
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "No target found",
                Text = "",
                Duration = 2
            })
        end
    else
        TextButton.Text = "Lock • Off"
        enabled = false
        Plr = nil
        game.StarterGui:SetCore("SendNotification", {
            Title = "Unlocked!",
            Text = "",
            Duration = 2
        })
    end

    if state then
        -- Create a looping RGB effect for UIStroke
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local t = tick() % 3
            local r = math.abs(math.sin(t * math.pi / 1.5))
            local g = math.abs(math.sin((t + 1) * math.pi / 1.5))
            local b = math.abs(math.sin((t + 2) * math.pi / 1.5))
            UIStroke.Color = Color3.new(r, g, b)
            
            if not state then
                connection:Disconnect()
                UIStroke.Color = Color3.fromRGB(255, 255, 255) -- Reset to white when turned off
            end
        end)
    end
end)

-- Small button for Camera Lock
local CamlockButton = Instance.new("TextButton")
CamlockButton.Parent = Pluh
CamlockButton.BackgroundColor3 = Color3.fromRGB(51, 50, 50)
CamlockButton.BorderSizePixel = 0
CamlockButton.BackgroundTransparency = 0.40
CamlockButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CamlockButton.Position = UDim2.new(0.75, 0, 0.18571429, 0)
CamlockButton.Size = UDim2.new(0, 30, 0, 30)
CamlockButton.Font = Enum.Font.SourceSansSemibold
CamlockButton.Text = "❌"
CamlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CamlockButton.TextScaled = true
CamlockButton.TextSize = 18.000
CamlockButton.TextWrapped = true
CamlockButton.Active = true
CamlockButton.Draggable = true

local CamlockState = false

CamlockButton.MouseButton1Click:Connect(function()
    CamlockState = not CamlockState
    if CamlockState then
        CamlockButton.Text = "📷"
        Notify({
            Description = "Camera Lock Enabled",
            Title = "Notification",
            Duration = 5,
        })
    else
        CamlockButton.Text = "❌"
        Notify({
            Description = "Camera Lock Disabled",
            Title = "Notification",
            Duration = 5,
        })
    end
end)

-- Combined Display for Ping and Prediction
local CombinedDisplay = Instance.new("TextLabel")
CombinedDisplay.Parent = Pluh -- Set parent to Pluh for screen-wide positioning
CombinedDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CombinedDisplay.BackgroundTransparency = 1.000
CombinedDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
CombinedDisplay.BorderSizePixel = 0
CombinedDisplay.AnchorPoint = Vector2.new(0.5, 1) -- Anchor point set to bottom center
CombinedDisplay.Position = UDim2.new(0.5, 0, 0.68, 0) -- Moved further up
CombinedDisplay.Size = UDim2.new(0, 150, 0, 10)
CombinedDisplay.Font = Enum.Font.GothamBold
CombinedDisplay.Text = "Ping: 0 | Prediction: N/A"
CombinedDisplay.TextScaled = true
CombinedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
CombinedDisplay.TextSize = 2.000 -- Smaller text size
CombinedDisplay.TextWrapped = true
CombinedDisplay.Visible = getgenv().ShowDisplay -- Set visibility based on getgenv()

-- Function to update the Ping and Prediction Display
local function updateDisplay()
    while true do
        if Settings.pluh.Display then
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            CombinedDisplay.Text = "Ping: " .. tostring(ping) .. " | Prediction: " .. tostring(PredictionValue)
            CombinedDisplay.Visible = true -- Ensure it's visible when ShowDisplay is true
        else
            CombinedDisplay.Visible = false -- Hide when ShowDisplay is false
        end
        wait(1) -- Update every second
    end
end

-- Start updating the Combined Display in a separate thread
coroutine.wrap(updateDisplay)()

local EnableResolver = Instance.new("TextButton")
EnableResolver.Parent = Frame -- Set parent to Frame
EnableResolver.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EnableResolver.BackgroundTransparency = 1.000
EnableResolver.BorderSizePixel = 0
EnableResolver.Position = UDim2.new(0, 0, 1, 0) -- Positioned below the existing content within the frame
EnableResolver.Size = UDim2.new(1, 0, 0, 20)
EnableResolver.Font = Enum.Font.Gotham
EnableResolver.Text = "Resolver Enabled!"
EnableResolver.TextColor3 = Color3.fromRGB(0, 0, 0) -- Text color set to black
EnableResolver.TextScaled = true
EnableResolver.TextSize = 14.000
EnableResolver.TextWrapped = true
EnableResolver.AutoButtonColor = false

local resolverConnection

local function updateResolver()
    if enabled and Plr then
        local hrp = Plr.Parent and Plr.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lastPosition = hrp.Position
            task.wait()
            local currentPosition = hrp.Position
            local velocity = (currentPosition - lastPosition) * 0
            hrp.AssemblyLinearVelocity = velocity
            hrp.Velocity = velocity
        end
    end
end

-- Resolver logic integrated with aimlock
RunService.Heartbeat:Connect(updateResolver)

-- Velocity Changer logic
local LP = game.Players.LocalPlayer
local Character = LP.Character
local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:FindFirstChild("HumanoidRootPart")
end)

local RVelocity

RunService.Heartbeat:Connect(function()
    if getgenv().VelocityChanger then
        if not RootPart or not RootPart.Parent then
            RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        else
            RVelocity = RootPart.Velocity
            RootPart.Velocity = getgenv().Velocity
            RunService.RenderStepped:Wait()
            RootPart.Velocity = RVelocity
        end
    end
end)

-- Resolver to prevent flinging players
RunService.Heartbeat:Connect(function()
    pcall(function()
        for _, player in ipairs(game.Players:GetChildren()) do
            if player.Name ~= LP.Name then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end
        end
    end)
end)

-- Hide loading screen after a certain duration
local function HideLoadingScreen()
    LoadingScreen:Destroy()
end

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;
Notify({
    Description = "Made by ;Pluh";
    Title = "https://discord.com/invite/gKrH43kPZB";
    Duration = 15;
})

-- Camera lock logic
getgenv().Pred = 0.290

RunService.Heartbeat:Connect(function()
    if enabled and Plr then
        if CamlockState then
            local camera = workspace.CurrentCamera
            local targetPosition = Plr.Position + Plr.Velocity * getgenv().Pred
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.p, targetPosition)
            local smoothness = Settings.pluh.Smoothness or 0.5

            camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
        end
    end
end)
