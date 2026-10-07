if game.CoreGui:FindFirstChild("SolaraArcanumGui") then
	game.CoreGui.SolaraArcanumGui:Destroy()
end

-- ========================================================
-- GLOBAL STATE & DEFAULTS
-- ========================================================
_G.BulletVelocity = 2500
_G.BulletGravity = 35
_G.AimbotFOV = 150
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
_G.ChatTranslator = false
_G.TargetLanguage = "de"
_G.OutboundLanguage = "ru"

_G.NoRecoil = false
_G.NoFovKick = false
_G.NoScope = false
_G.GodMode = false
_G.NoFallingDamage = false
_G.NoFootsteps = false
_G.AutoReload = false
_G.SmartDodge = false
_G.SmartDodgeSensitivity = 20
_G.SpinbotSpeed = 50
_G.SpinbotJitter = false
_G.SpinbotFakeLagComp = false
_G.BodyPartTargeting = "Head"
_G.WeaponProfile = "Auto"
_G.CustomCrosshair = false
_G.CrosshairColor = "255,255,255"
_G.CrosshairSize = 12
_G.CrosshairGap = 4
_G.CrosshairThickness = 2
_G.EntityTarget = ""
_G.EntityKill = false
_G.AutoDrive = false
_G.AutoDriveSpeed = 250
_G.MegaBaconFarm = false
_G.AutoDriveActive = false
_G.MaxSpeedValue = 300
_G.SteerAngleSpeed = 3.5

local UI = {}
_G.UI_Elements = UI

local player = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local camera = workspace.CurrentCamera
local guiService = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local tpService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local virtualUser = game:GetService("VirtualUser")
local alive = true
local conns = {}
local function track(sig)
	return { Connect = function(_, f) local c = sig:Connect(f); table.insert(conns, c); return c end }
end

-- CORE UTILITY FUNCTIONS
local function getHumanoid()
	if player and player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

-- UI CREATION HELPERS
local function createSimpleButton(parent, text, color)
	local btn = Instance.new("TextButton")
	btn.Parent = parent;
	btn.Size = UDim2.new(1, -10, 0, 34);
	btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 48)
	btn.Text = text;
	btn.TextColor3 = Color3.fromRGB(255, 255, 255);
	btn.TextSize = 12;
	btn.Font = Enum.Font.GothamBold
	local c = Instance.new("UICorner");
	c.CornerRadius = UDim.new(0, 6);
	c.Parent = btn
	return btn
end

local function createBindRow(parent, btnText)
	local row = Instance.new("Frame");
	row.Size = UDim2.new(1, -10, 0, 34);
	row.BackgroundTransparency = 1;
	row.Parent = parent
	local actionBtn = Instance.new("TextButton");
	actionBtn.Parent = row;
	actionBtn.Size = UDim2.new(0, 245, 1, 0);
	actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60);
	actionBtn.Text = btnText .. ": AUS";
	actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	actionBtn.TextSize = 12;
	actionBtn.Font = Enum.Font.GothamBold
	local c1 = Instance.new("UICorner");
	c1.CornerRadius = UDim.new(0, 6);
	c1.Parent = actionBtn
	local bindBtn = Instance.new("TextButton");
	bindBtn.Parent = row;
	bindBtn.Size = UDim2.new(0, 100, 1, 0);
	bindBtn.Position = UDim2.new(0, 253, 0, 0);
	bindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48);
	bindBtn.Text = "[ None ]";
	bindBtn.TextColor3 = Color3.fromRGB(200, 200, 220);
	bindBtn.TextSize = 11;
	bindBtn.Font = Enum.Font.GothamMedium
	local c2 = Instance.new("UICorner");
	c2.CornerRadius = UDim.new(0, 6);
	c2.Parent = bindBtn
	return actionBtn, bindBtn
end

local function createToggleInputRow(parent, labelText, defaultVal)
	local row = Instance.new("Frame");
	row.Size = UDim2.new(1, -10, 0, 34);
	row.BackgroundTransparency = 1;
	row.Parent = parent
	local toggleBtn = Instance.new("TextButton");
	toggleBtn.Parent = row;
	toggleBtn.Size = UDim2.new(0, 245, 1, 0);
	toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60);
	toggleBtn.Text = labelText .. ": AUS";
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	toggleBtn.TextSize = 12;
	toggleBtn.Font = Enum.Font.GothamBold
	local c1 = Instance.new("UICorner");
	c1.CornerRadius = UDim.new(0, 6);
	c1.Parent = toggleBtn
	local box = Instance.new("TextBox");
	box.Parent = row;
	box.Size = UDim2.new(0, 100, 1, 0);
	box.Position = UDim2.new(0, 253, 0, 0);
	box.BackgroundColor3 = Color3.fromRGB(32, 32, 44);
	box.Text = tostring(defaultVal);
	box.TextColor3 = Color3.fromRGB(255, 255, 255);
	box.TextSize = 11;
	box.Font = Enum.Font.GothamMedium
	local c2 = Instance.new("UICorner");
	c2.CornerRadius = UDim.new(0, 6);
	c2.Parent = box
	return toggleBtn, box
end

-- GENERATE ALL THE SCREENS (Zuerst laden!)
UI.ScreenGui = Instance.new("ScreenGui");
UI.ScreenGui.Name = "SolaraArcanumGui";
UI.ScreenGui.Parent = game.CoreGui;
UI.ScreenGui.ResetOnSpawn = false
UI.MainFrame = Instance.new("Frame");
UI.MainFrame.Parent = UI.ScreenGui;
UI.MainFrame.Size = UDim2.new(0, 560, 0, 420);
UI.MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210);
UI.MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24);
UI.MainFrame.Active = true;
UI.MainFrame.Draggable = true
MainCorner = Instance.new("UICorner");
MainCorner.CornerRadius = UDim.new(0, 12);
MainCorner.Parent = UI.MainFrame
MainStroke = Instance.new("UIStroke");
MainStroke.Color = Color3.fromRGB(45, 45, 60);
MainStroke.Thickness = 1.5;
MainStroke.Parent = UI.MainFrame
local Topbar = Instance.new("Frame");
Topbar.Parent = UI.MainFrame;
Topbar.Size = UDim2.new(1, 0, 0, 45);
Topbar.BackgroundTransparency = 1
UI.TitleLabel = Instance.new("TextLabel");
UI.TitleLabel.Parent = Topbar;
UI.TitleLabel.Size = UDim2.new(0, 250, 1, 0);
UI.TitleLabel.Position = UDim2.new(0, 16, 0, 0);
UI.TitleLabel.BackgroundTransparency = 1;
UI.TitleLabel.Text = "ARCANUM HUB";
UI.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255);
UI.TitleLabel.TextSize = 18;
UI.TitleLabel.Font = Enum.Font.GothamBold;
UI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

UI.UnloadButton = createSimpleButton(Topbar, "🛑", Color3.fromRGB(180, 40, 40));
UI.UnloadButton.Size = UDim2.new(0, 30, 0, 30);
UI.UnloadButton.Position = UDim2.new(1, -74, 0, 8)
local CloseButton = createSimpleButton(Topbar, "✕", Color3.fromRGB(30, 30, 42));
CloseButton.Size = UDim2.new(0, 30, 0, 30);
CloseButton.Position = UDim2.new(1, -38, 0, 8)
UI.OpenButton = createSimpleButton(UI.ScreenGui, "➔", Color3.fromRGB(25, 25, 35));
UI.OpenButton.Size = UDim2.new(0, 42, 0, 42);
UI.OpenButton.Position = UDim2.new(0, 10, 0.5, -21);
UI.OpenButton.Visible = false

local Sidebar = Instance.new("Frame");
Sidebar.Parent = UI.MainFrame;
Sidebar.Size = UDim2.new(0, 150, 0, 355);
Sidebar.Position = UDim2.new(0, 12, 0, 50);
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
SidebarCorner = Instance.new("UICorner");
SidebarCorner.CornerRadius = UDim.new(0, 10);
SidebarCorner.Parent = Sidebar

local UniversalTabButton = Instance.new("TextButton");
UniversalTabButton.Parent = Sidebar;
UniversalTabButton.Size = UDim2.new(1, -16, 0, 34);
UniversalTabButton.Position = UDim2.new(0, 8, 0, 10);
UniversalTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
UniversalTabButton.Text = " Universal";
UniversalTabButton.TextColor3 = Color3.fromRGB(255, 255, 255);
UniversalTabButton.TextSize = 12;
UniversalTabButton.Font = Enum.Font.GothamMedium;
UniversalTabButton.TextXAlignment = Enum.TextXAlignment.Left
UniCatCorner = Instance.new("UICorner");
UniCatCorner.CornerRadius = UDim.new(0, 6);
UniCatCorner.Parent = UniversalTabButton
local FarmingTabButton = Instance.new("TextButton");
FarmingTabButton.Parent = Sidebar;
FarmingTabButton.Size = UDim2.new(1, -16, 0, 34);
FarmingTabButton.Position = UDim2.new(0, 8, 0, 48);
FarmingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
FarmingTabButton.Text = " Military Madness";
FarmingTabButton.TextColor3 = Color3.fromRGB(160, 160, 180);
FarmingTabButton.TextSize = 12;
FarmingTabButton.Font = Enum.Font.Gotham;
FarmingTabButton.TextXAlignment = Enum.TextXAlignment.Left
FarmCatCorner = Instance.new("UICorner");
FarmCatCorner.CornerRadius = UDim.new(0, 6);
FarmCatCorner.Parent = FarmingTabButton
local MWTabButton = Instance.new("TextButton");
MWTabButton.Parent = Sidebar;
MWTabButton.Size = UDim2.new(1, -16, 0, 34);
MWTabButton.Position = UDim2.new(0, 8, 0, 86);
MWTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
MWTabButton.Text = " Military Warfare";
MWTabButton.TextColor3 = Color3.fromRGB(160, 160, 180);
MWTabButton.TextSize = 12;
MWTabButton.Font = Enum.Font.Gotham;
MWTabButton.TextXAlignment = Enum.TextXAlignment.Left
MWCatCorner = Instance.new("UICorner");
MWCatCorner.CornerRadius = UDim.new(0, 6);
MWCatCorner.Parent = MWTabButton
local CarDealershipTabButton = Instance.new("TextButton");
CarDealershipTabButton.Parent = Sidebar;
CarDealershipTabButton.Size = UDim2.new(1, -16, 0, 34);
CarDealershipTabButton.Position = UDim2.new(0, 8, 0, 124);
CarDealershipTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
CarDealershipTabButton.Text = " Car Dealership";
CarDealershipTabButton.TextColor3 = Color3.fromRGB(160, 160, 180);
CarDealershipTabButton.TextSize = 12;
CarDealershipTabButton.Font = Enum.Font.Gotham;
CarDealershipTabButton.TextXAlignment = Enum.TextXAlignment.Left
CarCatCorner = Instance.new("UICorner");
CarCatCorner.CornerRadius = UDim.new(0, 6);
CarCatCorner.Parent = CarDealershipTabButton
local NoobBossTabButton = Instance.new("TextButton");
NoobBossTabButton.Parent = Sidebar;
NoobBossTabButton.Size = UDim2.new(1, -16, 0, 34);
NoobBossTabButton.Position = UDim2.new(0, 8, 0, 162);
NoobBossTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
NoobBossTabButton.Text = " Noob Boss Tycoon";
NoobBossTabButton.TextColor3 = Color3.fromRGB(160, 160, 180);
NoobBossTabButton.TextSize = 12;
NoobBossTabButton.Font = Enum.Font.Gotham;
NoobBossTabButton.TextXAlignment = Enum.TextXAlignment.Left
NoobCatCorner = Instance.new("UICorner");
NoobCatCorner.CornerRadius = UDim.new(0, 6);
NoobCatCorner.Parent = NoobBossTabButton
UI.UniversalPage = Instance.new("Frame");
UI.UniversalPage.Parent = UI.MainFrame;
UI.UniversalPage.Size = UDim2.new(0, 374, 0, 355);
UI.UniversalPage.Position = UDim2.new(0, 172, 0, 50);
UI.UniversalPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32);
UI.UniversalPage.Visible = true
ContentCorner1 = Instance.new("UICorner");
ContentCorner1.CornerRadius = UDim.new(0, 10);
ContentCorner1.Parent = UI.UniversalPage
UI.UniScroll = Instance.new("ScrollingFrame");
UI.UniScroll.Parent = UI.UniversalPage;
UI.UniScroll.Size = UDim2.new(1, -10, 1, -10);
UI.UniScroll.Position = UDim2.new(0, 5, 0, 5);
UI.UniScroll.BackgroundTransparency = 1;
UI.UniScroll.BorderSizePixel = 0;
UI.UniScroll.CanvasSize = UDim2.new(0, 0, 0, 0);
	UI.UniScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y;
UI.UniScroll.ScrollBarThickness = 4
UniList = Instance.new("UIListLayout");
UniList.Parent = UI.UniScroll;
UniList.SortOrder = Enum.SortOrder.LayoutOrder;
UniList.Padding = UDim.new(0, 6)
UI.FarmingPage = Instance.new("Frame");
UI.FarmingPage.Parent = UI.MainFrame;
UI.FarmingPage.Size = UDim2.new(0, 374, 0, 355);
UI.FarmingPage.Position = UDim2.new(0, 172, 0, 50);
UI.FarmingPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32);
UI.FarmingPage.Visible = false
ContentCorner2 = Instance.new("UICorner");
ContentCorner2.CornerRadius = UDim.new(0, 10);
ContentCorner2.Parent = UI.FarmingPage
UI.FarmingScroll = Instance.new("ScrollingFrame");
UI.FarmingScroll.Parent = UI.FarmingPage;
UI.FarmingScroll.Size = UDim2.new(1, -10, 1, -10);
UI.FarmingScroll.Position = UDim2.new(0, 5, 0, 5);
UI.FarmingScroll.BackgroundTransparency = 1;
UI.FarmingScroll.BorderSizePixel = 0;
UI.FarmingScroll.CanvasSize = UDim2.new(0, 0, 0, 420);
UI.FarmingScroll.ScrollBarThickness = 4
FarmListLayout = Instance.new("UIListLayout");
FarmListLayout.Parent = UI.FarmingScroll;
FarmListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
FarmListLayout.Padding = UDim.new(0, 6)
UI.MWPage = Instance.new("Frame");
UI.MWPage.Parent = UI.MainFrame;
UI.MWPage.Size = UDim2.new(0, 374, 0, 355);
UI.MWPage.Position = UDim2.new(0, 172, 0, 50);
UI.MWPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32);
UI.MWPage.Visible = false
UI.CarDealershipPage = Instance.new("Frame");
UI.CarDealershipPage.Parent = UI.MainFrame;
UI.CarDealershipPage.Size = UDim2.new(0, 374, 0, 355);
UI.CarDealershipPage.Position = UDim2.new(0, 172, 0, 50);
UI.CarDealershipPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32);
UI.CarDealershipPage.Visible = false
UI.NoobBossPage = Instance.new("Frame");
UI.NoobBossPage.Parent = UI.MainFrame;
UI.NoobBossPage.Size = UDim2.new(0, 374, 0, 355);
UI.NoobBossPage.Position = UDim2.new(0, 172, 0, 50);
UI.NoobBossPage.BackgroundColor3 = Color3.fromRGB(24, 24, 32);
UI.NoobBossPage.Visible = false
UI.ESPSubView = Instance.new("Frame");
UI.ESPSubView.Parent = UI.UniversalPage;
UI.ESPSubView.Size = UDim2.new(1, 0, 1, 0);
UI.ESPSubView.BackgroundTransparency = 1;
UI.ESPSubView.Visible = false
local ESPScroll = Instance.new("ScrollingFrame");
ESPScroll.Parent = UI.ESPSubView;
ESPScroll.Size = UDim2.new(1, -10, 1, -50);
ESPScroll.Position = UDim2.new(0, 5, 0, 45);
ESPScroll.BackgroundTransparency = 1;
ESPScroll.BorderSizePixel = 0;
ESPScroll.CanvasSize = UDim2.new(0, 0, 0, 400);
ESPScroll.ScrollBarThickness = 4
ESPList = Instance.new("UIListLayout");
ESPList.Parent = ESPScroll;
ESPList.SortOrder = Enum.SortOrder.LayoutOrder;
ESPList.Padding = UDim.new(0, 6)
UI.AimbotSubView = Instance.new("Frame");
UI.AimbotSubView.Parent = UI.UniversalPage;
UI.AimbotSubView.Size = UDim2.new(1, 0, 1, 0);
UI.AimbotSubView.BackgroundTransparency = 1;
UI.AimbotSubView.Visible = false
local AimScroll = Instance.new("ScrollingFrame");
AimScroll.Parent = UI.AimbotSubView;
AimScroll.Size = UDim2.new(1, -10, 1, -50);
AimScroll.Position = UDim2.new(0, 5, 0, 45);
AimScroll.BackgroundTransparency = 1;
AimScroll.BorderSizePixel = 0;
AimScroll.CanvasSize = UDim2.new(0, 0, 0, 350);
AimScroll.ScrollBarThickness = 4
AimList = Instance.new("UIListLayout");
AimList.Parent = AimScroll;
AimList.SortOrder = Enum.SortOrder.LayoutOrder;
AimList.Padding = UDim.new(0, 6)
UI.CombatSubView = Instance.new("Frame");
UI.CombatSubView.Parent = UI.UniversalPage;
UI.CombatSubView.Size = UDim2.new(1, 0, 1, 0);
UI.CombatSubView.BackgroundTransparency = 1;
UI.CombatSubView.Visible = false
local CombatScroll = Instance.new("ScrollingFrame");
CombatScroll.Parent = UI.CombatSubView;
CombatScroll.Size = UDim2.new(1, -10, 1, -50);
CombatScroll.Position = UDim2.new(0, 5, 0, 45);
CombatScroll.BackgroundTransparency = 1;
CombatScroll.BorderSizePixel = 0;
CombatScroll.CanvasSize = UDim2.new(0, 0, 0, 350);
CombatScroll.ScrollBarThickness = 4
CombatList = Instance.new("UIListLayout");
CombatList.Parent = CombatScroll;
CombatList.SortOrder = Enum.SortOrder.LayoutOrder;
CombatList.Padding = UDim.new(0, 6)
UI.SpinbotSubView = Instance.new("Frame");
UI.SpinbotSubView.Parent = UI.UniversalPage;
UI.SpinbotSubView.Size = UDim2.new(1, 0, 1, 0);
UI.SpinbotSubView.BackgroundTransparency = 1;
UI.SpinbotSubView.Visible = false
local SpinScroll = Instance.new("ScrollingFrame");
SpinScroll.Parent = UI.SpinbotSubView;
SpinScroll.Size = UDim2.new(1, -10, 1, -50);
SpinScroll.Position = UDim2.new(0, 5, 0, 45);
SpinScroll.BackgroundTransparency = 1;
SpinScroll.BorderSizePixel = 0;
SpinScroll.CanvasSize = UDim2.new(0, 0, 0, 320);
SpinScroll.ScrollBarThickness = 4
SpinList = Instance.new("UIListLayout");
SpinList.Parent = SpinScroll;
SpinList.SortOrder = Enum.SortOrder.LayoutOrder;
SpinList.Padding = UDim.new(0, 6)
UI.DodgeSubView = Instance.new("Frame");
UI.DodgeSubView.Parent = UI.UniversalPage;
UI.DodgeSubView.Size = UDim2.new(1, 0, 1, 0);
UI.DodgeSubView.BackgroundTransparency = 1;
UI.DodgeSubView.Visible = false
local DodgeScroll = Instance.new("ScrollingFrame");
DodgeScroll.Parent = UI.DodgeSubView;
DodgeScroll.Size = UDim2.new(1, -10, 1, -50);
DodgeScroll.Position = UDim2.new(0, 5, 0, 45);
DodgeScroll.BackgroundTransparency = 1;
DodgeScroll.BorderSizePixel = 0;
DodgeScroll.CanvasSize = UDim2.new(0, 0, 0, 250);
DodgeScroll.ScrollBarThickness = 4
DodgeList = Instance.new("UIListLayout");
DodgeList.Parent = DodgeScroll;
DodgeList.SortOrder = Enum.SortOrder.LayoutOrder;
DodgeList.Padding = UDim.new(0, 6)
UI.CrosshairSubView = Instance.new("Frame");
UI.CrosshairSubView.Parent = UI.UniversalPage;
UI.CrosshairSubView.Size = UDim2.new(1, 0, 1, 0);
UI.CrosshairSubView.BackgroundTransparency = 1;
UI.CrosshairSubView.Visible = false
local CrosshairScroll = Instance.new("ScrollingFrame");
CrosshairScroll.Parent = UI.CrosshairSubView;
CrosshairScroll.Size = UDim2.new(1, -10, 1, -50);
CrosshairScroll.Position = UDim2.new(0, 5, 0, 45);
CrosshairScroll.BackgroundTransparency = 1;
CrosshairScroll.BorderSizePixel = 0;
CrosshairScroll.CanvasSize = UDim2.new(0, 0, 0, 250);
CrosshairScroll.ScrollBarThickness = 4
CrossList = Instance.new("UIListLayout");
CrossList.Parent = CrosshairScroll;
CrossList.SortOrder = Enum.SortOrder.LayoutOrder;
CrossList.Padding = UDim.new(0, 6)
UI.ConfigSubView = Instance.new("Frame");
UI.ConfigSubView.Parent = UI.UniversalPage;
UI.ConfigSubView.Size = UDim2.new(1, 0, 1, 0);
UI.ConfigSubView.BackgroundTransparency = 1;
UI.ConfigSubView.Visible = false
UI.TriggerbotSubView = Instance.new("Frame");
UI.TriggerbotSubView.Parent = UI.UniversalPage;
UI.TriggerbotSubView.Size = UDim2.new(1, 0, 1, 0);
UI.TriggerbotSubView.BackgroundTransparency = 1;
UI.TriggerbotSubView.Visible = false
UI.ChatSubView = Instance.new("Frame");
UI.ChatSubView.Parent = UI.UniversalPage;
UI.ChatSubView.Size = UDim2.new(1, 0, 1, 0);
UI.ChatSubView.BackgroundTransparency = 1;
UI.ChatSubView.Visible = false
UI.ServerListSubView = Instance.new("Frame");
UI.ServerListSubView.Parent = UI.UniversalPage;
UI.ServerListSubView.Size = UDim2.new(1, 0, 1, 0);
UI.ServerListSubView.BackgroundTransparency = 1;
UI.ServerListSubView.Visible = false
-- GENERATE UI STUFF (Jetzt gefixt nach oben gesetzt)
local ClickerButton, BindButton = createBindRow(UI.UniScroll, "Auto-Clicker")
local FlyButton, FlyBindButton = createBindRow(UI.UniScroll, "Fly")
local NoclipButton, NoclipBindButton = createBindRow(UI.UniScroll, "Noclip")
local FreecamButton, FreecamSpeedInput = createToggleInputRow(UI.UniScroll, "Freecam", "1.2")
local SpeedBtn, SpeedInput = createToggleInputRow(UI.UniScroll, "Custom Speed", 50)
local JumpBtn, JumpInput = createToggleInputRow(UI.UniScroll, "Custom Jump", 100)
local FovBtn, FovInput = createToggleInputRow(UI.UniScroll, "Custom FOV", 90)
local InstantPromptBtn = createSimpleButton(UI.UniScroll, "Instant Proximity Prompt: AUS")
local WallbangBtn = createSimpleButton(UI.UniScroll, "Universal Wall-Bang: AUS")
local OpenAimbotSubmenu = createSimpleButton(UI.UniScroll, "Aimbot / Waffen-Profile  ➡")
local OpenESPSubmenu = createSimpleButton(UI.UniScroll, "ESP / Vision  ➡")
local OpenCombatSubmenu = createSimpleButton(UI.UniScroll, "Combat / No Recoil / God Mode  ➡")
local OpenSpinbotSubmenu = createSimpleButton(UI.UniScroll, "Spinbot / Anti-Aim  ➡")
local OpenDodgeSubmenu = createSimpleButton(UI.UniScroll, "Smart Dodge (Anti-Aimbot)  ➡")
local OpenCrosshairSubmenu = createSimpleButton(UI.UniScroll, "Custom Crosshair  ➡")
local OpenTriggerbotSubmenu = createSimpleButton(UI.UniScroll, "Triggerbot  ➡")
local OpenChatSubmenu = createSimpleButton(UI.UniScroll, "Chat-Übersetzer  ➡")
local OpenConfigSubmenu = createSimpleButton(UI.UniScroll, "Config Save / Load  ➡")
local OpenServerListSubmenu = createSimpleButton(UI.UniScroll, "Server List (Ping + Player)  ➡")
local ClickTpBtn = createSimpleButton(UI.UniScroll, "Click Teleport (Strg + Klick): AUS")
local InfJumpBtn = createSimpleButton(UI.UniScroll, "Infinite Jump: AUS")
local BrightBtn = createSimpleButton(UI.UniScroll, "Fullbright: AUS")
local FpsBtn = createSimpleButton(UI.UniScroll, "FPS Booster: AUS")
local AntiAfkBtn = createSimpleButton(UI.UniScroll, "Anti-AFK: AN", Color3.fromRGB(45, 180, 90))
local DexButton = createSimpleButton(UI.UniScroll, "Open Dex Explorer", Color3.fromRGB(90, 45, 180))
local IYButton = createSimpleButton(UI.UniScroll, "Open Infinite Yield", Color3.fromRGB(45, 120, 180))
local ServerRow = Instance.new("Frame");
ServerRow.Size = UDim2.new(1, -10, 0, 36);
ServerRow.BackgroundTransparency = 1;
ServerRow.Parent = UI.UniScroll
local RejoinBtn = createSimpleButton(ServerRow, "Rejoin Server", Color3.fromRGB(45, 110, 230));
RejoinBtn.Size = UDim2.new(0, 168, 1, 0)
local HopBtn = createSimpleButton(ServerRow, "Server Hop", Color3.fromRGB(140, 60, 220));
HopBtn.Size = UDim2.new(0, 168, 1, 0);
HopBtn.Position = UDim2.new(0, 176, 0, 0)
local DropContainer = Instance.new("Frame");
DropContainer.Parent = UI.UniScroll;
DropContainer.Size = UDim2.new(1, -10, 0, 36);
DropContainer.BackgroundTransparency = 1
local DropdownButton = createSimpleButton(DropContainer, "Spieler wählen... ▼");
DropdownButton.Size = UDim2.new(0, 245, 1, 0)
local ExecutePlayerTp = createSimpleButton(DropContainer, "Teleport", Color3.fromRGB(45, 110, 230));
ExecutePlayerTp.Size = UDim2.new(0, 100, 1, 0);
ExecutePlayerTp.Position = UDim2.new(0, 253, 0, 0)
local DropdownList = Instance.new("ScrollingFrame");
DropdownList.Parent = UI.UniversalPage;
DropdownList.Size = UDim2.new(0, 245, 0, 110);
DropdownList.Position = UDim2.new(0, 15, 0, 245);
DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
DropdownList.BorderSizePixel = 0;
DropdownList.Visible = false;
DropdownList.ZIndex = 12;
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
UIListLayout2 = Instance.new("UIListLayout");
UIListLayout2.Parent = DropdownList;
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
DropListCorner = Instance.new("UICorner");
DropListCorner.CornerRadius = UDim.new(0, 6);
DropListCorner.Parent = DropdownList
local EntityKillRow = Instance.new("Frame");
EntityKillRow.Size = UDim2.new(1, -10, 0, 38);
EntityKillRow.BackgroundTransparency = 1;
EntityKillRow.Parent = UI.UniScroll
local EntityNameInput = Instance.new("TextBox");
EntityNameInput.Parent = EntityKillRow;
EntityNameInput.Size = UDim2.new(0, 245, 1, 0);
EntityNameInput.BackgroundColor3 = Color3.fromRGB(32, 32, 44);
EntityNameInput.PlaceholderText = "Entity-Name eingeben...";
EntityNameInput.TextColor3 = Color3.fromRGB(255, 255, 255);
EntityNameInput.TextSize = 12;
EntityNameInput.Font = Enum.Font.GothamMedium
ec = Instance.new("UICorner");
ec.CornerRadius = UDim.new(0, 6);
ec.Parent = EntityNameInput
local EntityKillBtn = createSimpleButton(EntityKillRow, "Kill + TP", Color3.fromRGB(180, 40, 40));
EntityKillBtn.Size = UDim2.new(0, 100, 1, 0);
EntityKillBtn.Position = UDim2.new(0, 253, 0, 0)
local AutoDriveBtn = createSimpleButton(UI.UniScroll, "Auto-Drive (WASD + Car): AUS", Color3.fromRGB(200, 50, 60))
local BackESPButton = createSimpleButton(UI.ESPSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackESPButton.Size = UDim2.new(1, -20, 0, 32);
BackESPButton.Position = UDim2.new(0, 10, 0, 6)
local ESPMasterBtn = createSimpleButton(ESPScroll, "ESP Hauptschalter: AUS")
local ESPBoxBtn = createSimpleButton(ESPScroll, "2D Spieler-Box: AUS")
local ESPSkeletonBtn = createSimpleButton(ESPScroll, "Skelett-ESP: AUS")
local ESPNameBtn = createSimpleButton(ESPScroll, "Spielernamen anzeigen: AUS")
local ESPHealthBtn = createSimpleButton(ESPScroll, "Lebensbalken (Health): AUS")
local ESPItemBtn = createSimpleButton(ESPScroll, "Gehaltenes Item: AUS")
local ESPDistanceBtn = createSimpleButton(ESPScroll, "Distanz (In Metern): AUS")
local ESPTracerBtn = createSimpleButton(ESPScroll, "Snaplines (Linien): AUS")
local BackAimbotButton = createSimpleButton(UI.AimbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackAimbotButton.Size = UDim2.new(1, -20, 0, 32);
BackAimbotButton.Position = UDim2.new(0, 10, 0, 6)
local AimbotToggleBtn, AimbotSmoothInput = createToggleInputRow(AimScroll, "Aimbot (Aimlock)", "5")
local AimbotBindBtn = createSimpleButton(AimScroll, "Aimbot Halte-Taste: [ E ]")
local FovRow = Instance.new("Frame");
FovRow.Size = UDim2.new(1, -10, 0, 34);
FovRow.BackgroundTransparency = 1;
FovRow.Parent = AimScroll
local FovLabel = Instance.new("TextLabel");
FovLabel.Parent = FovRow;
FovLabel.Size = UDim2.new(0, 245, 1, 0);
FovLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
FovLabel.Text = " FOV Radius (Pixel):";
FovLabel.TextColor3 = Color3.fromRGB(220, 220, 240);
FovLabel.TextSize = 12;
FovLabel.Font = Enum.Font.GothamMedium
flc = Instance.new("UICorner");
flc.CornerRadius = UDim.new(0, 8);
flc.Parent = FovLabel
local FovInputBox = Instance.new("TextBox");
FovInputBox.Parent = FovRow;
FovInputBox.Size = UDim2.new(0, 100, 1, 0);
FovInputBox.Position = UDim2.new(0, 253, 0, 0);
FovInputBox.BackgroundColor3 = Color3.fromRGB(32, 32, 44);
FovInputBox.Text = "150";
FovInputBox.TextColor3 = Color3.fromRGB(255, 255, 255);
FovInputBox.TextSize = 11;
FovInputBox.Font = Enum.Font.GothamMedium
fic = Instance.new("UICorner");
fic.CornerRadius = UDim.new(0, 6);
fic.Parent = FovInputBox
local WeaponProfileBtn = createSimpleButton(AimScroll, "Waffen-Profil: Auto (Detect)")
local BodyPartBtn = createSimpleButton(AimScroll, "Zielbereich: Head")
local BackCombatButton = createSimpleButton(UI.CombatSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackCombatButton.Size = UDim2.new(1, -20, 0, 32);
BackCombatButton.Position = UDim2.new(0, 10, 0, 6)
local NoRecoilBtn = createSimpleButton(CombatScroll, "No Recoil: AUS")
local NoFovKickBtn = createSimpleButton(CombatScroll, "No FOV Kick: AUS")
local NoScopeBtn = createSimpleButton(CombatScroll, "No Scope / ADS: AUS")
local GodModeBtn = createSimpleButton(CombatScroll, "⚠ GOD MODE (BANNABLE): AUS", Color3.fromRGB(160, 20, 20))
local NoFallDmgBtn = createSimpleButton(CombatScroll, "No Falling Damage: AUS")
local NoFootstepsBtn = createSimpleButton(CombatScroll, "No Footsteps: AUS")
local AutoReloadBtn = createSimpleButton(CombatScroll, "Auto-Reload: AUS")
local BackSpinbotButton = createSimpleButton(UI.SpinbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackSpinbotButton.Size = UDim2.new(1, -20, 0, 32);
BackSpinbotButton.Position = UDim2.new(0, 10, 0, 6)
local SpinbotToggleBtn, SpinbotSpeedInput = createToggleInputRow(SpinScroll, "Spinbot aktivieren", "50")
local JitterBtn = createSimpleButton(SpinScroll, "Jitter / Random Angle: AUS")
local FakeLagCompBtn = createSimpleButton(SpinScroll, "Fake Lag Comp: AUS")
local BackDodgeButton = createSimpleButton(UI.DodgeSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackDodgeButton.Size = UDim2.new(1, -20, 0, 32);
BackDodgeButton.Position = UDim2.new(0, 10, 0, 6)
local DodgeToggleBtn, DodgeSensInput = createToggleInputRow(DodgeScroll, "Smart Dodge (Anti-Aim)", "20")
local BackCrosshairButton = createSimpleButton(UI.CrosshairSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackCrosshairButton.Size = UDim2.new(1, -20, 0, 32);
BackCrosshairButton.Position = UDim2.new(0, 10, 0, 6)
local CrosshairToggleBtn = createSimpleButton(CrosshairScroll, "Custom Crosshair: AUS")
local CrosshairColorBtn, CrosshairColorInput = createToggleInputRow(CrosshairScroll, "Crosshair Farbe (R,G,B)", "255,255,255")
local CrosshairSizeBtn, CrosshairSizeInput = createToggleInputRow(CrosshairScroll, "Strich-Länge (Pixel)", "12")
local CrosshairGapBtn, CrosshairGapInput = createToggleInputRow(CrosshairScroll, "Mitten-Lücke (Pixel)", "4")
local BackConfigButton = createSimpleButton(UI.ConfigSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackConfigButton.Size = UDim2.new(1, -20, 0, 32);
BackConfigButton.Position = UDim2.new(0, 10, 0, 8)
local ConfigContainer = Instance.new("Frame");
ConfigContainer.Parent = UI.ConfigSubView;
ConfigContainer.Size = UDim2.new(1, -20, 0, 150);
ConfigContainer.Position = UDim2.new(0, 10, 0, 48);
ConfigContainer.BackgroundTransparency = 1
ConfigListLayout = Instance.new("UIListLayout");
ConfigListLayout.Parent = ConfigContainer;
ConfigListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
ConfigListLayout.Padding = UDim.new(0, 8)
local SaveConfigBtn = createSimpleButton(ConfigContainer, "💾 Speichern (JSON)", Color3.fromRGB(45, 110, 230))
local LoadConfigBtn = createSimpleButton(ConfigContainer, "📂 Laden (JSON)", Color3.fromRGB(45, 180, 90))
local ConfigStatusLabel = Instance.new("TextLabel");
ConfigStatusLabel.Parent = ConfigContainer;
ConfigStatusLabel.Size = UDim2.new(1, -10, 0, 30);
ConfigStatusLabel.BackgroundTransparency = 1;
ConfigStatusLabel.Text = "";
ConfigStatusLabel.TextColor3 = Color3.fromRGB(180, 255, 180);
ConfigStatusLabel.TextSize = 12;
ConfigStatusLabel.Font = Enum.Font.GothamMedium
local BackTriggerbotButton = createSimpleButton(UI.TriggerbotSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackTriggerbotButton.Size = UDim2.new(1, -20, 0, 32);
BackTriggerbotButton.Position = UDim2.new(0, 10, 0, 8)
local TriggerbotContainer = Instance.new("Frame");
TriggerbotContainer.Parent = UI.TriggerbotSubView;
TriggerbotContainer.Size = UDim2.new(1, -20, 0, 150);
TriggerbotContainer.Position = UDim2.new(0, 10, 0, 48);
TriggerbotContainer.BackgroundTransparency = 1
TriggerListLayout = Instance.new("UIListLayout");
TriggerListLayout.Parent = TriggerbotContainer;
TriggerListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
TriggerListLayout.Padding = UDim.new(0, 8)
local TriggerbotToggleBtn, TriggerbotDelayInput = createToggleInputRow(TriggerbotContainer, "Triggerbot aktivieren", "20")
local BackChatButton = createSimpleButton(UI.ChatSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackChatButton.Size = UDim2.new(1, -20, 0, 32);
BackChatButton.Position = UDim2.new(0, 10, 0, 8)
local ChatContainer = Instance.new("Frame");
ChatContainer.Parent = UI.ChatSubView;
ChatContainer.Size = UDim2.new(1, -20, 0, 250);
ChatContainer.Position = UDim2.new(0, 10, 0, 48);
ChatContainer.BackgroundTransparency = 1
ChatListLayout = Instance.new("UIListLayout");
ChatListLayout.Parent = ChatContainer;
ChatListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
ChatListLayout.Padding = UDim.new(0, 8)
local ChatToggleBtn = createSimpleButton(ChatContainer, "Chat-Übersetzer: AUS")
local InboundRowBtn, InboundInput = createToggleInputRow(ChatContainer, "Eingehend übersetzen in", "de")
local OutboundRowBtn, OutboundInput = createToggleInputRow(ChatContainer, "Deine Antwort übersetzen in", "ru")
local ReplyRow = Instance.new("Frame");
ReplyRow.Size = UDim2.new(1, -10, 0, 36);
ReplyRow.BackgroundTransparency = 1;
ReplyRow.Parent = ChatContainer
local ReplyInput = Instance.new("TextBox");
ReplyInput.Parent = ReplyRow;
ReplyInput.Size = UDim2.new(1, 0, 1, 0);
ReplyInput.BackgroundColor3 = Color3.fromRGB(32, 32, 44);
ReplyInput.Text = "";
ReplyInput.PlaceholderText = "Hier auf Deutsch schreiben & Enter drücken...";
ReplyInput.TextColor3 = Color3.fromRGB(255, 255, 255);
ReplyInput.TextSize = 12;
ReplyInput.Font = Enum.Font.GothamMedium
rrc = Instance.new("UICorner");
rrc.CornerRadius = UDim.new(0, 6);
rrc.Parent = ReplyInput
local BackServerButton = createSimpleButton(UI.ServerListSubView, "⬅  Zurück zum Hauptmenü", Color3.fromRGB(45, 45, 60));
BackServerButton.Size = UDim2.new(1, -20, 0, 32);
BackServerButton.Position = UDim2.new(0, 10, 0, 8)
local ServerListTitle = Instance.new("TextLabel");
ServerListTitle.Parent = UI.ServerListSubView;
ServerListTitle.Size = UDim2.new(1, -20, 0, 24);
ServerListTitle.Position = UDim2.new(0, 10, 0, 44);
ServerListTitle.BackgroundTransparency = 1;
ServerListTitle.Text = " Lade Server...";
ServerListTitle.TextColor3 = Color3.fromRGB(200, 200, 220);
ServerListTitle.TextSize = 11;
ServerListTitle.Font = Enum.Font.GothamMedium;
ServerListTitle.TextXAlignment = Enum.TextXAlignment.Left
local ServerListContainer = Instance.new("ScrollingFrame");
ServerListContainer.Parent = UI.ServerListSubView;
ServerListContainer.Size = UDim2.new(1, -20, 0, 260);
ServerListContainer.Position = UDim2.new(0, 10, 0, 72);
ServerListContainer.BackgroundTransparency = 1;
ServerListContainer.BorderSizePixel = 0;
ServerListContainer.ScrollBarThickness = 4;
ServerListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListLayout = Instance.new("UIListLayout");
ServerListLayout.Parent = ServerListContainer;
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
ServerListLayout.Padding = UDim.new(0, 4)
UI.CarSpeedBoostBtn = createSimpleButton(UI.CarDealershipPage, "Car Speed-Boost: AUS", Color3.fromRGB(200, 50, 60))
UI.CarSpeedBoostBtn.Position = UDim2.new(0, 10, 0, 10)
UI.CarSpeedBoostBtn.Size = UDim2.new(0, 245, 0, 34)
UI.CarSpeedInput = Instance.new("TextBox")
UI.CarSpeedInput.Parent = UI.CarDealershipPage
UI.CarSpeedInput.Size = UDim2.new(0, 100, 0, 34)
UI.CarSpeedInput.Position = UDim2.new(0, 263, 0, 10)
UI.CarSpeedInput.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
UI.CarSpeedInput.Text = "300"
UI.CarSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UI.CarSpeedInput.TextSize = 11
UI.CarSpeedInput.Font = Enum.Font.GothamMedium
Instance.new("UICorner", UI.CarSpeedInput).CornerRadius = UDim.new(0, 6)
UI.NoobFarmBtn = createSimpleButton(UI.NoobBossPage, "Mega Bacon Farm: AUS", Color3.fromRGB(200, 50, 60))
UI.NoobFarmBtn.Position = UDim2.new(0, 10, 0, 10)
UI.NoobFarmBtn.Size = UDim2.new(0, 245, 0, 34)
-- ===== Zusätzliche UI: Farming-Seite, Airdrop, Beschriftungen =====
do
	local RED = Color3.fromRGB(200, 50, 60)
	UI.FarmingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	UI.FarmingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	UI.RebirthButton = createSimpleButton(UI.FarmingScroll, "Auto-Rebirth: AUS", RED)
	UI.CratesButton = createSimpleButton(UI.FarmingScroll, "Auto-Collect Crates: AUS", RED)
	UI.AutoBuyBtn = createSimpleButton(UI.FarmingScroll, "Auto-Buy Dropper/Upgrader: AUS", RED)
	local title = Instance.new("TextLabel")
	title.Parent = UI.FarmingScroll
	title.Size = UDim2.new(1, -10, 0, 20)
	title.BackgroundTransparency = 1
	title.Text = " Base Teleports"
	title.TextColor3 = Color3.fromRGB(200, 200, 220)
	title.TextSize = 11
	title.Font = Enum.Font.GothamMedium
	title.TextXAlignment = Enum.TextXAlignment.Left
	local grid = Instance.new("Frame")
	grid.Parent = UI.FarmingScroll
	grid.Size = UDim2.new(1, -10, 0, 84)
	grid.BackgroundTransparency = 1
	local layout = Instance.new("UIGridLayout")
	layout.Parent = grid
	layout.CellSize = UDim2.new(0, 112, 0, 34)
	layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	for i = 1, 6 do
		local b = createSimpleButton(grid, "Base " .. i)
		b.Size = UDim2.new(0, 112, 0, 34)
		b.MouseButton1Click:Connect(function()
			local hrp = UI.root and UI.root() or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
			if not hrp then return end
			local tycoons = workspace:FindFirstChild("Tycoons")
			local tycoon = tycoons and tycoons:FindFirstChild("Tycoon" .. i)
			local base = tycoon and tycoon:FindFirstChild("Base")
			if base and base:IsA("BasePart") then
				hrp.CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))
			else
				hrp.CFrame = CFrame.new(-1587 + ((i - 1) * 300), 68, 831)
			end
		end)
	end
	UI.AirdropButton = createSimpleButton(UI.MWPage, "Auto-Collect Airdrops: AUS", RED)
	UI.AirdropButton.Position = UDim2.new(0, 10, 0, 10)
	UI.AirdropButton.Size = UDim2.new(0, 245, 0, 34)

	-- Zeilen, die nur Beschriftung für das Eingabefeld sind, nicht wie Schalter aussehen lassen
	for _, item in ipairs({
		{ CrosshairColorBtn, "Farbe (R,G,B 0-255)" },
		{ CrosshairSizeBtn, "Strich-Länge (Pixel)" },
		{ CrosshairGapBtn, "Mitten-Lücke (Pixel)" },
		{ InboundRowBtn, "Eingehend übersetzen in (Kürzel)" },
		{ OutboundRowBtn, "Antwort übersetzen in (Kürzel)" },
	}) do
		local btn = item[1]
		btn.Text = " " .. item[2] .. ":"
		btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
		btn.TextColor3 = Color3.fromRGB(220, 220, 240)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.AutoButtonColor = false
		btn.Active = false
	end
end

-- ===== Neue Buttons: Ziel-Auswahl, Sichtbarkeit, Team-Check, No Spread, No Fog =====
do
	AimScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	AimScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	CombatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	CombatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	UI.AimModeBtn = createSimpleButton(AimScroll, "Ziel-Auswahl: Nächster zum Fadenkreuz", Color3.fromRGB(70, 70, 110))
	UI.AimVisBtn = createSimpleButton(AimScroll, "Nur sichtbare Ziele: AUS")
	UI.AimTeamBtn = createSimpleButton(AimScroll, "Team-Check: AN", Color3.fromRGB(45, 180, 90))
	UI.NoSpreadBtn = createSimpleButton(CombatScroll, "No Spread: AUS")
	UI.NoFogBtn = createSimpleButton(UI.UniScroll, "No Fog / Atmosphere: AUS")
end

-- ========================================================
-- ALL CORES FUNCTIONAL NAVIGATION LOGICS CONNECTS
-- ========================================================
local function closeAllMainPages()
	UI.UniversalPage.Visible = false;
	UI.FarmingPage.Visible = false;
	UI.MWPage.Visible = false;
	UI.CarDealershipPage.Visible = false;
	UI.NoobBossPage.Visible = false
	UI.ESPSubView.Visible = false;
	UI.AimbotSubView.Visible = false;
	UI.CombatSubView.Visible = false;
	UI.SpinbotSubView.Visible = false;
	UI.DodgeSubView.Visible = false;
	UI.CrosshairSubView.Visible = false;
	UI.ConfigSubView.Visible = false;
	UI.TriggerbotSubView.Visible = false;
	UI.ChatSubView.Visible = false;
	UI.ServerListSubView.Visible = false;
	UI.UniScroll.Visible = false
	UniversalTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
	UniversalTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
	FarmingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
	FarmingTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
	MWTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
	MWTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
	CarDealershipTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
	CarDealershipTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
	NoobBossTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38);
	NoobBossTabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
end
UniversalTabButton.MouseButton1Click:Connect(function()
	closeAllMainPages();
	UI.UniversalPage.Visible = true;
	UI.UniScroll.Visible = true;
	UniversalTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
	UniversalTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
FarmingTabButton.MouseButton1Click:Connect(function()
	closeAllMainPages();
	UI.FarmingPage.Visible = true;
	UI.FarmingScroll.Visible = true;
	FarmingTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
	FarmingTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
MWTabButton.MouseButton1Click:Connect(function()
	closeAllMainPages();
	UI.MWPage.Visible = true;
	MWTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
	MWTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
CarDealershipTabButton.MouseButton1Click:Connect(function()
	closeAllMainPages();
	UI.CarDealershipPage.Visible = true;
	CarDealershipTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
	CarDealershipTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
NoobBossTabButton.MouseButton1Click:Connect(function()
	closeAllMainPages();
	UI.NoobBossPage.Visible = true;
	NoobBossTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 58);
	NoobBossTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
local function navigateToSub(sub)
	UI.UniScroll.Visible = false;
	sub.Visible = true
end
OpenESPSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.ESPSubView)
end)
OpenAimbotSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.AimbotSubView)
end)
OpenCombatSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.CombatSubView)
end)
OpenSpinbotSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.SpinbotSubView)
end)
OpenDodgeSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.DodgeSubView)
end)
OpenCrosshairSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.CrosshairSubView)
end)
OpenConfigSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.ConfigSubView)
end)
OpenTriggerbotSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.TriggerbotSubView)
end)
OpenChatSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.ChatSubView)
end)
local function goBack()
	UI.ESPSubView.Visible = false;
	UI.AimbotSubView.Visible = false;
	UI.CombatSubView.Visible = false;
	UI.SpinbotSubView.Visible = false;
	UI.DodgeSubView.Visible = false;
	UI.CrosshairSubView.Visible = false;
	UI.ConfigSubView.Visible = false;
	UI.TriggerbotSubView.Visible = false;
	UI.ChatSubView.Visible = false;
	UI.ServerListSubView.Visible = false;
	UI.UniScroll.Visible = true
end
BackESPButton.MouseButton1Click:Connect(goBack);
BackAimbotButton.MouseButton1Click:Connect(goBack);
BackCombatButton.MouseButton1Click:Connect(goBack);
BackSpinbotButton.MouseButton1Click:Connect(goBack);
BackDodgeButton.MouseButton1Click:Connect(goBack);
BackCrosshairButton.MouseButton1Click:Connect(goBack);
BackConfigButton.MouseButton1Click:Connect(goBack);
BackTriggerbotButton.MouseButton1Click:Connect(goBack);
BackChatButton.MouseButton1Click:Connect(goBack);
BackServerButton.MouseButton1Click:Connect(goBack)
-- Setup Toggles Helper Connects
local function setupToggle(btn, varName, baseText)
    if not btn then return end
    UI.Toggles = UI.Toggles or {}
    table.insert(UI.Toggles, { btn = btn, var = varName, text = baseText })
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = baseText .. (_G[varName] and ": AN" or ": AUS")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
    end)
end
setupToggle(ESPMasterBtn, "ESPEnabled", "ESP Hauptschalter")
setupToggle(ESPBoxBtn, "ESPBoxes", "2D Spieler-Box")
setupToggle(ESPSkeletonBtn, "ESPSkeletons", "Skelett-ESP")
setupToggle(ESPNameBtn, "ESPNames", "Spielernamen anzeigen")
setupToggle(ESPHealthBtn, "ESPHealth", "Lebensbalken (Health)")
setupToggle(ESPItemBtn, "ESPItems", "Gehaltenes Item")
setupToggle(ESPDistanceBtn, "ESPDistances", "Distanz (In Metern)")
setupToggle(ESPTracerBtn, "ESPTracers", "Snaplines (Linien)")
setupToggle(NoRecoilBtn, "NoRecoil", "No Recoil")
setupToggle(NoFovKickBtn, "NoFovKick", "No FOV Kick")
setupToggle(NoScopeBtn, "NoScope", "No Scope / ADS")
setupToggle(NoFallDmgBtn, "NoFallingDamage", "No Falling Damage")
setupToggle(NoFootstepsBtn, "NoFootsteps", "No Footsteps")
setupToggle(AutoReloadBtn, "AutoReload", "Auto-Reload")
setupToggle(SpinbotToggleBtn, "Spinbot", "Spinbot aktivieren")
setupToggle(JitterBtn, "SpinbotJitter", "Jitter / Random Angle")
setupToggle(FakeLagCompBtn, "SpinbotFakeLagComp", "Fake Lag Comp")
setupToggle(DodgeToggleBtn, "SmartDodge", "Smart Dodge (Anti-Aim)")
setupToggle(InstantPromptBtn, "InstantPrompt", "Instant Proximity Prompt")
setupToggle(WallbangBtn, "Wallbang", "Universal Wall-Bang")
setupToggle(BrightBtn, "Fullbright", "Fullbright")
setupToggle(FpsBtn, "FpsBooster", "FPS Booster")
setupToggle(UI.AirdropButton, "AutoAirdrops", "Auto-Collect Airdrops")
setupToggle(UI.RebirthButton, "AutoRebirth", "Auto-Rebirth")
setupToggle(UI.CratesButton, "AutoCrates", "Auto-Collect Crates")
setupToggle(UI.AutoBuyBtn, "AutoBuyTycoon", "Auto-Buy Dropper/Upgrader")
setupToggle(AimbotToggleBtn, "AimbotEnabled", "Aimbot (Aimlock)")
setupToggle(ClickTpBtn, "ClickTp", "Click Teleport (Strg + Klick)")
setupToggle(InfJumpBtn, "InfJump", "Infinite Jump")
setupToggle(CrosshairToggleBtn, "CustomCrosshair", "Custom Crosshair")
setupToggle(ChatToggleBtn, "ChatTranslator", "Chat-Übersetzer")
setupToggle(GodModeBtn, "GodMode", "⚠ GOD MODE (BANNABLE)")
-- ========================================================
-- INPUT BINDING SYSTEM HANDLERS (ZUKUNFTSSICHER SYSTEM)
-- ========================================================
_G.CurrentBind = nil;
_G.FlyBind = nil;
_G.NoclipBind = nil
_G.IsBindingClicker = false;
_G.IsBindingFly = false;
_G.IsBindingNoclip = false
BindButton.MouseButton1Click:Connect(function()
	_G.IsBindingClicker = true;
	BindButton.Text = "[ ... ]"
end)
FlyBindButton.MouseButton1Click:Connect(function()
	_G.IsBindingFly = true;
	FlyBindButton.Text = "[ ... ]"
end)
NoclipBindButton.MouseButton1Click:Connect(function()
	_G.IsBindingNoclip = true;
	NoclipBindButton.Text = "[ ... ]"
end)
_G.AimbotBindList = { Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.F, Enum.KeyCode.LeftAlt, Enum.UserInputType.MouseButton2 }
_G.AimbotBindIndex = 1
_G.AimbotBind = _G.AimbotBindList[_G.AimbotBindIndex]
AimbotBindBtn.MouseButton1Click:Connect(function()
	_G.AimbotBindIndex = _G.AimbotBindIndex + 1;
	if _G.AimbotBindIndex > #_G.AimbotBindList then
		_G.AimbotBindIndex = 1
	end
	_G.AimbotBind = _G.AimbotBindList[_G.AimbotBindIndex];
	local keyName = typeof(_G.AimbotBind) == "EnumItem" and _G.AimbotBind.Name or "RMB (Rechte Maus)"
	if _G.AimbotBind == Enum.KeyCode.LeftAlt then
		keyName = "Links Alt"
	end;
	AimbotBindBtn.Text = "Aimbot Halte-Taste: [ " .. keyName .. " ]"
end)
FovInputBox:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(FovInputBox.Text);
	if val then
		_G.AimbotFOV = math.clamp(val, 30, 600)
	end
end)
SpinbotSpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(SpinbotSpeedInput.Text);
	if val then
		_G.SpinbotSpeed = math.clamp(val, 1, 100)
	end
end)
DodgeSensInput:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(DodgeSensInput.Text);
	if val then
		_G.SmartDodgeSensitivity = math.clamp(val, 5, 90)
	end
end)
_G.WeaponProfiles = {
	{ name = "Auto (Detect)", match = {}, velocity = 2000, gravity = 35, smooth = 5 },
	{ name = "Sniper (2500+ Stds)", match = { "AWP", "Sniper", "Kilo", "Barrett", "DMR", "M24", "Bolt", "L96", "SV98", "Mosin" }, velocity = 2800, gravity = 18, smooth = 2 },
	{ name = "AR / Rifle (100-800 Stds)", match = { "AK47", "M4", "AR", "Rifle", "FAMAS", "M16", "SCAR", "MK18", "H&K", "G36", "M4A1" }, velocity = 2000, gravity = 35, smooth = 4 },
	{ name = "SMG (Nah-Kampf)", match = { "MP5", "MP40", "UZI", "SMG", "P90", "MP7", "Vector", "MP9" }, velocity = 1300, gravity = 50, smooth = 7 },
	{ name = "Pistol (Nah-Kampf)", match = { "Desert", "Glock", "Pistol", "USP", "Beretta", "M9", "G17", "Colt", "Revolver" }, velocity = 1000, gravity = 45, smooth = 10 },
	{ name = "Shotgun (Sehr nah)", match = { "Shotgun", "Pump", "SPAS", "AA12", "Sawed", "M1014", "Remington" }, velocity = 800, gravity = 60, smooth = 12 },
}
_G.WeaponProfileIdx = 1
local function getActiveWeaponProfile()
	if _G.WeaponProfileIdx ~= 1 and _G.WeaponProfiles[_G.WeaponProfileIdx] then
		return _G.WeaponProfiles[_G.WeaponProfileIdx]
	end
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool then
		local n = tool.Name:lower()
		for _, p in ipairs(_G.WeaponProfiles) do
			for _, kw in ipairs(p.match) do
				if n:find(kw:lower(), 1, true) then return p end
			end
		end
	end
	return _G.WeaponProfiles[1]
end
local function getTargetPart(char, area)
	if area == "Torso" then
		return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
	elseif area == "Legs" then
		return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Left Leg")
			or char:FindFirstChild("Right Leg") or char:FindFirstChild("HumanoidRootPart")
	end
	return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end
local function getClosestPlayerToCrosshair()
	local size = camera.ViewportSize
	local center = Vector2.new(size.X / 2, (size.Y - guiService:GetGuiInset().Y) / 2)
	local myChar = player.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local mode = _G.AimbotModeIdx or 1
	-- Liefert eine Bewertung (kleiner = besser) oder nil, wenn das Ziel ungültig ist
	local function rate(pl)
		if pl == player then return nil end
		if _G.AimbotTeamCheck ~= false and player.Team ~= nil and pl.Team == player.Team then return nil end
		local char = pl.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local part = char and getTargetPart(char, _G.BodyPartTargeting)
		if not hum or hum.Health <= 0 or not part then return nil end
		local sp, on = camera:WorldToViewportPoint(part.Position)
		if not on then return nil end
		local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
		if screenDist > _G.AimbotFOV then return nil end
		if _G.AimbotVisibleOnly then
			local blocked = camera:GetPartsObscuringTarget({ part.Position }, { myChar, char })
			if #blocked > 0 then return nil end
		end
		local metric = screenDist
		if mode == 2 then
			metric = (part.Position - camera.CFrame.Position).Magnitude
		elseif mode == 3 then
			metric = -hum.Health
		elseif mode == 4 then
			metric = hum.Health
		elseif mode == 5 then
			metric = hum.Health / math.max(hum.MaxHealth, 1)
		elseif mode == 6 then
			local head = char:FindFirstChild("Head")
			if head and myRoot then
				local toMe = (myRoot.Position - head.Position).Unit
				metric = math.acos(math.clamp(head.CFrame.LookVector:Dot(toMe), -1, 1)) + (char:FindFirstChildOfClass("Tool") and 0 or 1)
			end
		end
		return metric + screenDist * 0.0001
	end
	local now = os.clock()
	-- Bei HP-/Gefahren-Modi am aktuellen Ziel festhalten, solange es gültig ist (verhindert Hin- und Herspringen)
	if mode >= 3 and UI.aimLock and now - (UI.aimLockT or 0) < 0.2 and rate(UI.aimLock) then
		UI.aimLockT = now
		return UI.aimLock
	end
	local best, bestScore = nil, math.huge
	for _, pl in ipairs(players:GetPlayers()) do
		local score = rate(pl)
		if score and score < bestScore then best, bestScore = pl, score end
	end
	UI.aimLock, UI.aimLockT = best, now
	return best
end
WeaponProfileBtn.MouseButton1Click:Connect(function()
	_G.WeaponProfileIdx = _G.WeaponProfileIdx % #_G.WeaponProfiles + 1;
	_G.WeaponProfile = _G.WeaponProfiles[_G.WeaponProfileIdx].name
	local p = _G.WeaponProfiles[_G.WeaponProfileIdx];
	WeaponProfileBtn.Text = "Waffen-Profil: " .. p.name
	_G.BulletVelocity = p.velocity;
	_G.BulletGravity = p.gravity
end)
_G.BodyPartOptions = { "Head", "Torso", "Legs" };
_G.BodyPartIdx = 1
BodyPartBtn.MouseButton1Click:Connect(function()
	_G.BodyPartIdx = _G.BodyPartIdx % #_G.BodyPartOptions + 1;
	_G.BodyPartTargeting = _G.BodyPartOptions[_G.BodyPartIdx];
	BodyPartBtn.Text = "Zielbereich: " .. _G.BodyPartOptions[_G.BodyPartIdx]
end)
-- VALUE MANAGEMENT HANDLERS
_G.DefaultWalkSpeed = 16;
_G.DefaultJumpPower = 50
JumpBtn.MouseButton1Click:Connect(function()
	_G.JumpEnabled = not _G.JumpEnabled;
	JumpBtn.Text = _G.JumpEnabled and "Custom Jump: AN" or "Custom Jump: AUS";
	JumpBtn.BackgroundColor3 = _G.JumpEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
	local hum = getHumanoid();
	if not _G.JumpEnabled and hum then
		hum.JumpPower = _G.DefaultJumpPower
	end
end)
SpeedBtn.MouseButton1Click:Connect(function()
	_G.SpeedEnabled = not _G.SpeedEnabled;
	SpeedBtn.Text = _G.SpeedEnabled and "Custom Speed: AN" or "Custom Speed: AUS";
	SpeedBtn.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
	local hum = getHumanoid();
	if not _G.SpeedEnabled and hum then
		hum.WalkSpeed = _G.DefaultWalkSpeed
	end
end)
FovBtn.MouseButton1Click:Connect(function()
	_G.FovEnabled = not _G.FovEnabled;
	FovBtn.Text = _G.FovEnabled and "Custom FOV: AN" or "Custom FOV: AUS";
	FovBtn.BackgroundColor3 = _G.FovEnabled and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
	if not _G.FovEnabled then
		camera.FieldOfView = 70
	end
end)
track(uis.JumpRequest):Connect(function()
	if _G.InfJump and getHumanoid() then
		getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
-- External Loaders
DexButton.MouseButton1Click:Connect(function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/HummingBird8/HummingRn/main/OptimizedDexForSolara.lua"))()
	end)
end)
IYButton.MouseButton1Click:Connect(function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)
end)
-- ========================================================
-- FINAL LOOPS & PHYSICS TICK SERVICES (Am Ende platziert)
-- ========================================================
track(runService.Heartbeat):Connect(function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if _G.JumpEnabled then
			local val = tonumber(JumpInput.Text);
			if val then
				hum.UseJumpPower = true;
				hum.JumpPower = val
			end
		end
		if _G.SpeedEnabled then
			local val = tonumber(SpeedInput.Text);
			if val then
				hum.WalkSpeed = val
			end
		end
	end
	if _G.FovEnabled then
		local val = tonumber(FovInput.Text);
		if val then
			camera.FieldOfView = val
		end
	end
end)
_G.AimbotKeyDown = false
track(uis.InputBegan):Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if _G.IsBindingClicker then
			_G.CurrentBind = input.KeyCode;
			_G.IsBindingClicker = false;
			BindButton.Text = "[ " .. input.KeyCode.Name .. " ]";
			return
		end
		if _G.IsBindingFly then
			_G.FlyBind = input.KeyCode;
			_G.IsBindingFly = false;
			FlyBindButton.Text = "[ " .. input.KeyCode.Name .. " ]";
			return
		end
		if _G.IsBindingNoclip then
			_G.NoclipBind = input.KeyCode;
			_G.IsBindingNoclip = false;
			NoclipBindButton.Text = "[ " .. input.KeyCode.Name .. " ]";
			return
		end
		if not gameProcessed then
			if _G.CurrentBind and input.KeyCode == _G.CurrentBind then
				_G.AutoClicker = not _G.AutoClicker;
				ClickerButton.Text = "Auto-Clicker: " .. (_G.AutoClicker and "AN" or "AUS");
				ClickerButton.BackgroundColor3 = _G.AutoClicker and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
			end
			if _G.FlyBind and input.KeyCode == _G.FlyBind then
				_G.Flying = not _G.Flying;
				FlyButton.Text = "Fly: " .. (_G.Flying and "AN" or "AUS");
				FlyButton.BackgroundColor3 = _G.Flying and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
			end
			if _G.NoclipBind and input.KeyCode == _G.NoclipBind then
				_G.Noclip = not _G.Noclip;
				NoclipButton.Text = "Noclip: " .. (_G.Noclip and "AN" or "AUS");
				NoclipButton.BackgroundColor3 = _G.Noclip and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
			end
		end
	end
	if gameProcessed then
		return
	end
	if _G.ClickTp and input.UserInputType == Enum.UserInputType.MouseButton1 and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
		local mouse = player:GetMouse()
		if mouse and mouse.Hit and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end
	if _G.AimbotEnabled and _G.AimbotBind then
		if typeof(_G.AimbotBind) == "EnumItem" and _G.AimbotBind.EnumType == Enum.KeyCode and input.KeyCode == _G.AimbotBind then
			_G.AimbotKeyDown = true
		elseif typeof(_G.AimbotBind) == "EnumItem" and _G.AimbotBind.EnumType == Enum.UserInputType and input.UserInputType == _G.AimbotBind then
			_G.AimbotKeyDown = true
		end
	end
end)
track(uis.InputEnded):Connect(function(input)
	if _G.AimbotBind then
		if typeof(_G.AimbotBind) == "EnumItem" and _G.AimbotBind.EnumType == Enum.KeyCode and input.KeyCode == _G.AimbotBind then
			_G.AimbotKeyDown = false
		elseif typeof(_G.AimbotBind) == "EnumItem" and _G.AimbotBind.EnumType == Enum.UserInputType and input.UserInputType == _G.AimbotBind then
			_G.AimbotKeyDown = false
		end
	end
end)

track(runService.RenderStepped):Connect(function()
	-- FIX: Prüft zuerst, ob alle mathematischen Funktionen und das Textfeld im Scope existieren
	if getClosestPlayerToCrosshair and getTargetPart and getActiveWeaponProfile and AimbotSmoothInput then
		if _G.AimbotEnabled and _G.AimbotKeyDown then
			local target = getClosestPlayerToCrosshair()
			if target and target.Character and player.Character then
				local targetPart = getTargetPart(target.Character, _G.BodyPartTargeting)
				local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
				if targetPart and targetHrp and targetHrp:IsA("BasePart") then
					local targetPosition = targetPart.Position
					local distance = (targetPosition - camera.CFrame.Position).Magnitude

					local profile = getActiveWeaponProfile()
					local bulletVelocity = profile and profile.velocity or _G.BulletVelocity
					local bulletGravity = profile and profile.gravity or _G.BulletGravity

					local timeToTarget = distance / bulletVelocity
					targetPosition = targetPosition + (targetHrp.AssemblyLinearVelocity * timeToTarget)
					targetPosition = targetPosition + Vector3.new(0, 0.5 * bulletGravity * (timeToTarget ^ 2), 0)

					local smoothVal = tonumber(AimbotSmoothInput.Text) or (profile and profile.smooth) or 5
					smoothVal = math.clamp(smoothVal, 1, 20)

					if not _G.Freecam then
						camera.CameraType = Enum.CameraType.Custom
						local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
						if smoothVal == 1 then camera.CFrame = targetCFrame else camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1 / smoothVal) end
					end
				end
			end
		end
	end
end)


task.spawn(function()
	while alive do
		if _G.AutoClicker then
			local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
			if tool then
				pcall(function()
					tool:Activate()
				end)
			else
				pcall(function()
					local mousePos = uis:GetMouseLocation();
					vim:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0);
					task.wait(0.01);
					vim:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
				end)
			end
		end;
		task.wait(0.03)
	end
end)
local flyBV, flyBG
track(runService.Heartbeat):Connect(function()
	local char = player.Character
	if _G.Flying and char and char:FindFirstChild("HumanoidRootPart") then
		local hrp = char.HumanoidRootPart;
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = true
		end
		if not flyBV then
			flyBV = Instance.new("BodyVelocity");
			flyBV.MaxForce = Vector3.new(1, 1, 1) * 10000000;
			flyBV.Parent = hrp
		end
		if not flyBG then
			flyBG = Instance.new("BodyGyro");
			flyBG.MaxTorque = Vector3.new(1, 1, 1) * 10000000;
			flyBG.P = 9000;
			flyBG.Parent = hrp
		end
		local speed = _G.SpeedEnabled and tonumber(SpeedInput.Text) or 60;
		local moveDir = Vector3.new(0, 0, 0)
		if uis:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + camera.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - camera.CFrame.LookVector
		end
		if uis:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - camera.CFrame.RightVector
		end
		if uis:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + camera.CFrame.RightVector
		end
		if uis:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0, 1, 0)
		end
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDir = moveDir - Vector3.new(0, 1, 0)
		end
		flyBV.Velocity = moveDir * speed;
		flyBG.CFrame = camera.CFrame
	else
		if flyBV then
			flyBV:Destroy();
			flyBV = nil
		end
		if flyBG then
			flyBG:Destroy();
			flyBG = nil
		end
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
		end
	end
end)
track(runService.Stepped):Connect(function()
	if (_G.Noclip or _G.Flying) and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
track(runService.RenderStepped):Connect(function()
	local char = player.Character;
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
end)
_G.SpeedForceObj, _G.AntiFlipGyroObj, _G.FakeFloorPartObj, _G.CurrentTargetYawVal = nil, nil, nil, 0
_G.CleanupPhysicsFunc = function()
	if _G.SpeedForceObj then
		pcall(function()
			_G.SpeedForceObj:Destroy()
		end);
		_G.SpeedForceObj = nil
	end
	if _G.AntiFlipGyroObj then
		pcall(function()
			_G.AntiFlipGyroObj:Destroy()
		end);
		_G.AntiFlipGyroObj = nil
	end
	if _G.FakeFloorPartObj then
		pcall(function()
			_G.FakeFloorPartObj:Destroy()
		end);
		_G.FakeFloorPartObj = nil
	end
end
-- FIX: Verhindert den Absturz, falls die lokale Variable nil ist
if UI.CarSpeedBoostBtn then
    UI.CarSpeedBoostBtn.MouseButton1Click:Connect(function()
        _G.AutoDriveActive = not _G.AutoDriveActive
        UI.CarSpeedBoostBtn.Text = _G.AutoDriveActive and "Car Speed-Boost: AN" or "Car Speed-Boost: AUS"
        UI.CarSpeedBoostBtn.BackgroundColor3 = _G.AutoDriveActive and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
        if _G.AutoDriveActive then
            pcall(function()
                local char = player.Character;
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local _, y, _ = char.HumanoidRootPart.CFrame:ToEulerAnglesYXZ();
                    _G.CurrentTargetYawVal = y
                end
            end)
        else
            _G.CleanupPhysicsFunc()
        end
    end)
end

-- FIX: Verhindert den Absturz, falls das Textfeld nil ist
if UI.CarSpeedInput then
	UI.CarSpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
		local val = tonumber(UI.CarSpeedInput.Text);
		if val then
			_G.MaxSpeedValue = math.clamp(val, 1, 2000)
		end
	end)
end

task.spawn(function()
	while alive do
		task.wait(0.01)
		if not _G.AutoDriveActive then
			continue
		end
		if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
			_G.CleanupPhysicsFunc();
			continue
		end
		local seat = nil
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("VehicleSeat") then
				if (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude < 15 then
					seat = obj;
					break
				end
			end
		end
		if seat then
			if not _G.SpeedForceObj or _G.SpeedForceObj.Parent ~= seat then
				_G.CleanupPhysicsFunc()
				_G.SpeedForceObj = Instance.new("BodyVelocity");
				_G.SpeedForceObj.MaxForce = Vector3.new(5000000, 0, 5000000);
				_G.SpeedForceObj.P = 12000;
				_G.SpeedForceObj.Parent = seat
				local _, y, _ = seat.CFrame:ToEulerAnglesYXZ();
				_G.CurrentTargetYawVal = y
			end
			if not _G.AntiFlipGyroObj or _G.AntiFlipGyroObj.Parent ~= seat then
				_G.AntiFlipGyroObj = Instance.new("BodyGyro");
				_G.AntiFlipGyroObj.MaxTorque = Vector3.new(9999999, 9999999, 9999999);
				_G.AntiFlipGyroObj.P = 35000;
				_G.AntiFlipGyroObj.D = 600;
				_G.AntiFlipGyroObj.Parent = seat
			end
			if not _G.FakeFloorPartObj or _G.FakeFloorPartObj.Parent ~= workspace then
				_G.FakeFloorPartObj = Instance.new("Part");
				_G.FakeFloorPartObj.Size = Vector3.new(4, 0.2, 4);
				_G.FakeFloorPartObj.Anchored = true;
				_G.FakeFloorPartObj.Transparency = 1;
				_G.FakeFloorPartObj.Parent = workspace
			end
			_G.FakeFloorPartObj.CFrame = CFrame.new(seat.Position - Vector3.new(0, 3, 0))
			if uis:IsKeyDown(Enum.KeyCode.A) then
				_G.CurrentTargetYawVal = _G.CurrentTargetYawVal + math.rad(_G.SteerAngleSpeed)
			elseif uis:IsKeyDown(Enum.KeyCode.D) then
				_G.CurrentTargetYawVal = _G.CurrentTargetYawVal - math.rad(_G.SteerAngleSpeed)
			end
			local flatCFrame = CFrame.Angles(0, _G.CurrentTargetYawVal, 0);
			_G.AntiFlipGyroObj.CFrame = flatCFrame
			if uis:IsKeyDown(Enum.KeyCode.W) then
				_G.SpeedForceObj.Velocity = flatCFrame.LookVector * _G.MaxSpeedValue
			elseif uis:IsKeyDown(Enum.KeyCode.S) then
				_G.SpeedForceObj.Velocity = -flatCFrame.LookVector * (_G.MaxSpeedValue / 2)
			else
				_G.SpeedForceObj.Velocity = Vector3.new(0, 0, 0)
			end;
			seat.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		else
			_G.CleanupPhysicsFunc()
		end
	end
end)
if UI.NoobFarmBtn then
	UI.NoobFarmBtn.MouseButton1Click:Connect(function()
		_G.MegaBaconFarm = not _G.MegaBaconFarm;
		UI.NoobFarmBtn.Text = _G.MegaBaconFarm and "Mega Bacon Farm: AN" or "Mega Bacon Farm: AUS"
		UI.NoobFarmBtn.BackgroundColor3 = _G.MegaBaconFarm and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
	end)
end
task.spawn(function()
	while alive do
		task.wait(0.05)
		if not _G.MegaBaconFarm then
			continue
		end
		local character = player.Character;
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			continue
		end
		for _, part in ipairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
		local bossEnter = workspace:FindFirstChild("Boss") and workspace.Boss:FindFirstChild("Office") and workspace.Boss.Office:FindFirstChild("BossEnter")
		local boss = workspace:FindFirstChild("Mega Bacon")
		if not boss then
			if bossEnter then
				local bPos = bossEnter:IsA("BasePart") and bossEnter.Position or (bossEnter:IsA("Model") and bossEnter.PrimaryPart and bossEnter.PrimaryPart.Position)
				if bPos and (rootPart.Position - bPos).Magnitude > 5 then
					rootPart.CFrame = bossEnter:IsA("Model") and bossEnter.PrimaryPart.CFrame or bossEnter.CFrame
				end
			end
		else
			local bPart = boss.PrimaryPart or boss:FindFirstChildOfClass("Part")
			if bPart then
				rootPart.CFrame = bPart.CFrame * CFrame.new(0, 0, 3);
				local tool = character:FindFirstChildOfClass("Tool");
				if tool then
					tool:Activate()
				end;
				task.wait(0.1)
			end
		end
	end
end)
UI.UnloadButton.MouseButton1Click:Connect(function()
	_G.AutoDriveActive, _G.MegaBaconFarm, _G.InfJump, _G.JumpEnabled, _G.SpeedEnabled, _G.ESPEnabled, _G.AimbotEnabled, _G.Flying, _G.Noclip, _G.Freecam, _G.AutoClicker = false, false, false, false, false, false, false, false, false, false, false
	_G.CleanupPhysicsFunc()
	_G.Fullbright, _G.GodMode, _G.NoRecoil, _G.NoFovKick, _G.FovEnabled, _G.ClickTp = false, false, false, false, false, false
	alive = false
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	if flyBV then flyBV:Destroy() end
	if flyBG then flyBG:Destroy() end
	local hum, hrp = getHumanoid(), player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hum then hum.PlatformStand = false end
	if hrp then hrp.Anchored = false end
	camera.CameraType = Enum.CameraType.Custom
	for _, f in ipairs(UI.Cleanups or {}) do pcall(f) end
	UI.ScreenGui:Destroy()
end)
FlyButton.MouseButton1Click:Connect(function()
	_G.Flying = not _G.Flying;
	FlyButton.Text = "Fly: " .. (_G.Flying and "AN" or "AUS");
	FlyButton.BackgroundColor3 = _G.Flying and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)
NoclipButton.MouseButton1Click:Connect(function()
	_G.Noclip = not _G.Noclip;
	NoclipButton.Text = "Noclip: " .. (_G.Noclip and "AN" or "AUS");
	NoclipButton.BackgroundColor3 = _G.Noclip and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)
ClickerButton.MouseButton1Click:Connect(function()
	_G.AutoClicker = not _G.AutoClicker;
	ClickerButton.Text = "Auto-Clicker: " .. (_G.AutoClicker and "AN" or "AUS");
	ClickerButton.BackgroundColor3 = _G.AutoClicker and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)
-- ========================================================
-- ERGÄNZTE MODULE (aus der alten Version)
-- Jedes Modul steht in einem do-Block: seine Locals zählen nicht gegen das 200er-Limit,
-- sobald der Block endet. Gemeinsame Helfer hängen an der UI-Tabelle, nicht an Locals.
-- ========================================================
UI.Cleanups = UI.Cleanups or {}
UI.newDrawing = function(kind)
	if not (Drawing and Drawing.new) then return nil end
	local ok, d = pcall(Drawing.new, kind)
	return ok and d or nil
end
UI.killDrawing = function(d)
	if d then pcall(function() d.Visible = false; d:Remove() end) end
end
UI.getProp = function(inst, name)
	local ok, v = pcall(function() return inst[name] end)
	if ok then return v end
	return nil
end
UI.setProp = function(inst, name, value)
	pcall(function() inst[name] = value end)
end
UI.root = function()
	local c = player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
UI.partPos = function(obj)
	if not obj then return nil end
	if obj:IsA("BasePart") then return obj.Position end
	if obj:IsA("Model") then
		local ok, cf = pcall(function() return obj:GetPivot() end)
		if ok then return cf.Position end
	end
	return nil
end

-- ===== ESP =====
do
	local newDrawing, killDrawing = UI.newDrawing, UI.killDrawing
	local store = {}

	local function clearOne(name)
		local e = store[name]
		if not e then return end
		for k, o in pairs(e) do
			if k == "Bones" then
				for i = 1, 5 do killDrawing(o[i]); o[i] = nil end
			else
				killDrawing(o)
			end
		end
		store[name] = nil
	end
	local function clearAll()
		for name in pairs(store) do clearOne(name) end
	end
	table.insert(UI.Cleanups, clearAll)

	local function visibleToMe(part, char)
		if _G.Wallbang then return true end
		local ok, res = pcall(function()
			return #camera:GetPartsObscuringTarget({ camera.CFrame.Position, part.Position }, { player.Character, char }) == 0
		end)
		return ok and res
	end

	local function ensure(esp, key, kind, init)
		if not esp[key] then
			local d = newDrawing(kind)
			if d then init(d) end
			esp[key] = d
		end
		return esp[key]
	end
	local function drop(esp, key)
		if esp[key] then killDrawing(esp[key]); esp[key] = nil end
	end
	local function textInit(size)
		return function(d) d.Size = size; d.Center = true; d.Outline = true end
	end

	local function bone(esp, idx, fromPos, toPart)
		if toPart then
			local p, on = camera:WorldToViewportPoint(toPart.Position)
			if on then
				local l = esp.Bones[idx]
				if not l then
					l = newDrawing("Line")
					if l then l.Thickness = 1.5 end
					esp.Bones[idx] = l
				end
				if l then
					l.From = Vector2.new(fromPos.X, fromPos.Y)
					l.To = Vector2.new(p.X, p.Y)
					l.Color = Color3.fromRGB(255, 255, 255)
					l.Visible = true
				end
				return
			end
		end
		if esp.Bones[idx] then killDrawing(esp.Bones[idx]); esp.Bones[idx] = nil end
	end

	track(runService.RenderStepped):Connect(function()
		if not _G.ESPEnabled then
			if next(store) then clearAll() end
			return
		end
		for _, pl in ipairs(players:GetPlayers()) do
			if pl ~= player then
				local char = pl.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local head = char and char:FindFirstChild("Head")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local drawn = false
				if hrp and head and hum and hum.Health > 0 then
					local hrpPos, hrpOn = camera:WorldToViewportPoint(hrp.Position)
					local headPos, headOn = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
					if hrpOn and headOn then
						drawn = true
						local esp = store[pl.Name]
						if not esp then esp = { Bones = {} }; store[pl.Name] = esp end
						local boxH = math.abs(headPos.Y - hrpPos.Y) * 2.5
						local boxW = boxH / 1.6
						local boxX, boxY = hrpPos.X - boxW / 2, hrpPos.Y - boxH / 2
						local color = visibleToMe(head, char) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 30, 30)

						if _G.ESPBoxes then
							local d = ensure(esp, "Box", "Square", function(x) x.Thickness = 1.5; x.Filled = false end)
							if d then d.Size = Vector2.new(boxW, boxH); d.Position = Vector2.new(boxX, boxY); d.Color = color; d.Visible = true end
						else drop(esp, "Box") end

						if _G.ESPNames then
							local d = ensure(esp, "Name", "Text", textInit(13))
							if d then d.Text = pl.DisplayName .. " (" .. pl.Name .. ")"; d.Position = Vector2.new(hrpPos.X, boxY - 30); d.Color = Color3.fromRGB(240, 240, 255); d.Visible = true end
						else drop(esp, "Name") end

						if _G.ESPDistances then
							local d = ensure(esp, "Dist", "Text", textInit(11))
							local me = UI.root()
							if d then
								d.Text = "[" .. (me and math.round((me.Position - hrp.Position).Magnitude) or 0) .. " Stds]"
								d.Position = Vector2.new(hrpPos.X, boxY - 15); d.Color = Color3.fromRGB(255, 200, 50); d.Visible = true
							end
						else drop(esp, "Dist") end

						if _G.ESPItems then
							local d = ensure(esp, "Item", "Text", textInit(11))
							local tool = char:FindFirstChildOfClass("Tool")
							if d then d.Text = tool and tool.Name or "[ Faust ]"; d.Position = Vector2.new(hrpPos.X, boxY + boxH + 5); d.Color = Color3.fromRGB(100, 200, 255); d.Visible = true end
						else drop(esp, "Item") end

						if _G.ESPHealth then
							local bg = ensure(esp, "HealthBg", "Line", function(x) x.Thickness = 3 end)
							local fg = ensure(esp, "HealthFg", "Line", function(x) x.Thickness = 3 end)
							local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
							if bg then bg.From = Vector2.new(boxX - 6, boxY); bg.To = Vector2.new(boxX - 6, boxY + boxH); bg.Color = Color3.fromRGB(80, 0, 0); bg.Visible = true end
							if fg then fg.From = Vector2.new(boxX - 6, boxY + boxH); fg.To = Vector2.new(boxX - 6, boxY + boxH - boxH * pct); fg.Color = Color3.fromRGB(0, 255, 50); fg.Visible = true end
						else drop(esp, "HealthBg"); drop(esp, "HealthFg") end

						if _G.ESPTracers then
							local d = ensure(esp, "Line", "Line", function(x) x.Thickness = 1.5; x.Color = Color3.fromRGB(255, 255, 0) end)
							if d then d.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y); d.To = Vector2.new(hrpPos.X, hrpPos.Y); d.Visible = true end
						else drop(esp, "Line") end

						local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
						if _G.ESPSkeletons and torso then
							local pT, onT = camera:WorldToViewportPoint(torso.Position)
							bone(esp, 1, headPos, torso)
							if onT then
								bone(esp, 2, pT, char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"))
								bone(esp, 3, pT, char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"))
								bone(esp, 4, pT, char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"))
								bone(esp, 5, pT, char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"))
							end
						else
							for i = 1, 5 do
								if esp.Bones[i] then killDrawing(esp.Bones[i]); esp.Bones[i] = nil end
							end
						end
					end
				end
				if not drawn then clearOne(pl.Name) end
			end
		end
	end)
	players.PlayerRemoving:Connect(function(pl) clearOne(pl.Name) end)
end

-- ===== FOV-Kreis + Custom Crosshair =====
do
	local newDrawing, killDrawing = UI.newDrawing, UI.killDrawing
	local fov = newDrawing("Circle")
	if fov then
		fov.Thickness = 1.5; fov.Color = Color3.fromRGB(255, 255, 255); fov.Filled = false
		fov.Transparency = 0.6; fov.NumSides = 64; fov.Visible = false
	end
	local lines = {}
	local function parseColor(str)
		local r, g, b = string.match(tostring(str), "(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
		if r then return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
		return Color3.new(1, 1, 1)
	end
	table.insert(UI.Cleanups, function()
		killDrawing(fov)
		for _, l in pairs(lines) do killDrawing(l) end
	end)
	track(runService.RenderStepped):Connect(function()
		local size = camera.ViewportSize
		local cx, cy = size.X / 2, (size.Y - guiService:GetGuiInset().Y) / 2
		if fov then
			fov.Position = Vector2.new(cx, cy)
			fov.Radius = _G.AimbotFOV
			fov.Visible = _G.AimbotEnabled == true
		end
		if _G.CustomCrosshair then
			if #lines == 0 then
				for i = 1, 4 do lines[i] = newDrawing("Line") end
			end
			local gap, len, color = _G.CrosshairGap, _G.CrosshairSize, parseColor(_G.CrosshairColor)
			local seg = {
				{ Vector2.new(cx, cy - gap), Vector2.new(cx, cy - gap - len) },
				{ Vector2.new(cx, cy + gap), Vector2.new(cx, cy + gap + len) },
				{ Vector2.new(cx - gap, cy), Vector2.new(cx - gap - len, cy) },
				{ Vector2.new(cx + gap, cy), Vector2.new(cx + gap + len, cy) },
			}
			for i = 1, 4 do
				local l = lines[i]
				if l then
					l.From, l.To, l.Color = seg[i][1], seg[i][2], color
					l.Thickness = _G.CrosshairThickness
					l.Visible = true
				end
			end
		else
			for _, l in pairs(lines) do l.Visible = false end
		end
	end)
	-- Eingabefelder der Crosshair-Seite
	CrosshairColorInput.FocusLost:Connect(function() _G.CrosshairColor = CrosshairColorInput.Text end)
	CrosshairSizeInput.FocusLost:Connect(function()
		local v = tonumber(CrosshairSizeInput.Text); if v then _G.CrosshairSize = math.clamp(v, 2, 40) end
	end)
	CrosshairGapInput.FocusLost:Connect(function()
		local v = tonumber(CrosshairGapInput.Text); if v then _G.CrosshairGap = math.clamp(v, 0, 20) end
	end)
end

-- ===== Triggerbot =====
do
	task.spawn(function()
		local mouse = player:GetMouse()
		while alive do
			task.wait(0.01)
			if _G.Triggerbot then
				local locking = _G.AimbotEnabled and _G.AimbotKeyDown
				local lockTarget = locking and getClosestPlayerToCrosshair() or nil
				local model = mouse.Target and mouse.Target:FindFirstAncestorOfClass("Model")
				if lockTarget and lockTarget.Character then model = lockTarget.Character end
				if model then
					local hum = model:FindFirstChildOfClass("Humanoid")
					local tp = players:GetPlayerFromCharacter(model)
					if hum and hum.Health > 0 and tp and tp ~= player and (tp.Team ~= player.Team or player.Team == nil) then
						task.wait((tonumber(TriggerbotDelayInput.Text) or 20) / 1000)
						pcall(function()
							local m = uis:GetMouseLocation()
							vim:SendMouseButtonEvent(m.X, m.Y, 0, true, game, 0)
							task.wait(0.01)
							vim:SendMouseButtonEvent(m.X, m.Y, 0, false, game, 0)
						end)
						task.wait(0.05)
					end
				end
			end
		end
	end)
end

-- ===== Spinbot (Jitter + Fake Lag Comp) =====
do
	local lastJitter, lastLag, lagUntil = 0, 0, 0
	track(runService.Heartbeat):Connect(function()
		if not _G.Spinbot or _G.Freecam then return end
		local hrp = UI.root()
		if not hrp then return end
		local speed = tonumber(SpinbotSpeedInput.Text) or 50
		local now = os.clock()
		if _G.SpinbotJitter and now - lastJitter > 0.3 then
			lastJitter = now
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, (math.random() * 2 - 1) * math.rad(15 + speed * 0.2), 0)
		end
		if _G.SpinbotFakeLagComp and now - lastLag > 2 then
			lastLag, lagUntil = now, now + 0.15
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(-speed * 0.8), 0)
		end
		if now >= lagUntil then
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed * 0.016), 0)
		end
	end)
end

-- ===== Auto-Reload / Instant Prompt / FPS-Booster =====
do
	task.spawn(function()
		local rs = game:GetService("ReplicatedStorage")
		while alive do
			task.wait(0.5)
			local tool = _G.AutoReload and player.Character and player.Character:FindFirstChildOfClass("Tool")
			if tool then
				local ammo
				for _, n in ipairs({ "Ammo", "CurrentAmmo", "Bullets", "MagazineAmmoCount" }) do
					local v = UI.getProp(tool, n)
					if typeof(v) == "Instance" and v:IsA("ValueBase") then v = v.Value end
					if typeof(v) == "number" then ammo = v break end
				end
				if ammo == nil then
					local a = tool:GetAttribute("Ammo")
					if typeof(a) == "number" then ammo = a end
				end
				if ammo and ammo <= 0 then
					local remotes = rs:FindFirstChild("Remotes")
					local r = remotes and (remotes:FindFirstChild("Reload") or remotes:FindFirstChild("ReReload") or remotes:FindFirstChild("ReloadWeapon"))
					if r then
						pcall(function() r:FireServer(tool) end)
					else
						pcall(function()
							vim:SendKeyEvent(true, Enum.KeyCode.R, false, game)
							task.wait(0.05)
							vim:SendKeyEvent(false, Enum.KeyCode.R, false, game)
						end)
					end
				end
			end
		end
	end)

	track(game:GetService("ProximityPromptService").PromptButtonHoldBegan):Connect(function(prompt)
		if _G.InstantPrompt and fireproximityprompt then pcall(fireproximityprompt, prompt) end
	end)

	task.spawn(function()
		local applied = false
		while alive do
			task.wait(0.5)
			if _G.FpsBooster and not applied then
				applied = true
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
					elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
				end
			elseif not _G.FpsBooster then
				applied = false
			end
		end
	end)
end

-- ===== Chat-Übersetzer =====
do
	local TCS = game:GetService("TextChatService")
	local function translate(text, lang)
		if not text or text == "" then return text end
		local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. lang .. "&dt=t&q=" .. httpService:UrlEncode(text)
		local ok, res = pcall(function() return game:HttpGet(url) end)
		if not ok or type(res) ~= "string" then return text end
		local ok2, data = pcall(function() return httpService:JSONDecode(res) end)
		if ok2 and type(data) == "table" and type(data[1]) == "table" then
			local out = {}
			for _, seg in ipairs(data[1]) do
				if type(seg) == "table" and seg[1] then table.insert(out, tostring(seg[1])) end
			end
			if #out > 0 then return table.concat(out) end
		end
		return text
	end
	local function show(sender, translated)
		local msg = "[" .. sender .. " ➔ " .. string.upper(_G.TargetLanguage) .. "]: " .. translated
		local ok = pcall(function()
			game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", { Text = msg, Color = Color3.fromRGB(100, 255, 200) })
		end)
		if not ok then
			pcall(function() TCS.TextChannels.RBXGeneral:DisplaySystemMessage(msg) end)
		end
	end
	local function onIncoming(sender, text)
		if not _G.ChatTranslator or sender == player.Name then return end
		task.spawn(function()
			local t = translate(text, _G.TargetLanguage)
			if t and t ~= text then show(sender, t) end
		end)
	end
	-- Legacy-Chat
	local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
	local done = ev and ev:FindFirstChild("OnMessageDoneFiltering")
	if done then
		track(done.OnClientEvent):Connect(function(d)
			if d and d.FromSpeaker then onIncoming(d.FromSpeaker, d.Message) end
		end)
	end
	-- Neuer TextChatService
	pcall(function()
		track(TCS.MessageReceived):Connect(function(m)
			if m.TextSource then onIncoming(m.TextSource.Name, m.Text) end
		end)
	end)
	ReplyInput.FocusLost:Connect(function(enter)
		local raw = ReplyInput.Text
		if not enter or raw == "" then return end
		ReplyInput.Text = ""
		task.spawn(function()
			local out = translate(raw, _G.OutboundLanguage)
			local sent = pcall(function()
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(out, "All")
			end)
			if not sent then pcall(function() TCS.TextChannels.RBXGeneral:SendAsync(out) end) end
		end)
	end)
	InboundInput:GetPropertyChangedSignal("Text"):Connect(function()
		_G.TargetLanguage = string.lower(string.sub(InboundInput.Text, 1, 2))
	end)
	OutboundInput:GetPropertyChangedSignal("Text"):Connect(function()
		_G.OutboundLanguage = string.lower(string.sub(OutboundInput.Text, 1, 2))
	end)
end

-- ===== Entity Killer =====
do
	EntityKillBtn.MouseButton1Click:Connect(function()
		_G.EntityTarget = EntityNameInput.Text
		_G.EntityKill = true
		EntityNameInput.Text = ""
	end)
	task.spawn(function()
		while alive do
			task.wait(0.5)
			local name = _G.EntityTarget
			if name and name ~= "" then
				local ent = workspace:FindFirstChild(name, true)
				if ent then
					local hrp = UI.root()
					local pos = UI.partPos(ent)
					if hrp and pos then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) end
					if _G.EntityKill then pcall(function() ent:Destroy() end) end
					_G.EntityTarget = ""
				end
			end
		end
	end)
end

-- ===== Farming: Rebirth / Crates / Airdrops / Auto-Buy =====
do
	task.spawn(function()
		local rs = game:GetService("ReplicatedStorage")
		local remote, label
		while alive do
			task.wait(0.2)
			if _G.AutoRebirth then
				if not label then
					local gui = player:FindFirstChild("PlayerGui")
					local ui = gui and gui:FindFirstChild("UserInterface")
					local bar = ui and ui:FindFirstChild("RankBar")
					label = bar and bar:FindFirstChild("Label")
				end
				if not remote then
					local remotes = rs:FindFirstChild("Remotes")
					remote = remotes and remotes:FindFirstChild("Rebirth")
				end
				if label and remote then
					local text = label.Text
					if text:find("M") or text:find("B") then
						remote:FireServer()
					else
						local val = tonumber(text:match("Rank%s*([%d%.]+)"))
						if text:find("K") and val and val >= 297.5 then remote:FireServer() end
					end
				end
			end
		end
	end)

	task.spawn(function()
		while alive do
			task.wait(0.5)
			local hrp = UI.root()
			if hrp and _G.AutoCrates then
				for _, obj in ipairs(workspace:GetChildren()) do
					if obj.Name == "MoneyCrate" then
						if obj:IsA("Model") then
							obj:PivotTo(hrp.CFrame)
						else
							local p = obj:FindFirstChildOfClass("BasePart")
							if p then p.CFrame = hrp.CFrame end
						end
					end
				end
			end
		end
	end)

	task.spawn(function()
		while alive do
			task.wait(0.7)
			local hrp = UI.root()
			if hrp and _G.AutoAirdrops then
				for _, obj in ipairs(workspace:GetChildren()) do
					if obj.Name:lower():find("airdrop", 1, true) then
						local pos = UI.partPos(obj)
						if pos then
							hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
							task.wait(0.4)
						end
					end
				end
			end
		end
	end)

	task.spawn(function()
		while alive do
			task.wait(0.5)
			local hrp = UI.root()
			if hrp and _G.AutoBuyTycoon then
				for _, folder in ipairs(workspace:GetDescendants()) do
					if folder.Name == "Buttons" or folder.Name == "TycoonButtons" then
						for _, btn in ipairs(folder:GetChildren()) do
							local part = btn:FindFirstChild("Head") or btn:FindFirstChild("Dependency") or (btn:IsA("BasePart") and btn)
							if part and btn:FindFirstChild("Price") then
								if firetouchinterest then
									pcall(function()
										firetouchinterest(hrp, part, 0)
										task.wait()
										firetouchinterest(hrp, part, 1)
									end)
								else
									pcall(function()
										local old = part.CFrame
										part.CFrame = hrp.CFrame
										task.wait(0.05)
										part.CFrame = old
									end)
								end
							end
						end
					end
				end
			end
		end
	end)
end

-- ===== Config speichern / laden =====
do
	local KEYS = {
		"BulletVelocity", "BulletGravity", "AimbotFOV", "NoRecoil", "NoFovKick", "NoScope", "GodMode",
		"NoFallingDamage", "NoFootsteps", "AutoReload", "SmartDodge", "SmartDodgeSensitivity",
		"CustomCrosshair", "CrosshairColor", "CrosshairSize", "CrosshairGap", "CrosshairThickness",
		"SpinbotJitter", "SpinbotFakeLagComp", "BodyPartTargeting", "WeaponProfile", "WeaponProfileIdx",
		"AimbotEnabled", "Triggerbot", "ESPEnabled", "ESPBoxes", "ESPSkeletons", "ESPNames", "ESPHealth",
		"ESPItems", "ESPDistances", "ESPTracers", "SpeedEnabled", "JumpEnabled", "FovEnabled",
		"Noclip", "InfJump", "Fullbright", "FpsBooster", "AutoRebirth", "AutoCrates", "AutoAirdrops",
		"NoSpread", "NoFog", "AimbotVisibleOnly", "AimbotTeamCheck", "AimbotModeIdx",
		"Spinbot", "AutoBuyTycoon", "InstantPrompt", "Wallbang", "ChatTranslator", "TargetLanguage", "OutboundLanguage",
	}
	local FILE = "ArcanumConfig.json"
	local function status(text, ok)
		ConfigStatusLabel.Text = text
		ConfigStatusLabel.TextColor3 = ok and Color3.fromRGB(180, 255, 180) or Color3.fromRGB(255, 160, 160)
	end
	SaveConfigBtn.MouseButton1Click:Connect(function()
		local data = {}
		for _, k in ipairs(KEYS) do data[k] = _G[k] end
		local json = httpService:JSONEncode(data)
		if writefile then
			local ok, err = pcall(writefile, FILE, json)
			status(ok and ("Gespeichert: " .. FILE) or ("Fehler: " .. tostring(err)), ok)
		else
			status("writefile fehlt in deinem Executor", false)
			if setclipboard then pcall(setclipboard, json) end
		end
	end)
	LoadConfigBtn.MouseButton1Click:Connect(function()
		if not (readfile and isfile) then status("readfile/isfile fehlt in deinem Executor", false) return end
		if not isfile(FILE) then status("Keine Config gefunden.", false) return end
		local ok, data = pcall(function() return httpService:JSONDecode(readfile(FILE)) end)
		if not ok or type(data) ~= "table" then status("Config ist beschädigt.", false) return end
		for _, k in ipairs(KEYS) do
			if data[k] ~= nil then _G[k] = data[k] end
		end
		for _, t in ipairs(UI.Toggles or {}) do
			local on = _G[t.var] and true or false
			t.btn.Text = t.text .. (on and ": AN" or ": AUS")
			t.btn.BackgroundColor3 = on and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
		end
		_G.AimbotKeyDown = false
		if UI.AfterConfigLoad then UI.AfterConfigLoad() end
		status("Geladen: " .. FILE, true)
	end)
end

-- ========================================================
-- VERBESSERTE COMBAT-MODULE
-- ========================================================
setupToggle(UI.NoSpreadBtn, "NoSpread", "No Spread")
setupToggle(UI.NoFogBtn, "NoFog", "No Fog / Atmosphere")
setupToggle(UI.AimVisBtn, "AimbotVisibleOnly", "Nur sichtbare Ziele")
_G.AimbotTeamCheck = true
setupToggle(UI.AimTeamBtn, "AimbotTeamCheck", "Team-Check")

-- ===== Aimbot: Ziel-Auswahl =====
do
	local MODES = {
		"Nächster zum Fadenkreuz", "Nächste Distanz", "Meiste HP",
		"Wenigste HP", "Niedrigste HP %", "Gefährlichster (zielt auf dich)",
	}
	_G.AimbotModeIdx = _G.AimbotModeIdx or 1
	local function refresh()
		UI.AimModeBtn.Text = "Ziel-Auswahl: " .. (MODES[_G.AimbotModeIdx] or MODES[1])
	end
	UI.AimModeBtn.MouseButton1Click:Connect(function()
		_G.AimbotModeIdx = _G.AimbotModeIdx % #MODES + 1
		refresh()
	end)
	UI.AfterConfigLoad = refresh
end

-- ===== Freecam mit Maus-Blick (rechte Maustaste gedrückt halten) =====
do
	local yaw, pitch, active = 0, 0, false
	local function stop()
		if not active then return end
		active = false
		uis.MouseBehavior = Enum.MouseBehavior.Default
		local hrp = UI.root()
		if hrp then hrp.Anchored = false end
		camera.CameraType = Enum.CameraType.Custom
	end
	table.insert(UI.Cleanups, stop)
	track(runService.RenderStepped):Connect(function(dt)
		if not _G.Freecam then stop() return end
		if not active then
			active = true
			pitch, yaw = camera.CFrame:ToOrientation()
		end
		local hrp = UI.root()
		if hrp then hrp.Anchored = true end
		camera.CameraType = Enum.CameraType.Scriptable
		if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			uis.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			local d = uis:GetMouseDelta()
			yaw = yaw - d.X * 0.0035
			pitch = math.clamp(pitch - d.Y * 0.0035, -math.rad(89), math.rad(89))
		else
			uis.MouseBehavior = Enum.MouseBehavior.Default
		end
		local rot = CFrame.fromOrientation(pitch, yaw, 0)
		local pos = camera.CFrame.Position
		if not uis:GetFocusedTextBox() then
			local mv = Vector3.zero
			if uis:IsKeyDown(Enum.KeyCode.W) then mv = mv + rot.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then mv = mv - rot.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.D) then mv = mv + rot.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.A) then mv = mv - rot.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.Space) or uis:IsKeyDown(Enum.KeyCode.E) then mv = mv + Vector3.yAxis end
			if uis:IsKeyDown(Enum.KeyCode.LeftControl) or uis:IsKeyDown(Enum.KeyCode.Q) then mv = mv - Vector3.yAxis end
			if mv.Magnitude > 0 then
				local speed = (tonumber(FreecamSpeedInput.Text) or 1.2) * 60 * dt
				if uis:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 3 end
				pos = pos + mv.Unit * speed
			end
		end
		camera.CFrame = CFrame.new(pos) * rot
	end)
end

-- ===== No Recoil + No Spread (Werte, Attribute, Modul-Configs, GC-Tabellen) =====
do
	local RECOIL = { "recoil", "kick" }
	local SPREAD = { "spread", "bloom", "inaccura", "scatter" }
	local HINTS = { "firerate", "damage", "ammo", "magsize", "magazine", "reload", "bulletspeed", "muzzle", "projectile", "range" }
	local backup, visited = {}, {}

	local function has(name, list)
		name = name:lower()
		for _, w in ipairs(list) do
			if name:find(w, 1, true) then return true end
		end
		return false
	end
	local function wantKey(key)
		if type(key) ~= "string" then return false end
		return (_G.NoRecoil and has(key, RECOIL)) or (_G.NoSpread and has(key, SPREAD)) or false
	end
	local function save(container, key, value)
		backup[container] = backup[container] or {}
		if backup[container][key] == nil then backup[container][key] = value end
	end
	local function zeroOf(v)
		local t = typeof(v)
		if t == "number" then return 0 end
		if t == "Vector2" then return Vector2.zero end
		if t == "Vector3" then return Vector3.zero end
		if t == "NumberRange" then return NumberRange.new(0) end
		return nil
	end
	local function zeroTable(t, depth)
		if depth > 3 or (table.isfrozen and table.isfrozen(t)) then return end
		for k, v in pairs(t) do
			if type(v) == "table" then
				zeroTable(v, depth + 1)
			else
				local z = zeroOf(v)
				if z ~= nil then save(t, k, v); t[k] = z end
			end
		end
	end
	local function scanTable(t, depth)
		if type(t) ~= "table" or visited[t] or depth > 3 or (table.isfrozen and table.isfrozen(t)) then return end
		visited[t] = true
		for k, v in pairs(t) do
			if wantKey(k) then
				if type(v) == "table" then
					zeroTable(v, 0)
				else
					local z = zeroOf(v)
					if z ~= nil then save(t, k, v); t[k] = z end
				end
			elseif type(v) == "table" then
				scanTable(v, depth + 1)
			end
		end
	end
	local function scanInstance(inst)
		for name, v in pairs(inst:GetAttributes()) do
			local z = zeroOf(v)
			if z ~= nil and wantKey(name) then save(inst, "@" .. name, v); inst:SetAttribute(name, z) end
		end
		if (inst:IsA("NumberValue") or inst:IsA("IntValue")) and wantKey(inst.Name) then
			save(inst, "Value", inst.Value); inst.Value = 0
		end
		if inst:IsA("ModuleScript") then
			local ok, res = pcall(require, inst)
			if ok and type(res) == "table" then scanTable(res, 0) end
		end
	end
	local function looksLikeWeapon(t)
		for k in pairs(t) do
			if type(k) == "string" and has(k, HINTS) then return true end
		end
		return false
	end
	local function scanGc()
		if not getgc then return end
		local ok, objs = pcall(getgc, true)
		if not ok then return end
		for i, o in ipairs(objs) do
			if type(o) == "table" then
				pcall(function()
					if looksLikeWeapon(o) then scanTable(o, 2) end
				end)
			end
			if i % 3000 == 0 then task.wait() end
		end
	end
	local function restoreAll()
		for container, fields in pairs(backup) do
			pcall(function()
				for key, val in pairs(fields) do
					if typeof(container) == "Instance" then
						if type(key) == "string" and key:sub(1, 1) == "@" then container:SetAttribute(key:sub(2), val) else container[key] = val end
					else
						container[key] = val
					end
				end
			end)
		end
		backup = {}
	end
	table.insert(UI.Cleanups, restoreAll)

	task.spawn(function()
		local lastTool, lastFlags, lastGc = nil, "", 0
		while alive do
			task.wait(0.4)
			local on = _G.NoRecoil or _G.NoSpread
			local flags = tostring(_G.NoRecoil) .. tostring(_G.NoSpread)
			if on then
				local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
				if flags ~= lastFlags then
					restoreAll()
					lastTool, lastGc = nil, 0
				end
				if tool and tool ~= lastTool then
					lastTool, lastFlags = tool, flags
					visited = {}
					pcall(function()
						scanInstance(tool)
						for _, d in ipairs(tool:GetDescendants()) do scanInstance(d) end
					end)
					if os.clock() - lastGc > 5 then
						lastGc = os.clock()
						task.spawn(scanGc)
					end
				elseif not tool then
					lastTool = nil
				end
				lastFlags = flags
			elseif next(backup) then
				restoreAll()
				lastTool, lastFlags = nil, ""
			end
		end
	end)
end

-- ===== No FOV Kick + No Scope =====
do
	local baseFov
	local hidden = {}
	local function showScopes()
		for gui, prop in pairs(hidden) do pcall(function() gui[prop] = true end) end
		hidden = {}
	end
	table.insert(UI.Cleanups, showScopes)

	local function hide(obj)
		local prop = obj:IsA("ScreenGui") and "Enabled" or (obj:IsA("GuiObject") and "Visible") or (obj:IsA("LayerCollector") and "Enabled")
		if not prop then return end
		if hidden[obj] == nil and obj[prop] == true then hidden[obj] = prop end
		if hidden[obj] then obj[prop] = false end
	end

	track(runService.RenderStepped):Connect(function()
		if (_G.NoFovKick or _G.NoScope) and not _G.FovEnabled and not _G.Freecam then
			if not baseFov then
				baseFov = camera.FieldOfView
				if baseFov < 50 then baseFov = 70 end
			end
			camera.FieldOfView = baseFov
		else
			baseFov = nil
		end
	end)

	task.spawn(function()
		while alive do
			task.wait(0.4)
			if _G.NoScope then
				local pg = player:FindFirstChild("PlayerGui")
				if pg then
					for _, d in ipairs(pg:GetDescendants()) do
						if d.Name:lower():find("scope", 1, true) then pcall(hide, d) end
					end
				end
				local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
				if tool then
					for _, d in ipairs(tool:GetDescendants()) do
						if (d:IsA("SurfaceGui") or d:IsA("BillboardGui")) and d.Name:lower():find("scope", 1, true) then pcall(hide, d) end
					end
					if UI.getProp(tool, "AdsEnabled") ~= nil then UI.setProp(tool, "AdsEnabled", false) end
					if UI.getProp(tool, "CanZoom") ~= nil then UI.setProp(tool, "CanZoom", false) end
				end
			elseif next(hidden) then
				showScopes()
			end
		end
	end)
end

-- ===== No Falling Damage (weiche Landung) + No Footsteps =====
do
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	track(runService.Heartbeat):Connect(function()
		if not _G.NoFallingDamage then return end
		local char, hrp, hum = player.Character, UI.root(), getHumanoid()
		if not hrp or not hum or hum.Health <= 0 then return end
		local v = hrp.AssemblyLinearVelocity
		if v.Y < -45 and hum.FloorMaterial == Enum.Material.Air then
			rp.FilterDescendantsInstances = { char }
			if workspace:Raycast(hrp.Position, Vector3.new(0, -(math.abs(v.Y) * 0.08 + 6), 0), rp) then
				hrp.AssemblyLinearVelocity = Vector3.new(v.X, -18, v.Z)
			end
		end
	end)

	local STEP = { running = true, jumping = true, landing = true, climbing = true, splash = true, swimming = true, freefalling = true, gettingup = true }
	task.spawn(function()
		while alive do
			task.wait(0.1)
			local char = _G.NoFootsteps and player.Character
			if char then
				for _, d in ipairs(char:GetDescendants()) do
					if d:IsA("Sound") then
						local n = d.Name:lower()
						if STEP[n] or n:find("step", 1, true) then d.Volume = 0 end
					end
				end
			end
		end
	end)
end

-- ===== God Mode (Heilung per Signal + Anti-Void + Anti-Ragdoll) =====
do
	local healthConn, lastSafe
	local function hook(hum)
		if healthConn then healthConn:Disconnect() end
		healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if _G.GodMode and hum.Health > 0 and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
		end)
	end
	table.insert(UI.Cleanups, function() if healthConn then healthConn:Disconnect() end end)
	local boundHum
	local acc = 0
	track(runService.Heartbeat):Connect(function(dt)
		if not _G.GodMode then return end
		local hrp, hum = UI.root(), getHumanoid()
		if not hrp or not hum then return end
		if boundHum ~= hum then boundHum = hum; hook(hum) end
		if hum.Health > 0 and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		if hum.PlatformStand and not _G.Flying then hum.PlatformStand = false end
		acc = acc + dt
		local voidY = workspace.FallenPartsDestroyHeight + 60
		if hrp.Position.Y > voidY + 40 and hum.FloorMaterial ~= Enum.Material.Air then
			if acc > 0.5 then acc = 0; lastSafe = hrp.CFrame end
		elseif hrp.Position.Y < voidY and lastSafe then
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.CFrame = lastSafe + Vector3.new(0, 3, 0)
		end
	end)
end

-- ===== Fullbright + No Fog (mit Wiederherstellung) =====
do
	local FULL = { "Brightness", "ClockTime", "GlobalShadows", "Ambient", "OutdoorAmbient", "ExposureCompensation" }
	local FOG = { "FogStart", "FogEnd" }
	local savedFull, savedFog, savedAtmo, savedFx
	savedAtmo, savedFx = {}, {}
	local function capture(list)
		local t = {}
		for _, p in ipairs(list) do t[p] = lighting[p] end
		return t
	end
	local function restore(t)
		if not t then return end
		for p, v in pairs(t) do pcall(function() lighting[p] = v end) end
	end
	local function fullOff() restore(savedFull); savedFull = nil end
	local function fogOff()
		restore(savedFog); savedFog = nil
		for inst, props in pairs(savedAtmo) do
			pcall(function() for p, v in pairs(props) do inst[p] = v end end)
		end
		for inst, en in pairs(savedFx) do pcall(function() inst.Enabled = en end) end
		savedAtmo, savedFx = {}, {}
	end
	table.insert(UI.Cleanups, function() fullOff(); fogOff() end)

	track(runService.RenderStepped):Connect(function()
		if _G.Fullbright then
			savedFull = savedFull or capture(FULL)
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.GlobalShadows = false
			lighting.Ambient = Color3.fromRGB(178, 178, 178)
			lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
			lighting.ExposureCompensation = 0.2
		elseif savedFull then
			fullOff()
		end
		if _G.NoFog then
			savedFog = savedFog or capture(FOG)
			lighting.FogStart = 1e8
			lighting.FogEnd = 1e9
			for _, d in ipairs(lighting:GetChildren()) do
				if d:IsA("Atmosphere") then
					if not savedAtmo[d] then savedAtmo[d] = { Density = d.Density, Haze = d.Haze, Glare = d.Glare } end
					d.Density, d.Haze, d.Glare = 0, 0, 0
				elseif d:IsA("BlurEffect") or d:IsA("DepthOfFieldEffect") or d:IsA("SunRaysEffect") then
					if savedFx[d] == nil then savedFx[d] = d.Enabled end
					d.Enabled = false
				end
			end
		elseif savedFog then
			fogOff()
		end
	end)
end

-- ===== Smart Dodge (verbessert) =====
do
	local lastDodge, burstUntil, burstDir, side = 0, 0, Vector3.zero, 1
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude

	-- Gibt die Kopfposition des Gegners zurück, wenn er bewaffnet ist, freie Sicht hat und auf mich zielt
	local function threatHead(pl, myPos, extra)
		local char = pl.Character
		local head = char and char:FindFirstChild("Head")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 or not char:FindFirstChildOfClass("Tool") then return nil end
		local toMe = myPos - head.Position
		local flat = Vector3.new(toMe.X, 0, toMe.Z)
		local dist = flat.Magnitude
		if dist < 2 or dist > 250 then return nil end
		local look = Vector3.new(head.CFrame.LookVector.X, 0, head.CFrame.LookVector.Z)
		if look.Magnitude < 0.1 then return nil end
		local angle = math.acos(math.clamp(look.Unit:Dot(flat.Unit), -1, 1))
		if angle > math.atan(2.5 / dist) + extra then return nil end
		rp.FilterDescendantsInstances = { player.Character, char }
		if workspace:Raycast(head.Position, toMe, rp) then return nil end
		return head.Position, dist
	end

	track(runService.Heartbeat):Connect(function(dt)
		local hrp, hum = UI.root(), getHumanoid()
		if not _G.SmartDodge or _G.Flying or _G.Freecam or not hrp or not hum or hum.Health <= 0 or hum.Sit then
			burstUntil = 0
			return
		end
		local now = os.clock()
		if now < burstUntil then
			hrp.CFrame = hrp.CFrame + burstDir * (32 * dt)
			local v = hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity = Vector3.new(burstDir.X * 32, v.Y, burstDir.Z * 32)
			return
		end
		if now - lastDodge < 0.7 then return end
		local extra = math.rad(tonumber(_G.SmartDodgeSensitivity) or 20) * 0.2
		local nearestPos, nearestDist
		for _, pl in ipairs(players:GetPlayers()) do
			if pl ~= player then
				local p, d = threatHead(pl, hrp.Position, extra)
				if p and (not nearestDist or d < nearestDist) then nearestPos, nearestDist = p, d end
			end
		end
		if not nearestPos then return end
		local away = hrp.Position - nearestPos
		away = Vector3.new(away.X, 0, away.Z)
		if away.Magnitude < 0.1 then return end
		local perp = Vector3.new(-away.Z, 0, away.X).Unit
		if math.random() < 0.65 then side = -side end
		rp.FilterDescendantsInstances = { player.Character }
		local dir = perp * side
		if workspace:Raycast(hrp.Position, dir * 7, rp) then dir = -dir end
		if workspace:Raycast(hrp.Position, dir * 7, rp) then return end
		burstDir, burstUntil, lastDodge = dir, now + 0.22, now
	end)
end

-- Menü schließen / öffnen
CloseButton.MouseButton1Click:Connect(function()
	UI.MainFrame.Visible = false
	UI.OpenButton.Visible = true
end)
UI.OpenButton.MouseButton1Click:Connect(function()
	UI.MainFrame.Visible = true
	UI.OpenButton.Visible = false
end)
-- Freecam
FreecamButton.MouseButton1Click:Connect(function()
	_G.Freecam = not _G.Freecam
	FreecamButton.Text = "Freecam: " .. (_G.Freecam and "AN" or "AUS")
	FreecamButton.BackgroundColor3 = _G.Freecam and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)
-- Anti-AFK
player.Idled:Connect(function()
	if _G.AntiAFK then
		virtualUser:CaptureController()
		virtualUser:ClickButton2(Vector2.new())
	end
end)
AntiAfkBtn.MouseButton1Click:Connect(function()
	_G.AntiAFK = not _G.AntiAFK
	AntiAfkBtn.Text = "Anti-AFK: " .. (_G.AntiAFK and "AN" or "AUS")
	AntiAfkBtn.BackgroundColor3 = _G.AntiAFK and Color3.fromRGB(45, 180, 90) or Color3.fromRGB(200, 50, 60)
end)
-- Rejoin / Server Hop
RejoinBtn.MouseButton1Click:Connect(function()
	if #players:GetPlayers() <= 1 then
		player:Kick("\nRejoining...")
		task.wait()
		tpService:Teleport(game.PlaceId, player)
	else
		tpService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end
end)
local function fetchServers()
	local ok, res = pcall(function()
		return httpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	return ok and res and res.data or {}
end
HopBtn.MouseButton1Click:Connect(function()
	for _, srv in ipairs(fetchServers()) do
		if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
			tpService:TeleportToPlaceInstance(game.PlaceId, srv.id, player)
			return
		end
	end
end)
-- Server-Liste (Ping + Spieler), Klick = beitreten
OpenServerListSubmenu.MouseButton1Click:Connect(function()
	navigateToSub(UI.ServerListSubView)
	ServerListTitle.Text = " Lade Server..."
	for _, c in ipairs(ServerListContainer:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local list = fetchServers()
	ServerListTitle.Text = " " .. #list .. " Server gefunden (Klick = beitreten)"
	for _, srv in ipairs(list) do
		local b = createSimpleButton(ServerListContainer, string.format("%d/%d Spieler | Ping: %s ms", srv.playing, srv.maxPlayers, tostring(srv.ping or "?")))
		b.Size = UDim2.new(1, -10, 0, 28)
		b.MouseButton1Click:Connect(function()
			tpService:TeleportToPlaceInstance(game.PlaceId, srv.id, player)
		end)
	end
	ServerListContainer.CanvasSize = UDim2.new(0, 0, 0, #list * 32)
end)
-- Spieler-Dropdown + Teleport
local selectedPlayer
local function refreshDropdown()
	for _, c in ipairs(DropdownList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local n = 0
	for _, plr in ipairs(players:GetPlayers()) do
		if plr ~= player then
			n = n + 1
			local b = createSimpleButton(DropdownList, plr.Name)
			b.Size = UDim2.new(1, -4, 0, 26)
			b.ZIndex = 13
			b.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				DropdownButton.Text = plr.Name .. " ▼"
				DropdownList.Visible = false
			end)
		end
	end
	DropdownList.CanvasSize = UDim2.new(0, 0, 0, n * 26)
end
DropdownButton.MouseButton1Click:Connect(function()
	DropdownList.Visible = not DropdownList.Visible
	if DropdownList.Visible then refreshDropdown() end
end)
ExecutePlayerTp.MouseButton1Click:Connect(function()
	local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local tHrp = selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	if myHrp and tHrp then myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 3) end
end)
print("[Arcanum Hub] Master-Skript erfolgreich und vollständig geladen!")