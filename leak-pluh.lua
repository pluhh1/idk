local Webhook = "https://discord.com/api/webhooks/1261958258688524409/J2P8vUMxLuSPCu1pWISMRw6W43qcKz780nJ7Y31Tt67wkqdwDZKFV-NPSDrKYYzF00E1" -- Put your Webhook link here
local Headers = {["content-type"] = "application/json"} -- DO NOT TOUCH
local HttpService = game:GetService("HttpService")

-- Function to calculate the account age in days
local function getAccountAge(player)
    return player.AccountAge
end

function identifyexploit()
   local ieSuccess, ieResult = pcall(identifyexecutor)
   if ieSuccess then return ieResult end
   
   return (SENTINEL_LOADED and "Sentinel") or (XPROTECT and "SirHurt") or (PROTOSMASHER_LOADED and "Protosmasher")
end

-- Function to send a webhook notification with the player's status
local function sendWebhook(status)
    local Player = game:GetService("Players").LocalPlayer
    local PlayerName = Player.Name
    local DisplayName = Player.DisplayName
    local UserId = Player.UserId
    local LogTime = os.date('!%Y-%m-%d | %H:%M', os.time() + 8 * 60 * 60) -- Adjusted for GMT+8
    local AccountAge = getAccountAge(Player)
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local JoinLink = "https://www.roblox.com/home?placeId=" .. PlaceId .. "&gameId=" .. JobId -- Link to join the player's current game
    local ProfileLink = "https://www.roblox.com/users/" .. UserId .. "/profile" -- Link to the player's profile

    -- Player data to be sent in the webhook
    local PlayerData = {
        ["content"] = "",
        ["embeds"] = {{
            ["author"] = {
                ["name"] = "  Currently Using Pluh V3",
            },
            ["title"] =  "**" .. PlayerName .. "**", -- Username/PlayerName
            ["description"] = "aka "..DisplayName, -- Display Name/Nickname
            ["color"] = tonumber("00FFFF", 16), -- Light blue color in decimal
            ["fields"] = {
                {
                    ["name"] = "**Username:**",
                    ["value"] = "" .. PlayerName .. "",
                    ["inline"] = true
                },
                {
                    ["name"] = "**UserId:**",
                    ["value"] = "" .. UserId .. "",
                    ["inline"] = true
                },
                {
                    ["name"] = "**Log Time:**",
                    ["value"] = "" .. LogTime .. "",
                    ["inline"] = true
                },
                {
                    ["name"] = "**Account Age:**",
                    ["value"] = "" .. AccountAge .. " days",
                    ["inline"] = true
                },
                                {
                    --[[Exploit/Executor]]--
                    ["name"] = "Executor: ",
                    ["value"] = identifyexploit(),
                    ["inline"] = true
                },
                {
                    ["name"] = "**Status:**",
                    ["value"] = "" .. status .. "",
                    ["inline"] = true
                },  
                {
                    ["name"] = "**Join Player:**",
                    ["value"] = "[Click here to join](" .. JoinLink .. ")",
                    ["inline"] = true
                },
                {
                    ["name"] = "**Player Profile:**",
                    ["value"] = "[Click here to view profile](" .. ProfileLink .. ")",
                    ["inline"] = true
                },
            },
        }}
    }

    -- Encode the player data to JSON
    local PlayerData = HttpService:JSONEncode(PlayerData)
    local HttpRequest = http_request or (syn and syn.request)
    
    -- Send the HTTP request
    if HttpRequest then
        HttpRequest({
            Url = Webhook,
            Body = PlayerData,
            Method = "POST",
            Headers = Headers
        })
    else
        warn("HTTP request function is not available.")
    end
end

-- Connect to the PlayerAdded event
game:GetService("Players").PlayerAdded:Connect(function(player)
    if player == game:GetService("Players").LocalPlayer then
        sendWebhook("🟢 Playing")
    end
end)

-- Connect to the PlayerRemoving event
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game:GetService("Players").LocalPlayer then
        sendWebhook("🔴 Not Playing")
    end
end)

-- Initial send when the script is first executed
sendWebhook("🟢 Playing")
