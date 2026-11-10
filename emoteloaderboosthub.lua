-- FarmieHub.lua
local WindUI = loadstring(game:HttpGet("https://tree-hub.luau.site/flags/WindUI.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Farmie Hub",
    Icon = "rocket",
    Author = "Client Instrumentation",
    Folder = "FarmieHubConfig",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Light",
    SideBarWidth = 200,
    HasOutline = true
})

local Tabs = {
    Automation = Window:Tab({ Title = "Farm Automation", Icon = "rbxassetid://4483345998" })
}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Flags = {
    AutoTween = false,
    UndergroundFarm = false,
    TweenSpeed = 21,
    UndergroundOffset = 3
}

local ActiveTween = nil
local UndergroundConnection = nil

local function GetCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hrp, hum
end

local function GetTargetCoin()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Coin_Server" and (obj:IsA("BasePart") or obj:IsA("Model")) then
            return obj
        end
    end
    return nil
end

local function GetTargetCFrame(target)
    if target:IsA("BasePart") then
        return target.CFrame
    elseif target:IsA("Model") then
        return target:GetPivot()
    end
    return nil
end

local function StopTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
end

-- Main Automation Loop
task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoTween and not Flags.UndergroundFarm then
            local hrp, hum = GetCharacterParts()
            if hrp and hum and hum.Health > 0 then
                local coin = GetTargetCoin()
                if coin then
                    local targetCF = GetTargetCFrame(coin)
                    if targetCF then
                        local dist = (hrp.Position - targetCF.Position).Magnitude
                        local duration = math.clamp(dist / Flags.TweenSpeed, 0.1, 100)
                        
                        StopTween()
                        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                        ActiveTween = TweenService:Create(hrp, tweenInfo, { CFrame = targetCF })
                        ActiveTween:Play()
                        
                        repeat
                            task.wait(0.1)
                        until not Flags.AutoTween or not coin.Parent or (hrp.Position - targetCF.Position).Magnitude < 3
                    end
                end
            else
                StopTween()
            end
        else
            if not Flags.UndergroundFarm then
                StopTween()
            end
        end
    end
end)

-- Underground Loop
local function StartUnderground()
    if UndergroundConnection then UndergroundConnection:Disconnect() end
    UndergroundConnection = RunService.Heartbeat:Connect(function()
        if not Flags.UndergroundFarm then return end
        local hrp, hum = GetCharacterParts()
        if not hrp or not hum or hum.Health <= 0 then return end
        
        local coin = GetTargetCoin()
        if coin then
            local targetCF = GetTargetCFrame(coin)
            if targetCF then
                StopTween()
                local underPos = targetCF.Position - Vector3.new(0, Flags.UndergroundOffset, 0)
                hrp.CFrame = CFrame.new(underPos) * targetCF.Rotation
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

local function StopUnderground()
    if UndergroundConnection then
        UndergroundConnection:Disconnect()
        UndergroundConnection = nil
    end
end

Tabs.Automation:Section({ Title = "Tween Configurations" })

Tabs.Automation:Toggle({
    Title = "Auto Tween to Coin_Server",
    Default = false,
    Callback = function(state)
        Flags.AutoTween = state
        if not state then StopTween() end
    end
})

Tabs.Automation:Toggle({
    Title = "Underground Farm (Head Reach)",
    Default = false,
    Callback = function(state)
        Flags.UndergroundFarm = state
        if state then
            StopTween()
            StartUnderground()
        else
            StopUnderground()
        end
    end
})

Tabs.Automation:Slider({
    Title = "Tween Speed",
    Min = 5,
    Max = 21,
    Default = 21,
    Callback = function(value)
        Flags.TweenSpeed = math.clamp(value, 5, 21)
    end
})

Tabs.Automation:Slider({
    Title = "Underground Depth (Offset)",
    Min = 1,
    Max = 3,
    Default = 3,
    Callback = function(value)
        Flags.UndergroundOffset = math.clamp(value, 1, 3)
    end
})
