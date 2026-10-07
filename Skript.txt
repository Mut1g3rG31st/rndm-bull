if game.CoreGui:FindFirstChild("SolaraArcanumGui") then
    game.CoreGui.SolaraArcanumGui:Destroy()
end

-- ========================================================
-- ADVANCED COMBAT CONFIGURATION (PREDICTION & BALANCING)
-- ========================================================
_G.BulletVelocity = 2500  -- Fluggeschwindigkeit der Projektile (Höher = weniger Vorhalten nötig)
_G.BulletGravity = 35     -- Kugelabfall / Schwerkraft (Höher = zielt bei Distanz weiter nach oben)


-- ========================================================
-- 1. BASE CONTAINERS & MAIN GUI
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraArcanumGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Parent = MainFrame
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundTransparency = 1

-- ========================================================
-- SKRIPT KOMPLETT SCHLIESSEN BUTTON (OBEN RECHTS)
-- ========================================================
local UnloadButton = Instance.new("TextButton")
UnloadButton.Parent = Topbar
UnloadButton.Size = UDim2.new(0, 30, 0, 30)
UnloadButton.Position = UDim2.new(1, -74, 0, 8)
UnloadButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
UnloadButton.Text = "🛑"
UnloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadButton.TextSize = 12
UnloadButton.Font = Enum.Font.GothamBold

local UnloadCorner = Instance.new("UICorner")
UnloadCorner.CornerRadius = UDim.new(0, 8)
UnloadCorner.Parent = UnloadButton

UnloadButton.MouseButton1Click:Connect(function()
    _G.Freecam = false
    _G.Spinbot = false
    _G.InstantPrompt = false
    _G.AutoBuyTycoon = false
    _G.Wallbang = false
    _G.ESPEnabled = false
    if FOVCircle then FOVCircle:Remove() end
    clearAllDrawingsGlobally()
    ScreenGui:Destroy()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Topbar
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ARCANUM HUB"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Topbar
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui
OpenButton.Size = UDim2.new(0, 42, 0, 42)
OpenButton.Position = UDim2.new(0, 10, 0.5, -21)
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
OpenButton.Text = "➔"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

-- ========================================================
-- UI HELPER FUNCTIONS
-- ========================================================
local function createBindRow(parent, btnText)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local actionBtn = Instance.new("TextButton")
    actionBtn.Parent = row
    actionBtn.Size = UDim2.new(0, 245, 1, 0)
    actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    actionBtn.Text = btnText .. ": AUS"
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.TextSize = 13
    actionBtn.Font = Enum.Font.GothamBold

    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 8)
    c1.Parent = actionBtn

    local bindBtn = Instance.new("TextButton")
    bindBtn.Parent = row
    bindBtn.Size = UDim2.new(0, 100, 1, 0)
    bindBtn.Position = UDim2.new(0, 253, 0, 0)
    bindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    bindBtn.Text = "[ None ]"
    bindBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    bindBtn.TextSize = 12
    bindBtn.Font = Enum.Font.GothamMedium

    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(0, 8)
    c2.Parent = bindBtn

    return actionBtn, bindBtn
end

local function createSimpleButton(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local function createToggleInputRow(parent, labelText, defaultVal)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = row
    toggleBtn.Size = UDim2.new(0, 245, 1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    toggleBtn.Text = labelText .. ": AUS"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 13
    toggleBtn.Font = Enum.Font.GothamBold

    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 8)
    c1.Parent = toggleBtn

    local box = Instance.new("TextBox")
    box.Parent = row
    box.Size = UDim2.new(0, 100, 1, 0)
    box.Position = UDim2.new(0, 253, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    box.Font = Enum.Font.GothamMedium

    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(0, 8)
    c2.Parent = box

    return toggleBtn, box
end

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- ========================================================
-- 2. SIDEBAR & NAVIGATION BUTTONS
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 150, 0, 355)
Sidebar.Position = UDim2.new(0, 12, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local UniversalTabButton = Instance.new("TextButton")
UniversalTabButton.Parent = Sidebar
UniversalTabButton.Size = UDim2.new(1, -16, 0, 38)
UniversalTabButton.Position = UDim2.new(0, 8, 0, 10)
UniversalTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
UniversalTabButton.Text = " Universal"
UniversalTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UniversalTabButton.TextSize = 13
UniversalTabButton.Font = Enum.Font.GothamMedium
UniversalTabButton.TextXAlignment = Enum.TextXAlignment.Left

local UniCatCorner = Instance.new("UICorner")
UniCatCorner.CornerRadius = UDim.new(0, 8)
UniCatCorner.Parent = UniversalTabButton

local FarmingTabButton = Instance.new("TextButton")
FarmingTabButton.Parent = Sidebar
FarmingTabButton.Size = UDim2.new(1, -16, 0, 38)
FarmingTabButton.Position = UDim2.new(0, 8, 0, 54)
FarmingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
FarmingTabButton.Text = " Military Madness"
FarmingTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
FarmingTabButton.TextSize = 13
FarmingTabButton.Font = Enum.Font.Gotham
FarmingTabButton.TextXAlignment = Enum.TextXAlignment.Left

-- ========================================================
-- MISSING VISIBILITY HELPER (FIXED FOR SOLARA)
-- ========================================================
local function isPartVisible(part, character)
    if not part or not character then return false end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local castPoints = { cam.CFrame.Position, part.Position }
    local ignoreList = { game:GetService("Players").LocalPlayer.Character, character }
    local rays = cam:GetPartsObscuringTarget(castPoints, ignoreList)
    return #rays == 0
end

local FarmCatCorner = Instance.new("UICorner")
FarmCatCorner.CornerRadius = UDim.new(0, 8)
FarmCatCorner.Parent = FarmingTabButton

local MWTabButton = Instance.new("TextButton")
MWTabButton.Parent = Sidebar
MWTabButton.Size = UDim2.new(1, -16, 0, 38)
MWTabButton.Position = UDim2.new(0, 8, 0, 98)
MWTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
MWTabButton.Text = " Military Warfare"
MWTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
MWTabButton.TextSize = 13
MWTabButton.Font = Enum.Font.Gotham
MWTabButton.TextXAlignment = Enum.TextXAlignment.Left

local MWCatCorner = Instance.new("UICorner")
MWCatCorner.CornerRadius = UDim.new(0, 8)
MWCatCorner.Parent = MWTabButton

-- ========================================================
-- 3. PAGES INITIALIZATION
-- ========================================================
local UniversalPage = Instance.new("Frame")
UniversalPage.Parent = MainFrame
UniversalPage.Size = UDim2.new(0, 374, 0, 355)
UniversalPage.Position = UDim2.new(0, 172, 0, 50)
UniversalPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
UniversalPage.Visible = true

local ContentCorner1 = Instance.new("UICorner")
ContentCorner1.CornerRadius = UDim.new(0, 10)
ContentCorner1.Parent = UniversalPage

local UniScroll = Instance.new("ScrollingFrame")
UniScroll.Parent = UniversalPage
UniScroll.Size = UDim2.new(1, -10, 1, -10)
UniScroll.Position = UDim2.new(0, 5, 0, 5)
UniScroll.BackgroundTransparency = 1
UniScroll.BorderSizePixel = 0
UniScroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
UniScroll.ScrollBarThickness = 4

local UniList = Instance.new("UIListLayout")
UniList.Parent = UniScroll
UniList.SortOrder = Enum.SortOrder.LayoutOrder
UniList.Padding = UDim.new(0, 8)

local FarmingPage = Instance.new("Frame")
FarmingPage.Parent = MainFrame
FarmingPage.Size = UDim2.new(0, 374, 0, 355)
FarmingPage.Position = UDim2.new(0, 172, 0, 50)
FarmingPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
FarmingPage.Visible = false

local ContentCorner2 = Instance.new("UICorner")
ContentCorner2.CornerRadius = UDim.new(0, 10)
ContentCorner2.Parent = FarmingPage

local MWPage = Instance.new("Frame")
MWPage.Parent = MainFrame
MWPage.Size = UDim2.new(0, 374, 0, 355)
MWPage.Position = UDim2.new(0, 172, 0, 50)
MWPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
MWPage.Visible = false

local MWPageCorner = Instance.new("UICorner")
MWPageCorner.CornerRadius = UDim.new(0, 10)
MWPageCorner.Parent = MWPage

local AirdropButton = Instance.new("TextButton")
AirdropButton.Parent = MWPage
AirdropButton.Size = UDim2.new(1, -20, 0, 42)
AirdropButton.Position = UDim2.new(0, 10, 0, 10)
AirdropButton.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
AirdropButton.Text = "Auto-Collect Airdrops: AUS"
AirdropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AirdropButton.TextSize = 14
AirdropButton.Font = Enum.Font.GothamBold

local AirdropCorner = Instance.new("UICorner")
AirdropCorner.CornerRadius = UDim.new(0, 8)
AirdropCorner.Parent = AirdropButton

-- ========================================================
-- NEW SUBMENUS SETUP (ESP & AIMBOT SEITEN)
-- ========================================================

-- A) ESP SUBMENU VIEW WITH SCROLLING
local ESPSubView = Instance.new("Frame")
ESPSubView.Parent = UniversalPage
ESPSubView.Size = UDim2.new(1, 0, 1, 0)
ESPSubView.BackgroundTransparency = 1
ESPSubView.Visible = false

local BackESPButton = createSimpleButton(ESPSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60))
BackESPButton.Size = UDim2.new(1, -20, 0, 32)
BackESPButton.Position = UDim2.new(0, 10, 0, 8)

-- Scrollcontainer für die ESP-Toggles
local ESPScrollContainer = Instance.new("ScrollingFrame")
ESPScrollContainer.Parent = ESPSubView
ESPScrollContainer.Size = UDim2.new(1, -20, 0, 300)
ESPScrollContainer.Position = UDim2.new(0, 10, 0, 48)
ESPScrollContainer.BackgroundTransparency = 1
ESPScrollContainer.BorderSizePixel = 0
ESPScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 370)
ESPScrollContainer.ScrollBarThickness = 4

local ESPListLayout = Instance.new("UIListLayout")
ESPListLayout.Parent = ESPScrollContainer
ESPListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ESPListLayout.Padding = UDim.new(0, 6)

local ESPMasterBtn = createSimpleButton(ESPScrollContainer, "ESP Hauptschalter: AUS", Color3.fromRGB(200, 50, 60))
local ESPBoxBtn = createSimpleButton(ESPScrollContainer, "2D Spieler-Box: AUS", Color3.fromRGB(200, 50, 60))
local ESPSkeletonBtn = createSimpleButton(ESPScrollContainer, "Skelett-ESP: AUS", Color3.fromRGB(200, 50, 60))
local ESPNameBtn = createSimpleButton(ESPScrollContainer, "Spielernamen anzeigen: AUS", Color3.fromRGB(200, 50, 60))
local ESPHealthBtn = createSimpleButton(ESPScrollContainer, "Lebensbalken (Health): AUS", Color3.fromRGB(200, 50, 60))
local ESPItemBtn = createSimpleButton(ESPScrollContainer, "Gehaltenes Item: AUS", Color3.fromRGB(200, 50, 60))
local ESPDistanceBtn = createSimpleButton(ESPScrollContainer, "Distanz (In Metern): AUS", Color3.fromRGB(200, 50, 60))
local ESPTracerBtn = createSimpleButton(ESPScrollContainer, "Snaplines (Linien): AUS", Color3.fromRGB(200, 50, 60))

-- B) AIMBOT SUBMENU VIEW
local AimbotSubView = Instance.new("Frame")
AimbotSubView.Parent = UniversalPage
AimbotSubView.Size = UDim2.new(1, 0, 1, 0)
AimbotSubView.BackgroundTransparency = 1
AimbotSubView.Visible = false

local BackAimbotButton = createSimpleButton(AimbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60))
BackAimbotButton.Size = UDim2.new(1, -20, 0, 32)
BackAimbotButton.Position = UDim2.new(0, 10, 0, 8)

local AimbotControlsContainer = Instance.new("Frame")
AimbotControlsContainer.Parent = AimbotSubView
AimbotControlsContainer.Size = UDim2.new(1, -20, 0, 275)
AimbotControlsContainer.Position = UDim2.new(0, 10, 0, 48)
AimbotControlsContainer.BackgroundTransparency = 1

local AimbotListLayout = Instance.new("UIListLayout")
AimbotListLayout.Parent = AimbotControlsContainer
AimbotListLayout.SortOrder = Enum.SortOrder.LayoutOrder
AimbotListLayout.Padding = UDim.new(0, 10)

local AimbotToggleBtn, AimbotSmoothInput = createToggleInputRow(AimbotControlsContainer, "Aimbot (Aimlock)", "5")
AimbotSmoothInput.PlaceholderText = "Smooth (1-20)"

local AimbotBindBtn = createSimpleButton(AimbotControlsContainer, "Aimbot Halte-Taste: [ E ]", Color3.fromRGB(35, 35, 48))

-- ========================================================
-- 4. UI CONTROLS REGISTRATION (HAUPTMENÜ)
-- ========================================================
local ClickerButton, BindButton = createBindRow(UniScroll, "Auto-Clicker")
local FlyButton, FlyBindButton = createBindRow(UniScroll, "Fly")
local NoclipButton, NoclipBindButton = createBindRow(UniScroll, "Noclip")
local FreecamButton, FreecamSpeedInput = createToggleInputRow(UniScroll, "Freecam", "1.2")
FreecamSpeedInput.PlaceholderText = "Speed"

local SpeedBtn, SpeedInput = createToggleInputRow(UniScroll, "Custom Speed", 50)
local JumpBtn, JumpInput = createToggleInputRow(UniScroll, "Custom Jump", 100)
local FovBtn, FovInput = createToggleInputRow(UniScroll, "Custom FOV", 90)

local InstantPromptBtn = createSimpleButton(UniScroll, "Instant Proximity Prompt: AUS", Color3.fromRGB(200, 50, 60))
local WallbangBtn = createSimpleButton(UniScroll, "Universal Wall-Bang: AUS", Color3.fromRGB(200, 50, 60))
local OpenSpinbotSubmenu = createSimpleButton(UniScroll, "Spinbot / Anti-Aim Einstellungen  ➡", Color3.fromRGB(35, 35, 48))
local OpenESPSubmenu = createSimpleButton(UniScroll, "ESP / Vision Einstellungen  ➡", Color3.fromRGB(35, 35, 48))
local OpenAimbotSubmenu = createSimpleButton(UniScroll, "Aimbot Einstellungen  ➡", Color3.fromRGB(35, 35, 48))
local OpenTriggerbotSubmenu = createSimpleButton(UniScroll, "Triggerbot Einstellungen  ➡", Color3.fromRGB(35, 35, 48))
local ClickTpBtn = createSimpleButton(UniScroll, "Click Teleport (Strg + Klick): AUS", Color3.fromRGB(200, 50, 60))
local InfJumpBtn = createSimpleButton(UniScroll, "Infinite Jump: AUS", Color3.fromRGB(200, 50, 60))
local BrightBtn = createSimpleButton(UniScroll, "Fullbright / NoFog: AUS", Color3.fromRGB(200, 50, 60))
local FpsBtn = createSimpleButton(UniScroll, "FPS Booster: AUS", Color3.fromRGB(200, 50, 60))
local AntiAfkBtn = createSimpleButton(UniScroll, "Anti-AFK: AN", Color3.fromRGB(45, 180, 90))
local DexButton = createSimpleButton(UniScroll, "Open Dex Explorer", Color3.fromRGB(90, 45, 180))
local IYButton = createSimpleButton(UniScroll, "Open Infinite Yield", Color3.fromRGB(45, 120, 180))

local ServerRow = Instance.new("Frame")
ServerRow.Size = UDim2.new(1, -10, 0, 38)
ServerRow.BackgroundTransparency = 1
ServerRow.Parent = UniScroll

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Parent = ServerRow
RejoinBtn.Size = UDim2.new(0, 170, 1, 0)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(45, 110, 230)
RejoinBtn.Text = "Rejoin Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 12
RejoinBtn.Font = Enum.Font.GothamBold

local rC = Instance.new("UICorner")
rC.CornerRadius = UDim.new(0, 8)
rC.Parent = RejoinBtn

local HopBtn = Instance.new("TextButton")
HopBtn.Parent = ServerRow
HopBtn.Size = UDim2.new(0, 170, 1, 0)
HopBtn.Position = UDim2.new(0, 180, 0, 0)
HopBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
HopBtn.Text = "Server Hop"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 12
HopBtn.Font = Enum.Font.GothamBold

local hC = Instance.new("UICorner")
hC.CornerRadius = UDim.new(0, 8)
hC.Parent = HopBtn

-- Player Dropdown
local DropContainer = Instance.new("Frame")
DropContainer.Parent = UniScroll
DropContainer.Size = UDim2.new(1, -10, 0, 38)
DropContainer.BackgroundTransparency = 1

local DropdownButton = Instance.new("TextButton")
DropdownButton.Parent = DropContainer
DropdownButton.Size = UDim2.new(0, 245, 1, 0)
DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
DropdownButton.Text = "Spieler wählen... ▼"
DropdownButton.TextColor3 = Color3.fromRGB(220, 220, 240)
DropdownButton.TextSize = 13
DropdownButton.Font = Enum.Font.GothamMedium

local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 8)
DropCorner.Parent = DropdownButton

local ExecutePlayerTp = Instance.new("TextButton")
ExecutePlayerTp.Parent = DropContainer
ExecutePlayerTp.Size = UDim2.new(0, 100, 1, 0)
ExecutePlayerTp.Position = UDim2.new(0, 253, 0, 0)
ExecutePlayerTp.BackgroundColor3 = Color3.fromRGB(45, 110, 230)
ExecutePlayerTp.Text = "Teleport"
ExecutePlayerTp.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecutePlayerTp.TextSize = 13
ExecutePlayerTp.Font = Enum.Font.GothamBold

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 8)
ExecCorner.Parent = ExecutePlayerTp

local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Parent = UniversalPage
DropdownList.Size = UDim2.new(0, 245, 0, 110)
DropdownList.Position = UDim2.new(0, 10, 0, 230)
DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ZIndex = 10
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)

local DropListCorner = Instance.new("UICorner")
DropListCorner.CornerRadius = UDim.new(0, 8)
DropListCorner.Parent = DropdownList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DropdownList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ========================================================
-- MILITARY MADNESS SUBMENUS
-- ========================================================
local MMMainView = Instance.new("Frame")
MMMainView.Parent = FarmingPage
MMMainView.Size = UDim2.new(1, 0, 1, 0)
MMMainView.BackgroundTransparency = 1

local RebirthButton = Instance.new("TextButton")
RebirthButton.Parent = MMMainView
RebirthButton.Size = UDim2.new(1, -20, 0, 42)
RebirthButton.Position = UDim2.new(0, 10, 0, 10)
RebirthButton.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
RebirthButton.Text = "Auto-Rebirth: AUS"
RebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthButton.TextSize = 14
RebirthButton.Font = Enum.Font.GothamBold

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = RebirthButton

local OpenBaseTpSubmenu = Instance.new("TextButton")
OpenBaseTpSubmenu.Parent = MMMainView
OpenBaseTpSubmenu.Size = UDim2.new(1, -20, 0, 42)
OpenBaseTpSubmenu.Position = UDim2.new(0, 10, 0, 60)
OpenBaseTpSubmenu.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
OpenBaseTpSubmenu.Text = "Base Teleports  ➡"
OpenBaseTpSubmenu.TextColor3 = Color3.fromRGB(240, 240, 255)
OpenBaseTpSubmenu.TextSize = 14
OpenBaseTpSubmenu.Font = Enum.Font.GothamMedium

local BaseSubCorner = Instance.new("UICorner")
BaseSubCorner.CornerRadius = UDim.new(0, 8)
BaseSubCorner.Parent = OpenBaseTpSubmenu

local CratesButton = Instance.new("TextButton")
CratesButton.Parent = MMMainView
CratesButton.Size = UDim2.new(1, -20, 0, 42)
CratesButton.Position = UDim2.new(0, 10, 0, 110)
CratesButton.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
CratesButton.Text = "Auto-Collect Crates: AUS"
CratesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CratesButton.TextSize = 14
CratesButton.Font = Enum.Font.GothamBold

local CratesCorner = Instance.new("UICorner")
CratesCorner.CornerRadius = UDim.new(0, 8)
CratesCorner.Parent = CratesButton

local AutoBuyBtn = createSimpleButton(MMMainView, "Auto-Buy Dropper/Upgrader: AUS", Color3.fromRGB(200, 50, 60))
AutoBuyBtn.Size = UDim2.new(1, -20, 0, 42)
AutoBuyBtn.Position = UDim2.new(0, 10, 0, 160)

local MMBaseTpView = Instance.new("Frame")
MMBaseTpView.Parent = FarmingPage
MMBaseTpView.Size = UDim2.new(1, 0, 1, 0)
MMBaseTpView.BackgroundTransparency = 1
MMBaseTpView.Visible = false

local BackMMButton = Instance.new("TextButton")
BackMMButton.Parent = MMBaseTpView
BackMMButton.Size = UDim2.new(1, -20, 0, 32)
BackMMButton.Position = UDim2.new(0, 10, 0, 8)
BackMMButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
BackMMButton.Text = "⬅  Zurück"
BackMMButton.TextColor3 = Color3.fromRGB(220, 220, 240)
BackMMButton.TextSize = 13
BackMMButton.Font = Enum.Font.GothamMedium

local BackCorner = Instance.new("UICorner")
BackCorner.CornerRadius = UDim.new(0, 8)
BackCorner.Parent = BackMMButton

local BaseGridContainer = Instance.new("Frame")
BaseGridContainer.Parent = MMBaseTpView
BaseGridContainer.Size = UDim2.new(1, -20, 0, 275)
BaseGridContainer.Position = UDim2.new(0, 10, 0, 48)
BaseGridContainer.BackgroundTransparency = 1

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = BaseGridContainer
UIGridLayout.CellSize = UDim2.new(0, 172, 0, 42)
UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

OpenBaseTpSubmenu.MouseButton1Click:Connect(function()
    MMMainView.Visible = false
    MMBaseTpView.Visible = true
end)

BackMMButton.MouseButton1Click:Connect(function()
    MMBaseTpView.Visible = false
    MMMainView.Visible = true
end)

-- ========================================================
-- CHAT TRANSLATOR SUBMENU VIEW
-- ========================================================
_G.ChatTranslator = false
_G.TargetLanguage = "de"
_G.OutboundLanguage = "ru"

local ChatSubView = Instance.new("Frame")
ChatSubView.Parent = UniversalPage
ChatSubView.Size = UDim2.new(1, 0, 1, 0)
ChatSubView.BackgroundTransparency = 1
ChatSubView.Visible = false

local BackChatButton = createSimpleButton(ChatSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60))
BackChatButton.Size = UDim2.new(1, -20, 0, 32)
BackChatButton.Position = UDim2.new(0, 10, 0, 8)

local ChatControlsContainer = Instance.new("Frame")
ChatControlsContainer.Parent = ChatSubView
ChatControlsContainer.Size = UDim2.new(1, -20, 0, 275)
ChatControlsContainer.Position = UDim2.new(0, 10, 0, 48)
ChatControlsContainer.BackgroundTransparency = 1

local ChatListLayout = Instance.new("UIListLayout")
ChatListLayout.Parent = ChatControlsContainer
ChatListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatListLayout.Padding = UDim.new(0, 8)

local ChatToggleBtn = createSimpleButton(ChatControlsContainer, "Chat-Übersetzer: AUS", Color3.fromRGB(200, 50, 60))

local InboundRow = Instance.new("Frame")
InboundRow.Size = UDim2.new(1, -10, 0, 38)
InboundRow.BackgroundTransparency = 1
InboundRow.Parent = ChatControlsContainer

local InboundLabel = Instance.new("TextLabel")
InboundLabel.Parent = InboundRow
InboundLabel.Size = UDim2.new(0, 245, 1, 0)
InboundLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
InboundLabel.Text = " Eingehend übersetzen in (Kürzel):"
InboundLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
InboundLabel.TextSize = 13
InboundLabel.Font = Enum.Font.GothamMedium
InboundLabel.TextXAlignment = Enum.TextXAlignment.Left

local InboundLabelCorner = Instance.new("UICorner")
InboundLabelCorner.CornerRadius = UDim.new(0, 8)
InboundLabelCorner.Parent = InboundLabel

local InboundInput = Instance.new("TextBox")
InboundInput.Parent = InboundRow
InboundInput.Size = UDim2.new(0, 100, 1, 0)
InboundInput.Position = UDim2.new(0, 253, 0, 0)
InboundInput.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
InboundInput.Text = _G.TargetLanguage
InboundInput.TextColor3 = Color3.fromRGB(255, 255, 255)
InboundInput.TextSize = 12
InboundInput.Font = Enum.Font.GothamMedium

local InboundInputCorner = Instance.new("UICorner")
InboundInputCorner.CornerRadius = UDim.new(0, 8)
InboundInputCorner.Parent = InboundInput

local OutboundRow = Instance.new("Frame")
OutboundRow.Size = UDim2.new(1, -10, 0, 38)
OutboundRow.BackgroundTransparency = 1
OutboundRow.Parent = ChatControlsContainer

local OutboundLabel = Instance.new("TextLabel")
OutboundLabel.Parent = OutboundRow
OutboundLabel.Size = UDim2.new(0, 245, 1, 0)
OutboundLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
OutboundLabel.Text = " Deine Antwort übersetzen in:"
OutboundLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
OutboundLabel.TextSize = 13
OutboundLabel.Font = Enum.Font.GothamMedium
OutboundLabel.TextXAlignment = Enum.TextXAlignment.Left

local OutboundLabelCorner = Instance.new("UICorner")
OutboundLabelCorner.CornerRadius = UDim.new(0, 8)
OutboundLabelCorner.Parent = OutboundLabel

local OutboundInput = Instance.new("TextBox")
OutboundInput.Parent = OutboundRow
OutboundInput.Size = UDim2.new(0, 100, 1, 0)
OutboundInput.Position = UDim2.new(0, 253, 0, 0)
OutboundInput.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
OutboundInput.Text = _G.OutboundLanguage
OutboundInput.TextColor3 = Color3.fromRGB(255, 255, 255)
OutboundInput.TextSize = 12
OutboundInput.Font = Enum.Font.GothamMedium

local OutboundInputCorner = Instance.new("UICorner")
OutboundInputCorner.CornerRadius = UDim.new(0, 8)
OutboundInputCorner.Parent = OutboundInput

local ReplyRow = Instance.new("Frame")
ReplyRow.Size = UDim2.new(1, -10, 0, 38)
ReplyRow.BackgroundTransparency = 1
ReplyRow.Parent = ChatControlsContainer

local ReplyInput = Instance.new("TextBox")
ReplyInput.Parent = ReplyRow
ReplyInput.Size = UDim2.new(1, 0, 1, 0)
ReplyInput.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
ReplyInput.Text = ""
ReplyInput.PlaceholderText = "Hier auf Deutsch schreiben & Enter drücken..."
ReplyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ReplyInput.TextSize = 13
ReplyInput.Font = Enum.Font.GothamMedium

local ReplyCorner = Instance.new("UICorner")
ReplyCorner.CornerRadius = UDim.new(0, 8)
ReplyCorner.Parent = ReplyInput

-- ========================================================
-- TRANSLATION ENGINE & CHAT HOOKS
-- ========================================================
local httpService = game:GetService("HttpService")

local function translateText(text, targetLang)
    if not text or text == "" then
        return text
    end

    local url = "googleapis.com" .. targetLang .. "&dt=t&q=" .. httpService:UrlEncode(text)

    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result then
        if string.sub(result, 1, 1) ~= "[" and string.sub(result, 1, 1) ~= "{" then
            return text
        end

        local decodeSuccess, decoded = pcall(function()
            return httpService:JSONDecode(result)
        end)

        if decodeSuccess and decoded and typeof(decoded) == "table" then
            if decoded[1] and typeof(decoded[1]) == "table"
                and decoded[1][1] and typeof(decoded[1][1]) == "table"
                and decoded[1][1][1] then
                return tostring(decoded[1][1][1])
            end
        end
    end

    return text
end

local chatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 5)

if chatEvents then
    local messageEvent = chatEvents:WaitForChild("OnMessageDoneFiltering", 5)

    if messageEvent then
        messageEvent.OnClientEvent:Connect(function(messageData)
            local localPlayer = game:GetService("Players").LocalPlayer
            if not localPlayer then return end

            if _G.ChatTranslator and messageData and messageData.FromSpeaker
                and messageData.FromSpeaker ~= localPlayer.Name then
                local originalText = messageData.Message
                local sender = messageData.FromSpeaker

                task.spawn(function()
                    local translated = translateText(originalText, _G.TargetLanguage)
                    if translated and translated ~= originalText then
                        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                            Text = "[" .. sender .. " ➔ " .. string.upper(_G.TargetLanguage) .. "]: " .. translated,
                            Color = Color3.fromRGB(100, 255, 200),
                            Font = Enum.Font.GothamMedium,
                            TextSize = 13
                        })
                    end
                end)
            end
        end)
    end
end

ReplyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and ReplyInput.Text ~= "" then
        local rawText = ReplyInput.Text
        ReplyInput.Text = ""

        task.spawn(function()
            local translatedReply = translateText(rawText, _G.OutboundLanguage)
            local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                chatEvent.SayMessageRequest:FireServer(translatedReply, "All")
            end
        end)
    end
end)

InboundInput:GetPropertyChangedSignal("Text"):Connect(function()
    _G.TargetLanguage = string.lower(string.sub(InboundInput.Text, 1, 2))
end)

OutboundInput:GetPropertyChangedSignal("Text"):Connect(function()
    _G.OutboundLanguage = string.lower(string.sub(OutboundInput.Text, 1, 2))
end)

ChatToggleBtn.MouseButton1Click:Connect(function()
    _G.ChatTranslator = not _G.ChatTranslator
    ChatToggleBtn.Text = _G.ChatTranslator and "Chat-Übersetzer: AN" or "Chat-Übersetzer: AUS"
    ChatToggleBtn.BackgroundColor3 = _G.ChatTranslator and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

-- ========================================================
-- TRIGGERBOT SUBMENU LAYOUT
-- ========================================================
local TriggerbotSubView = Instance.new("Frame")
TriggerbotSubView.Parent = UniversalPage
TriggerbotSubView.Size = UDim2.new(1, 0, 1, 0)
TriggerbotSubView.BackgroundTransparency = 1
TriggerbotSubView.Visible = false

local BackTriggerbotButton = createSimpleButton(TriggerbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60))
BackTriggerbotButton.Size = UDim2.new(1, -20, 0, 32)
BackTriggerbotButton.Position = UDim2.new(0, 10, 0, 8)

local TriggerbotControlsContainer = Instance.new("Frame")
TriggerbotControlsContainer.Parent = TriggerbotSubView
TriggerbotControlsContainer.Size = UDim2.new(1, -20, 0, 275)
TriggerbotControlsContainer.Position = UDim2.new(0, 10, 0, 48)
TriggerbotControlsContainer.BackgroundTransparency = 1

local TriggerbotListLayout = Instance.new("UIListLayout")
TriggerbotListLayout.Parent = TriggerbotControlsContainer
TriggerbotListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TriggerbotListLayout.Padding = UDim.new(0, 8)

local TriggerbotToggleBtn = createSimpleButton(TriggerbotControlsContainer, "Triggerbot aktivieren: AUS", Color3.fromRGB(200, 50, 60))

local TriggerbotDelayRow = Instance.new("Frame")
TriggerbotDelayRow.Size = UDim2.new(1, -10, 0, 38)
TriggerbotDelayRow.BackgroundTransparency = 1
TriggerbotDelayRow.Parent = TriggerbotControlsContainer

local TriggerbotDelayLabel = Instance.new("TextLabel")
TriggerbotDelayLabel.Parent = TriggerbotDelayRow
TriggerbotDelayLabel.Size = UDim2.new(0, 245, 1, 0)
TriggerbotDelayLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TriggerbotDelayLabel.Text = " Schuss-Verzögerung (ms):"
TriggerbotDelayLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TriggerbotDelayLabel.TextSize = 13
TriggerbotDelayLabel.Font = Enum.Font.GothamMedium
TriggerbotDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local TriggerbotDelayCorner = Instance.new("UICorner")
TriggerbotDelayCorner.CornerRadius = UDim.new(0, 8)
TriggerbotDelayCorner.Parent = TriggerbotDelayLabel

local TriggerbotDelayInput = Instance.new("TextBox")
TriggerbotDelayInput.Parent = TriggerbotDelayRow
TriggerbotDelayInput.Size = UDim2.new(0, 100, 1, 0)
TriggerbotDelayInput.Position = UDim2.new(0, 253, 0, 0)
TriggerbotDelayInput.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
TriggerbotDelayInput.Text = "20"
TriggerbotDelayInput.PlaceholderText = "ms"
TriggerbotDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TriggerbotDelayInput.TextSize = 12
TriggerbotDelayInput.Font = Enum.Font.GothamMedium

local TriggerbotInputCorner = Instance.new("UICorner")
TriggerbotInputCorner.CornerRadius = UDim.new(0, 8)
TriggerbotInputCorner.Parent = TriggerbotDelayInput

OpenTriggerbotSubmenu.MouseButton1Click:Connect(function()
    UniScroll.Visible = false
    TriggerbotSubView.Visible = true
end)

BackTriggerbotButton.MouseButton1Click:Connect(function()
    TriggerbotSubView.Visible = false
    UniScroll.Visible = true
end)

-- ========================================================
-- SPINBOT SUBMENU VIEW WITH SPEED INPUT
-- ========================================================
local SpinbotSubView = Instance.new("Frame")
SpinbotSubView.Parent = UniversalPage
SpinbotSubView.Size = UDim2.new(1, 0, 1, 0)
SpinbotSubView.BackgroundTransparency = 1
SpinbotSubView.Visible = false

local BackSpinbotButton = createSimpleButton(SpinbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60))
BackSpinbotButton.Size = UDim2.new(1, -20, 0, 32)
BackSpinbotButton.Position = UDim2.new(0, 10, 0, 8)

local SpinbotControlsContainer = Instance.new("Frame")
SpinbotControlsContainer.Parent = SpinbotSubView
SpinbotControlsContainer.Size = UDim2.new(1, -20, 0, 275)
SpinbotControlsContainer.Position = UDim2.new(0, 10, 0, 48)
SpinbotControlsContainer.BackgroundTransparency = 1

local SpinbotListLayout = Instance.new("UIListLayout")
SpinbotListLayout.Parent = SpinbotControlsContainer
SpinbotListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpinbotListLayout.Padding = UDim.new(0, 10)

local SpinbotToggleBtn, SpinbotSpeedInput = createToggleInputRow(SpinbotControlsContainer, "Spinbot aktivieren", "50")
SpinbotSpeedInput.PlaceholderText = "Tempo (1-100)"

OpenSpinbotSubmenu.MouseButton1Click:Connect(function()
    UniScroll.Visible = false
    SpinbotSubView.Visible = true
end)

BackSpinbotButton.MouseButton1Click:Connect(function()
    SpinbotSubView.Visible = false
    UniScroll.Visible = true
end)

-- ========================================================
-- NAVIGATION LOGIC
-- ========================================================
UniversalTabButton.MouseButton1Click:Connect(function()
    UniversalPage.Visible = true
    FarmingPage.Visible = false
    MWPage.Visible = false

    UniversalTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
    UniversalTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    FarmingTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
    MWTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    MWTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
end)

OpenESPSubmenu.MouseButton1Click:Connect(function()
    UniScroll.Visible = false
    ESPSubView.Visible = true
end)

BackESPButton.MouseButton1Click:Connect(function()
    ESPSubView.Visible = false
    UniScroll.Visible = true
end)

OpenAimbotSubmenu.MouseButton1Click:Connect(function()
    UniScroll.Visible = false
    AimbotSubView.Visible = true
end)

BackAimbotButton.MouseButton1Click:Connect(function()
    AimbotSubView.Visible = false
    UniScroll.Visible = true
end)

FarmingTabButton.MouseButton1Click:Connect(function()
    UniversalPage.Visible = false
    FarmingPage.Visible = true
    MWPage.Visible = false
    MMMainView.Visible = true
    MMBaseTpView.Visible = false

    FarmingTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
    FarmingTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UniversalTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    UniversalTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
    MWTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    MWTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
end)

MWTabButton.MouseButton1Click:Connect(function()
    UniversalPage.Visible = false
    FarmingPage.Visible = false
    MWPage.Visible = true

    MWTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58)
    MWTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UniversalTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    UniversalTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
    FarmingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    FarmingTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
end)

-- ========================================================
-- 5. ENGINE HOOKS, SERVICES & AUTOMATION LOGIC
-- ========================================================
_G.AutoRebirth = false
_G.AutoCrates = false
_G.AutoClicker = false
_G.Flying = false
_G.Noclip = false
_G.Freecam = false
_G.InfJump = false
_G.Fullbright = false
_G.AntiAFK = true
_G.SpeedEnabled = false
_G.JumpEnabled = false
_G.FovEnabled = false
_G.ClickTp = false
_G.FpsBooster = false
_G.AutoAirdrops = false
_G.Triggerbot = false
_G.ESPEnabled = false
_G.ESPBoxes = false
_G.ESPSkeletons = false
_G.ESPNames = false
_G.ESPHealth = false
_G.ESPItems = false
_G.ESPDistances = false
_G.ESPTracers = false
_G.AimbotEnabled = false
_G.InstantPrompt = false
_G.Wallbang = false
_G.Spinbot = false
_G.AutoBuyTycoon = false

local AimbotBindList = {
    Enum.KeyCode.E,
    Enum.KeyCode.Q,
    Enum.KeyCode.F,
    Enum.KeyCode.LeftAlt,
    Enum.UserInputType.MouseButton2
}
local AimbotBindIndex = 1
local AimbotBind = AimbotBindList[AimbotBindIndex]
local AimbotKeyDown = false
local AimbotTarget = nil

local CurrentBind, ESPBind, FlyBind, NoclipBind
local IsBindingClicker, IsBindingESP, IsBindingFly, IsBindingNoclip = false, false, false, false
local SelectedPlayer = nil

local player = game:GetService("Players").LocalPlayer

while not player do
    task.wait(0.1)
    player = game:GetService("Players").LocalPlayer
end

local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local vim = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local tpService = game:GetService("TeleportService")
local camera = workspace.CurrentCamera

TriggerbotDelayInput:GetPropertyChangedSignal("Text"):Connect(function()
    TriggerbotDelayInput.Text = string.gsub(TriggerbotDelayInput.Text, "%D", "")
    if #TriggerbotDelayInput.Text > 4 then
        TriggerbotDelayInput.Text = string.sub(TriggerbotDelayInput.Text, 1, 4)
    end
end)

AimbotBindBtn.MouseButton1Click:Connect(function()
    AimbotBindIndex = AimbotBindIndex + 1
    if AimbotBindIndex > #AimbotBindList then
        AimbotBindIndex = 1
    end
    AimbotBind = AimbotBindList[AimbotBindIndex]

    local keyName = typeof(AimbotBind) == "EnumItem" and AimbotBind.Name or "RMB (Rechte Maus)"
    if AimbotBind == Enum.KeyCode.LeftAlt then
        keyName = "Links Alt"
    end
    AimbotBindBtn.Text = "Aimbot Halte-Taste: [ " .. keyName .. " ]"
end)

local function setupToggle(btn, varName, baseText)
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = baseText .. (_G[varName] and ": AN" or ": AUS")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
    end)
end

local ActiveDrawings = {}

local function destroyElement(obj)
    if obj then
        pcall(function()
            obj.Visible = false
            obj:Remove()
        end)
    end
end

function clearAllDrawingsGlobally()
    for plName, drawings in pairs(ActiveDrawings) do
        if drawings then
            for key, obj in pairs(drawings) do
                if key == "Bones" then
                    for i = 1, 5 do
                        if obj[i] then
                            destroyElement(obj[i])
                            obj[i] = nil
                        end
                    end
                else
                    destroyElement(obj)
                end
            end
            ActiveDrawings[plName] = nil
        end
    end
end

ESPMasterBtn.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    ESPMasterBtn.Text = "ESP Hauptschalter: " .. (_G.ESPEnabled and "AN" or "AUS")
    ESPMasterBtn.BackgroundColor3 = _G.ESPEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    if not _G.ESPEnabled then
        clearAllDrawingsGlobally()
    end
end)

setupToggle(ESPBoxBtn, "ESPBoxes", "2D Spieler-Box")
setupToggle(ESPSkeletonBtn, "ESPSkeletons", "Skelett-ESP")
setupToggle(ESPNameBtn, "ESPNames", "Spielernamen anzeigen")
setupToggle(ESPHealthBtn, "ESPHealth", "Lebensbalken (Health)")
setupToggle(ESPItemBtn, "ESPItems", "Gehaltenes Item")
setupToggle(ESPDistanceBtn, "ESPDistances", "Distanz (In Metern)")
setupToggle(ESPTracerBtn, "ESPTracers", "Snaplines (Linien)")

AimbotToggleBtn.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    AimbotToggleBtn.Text = _G.AimbotEnabled and "Aimbot (Aimlock): AN" or "Aimbot (Aimlock): AUS"
    AimbotToggleBtn.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

AirdropButton.MouseButton1Click:Connect(function()
    _G.AutoAirdrops = not _G.AutoAirdrops
    AirdropButton.Text = _G.AutoAirdrops and "Auto-Collect Airdrops: AN" or "Auto-Collect Airdrops: AUS"
    AirdropButton.BackgroundColor3 = _G.AutoAirdrops and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

players.PlayerRemoving:Connect(function(pl)
    if ActiveDrawings[pl.Name] then
        for key, obj in pairs(ActiveDrawings[pl.Name]) do
            if key == "Bones" then
                for i = 1, 5 do
                    if obj[i] then
                        destroyElement(obj[i])
                        obj[i] = nil
                    end
                end
            else
                destroyElement(obj)
            end
        end
        ActiveDrawings[pl.Name] = nil
    end
end)

runService.RenderStepped:Connect(function()
    if not _G.ESPEnabled then
        clearAllDrawingsGlobally()
        return
    end

    for _, pl in pairs(players:GetPlayers()) do
        if pl ~= player then
            local char = pl.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if hrp and head and hum and hum.Health > 0 then
                local hrpPos, hrpOn = camera:WorldToViewportPoint(hrp.Position)
                local headPos, headOn = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

                if hrpOn and headOn then
                    if not ActiveDrawings[pl.Name] then
                        ActiveDrawings[pl.Name] = { Bones = {} }
                    end

                    local esp = ActiveDrawings[pl.Name]
                    local boxHeight = math.abs(headPos.Y - hrpPos.Y) * 2.5
                    local boxWidth = boxHeight / 1.6
                    local boxX = hrpPos.X - (boxWidth / 2)
                    local boxY = hrpPos.Y - (boxHeight / 2)
                    local espColor = isPartVisible(head, char) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 30, 30)

                    if _G.ESPBoxes then
                        if not esp.Box then
                            esp.Box = Drawing.new("Square")
                            esp.Box.Thickness = 1.5
                            esp.Box.Filled = false
                        end
                        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                        esp.Box.Position = Vector2.new(boxX, boxY)
                        esp.Box.Color = espColor
                        esp.Box.Visible = true
                    elseif esp.Box then
                        destroyElement(esp.Box)
                        esp.Box = nil
                    end

                    if _G.ESPNames then
                        if not esp.Name then
                            esp.Name = Drawing.new("Text")
                            esp.Name.Size = 13
                            esp.Name.Center = true
                            esp.Name.Outline = true
                        end
                        esp.Name.Text = pl.DisplayName .. " (@" .. pl.Name .. ")"
                        esp.Name.Position = Vector2.new(hrpPos.X, boxY - 30)
                        esp.Name.Color = Color3.fromRGB(240, 240, 255)
                        esp.Name.Visible = true
                    elseif esp.Name then
                        destroyElement(esp.Name)
                        esp.Name = nil
                    end

                    if _G.ESPDistances then
                        if not esp.Dist then
                            esp.Dist = Drawing.new("Text")
                            esp.Dist.Size = 11
                            esp.Dist.Center = true
                            esp.Dist.Outline = true
                        end
                        local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        local studs = myHrp and math.round((myHrp.Position - hrp.Position).Magnitude) or 0
                        esp.Dist.Text = "[" .. studs .. " Studs]"
                        esp.Dist.Position = Vector2.new(hrpPos.X, boxY - 15)
                        esp.Dist.Color = Color3.fromRGB(255, 200, 50)
                        esp.Dist.Visible = true
                    elseif esp.Dist then
                        destroyElement(esp.Dist)
                        esp.Dist = nil
                    end

                    if _G.ESPItems then
                        if not esp.Item then
                            esp.Item = Drawing.new("Text")
                            esp.Item.Size = 11
                            esp.Item.Center = true
                            esp.Item.Outline = true
                        end
                        local tool = char:FindFirstChildOfClass("Tool")
                        esp.Item.Text = tool and tool.Name or "[ Faust ]"
                        esp.Item.Position = Vector2.new(hrpPos.X, boxY + boxHeight + 5)
                        esp.Item.Color = Color3.fromRGB(100, 200, 255)
                        esp.Item.Visible = true
                    elseif esp.Item then
                        destroyElement(esp.Item)
                        esp.Item = nil
                    end

                    if _G.ESPHealth then
                        if not esp.HealthBg then
                            esp.HealthBg = Drawing.new("Line")
                            esp.HealthBg.Thickness = 3
                        end
                        if not esp.HealthFg then
                            esp.HealthFg = Drawing.new("Line")
                            esp.HealthFg.Thickness = 3
                        end
                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        esp.HealthBg.From = Vector2.new(boxX - 6, boxY)
                        esp.HealthBg.To = Vector2.new(boxX - 6, boxY + boxHeight)
                        esp.HealthBg.Color = Color3.fromRGB(80, 0, 0)
                        esp.HealthBg.Visible = true
                        esp.HealthFg.From = Vector2.new(boxX - 6, boxY + boxHeight)
                        esp.HealthFg.To = Vector2.new(boxX - 6, boxY + boxHeight - (boxHeight * pct))
                        esp.HealthFg.Color = Color3.fromRGB(0, 255, 50)
                        esp.HealthFg.Visible = true
                    else
                        if esp.HealthBg then
                            destroyElement(esp.HealthBg)
                            esp.HealthBg = nil
                        end
                        if esp.HealthFg then
                            destroyElement(esp.HealthFg)
                            esp.HealthFg = nil
                        end
                    end

                    if _G.ESPTracers then
                        if not esp.Line then
                            esp.Line = Drawing.new("Line")
                            esp.Line.Thickness = 1.5
                            esp.Line.Color = Color3.fromRGB(255, 255, 0)
                        end
                        esp.Line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.Line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        esp.Line.Visible = true

                        if esp.Arrow then
                            destroyElement(esp.Arrow)
                            esp.Arrow = nil
                        end
                    else
                        if esp.Line then
                            destroyElement(esp.Line)
                            esp.Line = nil
                        end
                        if esp.Arrow then
                            destroyElement(esp.Arrow)
                            esp.Arrow = nil
                        end
                    end

                    local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                    local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                    local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                    local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Arm")

                    if _G.ESPSkeletons and upperTorso then
                        local boneColor = Color3.fromRGB(255, 255, 255)

                        local function updateBone(index, fromPos, toPart)
                            if toPart then
                                local pTo, onS = camera:WorldToViewportPoint(toPart.Position)
                                if onS then
                                    if not esp.Bones[index] then
                                        esp.Bones[index] = Drawing.new("Line")
                                        esp.Bones[index].Thickness = 1.5
                                    end
                                    esp.Bones[index].From = Vector2.new(fromPos.X, fromPos.Y)
                                    esp.Bones[index].To = Vector2.new(pTo.X, pTo.Y)
                                    esp.Bones[index].Color = boneColor
                                    esp.Bones[index].Visible = true
                                    return
                                end
                            end

                            if esp.Bones[index] then
                                destroyElement(esp.Bones[index])
                                esp.Bones[index] = nil
                            end
                        end

                        local pTorso, torsoOn = camera:WorldToViewportPoint(upperTorso.Position)
                        updateBone(1, headPos, upperTorso)

                        if torsoOn then
                            updateBone(2, pTorso, leftArm)
                            updateBone(3, pTorso, rightArm)
                            updateBone(4, pTorso, leftLeg)
                            updateBone(5, pTorso, rightLeg)
                        end
                    else
                        for i = 1, 5 do
                            if esp.Bones[i] then
                                destroyElement(esp.Bones[i])
                                esp.Bones[i] = nil
                            end
                        end
                    end

                    if _G.ESPEnabled and _G.ESPTracers then
                        if not ActiveDrawings[pl.Name] then
                            ActiveDrawings[pl.Name] = { Bones = {} }
                        end
                        local esp = ActiveDrawings[pl.Name]

                        if esp.Box then
                            destroyElement(esp.Box)
                            esp.Box = nil
                        end
                        if esp.Name then
                            destroyElement(esp.Name)
                            esp.Name = nil
                        end
                        if esp.Dist then
                            destroyElement(esp.Dist)
                            esp.Dist = nil
                        end
                        if esp.Item then
                            destroyElement(esp.Item)
                            esp.Item = nil
                        end
                        if esp.HealthBg then
                            destroyElement(esp.HealthBg)
                            esp.HealthBg = nil
                        end
                        if esp.HealthFg then
                            destroyElement(esp.HealthFg)
                            esp.HealthFg = nil
                        end
                        if esp.Line then
                            destroyElement(esp.Line)
                            esp.Line = nil
                        end

                        if not esp.Arrow then
                            esp.Arrow = Drawing.new("Text")
                            esp.Arrow.Text = "▲"
                            esp.Arrow.Size = 16
                            esp.Arrow.Center = true
                            esp.Arrow.Outline = true
                            esp.Arrow.Color = Color3.fromRGB(255, 220, 0)
                        end

                        local camLook = camera.CFrame.LookVector
                        local dirToTarget = (hrp.Position - camera.CFrame.Position).Unit
                        local camRight = camera.CFrame.RightVector
                        local angle = math.atan2(camRight:Dot(dirToTarget), camLook:Dot(dirToTarget))
                        local center = camera.ViewportSize / 2
                        local radius = math.min(center.X, center.Y) * 0.85

                        esp.Arrow.Position = Vector2.new(
                            center.X + math.sin(angle) * radius,
                            center.Y - math.cos(angle) * radius
                        )
                        esp.Arrow.Visible = true
                    elseif ActiveDrawings[pl.Name] and ActiveDrawings[pl.Name].Arrow then
                        destroyElement(ActiveDrawings[pl.Name].Arrow)
                        ActiveDrawings[pl.Name].Arrow = nil
                    end

                else
                    if ActiveDrawings[pl.Name] then
                        local esp = ActiveDrawings[pl.Name]

                        if esp.Box then
                            destroyElement(esp.Box)
                            esp.Box = nil
                        end
                        if esp.Name then
                            destroyElement(esp.Name)
                            esp.Name = nil
                        end
                        if esp.Dist then
                            destroyElement(esp.Dist)
                            esp.Dist = nil
                        end
                        if esp.Item then
                            destroyElement(esp.Item)
                            esp.Item = nil
                        end
                        if esp.HealthBg then
                            destroyElement(esp.HealthBg)
                            esp.HealthBg = nil
                        end
                        if esp.HealthFg then
                            destroyElement(esp.HealthFg)
                            esp.HealthFg = nil
                        end
                        if esp.Line then
                            destroyElement(esp.Line)
                            esp.Line = nil
                        end
                        if esp.Arrow then
                            destroyElement(esp.Arrow)
                            esp.Arrow = nil
                        end
                        if esp.Bones then
                            for i = 1, 5 do
                                if esp.Bones[i] then
                                    destroyElement(esp.Bones[i])
                                    esp.Bones[i] = nil
                                end
                            end
                        end

                        ActiveDrawings[pl.Name] = nil
                    end
                end
            end
        end
    end
end)

local function getHumanoid()
    if player.Character then
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local defaultWalkSpeed, defaultJumpPower = 16, 50

local function updateDefaults()
    local hum = getHumanoid()
    if hum then
        if not _G.SpeedEnabled then
            defaultWalkSpeed = hum.WalkSpeed
        end
        if not _G.JumpEnabled then
            defaultJumpPower = hum.JumpPower
        end
    end
end

SpeedBtn.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    SpeedBtn.Text = _G.SpeedEnabled and "Custom Speed: AN" or "Custom Speed: AUS"
    SpeedBtn.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    local hum = getHumanoid()
    if not _G.SpeedEnabled and hum then
        hum.WalkSpeed = defaultWalkSpeed
    else
        updateDefaults()
    end
end)

JumpBtn.MouseButton1Click:Connect(function()
    _G.JumpEnabled = not _G.JumpEnabled
    JumpBtn.Text = _G.JumpEnabled and "Custom Jump: AN" or "Custom Jump: AUS"
    JumpBtn.BackgroundColor3 = _G.JumpEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    local hum = getHumanoid()
    if not _G.JumpEnabled and hum then
        hum.JumpPower = defaultJumpPower
    else
        updateDefaults()
    end
end)

FovBtn.MouseButton1Click:Connect(function()
    _G.FovEnabled = not _G.FovEnabled
    FovBtn.Text = _G.FovEnabled and "Custom FOV: AN" or "Custom FOV: AUS"
    FovBtn.BackgroundColor3 = _G.FovEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    if not _G.FovEnabled then
        camera.FieldOfView = 70
    end
end)

runService.Heartbeat:Connect(function()
    local hum = getHumanoid()
    if hum then
        if _G.SpeedEnabled then
            local val = tonumber(SpeedInput.Text)
            if val and hum.WalkSpeed ~= val then
                hum.WalkSpeed = val
            end
        end

        if _G.JumpEnabled then
            local val = tonumber(JumpInput.Text)
            if val then
                hum.UseJumpPower = true
                if hum.JumpPower ~= val then
                    hum.JumpPower = val
                end
            end
        end

        if _G.FovEnabled then
            local val = tonumber(FovInput.Text)
            if val then
                camera.FieldOfView = val
            end
        end
    end
end)

ClickTpBtn.MouseButton1Click:Connect(function()
    _G.ClickTp = not _G.ClickTp
    ClickTpBtn.Text = _G.ClickTp and "Click Teleport (Strg + Klick): AN" or "Click Teleport (Strg + Klick): AUS"
    ClickTpBtn.BackgroundColor3 = _G.ClickTp and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if _G.ClickTp
        and input.UserInputType == Enum.UserInputType.MouseButton1
        and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = player:GetMouse()
        if mouse and mouse.Hit and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

local flyBV, flyBG

local function toggleFly()
    _G.Flying = not _G.Flying
    FlyButton.Text = _G.Flying and "Fly: AN" or "Fly: AUS"
    FlyButton.BackgroundColor3 = _G.Flying and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    local char = player.Character

    if _G.Flying and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
        end

        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.MaxForce = Vector3.new(1, 1, 1) * 10000000
        flyBV.Parent = hrp

        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1, 1, 1) * 10000000
        flyBG.P = 9000
        flyBG.CFrame = hrp.CFrame
        flyBG.Parent = hrp

        task.spawn(function()
            while _G.Flying and char and char:FindFirstChild("HumanoidRootPart") and flyBV and flyBG do
                local speed = _G.SpeedEnabled and tonumber(SpeedInput.Text) or 60
                local moveDir = Vector3.new(0, 0, 0)

                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                flyBV.Velocity = moveDir * speed
                flyBG.CFrame = camera.CFrame
                task.wait()
            end

            if flyBV then flyBV:Destroy(); flyBV = nil end
            if flyBG then flyBG:Destroy(); flyBG = nil end
            if hum then hum.PlatformStand = false end
        end)
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

FlyButton.MouseButton1Click:Connect(toggleFly)

local function toggleNoclip()
    _G.Noclip = not _G.Noclip
    NoclipButton.Text = _G.Noclip and "Noclip: AN" or "Noclip: AUS"
    NoclipButton.BackgroundColor3 = _G.Noclip and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end

NoclipButton.MouseButton1Click:Connect(toggleNoclip)

-- ========================================================
-- LOGIK FÜR DIE FREECAM (MIT ANPASSBARER GESCHWINDIGKEIT)
-- ========================================================
local function toggleFreecam()
    _G.Freecam = not _G.Freecam
    FreecamButton.Text = "Freecam" .. (_G.Freecam and ": AN" or ": AUS")
    FreecamButton.BackgroundColor3 = _G.Freecam and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if _G.Freecam then
        if hrp then hrp.Anchored = true end
        camera.CameraType = Enum.CameraType.Scriptable

        local cameraRotX = 0
        local cameraRotY = 0
        local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = camera.CFrame:GetComponents()
        cameraRotX = math.atan2(-R12, R22)
        cameraRotY = math.asin(R02)

        task.spawn(function()
            while _G.Freecam do
                local camCFrame = camera.CFrame
                local speed = tonumber(FreecamSpeedInput.Text) or 1.2
                local moveDir = Vector3.new(0, 0, 0)

                if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    uis.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                    local delta = uis:GetMouseDelta()
                    cameraRotX = cameraRotX - (delta.X * 0.003)
                    cameraRotY = math.clamp(cameraRotY - (delta.Y * 0.003), -math.pi / 2.1, math.pi / 2.1)
                    camera.CFrame = CFrame.new(camera.CFrame.Position)
                        * CFrame.Angles(0, cameraRotX, 0)
                        * CFrame.Angles(cameraRotY, 0, 0)
                else
                    uis.MouseBehavior = Enum.MouseBehavior.Default
                end

                local forwardVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector

                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + forwardVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - forwardVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - rightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + rightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                if moveDir.Magnitude > 0 then
                    camera.CFrame = camera.CFrame + (moveDir.Unit * speed)
                end

                task.wait()
            end

            uis.MouseBehavior = Enum.MouseBehavior.Default
        end)
    else
        camera.CameraType = Enum.CameraType.Custom
        uis.MouseBehavior = Enum.MouseBehavior.Default
        if hrp then hrp.Anchored = false end
    end
end

FreecamButton.MouseButton1Click:Connect(toggleFreecam)

-- REPARIERTE NOCLIP-SCHLEIFE
runService.Stepped:Connect(function()
    if _G.Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

runService.Stepped:Connect(function()
    if (_G.Noclip or _G.Flying) and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    _G.InfJump = not _G.InfJump
    InfJumpBtn.Text = _G.InfJump and "Infinite Jump: AN" or "Infinite Jump: AUS"
    InfJumpBtn.BackgroundColor3 = _G.InfJump and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

uis.JumpRequest:Connect(function()
    if _G.InfJump and getHumanoid() then
        getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

BrightBtn.MouseButton1Click:Connect(function()
    _G.Fullbright = not _G.Fullbright
    BrightBtn.Text = _G.Fullbright and "Fullbright / NoFog: AN" or "Fullbright / NoFog: AUS"
    BrightBtn.BackgroundColor3 = _G.Fullbright and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

runService.RenderStepped:Connect(function()
    if _G.Fullbright then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 1000000
        lighting.GlobalShadows = false
    end
end)

FpsBtn.MouseButton1Click:Connect(function()
    _G.FpsBooster = not _G.FpsBooster
    FpsBtn.Text = _G.FpsBooster and "FPS Booster: AN" or "FPS Booster: AUS"
    FpsBtn.BackgroundColor3 = _G.FpsBooster and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)

    if _G.FpsBooster then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end
end)

AntiAfkBtn.MouseButton1Click:Connect(function()
    _G.AntiAFK = not _G.AntiAFK
    AntiAfkBtn.Text = _G.AntiAFK and "Anti-AFK: AN" or "Anti-AFK: AUS"
    AntiAfkBtn.BackgroundColor3 = _G.AntiAFK and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

player.Idled:Connect(function()
    if _G.AntiAFK then
        vim:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
        task.wait(1)
        vim:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
    end
end)

RejoinBtn.MouseButton1Click:Connect(function()
    tpService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

HopBtn.MouseButton1Click:Connect(function()
    HopBtn.Text = "Suche Server..."
    pcall(function()
        local servers = httpService:JSONDecode(
            game:HttpGet("roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        ).data

        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                tpService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                break
            end
        end
    end)
end)

local function updateDropdown()
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local count = 0
    for _, pl in pairs(players:GetPlayers()) do
        if pl ~= player then
            count = count + 1
            local item = Instance.new("TextButton")
            item.Parent = DropdownList
            item.Size = UDim2.new(1, 0, 0, 30)
            item.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            item.Text = pl.DisplayName .. " (@" .. pl.Name .. ")"
            item.TextColor3 = Color3.fromRGB(200, 200, 220)
            item.TextSize = 12
            item.Font = Enum.Font.Gotham
            item.ZIndex = 11

            item.MouseButton1Click:Connect(function()
                SelectedPlayer = pl
                DropdownButton.Text = pl.DisplayName .. " ▼"
                DropdownList.Visible = false
            end)
        end
    end

    DropdownList.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end

DropdownButton.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        updateDropdown()
    end
end)

ExecutePlayerTp.MouseButton1Click:Connect(function()
    if SelectedPlayer
        and SelectedPlayer.Character
        and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        and player.Character
        and player.Character:FindFirstChild("HumanoidRootPart") then
        if _G.Freecam then toggleFreecam() end
        player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
    end
end)

-- HINWEIS: Die beiden URLs unten waren im Original beschädigt.
-- Hier bitte die echten Skript-URLs eintragen.
DexButton.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("githubusercontent.com"))() end)
end)

IYButton.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("githubusercontent.com"))() end)
end)

for i = 1, 6 do
    local baseBtn = Instance.new("TextButton")
    baseBtn.Parent = BaseGridContainer
    baseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    baseBtn.Text = "Base " .. i
    baseBtn.TextColor3 = Color3.fromRGB(240, 240, 255)
    baseBtn.TextSize = 13
    baseBtn.Font = Enum.Font.GothamMedium

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = baseBtn

    baseBtn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local tycoonObj = workspace:FindFirstChild("Tycoons") and workspace.Tycoons:FindFirstChild("Tycoon" .. i)

            if tycoonObj and tycoonObj:FindFirstChild("Base") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(tycoonObj.Base.CFrame.Position + Vector3.new(0, 5, 0))
            else
                player.Character.HumanoidRootPart.CFrame = CFrame.new(-1587.0 + ((i - 1) * 300), 68.0, 831.0)
            end
        end
    end)
end

RebirthButton.MouseButton1Click:Connect(function()
    _G.AutoRebirth = not _G.AutoRebirth
    RebirthButton.Text = _G.AutoRebirth and "Auto-Rebirth: AN" or "Auto-Rebirth: AUS"
    RebirthButton.BackgroundColor3 = _G.AutoRebirth and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

task.spawn(function()
    local localPlayer = game:GetService("Players").LocalPlayer
    while not localPlayer do
        task.wait(0.5)
        localPlayer = game:GetService("Players").LocalPlayer
    end

    local playerGui = localPlayer:WaitForChild("PlayerGui", 10)
    local userInterface = playerGui and playerGui:WaitForChild("UserInterface", 5)
    local rankBar = userInterface and userInterface:WaitForChild("RankBar", 5)
    local rankLabel = rankBar and rankBar:WaitForChild("Label", 5)
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5):WaitForChild("Rebirth", 5)

    while task.wait(0.1) do
        if _G.AutoRebirth and rankLabel and remote then
            local text = rankLabel.Text

            if string.find(text, "M") or string.find(text, "B") then
                remote:FireServer()
            else
                local val = tonumber(string.match(text, "Rank%s*([%d%.]+)"))
                if string.find(text, "K") and val and val >= 297.5 then
                    remote:FireServer()
                end
            end
        end
    end
end)

CratesButton.MouseButton1Click:Connect(function()
    _G.AutoCrates = not _G.AutoCrates
    CratesButton.Text = _G.AutoCrates and "Auto-Collect Crates: AN" or "Auto-Collect Crates: AUS"
    CratesButton.BackgroundColor3 = _G.AutoCrates and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoCrates and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart

            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "MoneyCrate" then
                    local crateModel = obj:FindFirstChild("Crate") or obj
                    local targetPart = crateModel:FindFirstChild("Center")
                        or crateModel:FindFirstChildOfClass("BasePart")
                        or obj:FindFirstChildOfClass("BasePart")

                    if targetPart then
                        if obj:IsA("Model") then
                            obj:PivotTo(hrp.CFrame)
                        else
                            targetPart.CFrame = hrp.CFrame
                        end
                    end
                end
            end
        end
    end
end)

local function toggleClicker()
    _G.AutoClicker = not _G.AutoClicker
    ClickerButton.Text = _G.AutoClicker and "Auto-Clicker: AN" or "Auto-Clicker: AUS"
    ClickerButton.BackgroundColor3 = _G.AutoClicker and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end

ClickerButton.MouseButton1Click:Connect(toggleClicker)

-- ========================================================
-- MODIFIZIERTE MAUSFREIE AUTOCLICKER-SCHLEIFE
-- ========================================================
task.spawn(function()
    while true do
        if _G.AutoClicker and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
        task.wait(0.03)
    end
end)

BindButton.MouseButton1Click:Connect(function()
    IsBindingClicker = true
    BindButton.Text = "[ ... ]"
end)

FlyBindButton.MouseButton1Click:Connect(function()
    IsBindingFly = true
    FlyBindButton.Text = "[ ... ]"
end)

NoclipBindButton.MouseButton1Click:Connect(function()
    IsBindingNoclip = true
    NoclipBindButton.Text = "[ ... ]"
end)

uis.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if IsBindingClicker then
            CurrentBind = input.KeyCode
            IsBindingClicker = false
            BindButton.Text = "[ " .. input.KeyCode.Name .. " ]"
            return
        elseif IsBindingFly then
            FlyBind = input.KeyCode
            IsBindingFly = false
            FlyBindButton.Text = "[ " .. input.KeyCode.Name .. " ]"
            return
        elseif IsBindingNoclip then
            NoclipBind = input.KeyCode
            IsBindingNoclip = false
            NoclipBindButton.Text = "[ " .. input.KeyCode.Name .. " ]"
            return
        end

        if not gameProcessed then
            if CurrentBind and input.KeyCode == CurrentBind then
                toggleClicker()
            end
            if FlyBind and input.KeyCode == FlyBind then
                toggleFly()
            end
            if NoclipBind and input.KeyCode == NoclipBind then
                toggleNoclip()
            end
        end
    end

    if gameProcessed then return end

    if _G.AimbotEnabled and AimbotBind then
        if typeof(AimbotBind) == "EnumItem" and AimbotBind.EnumType == Enum.KeyCode then
            if input.KeyCode == AimbotBind then
                AimbotKeyDown = true
            end
        elseif typeof(AimbotBind) == "EnumItem" and AimbotBind.EnumType == Enum.UserInputType then
            if input.UserInputType == AimbotBind then
                AimbotKeyDown = true
            end
        end
    end
end)

uis.InputEnded:Connect(function(input)
    if AimbotBind then
        if typeof(AimbotBind) == "EnumItem" and AimbotBind.EnumType == Enum.KeyCode then
            if input.KeyCode == AimbotBind then
                AimbotKeyDown = false
            end
        elseif typeof(AimbotBind) == "EnumItem" and AimbotBind.EnumType == Enum.UserInputType then
            if input.UserInputType == AimbotBind then
                AimbotKeyDown = false
            end
        end
    end
end)

-- ========================================================
-- ADVANCED COMBAT CONFIGURATION (FOV & BALLISTICS)
-- ========================================================
_G.AimbotFOV = 150
_G.BulletVelocity = 2300
_G.BulletGravity = 28

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.6
FOVCircle.NumSides = 64
FOVCircle.Visible = false

-- ========================================================
-- ULTRA-ACCURATE XYZ CROSSHAIR INTEGRATION
-- ========================================================
local function getClosestPlayerToCrosshair()
    local closestPlayer = nil
    local shortestPixelDistance = _G.AimbotFOV
    local screenSize = camera.ViewportSize
    local guiService = game:GetService("GuiService")
    local topInsetValue = guiService:GetGuiInset().Y
    local realCrosshairCenter = Vector2.new(screenSize.X / 2, (screenSize.Y - topInsetValue) / 2)

    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Position = realCrosshairCenter
    FOVCircle.Visible = _G.AimbotEnabled

    for _, pl in pairs(players:GetPlayers()) do
        if pl ~= player and (pl.Team ~= player.Team or player.Team == nil) then
            local char = pl.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if head and hum and hum.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local pixelDistance = (Vector2.new(screenPos.X, screenPos.Y) - realCrosshairCenter).Magnitude
                    if pixelDistance < shortestPixelDistance then
                        closestPlayer = pl
                        shortestPixelDistance = pixelDistance
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- ADVANCED BALLISTIC XYZ PREDICTION LOOP
runService.RenderStepped:Connect(function()
    if _G.AimbotEnabled and AimbotKeyDown then
        AimbotTarget = getClosestPlayerToCrosshair()

        if AimbotTarget
            and AimbotTarget.Character
            and AimbotTarget.Character:FindFirstChild("Head")
            and player.Character then
            local targetHead = AimbotTarget.Character.Head
            local targetHrp = AimbotTarget.Character:FindFirstChild("HumanoidRootPart") or targetHead

            local targetPosition = targetHead.Position
            local distance = (targetPosition - camera.CFrame.Position).Magnitude
            local timeToTarget = distance / _G.BulletVelocity

            if targetHrp and targetHrp:IsA("BasePart") then
                local targetVelocity = targetHrp.AssemblyLinearVelocity
                targetPosition = targetPosition + (targetVelocity * timeToTarget)
            end

            local gravityOffset = 0.5 * _G.BulletGravity * (timeToTarget ^ 2)
            targetPosition = targetPosition + Vector3.new(0, gravityOffset, 0)

            local smoothVal = tonumber(AimbotSmoothInput.Text) or 5
            smoothVal = math.clamp(smoothVal, 1, 20)

            if not _G.Freecam then
                camera.CameraType = Enum.CameraType.Custom
                local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)

                if smoothVal == 1 then
                    camera.CFrame = targetCFrame
                else
                    camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1 / smoothVal)
                end
            end
        else
            AimbotTarget = nil
            FOVCircle.Visible = false
        end
    end
end)

-- ========================================================
-- REPARIERTE TRIGGERBOT-SCHLEIFE
-- ========================================================
task.spawn(function()
    local mouse = player:GetMouse()

    while true do
        task.wait(0.01)

        if _G.Triggerbot then
            local isAimbotLocking = (_G.AimbotEnabled and AimbotKeyDown and AimbotTarget ~= nil)
            local targetObject = mouse.Target
            local detectedCharacter = nil

            if targetObject then
                detectedCharacter = targetObject:FindFirstAncestorOfClass("Model")
            end

            if isAimbotLocking and AimbotTarget.Character then
                detectedCharacter = AimbotTarget.Character
            end

            if detectedCharacter then
                local humanoid = detectedCharacter:FindFirstChildOfClass("Humanoid")
                local targetPlayer = players:GetPlayerFromCharacter(detectedCharacter)

                if not targetPlayer and detectedCharacter.Parent then
                    targetPlayer = players:GetPlayerFromCharacter(detectedCharacter.Parent)
                end

                if humanoid and humanoid.Health > 0 and targetPlayer and targetPlayer ~= player then
                    if targetPlayer.Team ~= player.Team or targetPlayer.Team == nil then
                        local delayTime = tonumber(TriggerbotDelayInput.Text) or 20
                        task.wait(delayTime / 1000)

                        pcall(function()
                            local mousePos = uis:GetMouseLocation()
                            vim:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
                            task.wait(0.01)
                            vim:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
                        end)

                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)

TriggerbotToggleBtn.MouseButton1Click:Connect(function()
    _G.Triggerbot = not _G.Triggerbot
    TriggerbotToggleBtn.Text = _G.Triggerbot and "Triggerbot aktivieren: AN" or "Triggerbot aktivieren: AUS"
    TriggerbotToggleBtn.BackgroundColor3 = _G.Triggerbot and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

-- ========================================================
-- FEATURE AUTOMATION (PROMPTS, SPINBOT, AUTO-BUY, WALLBANG)
-- ========================================================

-- 1. INSTANT PROXIMITY PROMPT INTERACT
setupToggle(InstantPromptBtn, "InstantPrompt", "Instant Proximity Prompt")

game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if _G.InstantPrompt then
        fireproximityprompt(prompt)
    end
end)

-- 2. SPINBOT / ANTI-AIM SYSTEM
SpinbotToggleBtn.MouseButton1Click:Connect(function()
    _G.Spinbot = not _G.Spinbot
    SpinbotToggleBtn.Text = "Spinbot aktivieren" .. (_G.Spinbot and ": AN" or ": AUS")
    SpinbotToggleBtn.BackgroundColor3 = _G.Spinbot and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)

runService.Heartbeat:Connect(function()
    if _G.Spinbot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not _G.Freecam then
        local hrp = player.Character.HumanoidRootPart
        local speed = tonumber(SpinbotSpeedInput.Text) or 50
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed), 0)
    end
end)

-- 3. AUTO-BUY DROPPER / UPGRADER
setupToggle(AutoBuyBtn, "AutoBuyTycoon", "Auto-Buy Dropper/Upgrader")

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoBuyTycoon and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart

            for _, folder in pairs(workspace:GetDescendants()) do
                if folder.Name == "Buttons" or folder.Name == "TycoonButtons" then
                    for _, btn in pairs(folder:GetChildren()) do
                        local touchPart = btn:FindFirstChild("Head")
                            or btn:FindFirstChild("Dependency")
                            or (btn:IsA("BasePart") and btn)

                        if touchPart and btn:FindFirstChild("Price") then
                            if firetouchinterest then
                                firetouchinterest(hrp, touchPart, 0)
                                task.wait()
                                firetouchinterest(hrp, touchPart, 1)
                            else
                                pcall(function()
                                    local oldCFrame = touchPart.CFrame
                                    touchPart.CFrame = hrp.CFrame
                                    task.wait(0.05)
                                    touchPart.CFrame = oldCFrame
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 4. UNIVERSAL WALL-BANG / BULLET PENETRATION
setupToggle(WallbangBtn, "Wallbang", "Universal Wall-Bang")

local oldIsPartVisible = isPartVisible
isPartVisible = function(part, character)
    if _G.Wallbang then
        return true
    end
    return oldIsPartVisible(part, character)
end

print("[Arcanum Hub] Master Skript erfolgreich geladen!")
