-- =====================================================================
-- BOOST HUB - LUXURY EDITION (NO UI LIBRARIES)
-- Designed for Roblox (Mobile & PC Compatible with Dragging, Minimizing, & Unload)
-- =====================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean up existing Boost Hub if already running
if CoreGui:FindFirstChild("BoostHubLuxury") then
    CoreGui.BoostHubLuxury:Destroy()
end
if PlayerGui:FindFirstChild("BoostHubLuxury") then
    PlayerGui.BoostHubLuxury:Destroy()
end

-- ScreenGui Setup (Protected if possible, fallback to PlayerGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoostHubLuxury"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

-- =====================================================================
-- DESIGN SYSTEM (Luxury Emerald & Dark Obsidian Theme)
-- =====================================================================
local Colors = {
    Background = Color3.fromRGB(12, 14, 18),
    CardBg = Color3.fromRGB(18, 22, 28),
    CardHover = Color3.fromRGB(24, 30, 38),
    Accent = Color3.fromRGB(16, 185, 129),       -- Emerald Green
    Danger = Color3.fromRGB(239, 68, 68),        -- Red Unload/Close
    TextPrimary = Color3.fromRGB(243, 244, 246),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(31, 41, 55),
    ElementBg = Color3.fromRGB(24, 30, 38)
}

-- =====================================================================
-- MAIN FRAME (Responsive for Mobile & PC)
-- =====================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Border
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- =====================================================================
-- TOP BAR (Title, Minimize, Red Unload Button)
-- =====================================================================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Colors.CardBg
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopBarCover = Instance.new("Frame")
TopBarCover.Size = UDim2.new(1, 0, 0, 10)
TopBarCover.Position = UDim2.new(0, 0, 1, -10)
TopBarCover.BackgroundColor3 = Colors.CardBg
TopBarCover.BorderSizePixel = 0
TopBarCover.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "BOOST <font color=\"#10B981\">HUB</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Colors.TextPrimary
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(0, 150, 1, 0)
SubtitleLabel.Position = UDim2.new(0, 115, 0, 2)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.Text = "LUXURY EDITION"
SubtitleLabel.TextColor3 = Colors.TextSecondary
SubtitleLabel.TextSize = 10
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = TopBar

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(0, 80, 1, 0)
ButtonContainer.Position = UDim2.new(1, -90, 0, 0)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = TopBar

local UIListLayout_Top = Instance.new("UIListLayout")
UIListLayout_Top.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Top.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout_Top.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout_Top.Padding = UDim.new(0, 8)
UIListLayout_Top.Parent = ButtonContainer

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.BackgroundColor3 = Colors.ElementBg
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Colors.TextPrimary
MinimizeBtn.TextSize = 16
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = ButtonContainer

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Colors.Border
MinStroke.Thickness = 1
MinStroke.Parent = MinimizeBtn

-- Unload Red Button (Destroys UI completely)
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Name = "UnloadBtn"
UnloadBtn.Size = UDim2.new(0, 30, 0, 30)
UnloadBtn.BackgroundColor3 = Colors.Danger
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.Text = "X"
UnloadBtn.TextColor3 = Colors.TextPrimary
UnloadBtn.TextSize = 14
UnloadBtn.AutoButtonColor = false
UnloadBtn.Parent = ButtonContainer

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 8)
UnloadCorner.Parent = UnloadBtn

-- =====================================================================
-- SIDEBAR NAVIGATION
-- =====================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Colors.CardBg
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BackgroundColor3 = Colors.Border
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.FillDirection = Enum.FillDirection.Vertical
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- =====================================================================
-- CONTENT AREA & EMOTE PLAYER PAGE
-- =====================================================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -140, 1, -45)
ContentContainer.Position = UDim2.new(0, 140, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local EmotePage = Instance.new("ScrollingFrame")
EmotePage.Name = "EmotePage"
EmotePage.Size = UDim2.new(1, 0, 1, 0)
EmotePage.BackgroundTransparency = 1
EmotePage.BorderSizePixel = 0
EmotePage.CanvasSize = UDim2.new(0, 0, 0, 0)
EmotePage.ScrollBarThickness = 4
EmotePage.ScrollBarImageColor3 = Colors.Accent
EmotePage.Visible = true
EmotePage.Parent = ContentContainer

local EmotePageLayout = Instance.new("UIListLayout")
EmotePageLayout.FillDirection = Enum.FillDirection.Vertical
EmotePageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
EmotePageLayout.SortOrder = Enum.SortOrder.LayoutOrder
EmotePageLayout.Padding = UDim.new(0, 12)
EmotePageLayout.Parent = EmotePage

local EmotePagePadding = Instance.new("UIPadding")
EmotePagePadding.PaddingTop = UDim.new(0, 15)
EmotePagePadding.PaddingBottom = UDim.new(0, 15)
EmotePagePadding.Parent = EmotePage

local EmoteHeader = Instance.new("Frame")
EmoteHeader.Size = UDim2.new(1, -30, 0, 40)
EmoteHeader.BackgroundColor3 = Colors.CardBg
EmoteHeader.Parent = EmotePage

local EHCorner = Instance.new("UICorner")
EHCorner.CornerRadius = UDim.new(0, 8)
EHCorner.Parent = EmoteHeader

local EHStroke = Instance.new("UIStroke")
EHStroke.Color = Colors.Border
EHStroke.Parent = EmoteHeader

local EHTitle = Instance.new("TextLabel")
EHTitle.Size = UDim2.new(1, -16, 1, 0)
EHTitle.Position = UDim2.new(0, 16, 0, 0)
EHTitle.BackgroundTransparency = 1
EHTitle.Font = Enum.Font.GothamBold
EHTitle.Text = "✨ LUXURY EMOTE PLAYER"
EHTitle.TextColor3 = Colors.Accent
EHTitle.TextSize = 13
EHTitle.TextXAlignment = Enum.TextXAlignment.Left
EHTitle.Parent = EmoteHeader

-- Emote Selector Box
local SelectorBox = Instance.new("Frame")
SelectorBox.Size = UDim2.new(1, -30, 0, 50)
SelectorBox.BackgroundColor3 = Colors.CardBg
SelectorBox.Parent = EmotePage

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 8)
SBCorner.Parent = SelectorBox

local SBStroke = Instance.new("UIStroke")
SBStroke.Color = Colors.Border
SBStroke.Parent = SelectorBox

local SelectedEmoteLabel = Instance.new("TextLabel")
SelectedEmoteLabel.Size = UDim2.new(1, -116, 1, 0)
SelectedEmoteLabel.Position = UDim2.new(0, 16, 0, 0)
SelectedEmoteLabel.BackgroundTransparency = 1
SelectedEmoteLabel.Font = Enum.Font.GothamMedium
SelectedEmoteLabel.Text = "Selected: None"
SelectedEmoteLabel.TextColor3 = Colors.TextPrimary
SelectedEmoteLabel.TextSize = 13
SelectedEmoteLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedEmoteLabel.Parent = SelectorBox

local DropdownToggle = Instance.new("TextButton")
DropdownToggle.Size = UDim2.new(0, 90, 0, 32)
DropdownToggle.Position = UDim2.new(1, -98, 0.5, -16)
DropdownToggle.BackgroundColor3 = Colors.ElementBg
DropdownToggle.Font = Enum.Font.GothamBold
DropdownToggle.Text = "Select ▼"
DropdownToggle.TextColor3 = Colors.Accent
DropdownToggle.TextSize = 12
DropdownToggle.AutoButtonColor = false
DropdownToggle.Parent = SelectorBox

local DTCorner = Instance.new("UICorner")
DTCorner.CornerRadius = UDim.new(0, 6)
DTCorner.Parent = DropdownToggle

local DTStroke = Instance.new("UIStroke")
DTStroke.Color = Colors.Border
DTStroke.Parent = DropdownToggle

-- Emote Dropdown List
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Name = "DropdownList"
DropdownList.Size = UDim2.new(1, -30, 0, 130)
DropdownList.BackgroundColor3 = Colors.CardBg
DropdownList.BorderSizePixel = 0
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4
DropdownList.ScrollBarImageColor3 = Colors.Accent
DropdownList.Visible = false
DropdownList.ZIndex = 5
DropdownList.Parent = EmotePage

local DLCorner = Instance.new("UICorner")
DLCorner.CornerRadius = UDim.new(0, 8)
DLCorner.Parent = DropdownList

local DLStroke = Instance.new("UIStroke")
DLStroke.Color = Colors.Accent
DLStroke.Parent = DropdownList

local DLLayout = Instance.new("UIListLayout")
DLLayout.SortOrder = Enum.SortOrder.LayoutOrder
DLLayout.Parent = DropdownList

-- Play Button positioned at the bottom of the section
local PlayButton = Instance.new("TextButton")
PlayButton.Size = UDim2.new(1, -30, 0, 48)
PlayButton.BackgroundColor3 = Colors.Accent
PlayButton.Font = Enum.Font.GothamBold
PlayButton.Text = "▶ PLAY EMOTE"
PlayButton.TextColor3 = Colors.Background
PlayButton.TextSize = 14
PlayButton.AutoButtonColor = false
PlayButton.Parent = EmotePage

local PBCorner = Instance.new("UICorner")
PBCorner.CornerRadius = UDim.new(0, 8)
PBCorner.Parent = PlayButton

-- Dashboard Page
local DashboardPage = Instance.new("ScrollingFrame")
DashboardPage.Name = "DashboardPage"
DashboardPage.Size = UDim2.new(1, 0, 1, 0)
DashboardPage.BackgroundTransparency = 1
DashboardPage.Visible = false
DashboardPage.Parent = ContentContainer

local DashboardLayout = Instance.new("UIListLayout")
DashboardLayout.FillDirection = Enum.FillDirection.Vertical
DashboardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
DashboardLayout.Padding = UDim.new(0, 12)
DashboardLayout.Parent = DashboardPage

local DashPadding = Instance.new("UIPadding")
DashPadding.PaddingTop = UDim.new(0, 15)
DashPadding.Parent = DashboardPage

local WelcomeCard = Instance.new("Frame")
WelcomeCard.Size = UDim2.new(1, -30, 0, 90)
WelcomeCard.BackgroundColor3 = Colors.CardBg
WelcomeCard.Parent = DashboardPage

local WCCorner = Instance.new("UICorner")
WCCorner.CornerRadius = UDim.new(0, 8)
WCCorner.Parent = WelcomeCard

local WCStroke = Instance.new("UIStroke")
WCStroke.Color = Colors.Border
WCStroke.Parent = WelcomeCard

local WCTitle = Instance.new("TextLabel")
WCTitle.Size = UDim2.new(1, -32, 0, 30)
WCTitle.Position = UDim2.new(0, 16, 0, 12)
WCTitle.BackgroundTransparency = 1
WCTitle.Font = Enum.Font.GothamBold
WCTitle.Text = "Welcome to Boost Hub"
WCTitle.TextColor3 = Colors.TextPrimary
WCTitle.TextSize = 15
WCTitle.TextXAlignment = Enum.TextXAlignment.Left
WCTitle.Parent = WelcomeCard

local WCDesc = Instance.new("TextLabel")
WCDesc.Size = UDim2.new(1, -32, 0, 35)
WCDesc.Position = UDim2.new(0, 16, 0, 42)
WCDesc.BackgroundTransparency = 1
WCDesc.Font = Enum.Font.GothamMedium
WCDesc.Text = "Engineered with a luxury obsidian & emerald aesthetic. Fully responsive for Mobile & PC with zero external dependencies."
WCDesc.TextColor3 = Colors.TextSecondary
WCDesc.TextSize = 11
WCDesc.TextWrapped = true
WCDesc.TextXAlignment = Enum.TextXAlignment.Left
WCDesc.Parent = WelcomeCard

-- Tab Builder
local function createTab(name, pageInstance, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = isDefault and Colors.ElementBg or Colors.CardBg
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = isDefault and Colors.Accent or Colors.TextSecondary
    TabBtn.TextSize = 12
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = Sidebar

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 8)
    TBCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Colors.CardBg
                btn.TextColor3 = Colors.TextSecondary
            end
        end
        pageInstance.Visible = true
        TabBtn.BackgroundColor3 = Colors.ElementBg
        TabBtn.TextColor3 = Colors.Accent
    end)
end

createTab("Dashboard", DashboardPage, false)
createTab("Emote Player", EmotePage, true)

-- =====================================================================
-- EMOTES DATA & LOGIC (Updated with full requested list)
-- =====================================================================
local emotes = {
    {Name = "Floating Aura", ID = 79795305221612},
    {Name = "Monkey", ID = 3716636630},
    {Name = "Curtsy", ID = 4646306583},
    {Name = "Godlike", ID = 3823158750},
    {Name = "Helicopter", ID = 110553756436163},
    {Name = "Happy", ID = 4849499887},
    {Name = "TWICE The Feels", ID = 12874468267},
    {Name = "Baby Queen - Bouncy Twirl", ID = 14353423348},
    {Name = "Rat Dance", ID = 83606297144428},
    {Name = "Plane", ID = 134913783169182},
    {Name = "Sleep", ID = 4689362868},
    {Name = "Tank", ID = 85076031433488},
    {Name = "Hero Landing", ID = 5104377791},
    {Name = "Shy", ID = 3576717965},
    {Name = "Car", ID = 115407270129592},
    {Name = "Floss Dance", ID = 5917570207},
    {Name = "Sit", ID = 129668542320076},
    {Name = "Quiet Waves", ID = 7466046574},
    {Name = "Fake MM2 Death", ID = 107498554725527},
    {Name = "Yungblud Happier Jump", ID = 15610015346},
    {Name = "Baby Dance", ID = 4272484885},
    {Name = "Baby Queen - Face Frame", ID = 14353421343},
    {Name = "Box", ID = 73500261613116},
    {Name = "Top Rock", ID = 3570535774},
    {Name = "Hide", ID = 84868707350198},
    {Name = "Baby Queen - Strut", ID = 14353425085},
    {Name = "Bored", ID = 5230661597},
    {Name = "KATSEYE - Touch", ID = 139021427684680},
    {Name = "Dog", ID = 84198855496510},
    {Name = "L Dance", ID = 73039500693145},
    {Name = "Ragdoll Push", ID = 91452077708399},
    {Name = "Take The L", ID = 75633408126191},
    {Name = "Fry Dance", ID = 124799741487022},
    {Name = "Twirl", ID = 3716633898},
    {Name = "Fashionable", ID = 3576745472},
    {Name = "Line Dance", ID = 4049646104},
    {Name = "Cower", ID = 4940597758},
    {Name = "High Wave", ID = 5915776835},
    {Name = "Worm", ID = 108956933782219},
    {Name = "TWICE Feel Special", ID = 14900153406},
    {Name = "V Pose", ID = 10214418283},
    {Name = "Lotus Position", ID = 12507097350},
    {Name = "Frosty Flair", ID = 10214406616},
    {Name = "Effortless Aura Pose", ID = 101573394483995},
    {Name = "HOT TO GO!", ID = 79312439851071},
    {Name = "Dolphin Dance", ID = 5938365243},
    {Name = "Old Town Road Dance", ID = 5938394742},
    {Name = "Phase", ID = 79653736088166},
    {Name = "Sturdy Dance", ID = 17746270218},
    {Name = "Piano Hands", ID = 16553249658},
    {Name = "Around Town", ID = 3576747102},
    {Name = "Head Bop", ID = 15554010118},
    {Name = "Celebrate", ID = 3994127840},
    {Name = "SHAKE", ID = 132367660388476},
    {Name = "Show Dem Wrists", ID = 7202898984},
    {Name = "Side to Side", ID = 3762641826},
    {Name = "Dorky Dance", ID = 4212499637},
    {Name = "Cute Levitating", ID = 101601077005248},
    {Name = "TWICE LIKEY", ID = 14900151704},
    {Name = "Chill Bounce", ID = 132112297758791},
    {Name = "Telekinesis Head Floating Aura", ID = 81666519067619},
    {Name = "Hornet's Spider Dance", ID = 74716792202343},
    {Name = "Spiderman Hang", ID = 108635834286627},
    {Name = "Shuffle", ID = 4391208058},
    {Name = "Fancy Feet", ID = 3934988903},
    {Name = "Dizzy", ID = 3934986896},
    {Name = "TWICE What Is Love", ID = 13344121112},
    {Name = "Jamal Brazil Groove", ID = 104131847054135},
    {Name = "HOLIDAY Dance", ID = 5938396308},
    {Name = "Hip Sway", ID = 80963950541052}
}

local selectedEmoteId = nil

local function populateEmotes()
    for _, item in pairs(DropdownList:GetChildren()) do
        if item:IsA("TextButton") then
            item:Destroy()
        end
    end

    for i, emote in ipairs(emotes) do
        local EmoteOpt = Instance.new("TextButton")
        EmoteOpt.Size = UDim2.new(1, 0, 0, 36)
        EmoteOpt.BackgroundColor3 = Colors.CardBg
        EmoteOpt.Font = Enum.Font.GothamMedium
        EmoteOpt.Text = "  " .. emote.Name
        EmoteOpt.TextColor3 = Colors.TextPrimary
        EmoteOpt.TextSize = 12
        EmoteOpt.TextXAlignment = Enum.TextXAlignment.Left
        EmoteOpt.AutoButtonColor = false
        EmoteOpt.LayoutOrder = i
        EmoteOpt.Parent = DropdownList

        EmoteOpt.MouseButton1Click:Connect(function()
            selectedEmoteId = emote.ID
            SelectedEmoteLabel.Text = "Selected: " .. emote.Name
            DropdownList.Visible = false
            DropdownToggle.Text = "Select ▼"
        end)
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #emotes * 36)
end

populateEmotes()

DropdownToggle.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    DropdownToggle.Text = DropdownList.Visible and "Select ▲" or "Select ▼"
end)

PlayButton.MouseButton1Click:Connect(function()
    if not selectedEmoteId then
        SelectedEmoteLabel.Text = "⚠ Please select an emote first!"
        task.wait(1.5)
        SelectedEmoteLabel.Text = "Selected: None"
        return
    end

    pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(selectedEmoteId)
            local track = humanoid:LoadAnimation(anim)
            track:Play()
        end
    end)
end)

-- =====================================================================
-- MOBILE & PC DRAGGING SUPPORT
-- =====================================================================
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- =====================================================================
-- MINIMIZE & UNLOAD LOGIC
-- =====================================================================
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Sidebar.Visible = not isMinimized
    ContentContainer.Visible = not isMinimized
    
    local targetSize = isMinimized and UDim2.new(0, 560, 0, 45) or UDim2.new(0, 560, 0, 380)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    MinimizeBtn.Text = isMinimized and "+" or "-"
end)

-- Red Unload Button (Destroys the UI entirely)
UnloadBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Boost Hub Luxury Loaded Successfully with All Emotes!")
