local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local attack = false
local teleportEnabled = false

local function teleportPlayerBehind(humanoid)
    local humanoidRootPart = humanoid.Parent:FindFirstChild("HumanoidRootPart")
    local playerCharacter = LocalPlayer.Character

    if humanoidRootPart and playerCharacter then
        local playerTorso = playerCharacter:FindFirstChild("HumanoidRootPart")
        if playerTorso then
            local newPosition = humanoidRootPart.Position - (humanoidRootPart.CFrame.LookVector * 5)
            playerCharacter:SetPrimaryPartCFrame(CFrame.new(newPosition))
        end
    end
end

local function onKeyPress(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.T then
        teleportEnabled = not teleportEnabled
        attack = teleportEnabled
        warn(teleportEnabled, "K")
    end
end

local function getClosestEnemy()
    local closestEnemy = nil
    local closestDistance = math.huge

    for _, descendant in pairs(game:GetService("Workspace")["副本地图"]:GetDescendants()) do
        if descendant:IsA("Model") and descendant:FindFirstChild("HumanoidRootPart") and descendant:FindFirstChild("Head") then
            local humanoid = descendant:FindFirstChildOfClass("Humanoid")
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - descendant.HumanoidRootPart.Position).magnitude

            if humanoid and humanoid.Health > 0 and distance < closestDistance and not Players:GetPlayerFromCharacter(descendant) then
                closestEnemy = humanoid
                closestDistance = distance
            end
        end
    end

    return closestEnemy
end

local function continuousTeleport()
    while true do
        task.wait()
        if teleportEnabled then
            local closestEnemy = getClosestEnemy()
            if closestEnemy then
                teleportPlayerBehind(closestEnemy)
                task.wait()
                local button = game:GetService("VirtualInputManager")
                local keysToPress = {"Z", "X", "C"}
                for _, key in ipairs(keysToPress) do
                    button:SendKeyEvent(true, key, false, game)
                    task.wait()
                    button:SendKeyEvent(false, key, false, game)
                end
            end
        end
    end
end

local function mouse1click()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local X, Y = 0, 0
    while task.wait(0.5) do
        if attack then  
            VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 1)
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPress)
coroutine.wrap(continuousTeleport)()


mouse1click()
print("script loaded")
