-- ============================================================================
--               BOOST HUB - CUSTOM DARK-RED MOBILE UI (NO KEY)
-- ============================================================================
​local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
​local LocalPlayer = Players.LocalPlayer
​-- GAME CHECK VERIFICATION
local TARGET_PLACE_ID = 12069083555
if game.PlaceId ~= TARGET_PLACE_ID then
warn("[Boost Hub] Wrong Game! Expected PlaceId: " .. tostring(TARGET_PLACE_ID))
end
​-- GLOBAL CONFIG STORAGE
getgenv().BoostHubConfig = getgenv().BoostHubConfig or {
AutoCatClick = false,
AutoRNG = false,
AutoGoal = false,
AutoCollectOrbs = false,
AutoBeg = false,
AutoClaimStand = false,
AntiBanEnabled = true,
AutoChatSpam = false,
Disable3DRender = false,
WalkSpeed = 16,
JumpPower = 50,
CatClickDelay = 100,
RNGDelay = 15,
AutoAvoidObstacles = true,
AutoBegMultiChat = true,
TimedServerHop = false,
TimedHopDelay = 15
}
​getgenv().CatClickDelay = getgenv().BoostHubConfig.CatClickDelay / 1000
getgenv().RNGDelay = getgenv().BoostHubConfig.RNGDelay
getgenv().AntiBanEnabled = getgenv().BoostHubConfig.AntiBanEnabled
​-- STATE VARIABLES
local customAudioId = ""
local activeCustomSound = nil
local originalVolumes = {}
local morphTargetName = ""
local targetPlayerName = ""
local configInputName = "DefaultConfig"
local timedHopThread = nil
local timedHopMinutes = getgenv().BoostHubConfig.TimedHopDelay or 15
​local autoChatMessages = {
"Every robux is appreciated!",
"Thank for your donations! Goal is 5k",
"Any given amount will be appreciated!",
"My goal is to reach 5k and buy a new avatar!",
"Currently afk. Any given amount will be appreciated!"
}
​local autoBegSayEnabled = true
local autoBegMessageTemplate = "Hello %s, would you like to donate me? Any donation is highly appreciated :D"
local autoBegChatMessages = {
"Hello %s, would you like to donate me? Any donation is highly appreciated :D",
"Hey %s! Every robux helps me reach my goal!",
"Hi %s, spare some robux if you can please!",
"Hello %s, appreciate any donation you can give!",
"Hey %s! Goal is 5k, any bit helps out a lot!"
}
​-- ============================================================================
--                        CUSTOM DARK-RED UI ENGINE
-- ============================================================================
local ParentGui = (gethui and gethui()) or CoreGui
if ParentGui:FindFirstChild("BoostHubCustomUI") then
ParentGui.BoostHubCustomUI:Destroy()
end
​local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoostHubCustomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui
​-- COLOR PALETTE (Matches Dark-Red Screenshot Theme)
local Theme = {
BgMain = Color3.fromRGB(18, 13, 14),
BgSidebar = Color3.fromRGB(24, 17, 18),
BgCard = Color3.fromRGB(28, 20, 21),
BgElement = Color3.fromRGB(36, 25, 27),
BgHover = Color3.fromRGB(48, 32, 34),
Accent = Color3.fromRGB(205, 38, 48),
AccentDark = Color3.fromRGB(135, 22, 30),
TextPrimary = Color3.fromRGB(245, 240, 240),
TextSecondary = Color3.fromRGB(165, 150, 152),
Border = Color3.fromRGB(55, 35, 38),
ToggleOff = Color3.fromRGB(58, 42, 44),
Knob = Color3.fromRGB(255, 255, 255)
}
​-- NOTIFICATION SYSTEM
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "Notifications"
NotifyContainer.Size = UDim2.new(0, 260, 1, -20)
NotifyContainer.Position = UDim2.new(1, -270, 0, 10)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui
​local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.Parent = NotifyContainer
​local function Notify(title, content, duration)
duration = duration or 3.5
local card = Instance.new("Frame")
card.Size = UDim2.new(1, 0, 0, 62)
card.BackgroundColor3 = Theme.BgCard
card.BorderSizePixel = 0
card.Parent = NotifyContainer
​local corner = Instance.new("UICorner", card)
corner.CornerRadius = UDim.new(0, 8)
​local stroke = Instance.new("UIStroke", card)
stroke.Color = Theme.Accent
stroke.Thickness = 1.2
​local bar = Instance.new("Frame", card)
bar.Size = UDim2.new(0, 4, 1, -12)
bar.Position = UDim2.new(0, 6, 0, 6)
bar.BackgroundColor3 = Theme.Accent
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
​local tLabel = Instance.new("TextLabel", card)
tLabel.Size = UDim2.new(1, -24, 0, 20)
tLabel.Position = UDim2.new(0, 18, 0, 6)
tLabel.BackgroundTransparency = 1
tLabel.Font = Enum.Font.GothamBold
tLabel.TextSize = 13
tLabel.TextColor3 = Theme.TextPrimary
tLabel.TextXAlignment = Enum.TextXAlignment.Left
tLabel.Text = title
​local cLabel = Instance.new("TextLabel", card)
cLabel.Size = UDim2.new(1, -24, 0, 30)
cLabel.Position = UDim2.new(0, 18, 0, 26)
cLabel.BackgroundTransparency = 1
cLabel.Font = Enum.Font.Gotham
cLabel.TextSize = 11
cLabel.TextColor3 = Theme.TextSecondary
cLabel.TextXAlignment = Enum.TextXAlignment.Left
cLabel.TextYAlignment = Enum.TextYAlignment.Top
cLabel.TextWrapped = true
cLabel.Text = content
​task.delay(duration, function()
if card and card.Parent then
TweenService:Create(card, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
task.wait(0.25)
card:Destroy()
end
end)
end
​-- FLOATING MOBILE TOGGLE BUTTON
local MobileToggleBtn = Instance.new("TextButton")
MobileToggleBtn.Name = "MobileToggle"
MobileToggleBtn.Size = UDim2.new(0, 48, 0, 48)
MobileToggleBtn.Position = UDim2.new(0, 16, 0.5, -24)
MobileToggleBtn.BackgroundColor3 = Theme.BgMain
MobileToggleBtn.Text = "BH"
MobileToggleBtn.Font = Enum.Font.GothamBlack
MobileToggleBtn.TextSize = 16
MobileToggleBtn.TextColor3 = Theme.Accent
MobileToggleBtn.AutoButtonColor = false
MobileToggleBtn.Parent = ScreenGui
Instance.new("UICorner", MobileToggleBtn).CornerRadius = UDim.new(1, 0)
local mStroke = Instance.new("UIStroke", MobileToggleBtn)
mStroke.Color = Theme.Accent
mStroke.Thickness = 2
​-- MAIN WINDOW FRAME (Responsive for Mobile & PC)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Theme.BgMain
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 1.5
​-- Mobile Screen Auto-Scale
local UIScale = Instance.new("UIScale", MainFrame)
local function updateScale()
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
if vp.X < 620 or vp.Y < 410 then
UIScale.Scale = math.min((vp.X - 30) / 560, (vp.Y - 30) / 360)
else
UIScale.Scale = 1
end
end
updateScale()
if workspace.CurrentCamera then
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end
​-- DRAGGING SUPPORT (Touch + Mouse)
local function makeDraggable(dragHandle, targetFrame)
local dragging, dragInput, dragStart, startPos
dragHandle.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = targetFrame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)
dragHandle.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
end
​makeDraggable(MobileToggleBtn, MobileToggleBtn)
​MobileToggleBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)
​-- TOP HEADER BAR
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame
makeDraggable(Header, MainFrame)
​local LogoIcon = Instance.new("Frame", Header)
LogoIcon.Size = UDim2.new(0, 24, 0, 24)
LogoIcon.Position = UDim2.new(0, 14, 0.5, -12)
LogoIcon.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", LogoIcon).CornerRadius = UDim.new(0, 6)
​local LogoLetter = Instance.new("TextLabel", LogoIcon)
LogoLetter.Size = UDim2.new(1, 0, 1, 0)
LogoLetter.BackgroundTransparency = 1
LogoLetter.Text = "B"
LogoLetter.Font = Enum.Font.GothamBlack
LogoLetter.TextSize = 14
LogoLetter.TextColor3 = Theme.TextPrimary
​local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(0, 210, 0, 20)
TitleLabel.Position = UDim2.new(0, 46, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Theme.TextPrimary
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Text = "Boost Hub - PLS WAIT"
​local SubTitleLabel = Instance.new("TextLabel", Header)
SubTitleLabel.Size = UDim2.new(0, 210, 0, 14)
SubTitleLabel.Position = UDim2.new(0, 46, 0, 23)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Font = Enum.Font.Gotham
SubTitleLabel.TextSize = 10
SubTitleLabel.TextColor3 = Theme.TextSecondary
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Text = "Made by Xeavz • Mobile Ready"
​-- VERSION PILL BADGE (Matches Screenshot Red Badge)
local VersionBadge = Instance.new("Frame", Header)
VersionBadge.Size = UDim2.new(0, 46, 0, 20)
VersionBadge.Position = UDim2.new(0, 225, 0.5, -10)
VersionBadge.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(1, 0)
​local VersionText = Instance.new("TextLabel", VersionBadge)
VersionText.Size = UDim2.new(1, 0, 1, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "v2.0"
VersionText.Font = Enum.Font.GothamBold
VersionText.TextSize = 11
VersionText.TextColor3 = Theme.TextPrimary
​-- WINDOW CONTROLS (Minimize / Close)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Theme.Accent
CloseBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
Notify("UI Hidden", "Tap the 'BH' button on screen to reopen.", 3)
end)
​local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "—"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.TextColor3 = Theme.Accent
MinBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
Notify("UI Minimized", "Tap the 'BH' button to restore.", 2.5)
end)
​local Divider = Instance.new("Frame", MainFrame)
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 42)
Divider.BackgroundColor3 = Theme.Border
Divider.BorderSizePixel = 0
​-- LEFT SIDEBAR (Search + Tabs + User Profile)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 148, 1, -43)
Sidebar.Position = UDim2.new(0, 0, 0, 43)
Sidebar.BackgroundColor3 = Theme.BgSidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
​-- SEARCH BAR
local SearchBox = Instance.new("TextBox", Sidebar)
SearchBox.Size = UDim2.new(1, -16, 0, 28)
SearchBox.Position = UDim2.new(0, 8, 0, 8)
SearchBox.BackgroundColor3 = Theme.BgElement
SearchBox.PlaceholderText = "🔍 Search..."
SearchBox.PlaceholderColor3 = Theme.TextSecondary
SearchBox.Text = ""
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
SearchBox.TextColor3 = Theme.TextPrimary
SearchBox.ClearTextOnFocus = false
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
local sStroke = Instance.new("UIStroke", SearchBox)
sStroke.Color = Theme.Border
sStroke.Thickness = 1
​-- TAB BUTTONS SCROLL LIST
local TabScroll = Instance.new("ScrollingFrame", Sidebar)
TabScroll.Size = UDim2.new(1, -12, 1, -92)
TabScroll.Position = UDim2.new(0, 6, 0, 42)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 2
TabScroll.ScrollBarImageColor3 = Theme.Accent
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
​local TabListLayout = Instance.new("UIListLayout", TabScroll)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)
​-- USER PROFILE CARD AT BOTTOM LEFT
local ProfileBox = Instance.new("Frame", Sidebar)
ProfileBox.Size = UDim2.new(1, -12, 0, 40)
ProfileBox.Position = UDim2.new(0, 6, 1, -46)
ProfileBox.BackgroundColor3 = Theme.BgElement
Instance.new("UICorner", ProfileBox).CornerRadius = UDim.new(0, 8)
​local AvatarImg = Instance.new("ImageLabel", ProfileBox)
AvatarImg.Size = UDim2.new(0, 28, 0, 28)
AvatarImg.Position = UDim2.new(0, 6, 0.5, -14)
AvatarImg.BackgroundColor3 = Theme.BgMain
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
pcall(function()
AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
​local DispName = Instance.new("TextLabel", ProfileBox)
DispName.Size = UDim2.new(1, -42, 0, 16)
DispName.Position = UDim2.new(0, 38, 0, 5)
DispName.BackgroundTransparency = 1
DispName.Font = Enum.Font.GothamBold
DispName.TextSize = 11
DispName.TextColor3 = Theme.TextPrimary
DispName.TextXAlignment = Enum.TextXAlignment.Left
DispName.TextTruncate = Enum.TextTruncate.AtEnd
DispName.Text = LocalPlayer.DisplayName
​local UserName = Instance.new("TextLabel", ProfileBox)
UserName.Size = UDim2.new(1, -42, 0, 14)
UserName.Position = UDim2.new(0, 38, 0, 20)
UserName.BackgroundTransparency = 1
UserName.Font = Enum.Font.Gotham
UserName.TextSize = 9
UserName.TextColor3 = Theme.TextSecondary
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.TextTruncate = Enum.TextTruncate.AtEnd
UserName.Text = "@" .. LocalPlayer.Name
​-- CONTENT AREA (RIGHT SIDE)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -156, 1, -51)
ContentArea.Position = UDim2.new(0, 152, 0, 47)
ContentArea.BackgroundTransparency = 1
​-- ============================================================================
--                         UI BUILDER API FUNCTIONS
-- ============================================================================
local Tabs = {}
local AllSearchableItems = {}
local CurrentTab = nil
​local function CreateTab(name, iconText)
local tabBtn = Instance.new("TextButton", TabScroll)
tabBtn.Size = UDim2.new(1, 0, 0, 30)
tabBtn.BackgroundColor3 = Theme.BgElement
tabBtn.BackgroundTransparency = 1
tabBtn.Text = ""
tabBtn.AutoButtonColor = false
Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
​local indicator = Instance.new("Frame", tabBtn)
indicator.Size = UDim2.new(0, 3, 0, 16)
indicator.Position = UDim2.new(0, 4, 0.5, -8)
indicator.BackgroundColor3 = Theme.Accent
indicator.Visible = false
Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
​local lbl = Instance.new("TextLabel", tabBtn)
lbl.Size = UDim2.new(1, -16, 1, 0)
lbl.Position = UDim2.new(0, 14, 0, 0)
lbl.BackgroundTransparency = 1
lbl.Font = Enum.Font.GothamSemibold
lbl.TextSize = 12
lbl.TextColor3 = Theme.TextSecondary
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Text = iconText .. "  " .. name
​local page = Instance.new("ScrollingFrame", ContentArea)
page.Size = UDim2.new(1, 0, 1, 0)
page.BackgroundTransparency = 1
page.ScrollBarThickness = 3
page.ScrollBarImageColor3 = Theme.Accent
page.CanvasSize = UDim2.new(0, 0, 0, 0)
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Visible = false
​local pagePad = Instance.new("UIPadding", page)
pagePad.PaddingTop = UDim.new(0, 4)
pagePad.PaddingBottom = UDim.new(0, 10)
pagePad.PaddingLeft = UDim.new(0, 4)
pagePad.PaddingRight = UDim.new(0, 8)
​local pageLayout = Instance.new("UIListLayout", page)
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.Padding = UDim.new(0, 8)
​local function selectTab()
for _, t in ipairs(Tabs) do
t.Page.Visible = false
t.Btn.BackgroundTransparency = 1
t.Indicator.Visible = false
t.Label.TextColor3 = Theme.TextSecondary
end
page.Visible = true
tabBtn.BackgroundTransparency = 0
indicator.Visible = true
lbl.TextColor3 = Theme.TextPrimary
CurrentTab = page
end
​tabBtn.MouseButton1Click:Connect(selectTab)
table.insert(Tabs, { Name = name, Btn = tabBtn, Indicator = indicator, Label = lbl, Page = page, Select = selectTab })
​if #Tabs == 1 then
selectTab()
end
​local TabObj = {}
​function TabObj:Section(sectionTitle)
local card = Instance.new("Frame", page)
card.Size = UDim2.new(1, 0, 0, 0)
card.AutomaticSize = Enum.AutomaticSize.Y
card.BackgroundColor3 = Theme.BgCard
card.BorderSizePixel = 0
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
local cStroke = Instance.new("UIStroke", card)
cStroke.Color = Theme.Border
cStroke.Thickness = 1
​local cPad = Instance.new("UIPadding", card)
cPad.PaddingTop = UDim.new(0, 10)
cPad.PaddingBottom = UDim.new(0, 10)
cPad.PaddingLeft = UDim.new(0, 10)
cPad.PaddingRight = UDim.new(0, 10)
​local cLayout = Instance.new("UIListLayout", card)
cLayout.SortOrder = Enum.SortOrder.LayoutOrder
cLayout.Padding = UDim.new(0, 6)
​local secHeader = Instance.new("TextLabel", card)
secHeader.Size = UDim2.new(1, 0, 0, 20)
secHeader.BackgroundTransparency = 1
secHeader.Font = Enum.Font.GothamBold
secHeader.TextSize = 13
secHeader.TextColor3 = Theme.Accent
secHeader.TextXAlignment = Enum.TextXAlignment.Left
secHeader.Text = "⚔  " .. sectionTitle
​local SecObj = {}
​function SecObj:Toggle(title, defaultVal, callback)
local state = defaultVal or false
local row = Instance.new("TextButton", card)
row.Size = UDim2.new(1, 0, 0, 34)
row.BackgroundColor3 = Theme.BgElement
row.Text = ""
row.AutoButtonColor = false
Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
​local tLbl = Instance.new("TextLabel", row)
tLbl.Size = UDim2.new(1, -60, 1, 0)
tLbl.Position = UDim2.new(0, 12, 0, 0)
tLbl.BackgroundTransparency = 1
tLbl.Font = Enum.Font.GothamSemibold
tLbl.TextSize = 12
tLbl.TextColor3 = Theme.TextPrimary
tLbl.TextXAlignment = Enum.TextXAlignment.Left
tLbl.Text = title
​local pill = Instance.new("Frame", row)
pill.Size = UDim2.new(0, 38, 0, 20)
pill.Position = UDim2.new(1, -48, 0.5, -10)
pill.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
​local knob = Instance.new("Frame", pill)
knob.Size = UDim2.new(0, 14, 0, 14)
knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
knob.BackgroundColor3 = Theme.Knob
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
​local function setToggle(newState, skipCallback)
state = newState
TweenService:Create(pill, TweenInfo.new(0.18), { BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff }):Play()
TweenService:Create(knob, TweenInfo.new(0.18), { Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) }):Play()
if not skipCallback and callback then
callback(state)
end
end
​row.MouseButton1Click:Connect(function()
setToggle(not state, false)
end)
​table.insert(AllSearchableItems, { Title = string.lower(title), Element = row })
return { Set = setToggle, Get = function() return state end }
end
​function SecObj:Slider(title, min, max, defaultVal, callback)
local val = math.clamp(defaultVal or min, min, max)
local row = Instance.new("Frame", card)
row.Size = UDim2.new(1, 0, 0, 38)
row.BackgroundColor3 = Theme.BgElement
Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
​local tLbl = Instance.new("TextLabel", row)
tLbl.Size = UDim2.new(0.48, 0, 1, 0)
tLbl.Position = UDim2.new(0, 12, 0, 0)
tLbl.BackgroundTransparency = 1
tLbl.Font = Enum.Font.GothamSemibold
tLbl.TextSize = 12
tLbl.TextColor3 = Theme.TextPrimary
tLbl.TextXAlignment = Enum.TextXAlignment.Left
tLbl.Text = title
​local vLbl = Instance.new("TextLabel", row)
vLbl.Size = UDim2.new(0, 42, 1, 0)
vLbl.Position = UDim2.new(0.48, 0, 0, 0)
vLbl.BackgroundTransparency = 1
vLbl.Font = Enum.Font.GothamBold
vLbl.TextSize = 11
vLbl.TextColor3 = Theme.TextSecondary
vLbl.Text = tostring(val)
​local track = Instance.new("Frame", row)
track.Size = UDim2.new(0.38, 0, 0, 4)
track.Position = UDim2.new(0.60, 0, 0.5, -2)
track.BackgroundColor3 = Theme.ToggleOff
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
​local fill = Instance.new("Frame", track)
local pct = (val - min) / math.max(1, (max - min))
fill.Size = UDim2.new(pct, 0, 1, 0)
fill.BackgroundColor3 = Theme.Accent
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
​local knob = Instance.new("Frame", track)
knob.Size = UDim2.new(0, 14, 0, 14)
knob.Position = UDim2.new(pct, -7, 0.5, -7)
knob.BackgroundColor3 = Theme.Knob
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
​local hitBtn = Instance.new("TextButton", row)
hitBtn.Size = UDim2.new(0.44, 0, 1, 0)
hitBtn.Position = UDim2.new(0.56, 0, 0, 0)
hitBtn.BackgroundTransparency = 1
hitBtn.Text = ""
​local sliding = false
local function updateFromInput(input)
local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
val = math.floor(min + (max - min) * relX + 0.5)
local newPct = (val - min) / math.max(1, (max - min))
fill.Size = UDim2.new(newPct, 0, 1, 0)
knob.Position = UDim2.new(newPct, -7, 0.5, -7)
vLbl.Text = tostring(val)
if callback then callback(val) end
end
​hitBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = true
updateFromInput(input)
end
end)
UserInputService.InputChanged:Connect(function(input)
if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
updateFromInput(input)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = false
end
end)
​table.insert(AllSearchableItems, { Title = string.lower(title), Element = row })
return {
Set = function(newVal)
val = math.clamp(newVal, min, max)
local newPct = (val - min) / math.max(1, (max - min))
fill.Size = UDim2.new(newPct, 0, 1, 0)
knob.Position = UDim2.new(newPct, -7, 0.5, -7)
vLbl.Text = tostring(val)
end
}
end
​function SecObj:Button(title, callback)
local btn = Instance.new("TextButton", card)
btn.Size = UDim2.new(1, 0, 0, 32)
btn.BackgroundColor3 = Theme.BgElement
btn.Text = ""
btn.AutoButtonColor = false
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
​local tLbl = Instance.new("TextLabel", btn)
tLbl.Size = UDim2.new(1, -36, 1, 0)
tLbl.Position = UDim2.new(0, 12, 0, 0)
tLbl.BackgroundTransparency = 1
tLbl.Font = Enum.Font.GothamSemibold
tLbl.TextSize = 12
tLbl.TextColor3 = Theme.TextPrimary
tLbl.TextXAlignment = Enum.TextXAlignment.Left
tLbl.Text = title
​local arrow = Instance.new("TextLabel", btn)
arrow.Size = UDim2.new(0, 24, 1, 0)
arrow.Position = UDim2.new(1, -28, 0, 0)
arrow.BackgroundTransparency = 1
arrow.Font = Enum.Font.GothamBold
arrow.TextSize = 13
arrow.TextColor3 = Theme.Accent
arrow.Text = "›"
​btn.MouseButton1Click:Connect(function()
TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.AccentDark }):Play()
task.delay(0.12, function()
TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.BgElement }):Play()
end)
if callback then callback() end
end)
​table.insert(AllSearchableItems, { Title = string.lower(title), Element = btn })
return btn
end
​function SecObj:Input(title, placeholder, defaultText, callback)
local box = Instance.new("Frame", card)
box.Size = UDim2.new(1, 0, 0, 36)
box.BackgroundColor3 = Theme.BgElement
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
​local tLbl = Instance.new("TextLabel", box)
tLbl.Size = UDim2.new(0.45, 0, 1, 0)
tLbl.Position = UDim2.new(0, 12, 0, 0)
tLbl.BackgroundTransparency = 1
tLbl.Font = Enum.Font.GothamSemibold
tLbl.TextSize = 11
tLbl.TextColor3 = Theme.TextPrimary
tLbl.TextXAlignment = Enum.TextXAlignment.Left
tLbl.Text = title
​local inputBox = Instance.new("TextBox", box)
inputBox.Size = UDim2.new(0.50, 0, 0, 24)
inputBox.Position = UDim2.new(0.48, 0, 0.5, -12)
inputBox.BackgroundColor3 = Theme.BgMain
inputBox.PlaceholderText = placeholder or "Type..."
inputBox.PlaceholderColor3 = Theme.TextSecondary
inputBox.Text = defaultText or ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 11
inputBox.TextColor3 = Theme.TextPrimary
inputBox.ClearTextOnFocus = false
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 5)
local iStroke = Instance.new("UIStroke", inputBox)
iStroke.Color = Theme.Border
iStroke.Thickness = 1
​inputBox.FocusLost:Connect(function()
if callback then callback(inputBox.Text) end
end)
​table.insert(AllSearchableItems, { Title = string.lower(title), Element = box })
return inputBox
end
​return SecObj
end
​return TabObj
end
​-- LIVE SEARCH FILTER
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
local q = string.lower(SearchBox.Text)
for _, item in ipairs(AllSearchableItems) do
if q == "" then
item.Element.Visible = true
else
item.Element.Visible = string.find(item.Title, q, 1, true) ~= nil
end
end
end)
​-- ============================================================================
--                     CORE GAME LOGIC & PROTECTIONS
-- ============================================================================
​-- ADMIN WATCHLIST AUTO-HOP
local adminList = { "valchuuz", "angel019999", "bvetterdays", "HayyanPro167", "HayyanProRBX" }
local function checkAndHopForAdmins(player)
if player == LocalPlayer then return end
for _, adminName in ipairs(adminList) do
if string.lower(player.Name) == string.lower(adminName) or string.lower(player.DisplayName) == string.lower(adminName) then
Notify("Admin Detected!", "Staff member joined. Server hopping for safety...", 6)
task.wait(1.5)
TeleportService:Teleport(game.PlaceId, LocalPlayer)
return true
end
end
end
for _, p in ipairs(Players:GetPlayers()) do checkAndHopForAdmins(p) end
Players.PlayerAdded:Connect(checkAndHopForAdmins)
​-- CHAT HELPER
local function SendChatMessage(msg)
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
if general then general:SendAsync(msg) end
else
local legacy = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if legacy and legacy:FindFirstChild("SayMessageRequest") then
legacy.SayMessageRequest:FireServer(msg, "All")
end
end
end
​-- OBSTACLE AVOIDANCE
local function isObstacle(instance)
if not instance then return false end
local name = string.lower(instance.Name)
local pName = instance.Parent and string.lower(instance.Parent.Name) or ""
for _, kw in ipairs({ "chair", "seat", "trampoline", "piano", "obby", "stage", "bounce" }) do
if string.find(name, kw) or string.find(pName, kw) then return true end
end
return false
end
​local function avoidObstaclesNear(position)
if not getgenv().BoostHubConfig.AutoAvoidObstacles then return position end
for _, obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and isObstacle(obj) and (obj.Position - position).Magnitude < 6 then
local offset = (position - obj.Position).Unit * 5
return position + Vector3.new(offset.X, 0, offset.Z)
end
end
return position
end
​-- STAND CHECK & CLAIM
local function HasClaimedStand()
local myName = string.lower(LocalPlayer.DisplayName)
for _, obj in pairs(workspace:GetDescendants()) do
if not obj:IsDescendantOf(LocalPlayer.Character or workspace) and not obj:IsDescendantOf(CoreGui) and not obj:IsA("Tool") then
if obj:IsA("TextLabel") or obj:IsA("TextBox") then
local text = string.lower(obj.Text or "")
if string.find(text, myName) then
local pName = string.lower(obj.Parent.Name)
local gpName = obj.Parent.Parent and string.lower(obj.Parent.Parent.Name) or ""
if (string.find(pName, "stand") or string.find(gpName, "stand") or string.find(text, "stand")) and
not string.find(pName, "shop") and not string.find(gpName, "shop") then
return true
end
end
end
end
end
return false
end
​local function AttemptClaimStand()
if HasClaimedStand() then return false end
local char = LocalPlayer.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
local hrp = char.HumanoidRootPart
local origCF = hrp.CFrame
​local emitters = {}
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") then
local nl = string.lower(obj.Name)
if (string.find(nl, "baseemitter") or string.find(nl, "stand")) and not string.find(nl, "shop") then
table.insert(emitters, obj)
end
end
end
​for _, targetPart in ipairs(emitters) do
if targetPart and targetPart.Parent then
hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
task.wait(0.4)
local prompt
for _, desc in pairs(targetPart.Parent:GetDescendants()) do
if desc:IsA("ProximityPrompt") and desc.Enabled then prompt = desc break end
end
if prompt then
if type(fireproximityprompt) == "function" then
pcall(function() fireproximityprompt(prompt) end)
else
pcall(function() prompt:InputHoldBegin() task.wait(0.1) prompt:InputHoldEnd() end)
end
task.wait(1.2)
if HasClaimedStand() then
hrp.CFrame = origCF
return true
end
end
end
end
hrp.CFrame = origCF
return false
end
​-- ============================================================================
--                          POPULATE TABS & FEATURES
-- ============================================================================
local HomeTab = CreateTab("Home", "🏠")
local FarmTab = CreateTab("Farm", "⚡")
local MoveTab = CreateTab("Movement", "🏃")
local AutoTab = CreateTab("Automation", "🤖")
local HopTab = CreateTab("Server Hop", "🔄")
local VisualTab = CreateTab("Visuals", "👁")
local ClientTab = CreateTab("Client", "🎵")
local ConfigTab = CreateTab("Configs", "⚙")
​-- 1. HOME TAB
local InfoSec = HomeTab:Section("Hub Status & Updates")
InfoSec:Button("View Changelog", function()
Notify("Boost Hub v2.0", "Custom Dark-Red Mobile UI • No Key System • All Features Active!", 5)
end)
InfoSec:Toggle("Anti-Ban Safe Mode (Jitter)", getgenv().BoostHubConfig.AntiBanEnabled, function(s)
getgenv().AntiBanEnabled = s
getgenv().BoostHubConfig.AntiBanEnabled = s
Notify("Anti-Ban", s and "Safe Mode Enabled" or "Safe Mode Disabled", 2.5)
end)
​local PerfSec = HomeTab:Section("Performance & Safety")
local renderToggle = PerfSec:Toggle("Disable 3D Render (AFK FPS)", getgenv().BoostHubConfig.Disable3DRender, function(s)
getgenv().BoostHubConfig.Disable3DRender = s
if RunService.Set3dRenderingEnabled then
RunService:Set3dRenderingEnabled(not s)
end
end)
​local antiAfkConn
PerfSec:Toggle("Anti AFK", true, function(s)
getgenv().AntiAfk = s
if s then
local vu = game:GetService("VirtualUser")
antiAfkConn = LocalPlayer.Idled:Connect(function()
if getgenv().AntiAfk then
vu:CaptureController()
vu:ClickButton2(Vector2.new())
end
end)
elseif antiAfkConn then
antiAfkConn:Disconnect()
end
end)
​local antiFlingConn
PerfSec:Toggle("Anti Fling", false, function(s)
getgenv().AntiFling = s
if s then
antiFlingConn = RunService.Stepped:Connect(function()
if not getgenv().AntiFling then return end
for _, p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
for _, part in pairs(p.Character:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = false end
end
end
end
end)
elseif antiFlingConn then
antiFlingConn:Disconnect()
end
end)
​-- 2. FARM TAB
local DelaySec = FarmTab:Section("Automation Delays")
DelaySec:Slider("Click Delay (Ms)", 100, 5000, getgenv().BoostHubConfig.CatClickDelay, function(ms)
getgenv().CatClickDelay = ms / 1000
getgenv().BoostHubConfig.CatClickDelay = ms
end)
DelaySec:Slider("Auto RNG Delay (Sec)", 5, 50, getgenv().BoostHubConfig.RNGDelay, function(sec)
getgenv().RNGDelay = sec
getgenv().BoostHubConfig.RNGDelay = sec
end)
​local FarmMainSec = FarmTab:Section("Active Farming")
local gato = nil
local function findCat()
if gato and gato.Parent then return gato end
for _, o in pairs(workspace:GetDescendants()) do
if o:IsA("ClickDetector") then
local n = string.lower(o.Parent.Name)
if string.find(n, "cat") or string.find(n, "gato") or string.find(n, "leader") or string.find(n, "clic") then
gato = o
return o
end
end
end
return nil
end
​local catToggle
catToggle = FarmMainSec:Toggle("Auto Cat Click", getgenv().BoostHubConfig.AutoCatClick, function(state)
getgenv().AutoCatClick = state
getgenv().BoostHubConfig.AutoCatClick = state
if state then
local tgt = findCat()
if tgt then
Notify("Auto Cat Click", "Clicking target started!", 3)
task.spawn(function()
local cx = (type(getconnections) == "function" and getconnections(tgt.MouseClick)) or {}
while getgenv().AutoCatClick and tgt and tgt.Parent do
if #cx > 0 then
for _, c in pairs(cx) do pcall(function() c:Fire() end) end
elseif type(fireclickdetector) == "function" then
pcall(function() fireclickdetector(tgt) end)
end
local d = getgenv().CatClickDelay or 0.1
if getgenv().AntiBanEnabled then d = d + (math.random(1, 10) / 100) end
task.wait(d)
end
end)
else
Notify("Auto Cat Click", "Cat target not found!", 3)
catToggle.Set(false, true)
end
else
gato = nil
end
end)
​local rngToggle, goalToggle
rngToggle = FarmMainSec:Toggle("Auto RNG", getgenv().BoostHubConfig.AutoRNG, function(state)
if state and getgenv().AutoGoal then
Notify("Conflict", "Disable Auto Goal before enabling Auto RNG!", 4)
rngToggle.Set(false, true)
return
end
getgenv().AutoRNG = state
getgenv().BoostHubConfig.AutoRNG = state
if state then
task.spawn(function()
while getgenv().AutoRNG do
local rngPart = workspace:FindFirstChild("RNGButton", true)
local char = LocalPlayer.Character
if rngPart and char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = (rngPart:IsA("Model") and rngPart:GetPivot() or rngPart.CFrame) + Vector3.new(0, 3, 0)
end
task.wait(getgenv().RNGDelay or 15)
end
end)
end
end)
​goalToggle = FarmMainSec:Toggle("Auto Goal (Soccer)", getgenv().BoostHubConfig.AutoGoal, function(state)
if state and getgenv().AutoRNG then
Notify("Conflict", "Disable Auto RNG before enabling Auto Goal!", 4)
goalToggle.Set(false, true)
return
end
getgenv().AutoGoal = state
getgenv().BoostHubConfig.AutoGoal = state
if state then
task.spawn(function()
while getgenv().AutoGoal do
local char = LocalPlayer.Character
local ball = workspace:FindFirstChild("SoccerBall", true)
if ball and char and char:FindFirstChild("HumanoidRootPart") then
local hrp = char.HumanoidRootPart
local bp = ball:IsA("BasePart") and ball or ball:FindFirstChildWhichIsA("BasePart", true)
if bp then
local targetPos = bp.CFrame + Vector3.new(0, 1.5, -3.5)
local dist = (hrp.Position - targetPos.Position).Magnitude
local tw = TweenService:Create(hrp, TweenInfo.new(math.max(0.1, dist / 20), Enum.EasingStyle.Linear), { CFrame = targetPos })
tw:Play()
tw.Completed:Wait()
if bp:IsA("BasePart") and getgenv().AutoGoal then
bp.Anchored = false
bp.AssemblyLinearVelocity = Vector3.new(0, 12, 45)
end
end
end
task.wait(4)
end
end)
end
end)
​local orbsToggle
orbsToggle = FarmMainSec:Toggle("Auto Collect Orbs", getgenv().BoostHubConfig.AutoCollectOrbs, function(state)
getgenv().AutoCollectOrbs = state
getgenv().BoostHubConfig.AutoCollectOrbs = state
if state then
task.spawn(function()
while getgenv().AutoCollectOrbs do
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local orb = workspace:FindFirstChild("DiscoOrb", true)
if orb and hrp then
hrp.CFrame = (orb:IsA("Model") and orb:GetPivot() or orb.CFrame) + Vector3.new(0, 3, 0)
else
Notify("Orbs", "No DiscoOrbs found! Stopped.", 3)
getgenv().AutoCollectOrbs = false
orbsToggle.Set(false, true)
break
end
task.wait(0.3)
end
end)
end
end)
​-- 3. MOVEMENT TAB
local StatsSec = MoveTab:Section("Character Stats")
local wsSlider = StatsSec:Slider("Walk Speed", 16, 250, getgenv().BoostHubConfig.WalkSpeed, function(s)
getgenv().BoostHubConfig.WalkSpeed = s
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = s end
end)
local jpSlider = StatsSec:Slider("Jump Power", 50, 350, getgenv().BoostHubConfig.JumpPower, function(p)
getgenv().BoostHubConfig.JumpPower = p
local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.UseJumpPower = true hum.JumpPower = p end
end)
​local AbilitySec = MoveTab:Section("Movement Abilities (Mobile Ready)")
local flying, flyConn, bodyVel, bodyGyro = false, nil, nil, nil
AbilitySec:Toggle("Fly (Joystick + Camera)", false, function(state)
flying = state
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
​if flying then
bodyVel = Instance.new("BodyVelocity", hrp)
bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bodyGyro = Instance.new("BodyGyro", hrp)
bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
hum.PlatformStand = true
​flyConn = RunService.RenderStepped:Connect(function()
if not flying then return end
local cam = workspace.CurrentCamera
local dir = hum.MoveDirection
if dir.Magnitude > 0 then
local camForward = cam.CFrame.LookVector
dir = (dir + Vector3.new(0, camForward.Y * 0.8, 0)).Unit
end
if hum.Jump then dir = dir + Vector3.new(0, 1, 0) end
bodyVel.Velocity = dir * 50
bodyGyro.CFrame = cam.CFrame
end)
else
if flyConn then flyConn:Disconnect() end
if bodyVel then bodyVel:Destroy() end
if bodyGyro then bodyGyro:Destroy() end
hum.PlatformStand = false
end
end)
​local infJump = false
AbilitySec:Toggle("Infinite Jump", false, function(s) infJump = s end)
UserInputService.JumpRequest:Connect(function()
if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
​local noclip = false
AbilitySec:Toggle("Noclip", false, function(s) noclip = s end)
RunService.Stepped:Connect(function()
if noclip and LocalPlayer.Character then
for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide = false end
end
end
end)
​local TpSec = MoveTab:Section("Quick Teleports")
TpSec:Button("Teleport To RNG Button", function()
local rng = workspace:FindFirstChild("RNGButton", true)
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if rng and hrp then
hrp.CFrame = (rng:IsA("Model") and rng:GetPivot() or rng.CFrame) + Vector3.new(0, 3, 0)
end
end)
TpSec:Button("Teleport To Soccer Ball", function()
local ball = workspace:FindFirstChild("SoccerBall", true)
local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if ball and hrp then
hrp.CFrame = (ball:IsA("Model") and ball:GetPivot() or ball.CFrame) + Vector3.new(0, 3, 0)
end
end)
TpSec:Input("Target Player", "Username...", "", function(txt) targetPlayerName = txt end)
TpSec:Button("Teleport To Player", function()
for _, p in pairs(Players:GetPlayers()) do
if string.find(string.lower(p.Name), string.lower(targetPlayerName)) or string.find(string.lower(p.DisplayName), string.lower(targetPlayerName)) then
if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
Notify("Teleported", "Teleported to " .. p.DisplayName, 2.5)
return
end
end
end
Notify("Error", "Player not found!", 2.5)
end)
​-- 4. AUTOMATION TAB
local StandSec = AutoTab:Section("Stand & Begging")
StandSec:Button("Claim Stand Now", function()
if AttemptClaimStand() then
Notify("Stand", "Claimed stand successfully!", 3)
else
Notify("Stand", HasClaimedStand() and "You already own a stand!" or "No open stand found.", 3)
end
end)
​StandSec:Toggle("Auto Claim Stand", getgenv().BoostHubConfig.AutoClaimStand, function(state)
getgenv().BoostHubConfig.AutoClaimStand = state
if state then
task.spawn(function()
while getgenv().BoostHubConfig.AutoClaimStand do
if not HasClaimedStand() then AttemptClaimStand() end
task.wait(5)
end
end)
end
end)
​StandSec:Toggle("Auto Avoid Obstacles", getgenv().BoostHubConfig.AutoAvoidObstacles, function(s)
getgenv().BoostHubConfig.AutoAvoidObstacles = s
end)
​StandSec:Toggle("Auto Beg Multi-Chat", getgenv().BoostHubConfig.AutoBegMultiChat, function(s)
getgenv().BoostHubConfig.AutoBegMultiChat = s
end)
​local begToggle
begToggle = StandSec:Toggle("Auto Beg (Pathfinding)", getgenv().BoostHubConfig.AutoBeg, function(state)
getgenv().BoostHubConfig.AutoBeg = state
if state then
Notify("Auto Beg", "Started pathfinding to players...", 3)
task.spawn(function()
local PathfindingService = game:GetService("PathfindingService")
local begged = {}
while getgenv().BoostHubConfig.AutoBeg do
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then task.wait(1) continue end
​local sign = char:FindFirstChild("DonationSign") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("DonationSign"))
if sign and sign.Parent ~= char then hum:EquipTool(sign) task.wait(0.5) end
if not char:FindFirstChild("DonationSign") then
Notify("Auto Beg", "Equip or buy a DonationSign first!", 4)
getgenv().BoostHubConfig.AutoBeg = false
begToggle.Set(false, true)
break
end
​local target = nil
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and not begged[p.UserId] and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
target = p
break
end
end
if not target then begged = {} task.wait(1) continue end
​begged[target.UserId] = true
local tHrp = target.Character.HumanoidRootPart
local dest = avoidObstaclesNear(tHrp.Position + (tHrp.CFrame.LookVector * 5))
local path = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
pcall(function() path:ComputeAsync(hrp.Position, dest) end)
​if path.Status == Enum.PathStatus.Success then
for _, wp in ipairs(path:GetWaypoints()) do
if not getgenv().BoostHubConfig.AutoBeg then break end
hum:MoveTo(wp.Position)
if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
hum.MoveToFinished:Wait(1)
end
else
hrp.CFrame = tHrp.CFrame + Vector3.new(0, 3, 0)
end
​if getgenv().BoostHubConfig.AutoBeg and autoBegSayEnabled then
local tmpl = getgenv().BoostHubConfig.AutoBegMultiChat and autoBegChatMessages[math.random(1, #autoBegChatMessages)] or autoBegMessageTemplate
SendChatMessage(string.format(tmpl, target.Name))
end
task.wait(12)
end
end)
end
end)
​local ChatSec = AutoTab:Section("Auto Chat Spammer")
ChatSec:Input("Spam Message 1", "Enter text...", autoChatMessages[1], function(t) if t ~= "" then autoChatMessages[1] = t end end)
ChatSec:Input("Spam Message 2", "Enter text...", autoChatMessages[2], function(t) if t ~= "" then autoChatMessages[2] = t end end)
ChatSec:Toggle("Auto Chat Spammer (25s)", getgenv().BoostHubConfig.AutoChatSpam, function(state)
getgenv().BoostHubConfig.AutoChatSpam = state
if state then
task.spawn(function()
while getgenv().BoostHubConfig.AutoChatSpam do
local msg = autoChatMessages[math.random(1, #autoChatMessages)]
if msg and msg ~= "" then SendChatMessage(msg) end
task.wait(25)
end
end)
end
end)
​-- 5. SERVER HOP TAB
local HopSec = HopTab:Section("Instant Server Hop")
HopSec:Button("Normal Server Hop", function()
Notify("Server Hop", "Teleporting to a new server...", 3)
TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
​HopSec:Button("Hop To Small Server", function()
Notify("Small Server", "Searching for low-player server...", 3)
task.spawn(function()
local req = (syn and syn.request) or (http and http.request) or http_request or request
if not req then Notify("Error", "Executor lacks HTTP request support.", 3) return end
local raw = req({ Url = string.format("https://games.roblox.com/v1/games/%d/servers/0?sortOrder=Asc&limit=100", game.PlaceId) })
if raw and raw.Body then
local data = HttpService:JSONDecode(raw.Body)
if data and data.data then
for _, srv in ipairs(data.data) do
if srv.id ~= game.JobId and srv.playing > 0 and srv.playing < srv.maxPlayers then
TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
return
end
end
end
end
end)
end)
​HopSec:Button("Hop To Most Players Server", function()
Notify("Populated Server", "Searching for high-player server...", 3)
task.spawn(function()
local req = (syn and syn.request) or (http and http.request) or http_request or request
if not req then Notify("Error", "Executor lacks HTTP request support.", 3) return end
local raw = req({ Url = string.format("https://games.roblox.com/v1/games/%d/servers/0?sortOrder=Desc&limit=100", game.PlaceId) })
if raw and raw.Body then
local data = HttpService:JSONDecode(raw.Body)
if data and data.data then
for _, srv in ipairs(data.data) do
if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
return
end
end
end
end
end)
end)
​local TimedSec = HopTab:Section("Timed Auto Hop")
TimedSec:Slider("Hop Interval (Minutes)", 1, 60, timedHopMinutes, function(m)
timedHopMinutes = m
getgenv().BoostHubConfig.TimedHopDelay = m
end)
TimedSec:Toggle("Enable Timed Server Hop", getgenv().BoostHubConfig.TimedServerHop, function(state)
getgenv().BoostHubConfig.TimedServerHop = state
if state then
if timedHopThread then task.cancel(timedHopThread) end
timedHopThread = task.spawn(function()
while getgenv().BoostHubConfig.TimedServerHop do
task.wait((timedHopMinutes or 15) * 60)
if getgenv().BoostHubConfig.TimedServerHop then
TeleportService:Teleport(game.PlaceId, LocalPlayer)
end
end
end)
elseif timedHopThread then
task.cancel(timedHopThread)
end
end)
​-- 6. VISUALS TAB
local VisSec = VisualTab:Section("Graphics & ESP")
VisSec:Toggle("Anti-Lag / FPS Boost", false, function(state)
if state then
local lighting = game:GetService("Lighting")
lighting.GlobalShadows = false
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
end
Notify("FPS Boost", "Graphics simplified for higher FPS!", 3)
end
end)
​VisSec:Toggle("Full Bright", false, function(state)
local lighting = game:GetService("Lighting")
lighting.Brightness = state and 2 or 1
lighting.ClockTime = state and 14 or 12
lighting.GlobalShadows = not state
end)
​local espEnabled, espFolder = false, Instance.new("Folder", CoreGui)
espFolder.Name = "BoostHubESPFolder"
VisSec:Toggle("Player ESP (Red Highlight)", false, function(state)
espEnabled = state
espFolder:ClearAllChildren()
if state then
task.spawn(function()
while espEnabled do
espFolder:ClearAllChildren()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local hl = Instance.new("Highlight", espFolder)
hl.Adornee = p.Character
hl.FillColor = Theme.Accent
hl.OutlineColor = Theme.Knob
hl.FillTransparency = 0.55
end
end
task.wait(2)
end
end)
end
end)
​-- 7. CLIENT TAB
local AudioSec = ClientTab:Section("Local Audio & Morph")
AudioSec:Input("Roblox Audio ID", "18483545", "", function(t) customAudioId = t end)
AudioSec:Button("Play Custom Audio", function()
if customAudioId == "" then Notify("Error", "Enter an Audio ID first!", 2.5) return end
if activeCustomSound then activeCustomSound:Destroy() end
for _, s in pairs(workspace:GetDescendants()) do
if s:IsA("Sound") then originalVolumes[s] = s.Volume s.Volume = 0 end
end
local snd = Instance.new("Sound", game:GetService("SoundService"))
snd.SoundId = "rbxassetid://" .. customAudioId
snd.Looped = true
snd.Volume = 1
snd:Play()
activeCustomSound = snd
Notify("Audio", "Playing custom sound locally.", 3)
end)
​AudioSec:Button("Stop Audio & Restore Game", function()
if activeCustomSound then activeCustomSound:Destroy() activeCustomSound = nil end
for s, v in pairs(originalVolumes) do if s and s.Parent then s.Volume = v end end
originalVolumes = {}
Notify("Audio", "Restored game audio.", 2.5)
end)
​-- 8. CONFIGS TAB
local CfgSec = ConfigTab:Section("Save & Load Configs")
CfgSec:Input("Config Name", "DefaultConfig", "DefaultConfig", function(t) if t ~= "" then configInputName = t end end)
CfgSec:Button("Save Configuration", function()
if not writefile then Notify("Error", "Executor does not support writefile.", 3) return end
pcall(function()
if makefolder then makefolder("BoostHubConfigs") end
writefile("BoostHubConfigs/" .. configInputName .. ".json", HttpService:JSONEncode(getgenv().BoostHubConfig))
Notify("Saved", "Saved config: " .. configInputName, 3)
end)
end)
CfgSec:Button("Load Configuration", function()
if not readfile then Notify("Error", "Executor does not support readfile.", 3) return end
local ok, raw = pcall(function() return readfile("BoostHubConfigs/" .. configInputName .. ".json") end)
if ok and raw then
local data = HttpService:JSONDecode(raw)
for k, v in pairs(data) do getgenv().BoostHubConfig[k] = v end
wsSlider.Set(getgenv().BoostHubConfig.WalkSpeed or 16)
jpSlider.Set(getgenv().BoostHubConfig.JumpPower or 50)
Notify("Loaded", "Loaded config: " .. configInputName, 3)
else
Notify("Error", "Config not found!", 3)
end
end)
​local CredSec = ConfigTab:Section("Credits & Community")
CredSec:Button("Copy Discord Invite", function()
if setclipboard then
setclipboard("https://discord.gg/gydHWv8Bx")
Notify("Copied!", "Discord invite copied to clipboard.", 3)
end
end)
​-- INITIALIZATION COMPLETE
Notify("Boost Hub Loaded", "Custom Dark-Red Mobile UI Ready (No Key)!", 4)
