local words = {
    ".",
    "ate xx",
    "pooron 💋",
    "luv the aim xx",
    "ew",
    "BYE-",
    "GN WHAT-,
    "LOL",
    "HELP LOL",
    "lol",
    "GN THE AIM-",
    "tapped xx",
    "sit down 💋",
    "sleep well xx",
}

local player = game.Players.LocalPlayer
local event = game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest

-- Create the ScreenGui
local pluh = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local negar = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

-- Properties:
pluh.Name = "pluh"
pluh.Parent = game.CoreGui
pluh.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Add UICorner to negar for rounded corners
local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 10) -- Adjust the value for more or less rounded corners
UICorner_2.Parent = negar

-- negar
negar.Parent = pluh
negar.Name = "negar"
negar.BorderSizePixel = 0
negar.Active = true
negar.Draggable = true
negar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Full black background
negar.BackgroundTransparency = 0.0 -- No transparency
negar.BorderColor3 = Color3.fromRGB(255, 255, 255) -- Border color white
negar.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
negar.Size = UDim2.new(0, 90, 0, 30)
negar.Font = Enum.Font.SourceSansSemibold
negar.Text = "🗑️🗣️"
negar.TextColor3 = Color3.fromRGB(255, 255, 255) -- Text color white
negar.TextScaled = true
negar.TextSize = 14.000
negar.TextWrapped = true

-- Connect the button's MouseButton1Click event to the function
negar.MouseButton1Click:Connect(function()
    event:FireServer(words[math.random(#words)], "All")
end)
