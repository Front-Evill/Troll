-- FRONT GUI Library
-- github.com/YOUR_USERNAME/FRONT_GUI
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/FRONT_GUI/main/main.lua"))()

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ──────────────────────────────────────────────────────────────────
-- THEMES
-- ──────────────────────────────────────────────────────────────────

local Themes = {
    Dark = {
        Background  = Color3.fromRGB(13, 13, 18),
        Surface     = Color3.fromRGB(20, 20, 28),
        SurfaceB    = Color3.fromRGB(27, 27, 37),
        SurfaceC    = Color3.fromRGB(34, 34, 46),
        Accent      = Color3.fromRGB(100, 145, 255),
        AccentDim   = Color3.fromRGB(65,  100, 200),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(238, 242, 255),
        TextSub     = Color3.fromRGB(110, 118, 148),
        TextMuted   = Color3.fromRGB(56,  60,  80),
        Border      = Color3.fromRGB(44,  46,  62),
        BorderHover = Color3.fromRGB(60,  64,  88),
        White       = Color3.fromRGB(255, 255, 255),
    },
    Ocean = {
        Background  = Color3.fromRGB(7,  13, 24),
        Surface     = Color3.fromRGB(11, 19, 34),
        SurfaceB    = Color3.fromRGB(15, 25, 44),
        SurfaceC    = Color3.fromRGB(19, 31, 54),
        Accent      = Color3.fromRGB(28, 168, 234),
        AccentDim   = Color3.fromRGB(18, 125, 180),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(232, 246, 255),
        TextSub     = Color3.fromRGB(88,  162, 210),
        TextMuted   = Color3.fromRGB(40,  90,  130),
        Border      = Color3.fromRGB(20,  52,  84),
        BorderHover = Color3.fromRGB(30,  72,  110),
        White       = Color3.fromRGB(255, 255, 255),
    },
    Purple = {
        Background  = Color3.fromRGB(14,  9, 24),
        Surface     = Color3.fromRGB(20, 14, 34),
        SurfaceB    = Color3.fromRGB(26, 19, 44),
        SurfaceC    = Color3.fromRGB(32, 24, 54),
        Accent      = Color3.fromRGB(155, 85, 245),
        AccentDim   = Color3.fromRGB(115, 58, 195),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(238, 234, 255),
        TextSub     = Color3.fromRGB(148, 120, 210),
        TextMuted   = Color3.fromRGB(68,  48,  110),
        Border      = Color3.fromRGB(50,  28,  88),
        BorderHover = Color3.fromRGB(68,  40,  115),
        White       = Color3.fromRGB(255, 255, 255),
    },
    Midnight = {
        Background  = Color3.fromRGB(0,   0,   0),
        Surface     = Color3.fromRGB(8,   8,  10),
        SurfaceB    = Color3.fromRGB(14,  14,  18),
        SurfaceC    = Color3.fromRGB(20,  20,  26),
        Accent      = Color3.fromRGB(78,  130, 255),
        AccentDim   = Color3.fromRGB(52,  90,  200),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(255, 255, 255),
        TextSub     = Color3.fromRGB(120, 120, 138),
        TextMuted   = Color3.fromRGB(52,  52,  64),
        Border      = Color3.fromRGB(30,  30,  40),
        BorderHover = Color3.fromRGB(46,  46,  60),
        White       = Color3.fromRGB(255, 255, 255),
    },
    Emerald = {
        Background  = Color3.fromRGB(5,  16, 10),
        Surface     = Color3.fromRGB(9,  22, 15),
        SurfaceB    = Color3.fromRGB(13, 28, 20),
        SurfaceC    = Color3.fromRGB(17, 34, 25),
        Accent      = Color3.fromRGB(46, 210, 148),
        AccentDim   = Color3.fromRGB(30, 160, 108),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(232, 255, 244),
        TextSub     = Color3.fromRGB(92,  192, 148),
        TextMuted   = Color3.fromRGB(34,  88,  60),
        Border      = Color3.fromRGB(18,  60,  38),
        BorderHover = Color3.fromRGB(26,  82,  52),
        White       = Color3.fromRGB(255, 255, 255),
    },
    Rose = {
        Background  = Color3.fromRGB(18,  8, 12),
        Surface     = Color3.fromRGB(26, 12, 18),
        SurfaceB    = Color3.fromRGB(34, 16, 24),
        SurfaceC    = Color3.fromRGB(42, 20, 30),
        Accent      = Color3.fromRGB(240, 72, 110),
        AccentDim   = Color3.fromRGB(195, 50,  85),
        Success     = Color3.fromRGB(48,  204, 120),
        Warning     = Color3.fromRGB(245, 165,  35),
        Error       = Color3.fromRGB(238,  72,  72),
        Text        = Color3.fromRGB(255, 238, 242),
        TextSub     = Color3.fromRGB(210, 110, 135),
        TextMuted   = Color3.fromRGB(95,  38,  55),
        Border      = Color3.fromRGB(72,  22,  38),
        BorderHover = Color3.fromRGB(95,  32,  52),
        White       = Color3.fromRGB(255, 255, 255),
    },
}

-- ──────────────────────────────────────────────────────────────────
-- ICONS
-- ──────────────────────────────────────────────────────────────────

local Icons = {
    home         = "rbxassetid://92309619719802",
    settings     = "rbxassetid://10734950309",
    wrench       = "rbxassetid://75760172015867",
    terminal     = "rbxassetid://86935080083630",
    play         = "rbxassetid://140688372742211",
    star         = "rbxassetid://126945835022671",
    save         = "rbxassetid://124502845829112",
    ["save-all"] = "rbxassetid://115892453613638",
    plug         = "rbxassetid://127640868105866",
    smartphone   = "rbxassetid://92613756801622",
    logs         = "rbxassetid://125195928083757",
    locate       = "rbxassetid://117295186471094",
    ruler        = "rbxassetid://130521784598692",
    sticker      = "rbxassetid://119340479392140",
    phone        = "rbxassetid://117916436209255",
    shield       = "rbxassetid://125733003566871",
    scroll       = "rbxassetid://130077059981083",
    map          = "rbxassetid://132129417926899",
    signal       = "rbxassetid://84621858630690",
    note         = "rbxassetid://78566545135896",
    user         = "rbxassetid://89989366513016",
    lock         = "rbxassetid://101626468102285",
    wifi         = "rbxassetid://119974531057294",
    scaling      = "rbxassetid://138342522500370",
    radio        = "rbxassetid://99030541960024",
    screen       = "rbxassetid://78407375693434",
    mouse        = "rbxassetid://113303138946224",
    panel        = "rbxassetid://111855496283529",
    trending     = "rbxassetid://73414152507992",
    undo         = "rbxassetid://116283716426162",
}

-- ──────────────────────────────────────────────────────────────────
-- UTILITIES
-- ──────────────────────────────────────────────────────────────────

local function Tw(obj, dur, style, dir, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(dur, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    )
end
local function TwSpring(obj, dur, props) return Tw(obj, dur, Enum.EasingStyle.Back, nil, props) end
local function TwSmooth(obj, dur, props) return Tw(obj, dur, Enum.EasingStyle.Quint, nil, props) end

local function NewCorner(parent, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = parent; return c
end
local function NewStroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color           = color or Color3.new(1,1,1)
    s.Transparency    = transparency or 0
    s.Thickness       = thickness or 1
    s.Parent          = parent
    return s
end
local function NewPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0); p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0); p.PaddingRight  = UDim.new(0, r or 0)
    p.Parent = parent; return p
end
local function NewVList(parent, pad, ha, va)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = Enum.FillDirection.Vertical
    l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va or Enum.VerticalAlignment.Top
    l.Padding             = UDim.new(0, pad or 0)
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent              = parent; return l
end
local function NewHList(parent, pad, ha, va)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = Enum.FillDirection.Horizontal
    l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va or Enum.VerticalAlignment.Center
    l.Padding             = UDim.new(0, pad or 0)
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent              = parent; return l
end
local function NewFrame(parent, bg, bgT, size, pos, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3    = bg   or Color3.new()
    f.BackgroundTransparency = bgT or 0
    f.BorderSizePixel     = 0
    f.Size                = size or UDim2.fromScale(1,1)
    f.Position            = pos  or UDim2.new()
    f.ZIndex              = zi   or 1
    f.Parent              = parent; return f
end
local function NewLabel(parent, txt, sz, font, col, zi)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = txt or ""; l.TextSize = sz or 13; l.Font = font or Enum.Font.GothamMedium
    l.TextColor3 = col or Color3.new(1,1,1)
    l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = zi or 1
    l.Size = UDim2.fromScale(1,1); l.Parent = parent; return l
end
local function NewButton(parent, zi)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1; b.BorderSizePixel = 0
    b.Text = ""; b.AutoButtonColor = false
    b.ZIndex = zi or 1; b.Size = UDim2.fromScale(1,1)
    b.Parent = parent; return b
end
local function NewScroll(parent, barCol, barT, zi)
    local s = Instance.new("ScrollingFrame")
    s.BackgroundTransparency  = 1; s.BorderSizePixel = 0
    s.ScrollBarThickness      = 3
    s.ScrollBarImageColor3    = barCol or Color3.fromRGB(80,80,100)
    s.ScrollBarImageTransparency = barT or 0.30
    s.CanvasSize              = UDim2.new(); s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.ZIndex = zi or 1; s.Size = UDim2.fromScale(1,1); s.Parent = parent; return s
end

local function MakeDraggable(frame, handle)
    local drag, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; sp = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
end

local function FormatTime(s)
    local h  = math.floor(s/3600); local m = math.floor((s%3600)/60); local sc = math.floor(s%60)
    return h > 0 and string.format("%02d:%02d:%02d",h,m,sc) or string.format("%02d:%02d",m,sc)
end

local function AccountAge(p)
    local d = p.AccountAge
    return d < 30 and (d.."d") or d < 365 and (math.floor(d/30).."mo") or (math.floor(d/365).."yr")
end

local function GetIcon(name) return Icons[name] or "" end

-- ──────────────────────────────────────────────────────────────────
-- LIBRARY
-- ──────────────────────────────────────────────────────────────────

local Library = {}

function Library:CreateWindow(cfg)
    local Window = {}

    local Title    = cfg.Title       or "FRONT"
    local Sub      = cfg.SubTitle    or "v1.0"
    local Welcome  = cfg.WelcomeText or "Welcome back"
    local LoadTime = cfg.LoadingTime or 3
    local Size     = cfg.Size        or UDim2.fromOffset(580, 460)
    local TH       = Themes[cfg.Theme or "Dark"] or Themes.Dark
    local MinKey   = cfg.MinimizeKey or Enum.KeyCode.RightShift
    local Icon     = cfg.IconImage   or "rbxassetid://0"
    local TabW     = cfg.TabWidth    or 168

    local T0     = tick()
    local TabList = {}
    local CurTab  = nil

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "FRONT_GUI"; Screen.ResetOnSpawn = false
    Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; Screen.Parent = PlayerGui

    -- Notification holder
    local NotifFrame = NewFrame(Screen, Color3.new(), 1, UDim2.new(0,310,1,-24), UDim2.new(1,-318,1,-12))
    NotifFrame.AnchorPoint = Vector2.new(0,1); NotifFrame.ZIndex = 900
    NewVList(NotifFrame, 6, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)

    -- ── Welcome Screen ──────────────────────────────────────────
    local Dimmer = NewFrame(Screen, Color3.new(), 0.38, UDim2.fromScale(1,1))
    Dimmer.ZIndex = 200

    local WCard = NewFrame(Screen, TH.Surface, 0, UDim2.fromOffset(340,0), UDim2.fromScale(0.5,0.5))
    WCard.AnchorPoint = Vector2.new(0.5,0.5); WCard.ZIndex = 201; WCard.ClipsDescendants = true
    NewCorner(WCard, 14); NewStroke(WCard, TH.Border, 0.25, 1)
    TwSpring(WCard, 0.50, {Size = UDim2.fromOffset(340, 300)}):Play()

    local WTopBand = NewFrame(WCard, TH.Accent, 0.88, UDim2.new(1,0,0,96))
    WTopBand.ZIndex = 202

    local WGrad = Instance.new("UIGradient")
    WGrad.Color    = ColorSequence.new{
        ColorSequenceKeypoint.new(0, TH.AccentDim),
        ColorSequenceKeypoint.new(1, TH.Accent)
    }
    WGrad.Rotation = 135; WGrad.Parent = WTopBand

    local WAvatarRing = NewFrame(WCard, TH.Surface, 0, UDim2.fromOffset(72,72))
    WAvatarRing.Position = UDim2.new(0.5,-36,0,60); WAvatarRing.ZIndex = 203
    NewCorner(WAvatarRing, 36); NewStroke(WAvatarRing, TH.Accent, 0.15, 2.5)

    local WAvatar = Instance.new("ImageLabel")
    WAvatar.BackgroundTransparency = 1; WAvatar.Size = UDim2.fromOffset(66,66)
    WAvatar.Position = UDim2.fromOffset(3,3)
    WAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=150&height=150&format=png"
    WAvatar.ZIndex = 204; WAvatar.Parent = WAvatarRing; NewCorner(WAvatar, 33)

    local function WL(txt, sz, fnt, col, y)
        local l = NewLabel(WCard, txt, sz, fnt, col, 202)
        l.Size = UDim2.new(1,-32,0,sz+6); l.Position = UDim2.new(0.5,0,0,y); l.AnchorPoint = Vector2.new(0.5,0)
        l.TextXAlignment = Enum.TextXAlignment.Center; return l
    end

    WL(Welcome,                                 15, Enum.Font.GothamBold,   TH.Text,    142)
    WL(Player.DisplayName,                      13, Enum.Font.GothamMedium, TH.TextSub, 162)
    WL("@"..Player.Name.." · "..AccountAge(Player), 11, Enum.Font.Gotham,   TH.TextMuted,182)

    local WBarBg = NewFrame(WCard, TH.SurfaceC, 0, UDim2.new(0.72,0,0,4))
    WBarBg.Position = UDim2.new(0.14,0,0,218); WBarBg.ZIndex = 202; NewCorner(WBarBg, 4)

    local WBarFill = NewFrame(WBarBg, TH.Accent, 0, UDim2.fromScale(0,1))
    WBarFill.ZIndex = 203; NewCorner(WBarFill, 4)
    local WBarGrad = Instance.new("UIGradient")
    WBarGrad.Color  = ColorSequence.new(TH.AccentDim, TH.Accent)
    WBarGrad.Parent = WBarFill

    local WStatusL = WL("Initializing...", 11, Enum.Font.Gotham, TH.TextMuted, 232)
    local WPctL    = WL("0%", 11, Enum.Font.GothamMedium, TH.Accent, 232)
    WPctL.TextXAlignment = Enum.TextXAlignment.Right

    local loadMsgs = {"Initializing", "Loading assets", "Building UI", "Finalizing", "Done!"}
    local loadIdx  = 1

    local loadConn = RunService.Heartbeat:Connect(function()
        local pct = math.clamp((tick()-T0)/LoadTime, 0, 1)
        WBarFill.Size = UDim2.fromScale(pct, 1)
        WPctL.Text    = math.floor(pct*100) .. "%"
        local i = math.min(math.ceil(pct*(#loadMsgs-1))+1, #loadMsgs)
        if i ~= loadIdx then loadIdx = i; WStatusL.Text = loadMsgs[i] end
    end)

    -- ── Main Window ──────────────────────────────────────────────
    local Main = NewFrame(Screen, TH.Background, 0, Size, UDim2.fromScale(0.5,0.5))
    Main.AnchorPoint = Vector2.new(0.5,0.5); Main.Visible = false; Main.ZIndex = 10
    NewCorner(Main, 12); NewStroke(Main, TH.Border, 0.20, 1)

    local TitleBar = NewFrame(Main, TH.Surface, 0, UDim2.new(1,0,0,50))
    TitleBar.ZIndex = 11; NewCorner(TitleBar, 12)
    local TBFix = NewFrame(TitleBar, TH.Surface, 0, UDim2.new(1,0,0,14), UDim2.new(0,0,1,-14))
    TBFix.ZIndex = 11
    local TBLine = NewFrame(TitleBar, TH.Border, 0.60, UDim2.new(1,0,0,1), UDim2.new(0,0,1,0))
    TBLine.ZIndex = 12

    local TIconBg = NewFrame(TitleBar, TH.Accent, 0.80, UDim2.fromOffset(30,30), UDim2.fromOffset(12,10))
    TIconBg.ZIndex = 12; NewCorner(TIconBg, 9); NewStroke(TIconBg, TH.Accent, 0.60, 1)
    local TIconImg = Instance.new("ImageLabel")
    TIconImg.BackgroundTransparency = 1; TIconImg.Size = UDim2.fromOffset(18,18)
    TIconImg.Position = UDim2.fromOffset(6,6); TIconImg.Image = Icon
    TIconImg.ScaleType = Enum.ScaleType.Fit; TIconImg.ImageColor3 = TH.White
    TIconImg.ZIndex = 13; TIconImg.Parent = TIconBg

    local TTitleL = NewLabel(TitleBar, Title, 14, Enum.Font.GothamBold, TH.Text, 12)
    TTitleL.Size = UDim2.new(0,220,0,18); TTitleL.Position = UDim2.fromOffset(50,8)
    TTitleL.TextYAlignment = Enum.TextYAlignment.Center

    local TSubL = NewLabel(TitleBar, Sub, 11, Enum.Font.Gotham, TH.TextSub, 12)
    TSubL.Size = UDim2.new(0,220,0,14); TSubL.Position = UDim2.fromOffset(50,27)
    TSubL.TextYAlignment = Enum.TextYAlignment.Center

    local TCtrl = NewFrame(TitleBar, TH.White, 1, UDim2.new(0,96,0,32), UDim2.new(1,-104,0,9))
    TCtrl.ZIndex = 12; NewHList(TCtrl, 6, Enum.HorizontalAlignment.Right)

    local UptimeLabel = NewLabel(TitleBar, "00:00", 10, Enum.Font.GothamMedium, TH.TextMuted, 12)
    UptimeLabel.Size = UDim2.new(0,100,0,14); UptimeLabel.Position = UDim2.new(0.5,-50,1,-18)
    UptimeLabel.TextXAlignment = Enum.TextXAlignment.Center

    local function CtrlBtn(icon, hoverCol)
        local BF = NewFrame(TCtrl, TH.SurfaceB, 0, UDim2.fromOffset(26,26))
        BF.ZIndex = 13; NewCorner(BF, 7); NewStroke(BF, TH.Border, 0.55, 1)
        local BL = NewLabel(BF, icon, 12, Enum.Font.GothamBold, TH.TextSub, 14)
        BL.TextXAlignment = Enum.TextXAlignment.Center; BL.TextYAlignment = Enum.TextYAlignment.Center
        local BB = NewButton(BF, 15)
        BB.MouseEnter:Connect(function()
            TwSmooth(BF, 0.14, {BackgroundColor3 = hoverCol, BackgroundTransparency = 0.10}):Play()
            TwSmooth(BL, 0.14, {TextColor3 = TH.White}):Play()
        end)
        BB.MouseLeave:Connect(function()
            TwSmooth(BF, 0.14, {BackgroundColor3 = TH.SurfaceB, BackgroundTransparency = 0}):Play()
            TwSmooth(BL, 0.14, {TextColor3 = TH.TextSub}):Play()
        end)
        return BB
    end

    local CloseBtn = CtrlBtn("✕", TH.Error)
    local MinBtn   = CtrlBtn("—", TH.Warning)
    local MaxBtn   = CtrlBtn("⤢", TH.Success)

    local Sidebar = NewFrame(Main, TH.Surface, 0, UDim2.new(0,TabW,1,-50), UDim2.new(0,0,0,50))
    Sidebar.ZIndex = 11
    local SidebarFix1 = NewFrame(Sidebar, TH.Surface, 0, UDim2.new(0,12,1,0), UDim2.new(1,-12,0,0))
    SidebarFix1.ZIndex = 11
    local SidebarLine = NewFrame(Sidebar, TH.Border, 0.55, UDim2.new(0,1,1,0), UDim2.new(1,0,0,0))
    SidebarLine.ZIndex = 12

    local TabsScroll = NewScroll(Sidebar, TH.BorderHover, 0.80, 12)
    TabsScroll.ScrollBarThickness = 0
    NewPadding(TabsScroll, 8, 8, 8, 8)
    NewVList(TabsScroll, 3)

    local ContentArea = NewFrame(Main, TH.White, 1, UDim2.new(1,-TabW,1,-50), UDim2.new(0,TabW,0,50))
    ContentArea.ZIndex = 11

    local FloatBtn = NewFrame(Screen, TH.Accent, 0, UDim2.fromOffset(48,48), UDim2.fromOffset(18,18))
    FloatBtn.Visible = false; FloatBtn.ZIndex = 100; NewCorner(FloatBtn, 24)
    NewStroke(FloatBtn, TH.Accent, 0.60, 2)
    local FloatImg = Instance.new("ImageLabel")
    FloatImg.BackgroundTransparency = 1; FloatImg.Size = UDim2.fromOffset(28,28)
    FloatImg.Position = UDim2.fromOffset(10,10); FloatImg.Image = Icon
    FloatImg.ScaleType = Enum.ScaleType.Fit; FloatImg.ImageColor3 = TH.White
    FloatImg.ZIndex = 101; FloatImg.Parent = FloatBtn
    local FloatClick = NewButton(FloatBtn, 102)

    MakeDraggable(Main, TitleBar)
    MakeDraggable(FloatBtn, FloatBtn)

    local isMax = false

    local function ShowMain()
        Main.Visible = true; FloatBtn.Visible = false
        Main.Size = UDim2.fromOffset(0,0)
        TwSpring(Main, 0.46, {Size = isMax and UDim2.fromScale(0.92,0.92) or Size}):Play()
    end

    local function HideMain()
        TwSmooth(Main, 0.28, {Size = UDim2.fromOffset(0,0)}):Play()
        task.wait(0.28); Main.Visible = false; FloatBtn.Visible = true
    end

    CloseBtn.MouseButton1Click:Connect(function()
        TwSmooth(Main, 0.24, {Size = UDim2.fromOffset(0,0)}):Play()
        task.wait(0.24); Screen:Destroy()
    end)
    MinBtn.MouseButton1Click:Connect(function() task.spawn(HideMain) end)
    MaxBtn.MouseButton1Click:Connect(function()
        isMax = not isMax
        TwSmooth(Main, 0.38, {
            Size     = isMax and UDim2.fromScale(0.92,0.92) or Size,
            Position = UDim2.fromScale(0.5,0.5)
        }):Play()
    end)
    FloatClick.MouseButton1Click:Connect(function() task.spawn(ShowMain) end)
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == MinKey then
            if Main.Visible then task.spawn(HideMain) else task.spawn(ShowMain) end
        end
    end)

    local timerConn = RunService.Heartbeat:Connect(function()
        UptimeLabel.Text = FormatTime(tick() - T0)
    end)

    -- Welcome → Main transition
    task.spawn(function()
        task.wait(LoadTime)
        loadConn:Disconnect()
        WBarFill.Size = UDim2.fromScale(1,1)
        WPctL.Text = "100%"; WStatusL.Text = "Done!"
        task.wait(0.45)

        for _, v in ipairs(WCard:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                TwSmooth(v, 0.20, {TextTransparency = 1}):Play()
            elseif v:IsA("ImageLabel") then
                TwSmooth(v, 0.20, {ImageTransparency = 1}):Play()
            elseif v:IsA("Frame") then
                TwSmooth(v, 0.20, {BackgroundTransparency = 1}):Play()
            elseif v:IsA("UIStroke") then
                TwSmooth(v, 0.20, {Transparency = 1}):Play()
            end
        end
        TwSmooth(WCard, 0.28, {BackgroundTransparency = 1, Size = UDim2.fromOffset(340,280)}):Play()
        TwSmooth(Dimmer, 0.35, {BackgroundTransparency = 1}):Play()
        task.wait(0.36)
        WCard:Destroy(); Dimmer:Destroy()

        Main.Visible = true; Main.Size = UDim2.fromOffset(0,0)
        TwSpring(Main, 0.55, {Size = Size}):Play()
    end)

    -- ── Notify ──────────────────────────────────────────────────
    local notifN = 0

    function Window:Notify(cfg2)
        local NT   = cfg2.Title    or "Notification"
        local NC   = cfg2.Content  or ""
        local ND   = cfg2.Duration or 4
        local NCL  = cfg2.Color    or TH.Accent

        notifN = notifN + 1
        local NF = NewFrame(NotifFrame, TH.Surface, 0, UDim2.new(1,0,0,62))
        NF.Position = UDim2.new(1,12,0,0); NF.LayoutOrder = notifN; NF.ZIndex = 901
        NewCorner(NF, 10); NewStroke(NF, TH.Border, 0.30, 1)

        local NPill = NewFrame(NF, NCL, 0, UDim2.fromOffset(3,36), UDim2.fromOffset(10,13))
        NPill.ZIndex = 902; NewCorner(NPill, 2)

        local NTL = NewLabel(NF, NT, 13, Enum.Font.GothamBold, TH.Text, 902)
        NTL.Size = UDim2.new(1,-62,0,18); NTL.Position = UDim2.fromOffset(22,9)
        NTL.TextYAlignment = Enum.TextYAlignment.Center; NTL.TextTruncate = Enum.TextTruncate.AtEnd

        local NCLabel = NewLabel(NF, NC, 11, Enum.Font.Gotham, TH.TextSub, 902)
        NCLabel.Size = UDim2.new(1,-62,0,26); NCLabel.Position = UDim2.fromOffset(22,27)
        NCLabel.TextYAlignment = Enum.TextYAlignment.Top; NCLabel.TextWrapped = true

        local NXBox = NewFrame(NF, TH.SurfaceB, 0, UDim2.fromOffset(20,20), UDim2.new(1,-30,0,8))
        NXBox.ZIndex = 902; NewCorner(NXBox, 6)
        local NXL = NewLabel(NXBox, "✕", 10, Enum.Font.GothamBold, TH.TextSub, 903)
        NXL.TextXAlignment = Enum.TextXAlignment.Center; NXL.TextYAlignment = Enum.TextYAlignment.Center
        local NXBtn = NewButton(NXBox, 904)
        NXBtn.MouseEnter:Connect(function()
            TwSmooth(NXBox, 0.12, {BackgroundColor3 = TH.Error}):Play()
            TwSmooth(NXL,   0.12, {TextColor3 = TH.White}):Play()
        end)
        NXBtn.MouseLeave:Connect(function()
            TwSmooth(NXBox, 0.12, {BackgroundColor3 = TH.SurfaceB}):Play()
            TwSmooth(NXL,   0.12, {TextColor3 = TH.TextSub}):Play()
        end)

        TwSpring(NF, 0.34, {Position = UDim2.new(0,0,0,0)}):Play()

        local gone = false
        local function Dismiss()
            if gone then return end; gone = true
            TwSmooth(NF, 0.22, {Position = UDim2.new(1,12,0,0), BackgroundTransparency = 1}):Play()
            task.wait(0.22); if NF.Parent then NF:Destroy() end
        end

        NXBtn.MouseButton1Click:Connect(function() task.spawn(Dismiss) end)
        NF.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then task.spawn(Dismiss) end
        end)
        if ND > 0 then task.spawn(function() task.wait(ND+0.35); Dismiss() end) end
    end

    -- ── Tab switching ────────────────────────────────────────────
    local function SwitchTab(tab)
        for _, t in ipairs(TabList) do
            if t.Page then t.Page.Visible = false end
            if t.Btn then
                TwSmooth(t.Btn, 0.16, {BackgroundColor3 = TH.SurfaceB, BackgroundTransparency = 1}):Play()
                if t.Lbl  then TwSmooth(t.Lbl,  0.16, {TextColor3  = TH.TextSub}):Play() end
                if t.ILbl then TwSmooth(t.ILbl, 0.16, {ImageColor3 = TH.TextMuted}):Play() end
                if t.Pill then TwSmooth(t.Pill, 0.16, {BackgroundTransparency = 1}):Play() end
            end
        end
        if tab.Page then tab.Page.Visible = true end
        if tab.Btn then
            TwSmooth(tab.Btn, 0.16, {BackgroundColor3 = TH.SurfaceB, BackgroundTransparency = 0}):Play()
            if tab.Lbl  then TwSmooth(tab.Lbl,  0.16, {TextColor3  = TH.Text}):Play() end
            if tab.ILbl then TwSmooth(tab.ILbl, 0.16, {ImageColor3 = TH.Accent}):Play() end
            if tab.Pill then TwSmooth(tab.Pill, 0.16, {BackgroundTransparency = 0.10}):Play() end
        end
        CurTab = tab
    end

    -- ── Add Tab ──────────────────────────────────────────────────
    function Window:AddTab(cfg2)
        local Tab = {}
        local TBTitle  = cfg2.Title or "Tab"
        local TBIconId = GetIcon(cfg2.Icon or "")

        local TBBtn = NewFrame(TabsScroll, TH.SurfaceB, 1, UDim2.new(1,0,0,36))
        TBBtn.ZIndex = 12; NewCorner(TBBtn, 8)

        local TBPill = NewFrame(TBBtn, TH.Accent, 1, UDim2.fromOffset(3,18))
        TBPill.Position = UDim2.new(0,0,0.5,-9); TBPill.ZIndex = 13; NewCorner(TBPill, 2)

        local hasIcon = TBIconId ~= ""
        local TBILbl  = nil
        if hasIcon then
            TBILbl = Instance.new("ImageLabel")
            TBILbl.BackgroundTransparency = 1
            TBILbl.Size = UDim2.fromOffset(16,16); TBILbl.Position = UDim2.fromOffset(12,10)
            TBILbl.Image = TBIconId; TBILbl.ScaleType = Enum.ScaleType.Fit
            TBILbl.ImageColor3 = TH.TextMuted; TBILbl.ZIndex = 13; TBILbl.Parent = TBBtn
        end

        local TBLbl = NewLabel(TBBtn, TBTitle, 13, Enum.Font.GothamMedium, TH.TextSub, 13)
        TBLbl.Size     = UDim2.new(1, hasIcon and -38 or -16, 1, 0)
        TBLbl.Position = UDim2.fromOffset(hasIcon and 33 or 10, 0)
        TBLbl.TextYAlignment = Enum.TextYAlignment.Center

        local TBClick = NewButton(TBBtn, 14)

        local Page = NewFrame(ContentArea, TH.White, 1, UDim2.fromScale(1,1))
        Page.Visible = false; Page.ZIndex = 11

        local PageScroll = NewScroll(Page, TH.BorderHover, 0.45, 12)
        NewPadding(PageScroll, 12, 14, 12, 12)
        NewVList(PageScroll, 8)

        Tab.Btn   = TBBtn; Tab.Lbl = TBLbl; Tab.ILbl = TBILbl
        Tab.Pill  = TBPill; Tab.Page = Page; Tab.Scroll = PageScroll
        Tab.Theme = TH

        TBBtn.MouseEnter:Connect(function()
            if CurTab ~= Tab then
                TwSmooth(TBBtn, 0.14, {BackgroundColor3 = TH.SurfaceB, BackgroundTransparency = 0.55}):Play()
                TwSmooth(TBLbl, 0.14, {TextColor3 = TH.Text}):Play()
            end
        end)
        TBBtn.MouseLeave:Connect(function()
            if CurTab ~= Tab then
                TwSmooth(TBBtn, 0.14, {BackgroundColor3 = TH.SurfaceB, BackgroundTransparency = 1}):Play()
                TwSmooth(TBLbl, 0.14, {TextColor3 = TH.TextSub}):Play()
            end
        end)
        TBClick.MouseButton1Click:Connect(function() SwitchTab(Tab) end)

        table.insert(TabList, Tab)
        if #TabList == 1 then SwitchTab(Tab) end

        -- ── Add Section ──────────────────────────────────────────
        function Tab:AddSection(secName)
            local Sec = {Theme = TH, Scroll = PageScroll}

            local SF = NewFrame(PageScroll, TH.Surface, 0, UDim2.new(1,0,0,0))
            SF.AutomaticSize = Enum.AutomaticSize.Y; SF.ZIndex = 12
            NewCorner(SF, 10); NewStroke(SF, TH.Border, 0.28, 1)

            local SH = NewFrame(SF, TH.SurfaceB, 0, UDim2.new(1,0,0,40))
            SH.ZIndex = 13; NewCorner(SH, 10)
            local SHFix = NewFrame(SH, TH.SurfaceB, 0, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12))
            SHFix.ZIndex = 13
            NewPadding(SH, 0, 0, 14, 14)

            local SHPill = NewFrame(SH, TH.Accent, 0, UDim2.fromOffset(3,16))
            SHPill.Position = UDim2.new(0,0,0.5,-8); SHPill.ZIndex = 14; NewCorner(SHPill, 2)

            local SHTitleBox = NewFrame(SH, TH.White, 1, UDim2.new(1,-14,1,0), UDim2.fromOffset(12,0))
            SHTitleBox.ZIndex = 14
            local SHTitleL = NewLabel(SHTitleBox, secName or "Section", 13, Enum.Font.GothamBold, TH.Text, 14)
            SHTitleL.TextYAlignment = Enum.TextYAlignment.Center

            local SDivide = NewFrame(SF, TH.Border, 0.50, UDim2.new(1,-28,0,1), UDim2.fromOffset(14,40))
            SDivide.ZIndex = 13

            local SC = NewFrame(SF, TH.White, 1, UDim2.new(1,-28,0,0), UDim2.fromOffset(14,50))
            SC.AutomaticSize = Enum.AutomaticSize.Y; SC.ZIndex = 13
            NewVList(SC, 5)

            local SBotPad = Instance.new("UIPadding")
            SBotPad.PaddingBottom = UDim.new(0,14); SBotPad.Parent = SF

            Sec.Frame   = SF
            Sec.Content = SC

            -- helper: base element frame
            local function EF(hasDesc, h1, h2)
                local ef = NewFrame(SC, TH.SurfaceB, 0, UDim2.new(1,0,0, hasDesc and h2 or h1))
                ef.ZIndex = 14; NewCorner(ef, 8)
                local es = NewStroke(ef, TH.Border, 0.55, 1)
                return ef, es
            end

            -- ─ Paragraph ─────────────────────────────────────────
            function Sec:AddParagraph(c)
                local PT = c.Title or ""; local PC = c.Content or ""
                local PF = NewFrame(SC, TH.SurfaceB, 0, UDim2.new(1,0,0,0))
                PF.AutomaticSize = Enum.AutomaticSize.Y; PF.ZIndex = 14
                NewCorner(PF, 8); NewStroke(PF, TH.Border, 0.55, 1)
                NewPadding(PF, 10, 10, 12, 12)
                NewVList(PF, 4)

                local PTL = nil
                if PT ~= "" then
                    local h = NewFrame(PF, TH.White, 1, UDim2.new(1,0,0,18))
                    h.AutomaticSize = Enum.AutomaticSize.Y; h.ZIndex = 15
                    PTL = NewLabel(h, PT, 13, Enum.Font.GothamBold, TH.Text, 15)
                    PTL.Size = UDim2.new(1,0,0,18); PTL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local ch = NewFrame(PF, TH.White, 1, UDim2.new(1,0,0,0))
                ch.AutomaticSize = Enum.AutomaticSize.Y; ch.ZIndex = 15
                local PCL = NewLabel(ch, PC, 11, Enum.Font.Gotham, TH.TextSub, 15)
                PCL.Size = UDim2.new(1,0,0,0); PCL.AutomaticSize = Enum.AutomaticSize.Y
                PCL.TextWrapped = true; PCL.TextYAlignment = Enum.TextYAlignment.Top

                return {Frame = PF,
                    SetTitle   = function(v) if PTL then PTL.Text = v end end,
                    SetContent = function(v) PCL.Text = v end}
            end

            -- ─ Button ─────────────────────────────────────────────
            function Sec:AddButton(c)
                local BT = c.Title or "Button"; local BD = c.Description or ""
                local BCB = c.Callback or function() end; local BCONF = c.Confirm or false
                local hasD = BD ~= ""
                local BF, BSt = EF(hasD, 40, 58)

                local BTL = NewLabel(BF, BT, 13, Enum.Font.GothamSemibold, TH.Text, 15)
                BTL.Size = UDim2.new(1,-48,0,18); BTL.Position = UDim2.fromOffset(12, hasD and 9 or 11)
                BTL.TextYAlignment = Enum.TextYAlignment.Center

                if hasD then
                    local BDL = NewLabel(BF, BD, 11, Enum.Font.Gotham, TH.TextSub, 15)
                    BDL.Size = UDim2.new(1,-48,0,14); BDL.Position = UDim2.fromOffset(12,27)
                    BDL.TextTruncate = Enum.TextTruncate.AtEnd; BDL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local BArrow = NewFrame(BF, TH.Accent, 0.88, UDim2.fromOffset(24,24))
                BArrow.Position = UDim2.new(1,-34,0.5,-12); BArrow.ZIndex = 15; NewCorner(BArrow, 7)
                local BAL = NewLabel(BArrow, "›", 16, Enum.Font.GothamBold, TH.Accent, 16)
                BAL.TextXAlignment = Enum.TextXAlignment.Center; BAL.TextYAlignment = Enum.TextYAlignment.Center

                local BB = NewButton(BF, 17)
                BB.MouseEnter:Connect(function()
                    TwSmooth(BF,    0.15, {BackgroundColor3 = TH.SurfaceC}):Play()
                    TwSmooth(BTL,   0.15, {TextColor3 = TH.Accent}):Play()
                    TwSmooth(BArrow,0.15, {BackgroundTransparency = 0.72}):Play()
                    TwSmooth(BSt,   0.15, {Color = TH.BorderHover, Transparency = 0.28}):Play()
                end)
                BB.MouseLeave:Connect(function()
                    TwSmooth(BF,    0.15, {BackgroundColor3 = TH.SurfaceB}):Play()
                    TwSmooth(BTL,   0.15, {TextColor3 = TH.Text}):Play()
                    TwSmooth(BArrow,0.15, {BackgroundTransparency = 0.88}):Play()
                    TwSmooth(BSt,   0.15, {Color = TH.Border, Transparency = 0.55}):Play()
                end)

                local function RunConfirm(cb)
                    local OV = NewFrame(Screen, Color3.new(), 0.55, UDim2.fromScale(1,1))
                    OV.ZIndex = 600
                    local DF = NewFrame(Screen, TH.Surface, 0, UDim2.fromOffset(0,0), UDim2.fromScale(0.5,0.5))
                    DF.AnchorPoint = Vector2.new(0.5,0.5); DF.ZIndex = 601
                    NewCorner(DF,12); NewStroke(DF, TH.Border, 0.22, 1)
                    TwSpring(DF, 0.30, {Size = UDim2.fromOffset(320,142)}):Play()

                    local DPill = NewFrame(DF, TH.Accent, 0, UDim2.fromOffset(3,22), UDim2.fromOffset(16,16))
                    DPill.ZIndex = 602; NewCorner(DPill, 2)
                    local DT = NewLabel(DF, "Confirm Action", 14, Enum.Font.GothamBold, TH.Text, 602)
                    DT.Size = UDim2.new(1,-46,0,20); DT.Position = UDim2.fromOffset(28,16)
                    DT.TextYAlignment = Enum.TextYAlignment.Center
                    local DX = NewLabel(DF, "Are you sure you want to proceed with this action?", 11, Enum.Font.Gotham, TH.TextSub, 602)
                    DX.Size = UDim2.new(1,-32,0,0); DX.Position = UDim2.fromOffset(16,46)
                    DX.TextWrapped = true; DX.AutomaticSize = Enum.AutomaticSize.Y

                    local function DBtnMake(txt, bg, xOff)
                        local dbf = NewFrame(DF, bg, 0, UDim2.fromOffset(96,30))
                        dbf.Position = UDim2.new(1,xOff,1,-40); dbf.ZIndex = 602; NewCorner(dbf, 8)
                        local dbl = NewLabel(dbf, txt, 12, Enum.Font.GothamMedium, TH.White, 603)
                        dbl.TextXAlignment = Enum.TextXAlignment.Center; dbl.TextYAlignment = Enum.TextYAlignment.Center
                        local dbb = NewButton(dbf, 604); return dbb
                    end

                    local closed = false
                    local function CloseD()
                        if closed then return end; closed = true
                        TwSmooth(DF, 0.18, {Size = UDim2.fromOffset(0,0)}):Play()
                        TwSmooth(OV, 0.20, {BackgroundTransparency = 1}):Play()
                        task.wait(0.20); OV:Destroy(); DF:Destroy()
                    end

                    DBtnMake("Cancel",  TH.SurfaceC, -214).MouseButton1Click:Connect(CloseD)
                    DBtnMake("Confirm", TH.Accent,   -108).MouseButton1Click:Connect(function() CloseD(); task.spawn(cb) end)
                    OV.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then CloseD() end end)
                end

                BB.MouseButton1Click:Connect(function()
                    TwSpring(BF, 0.07, {Size = UDim2.new(1,-6,0, hasD and 52 or 34)}):Play()
                    task.wait(0.07)
                    TwSpring(BF, 0.18, {Size = UDim2.new(1,0,0, hasD and 58 or 40)}):Play()
                    if BCONF then RunConfirm(BCB) else task.spawn(BCB) end
                end)
                return BF
            end

            -- ─ Toggle ─────────────────────────────────────────────
            function Sec:AddToggle(_, c)
                local TT = c.Title or "Toggle"; local TD = c.Description or ""
                local TDef = c.Default or false; local TCB = c.Callback or function() end
                local hasD = TD ~= ""; local isOn = TDef
                local TF, _ = EF(hasD, 40, 58)

                local TTL = NewLabel(TF, TT, 13, Enum.Font.GothamSemibold, TH.Text, 15)
                TTL.Size = UDim2.new(1,-58,0,18); TTL.Position = UDim2.fromOffset(12, hasD and 9 or 11)
                TTL.TextYAlignment = Enum.TextYAlignment.Center

                if hasD then
                    local TDL = NewLabel(TF, TD, 11, Enum.Font.Gotham, TH.TextSub, 15)
                    TDL.Size = UDim2.new(1,-58,0,14); TDL.Position = UDim2.fromOffset(12,27)
                    TDL.TextTruncate = Enum.TextTruncate.AtEnd; TDL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local TTrack = NewFrame(TF, isOn and TH.Accent or TH.SurfaceC, 0, UDim2.fromOffset(38,20))
                TTrack.Position = UDim2.new(1,-48,0.5,-10); TTrack.ZIndex = 15; NewCorner(TTrack, 10)
                local TTrackStr = NewStroke(TTrack, isOn and TH.Accent or TH.Border, 0.40, 1)

                local TKnob = NewFrame(TTrack, TH.White, 0, UDim2.fromOffset(14,14))
                TKnob.Position = UDim2.fromOffset(isOn and 21 or 3, 3); TKnob.ZIndex = 16
                NewCorner(TKnob, 7)

                local TClick = NewButton(TF, 17)
                local function SetVal(v, silent)
                    isOn = v
                    TwSmooth(TTrack,    0.22, {BackgroundColor3 = isOn and TH.Accent or TH.SurfaceC}):Play()
                    TwSmooth(TTrackStr, 0.22, {Color = isOn and TH.Accent or TH.Border}):Play()
                    TwSpring(TKnob,     0.22, {Position = UDim2.fromOffset(isOn and 21 or 3, 3)}):Play()
                    if not silent then task.spawn(TCB, isOn) end
                end

                TClick.MouseEnter:Connect(function() TwSmooth(TF, 0.14, {BackgroundColor3 = TH.SurfaceC}):Play() end)
                TClick.MouseLeave:Connect(function() TwSmooth(TF, 0.14, {BackgroundColor3 = TH.SurfaceB}):Play() end)
                TClick.MouseButton1Click:Connect(function() SetVal(not isOn) end)
                if isOn then task.spawn(TCB, isOn) end

                return {Frame = TF, SetValue = SetVal, GetValue = function() return isOn end}
            end

            -- ─ Slider ─────────────────────────────────────────────
            function Sec:AddSlider(_, c)
                local ST = c.Title or "Slider"; local SD = c.Description or ""
                local SMn = c.Min or 0; local SMx = c.Max or 100
                local SDef = math.clamp(c.Default or SMn, SMn, SMx)
                local SR = c.Rounding or 1; local SCB = c.Callback or function() end
                local SSuf = c.Suffix or ""
                local val = SDef; local dragging = false; local hasD = SD ~= ""

                local SFrame, _ = EF(hasD, 48, 64)

                local STL = NewLabel(SFrame, ST, 13, Enum.Font.GothamSemibold, TH.Text, 15)
                STL.Size = UDim2.new(1,-80,0,18); STL.Position = UDim2.fromOffset(12, hasD and 9 or 8)
                STL.TextYAlignment = Enum.TextYAlignment.Center

                local SVL = NewLabel(SFrame, tostring(val)..SSuf, 12, Enum.Font.GothamMedium, TH.Accent, 15)
                SVL.Size = UDim2.new(0,60,0,18); SVL.Position = UDim2.new(1,-68,0, hasD and 9 or 8)
                SVL.TextXAlignment = Enum.TextXAlignment.Right; SVL.TextYAlignment = Enum.TextYAlignment.Center

                if hasD then
                    local SDL = NewLabel(SFrame, SD, 11, Enum.Font.Gotham, TH.TextSub, 15)
                    SDL.Size = UDim2.new(1,-24,0,14); SDL.Position = UDim2.fromOffset(12,26)
                    SDL.TextTruncate = Enum.TextTruncate.AtEnd; SDL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local trackY = hasD and 46 or 32
                local STrack = NewFrame(SFrame, TH.SurfaceC, 0, UDim2.new(1,-24,0,4))
                STrack.Position = UDim2.fromOffset(12, trackY); STrack.ZIndex = 15; NewCorner(STrack, 4)

                local SFill = NewFrame(STrack, TH.Accent, 0, UDim2.new((val-SMn)/(SMx-SMn),0,1,0))
                SFill.ZIndex = 16; NewCorner(SFill, 4)
                local SFillGrad = Instance.new("UIGradient")
                SFillGrad.Color  = ColorSequence.new(TH.AccentDim, TH.Accent)
                SFillGrad.Parent = SFill

                local SKnob = NewFrame(STrack, TH.White, 0, UDim2.fromOffset(14,14))
                SKnob.Position = UDim2.new((val-SMn)/(SMx-SMn),-7,0.5,-7); SKnob.ZIndex = 17
                NewCorner(SKnob, 7)
                local SKStr = NewStroke(SKnob, TH.Accent, 0.25, 2)

                local function SetVal(v)
                    v = math.clamp(v, SMn, SMx)
                    if SR and SR > 0 then v = math.round(v/SR)*SR end
                    val = v
                    local p = (v-SMn)/(SMx-SMn)
                    TwSmooth(SFill,  0.10, {Size     = UDim2.new(p,0,1,0)}):Play()
                    TwSmooth(SKnob,  0.10, {Position = UDim2.new(p,-7,0.5,-7)}):Play()
                    SVL.Text = tostring(v)..SSuf
                    task.spawn(SCB, v)
                end

                local function getPct(px)
                    return math.clamp((px - STrack.AbsolutePosition.X) / STrack.AbsoluteSize.X, 0, 1)
                end

                local function beginDrag(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        TwSpring(SKnob, 0.14, {Size = UDim2.fromOffset(18,18)}):Play()
                        TwSmooth(SKStr, 0.14, {Transparency = 0.05}):Play()
                        SetVal(SMn + (SMx-SMn)*getPct(i.Position.X))
                    end
                end

                STrack.InputBegan:Connect(beginDrag)
                SKnob.InputBegan:Connect(beginDrag)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch) then
                        SetVal(SMn + (SMx-SMn)*getPct(i.Position.X))
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch) then
                        dragging = false
                        TwSmooth(SKnob, 0.14, {Size = UDim2.fromOffset(14,14)}):Play()
                        TwSmooth(SKStr, 0.14, {Transparency = 0.25}):Play()
                    end
                end)

                SetVal(val)
                return {Frame = SFrame, SetValue = SetVal, GetValue = function() return val end}
            end

            -- ─ Dropdown ───────────────────────────────────────────
            function Sec:AddDropdown(_, c)
                local DT = c.Title or "Dropdown"; local DD = c.Description or ""
                local DV = c.Values or {}; local DM = c.Multi or false
                local DDef = c.Default or (DM and {} or 1); local DCB = c.Callback or function() end
                local sel = {}
                if DM then if type(DDef)=="table" then for _,v in pairs(DDef) do sel[v]=true end end
                else sel = type(DDef)=="number" and (DV[DDef] or DV[1]) or DDef end

                local open = false; local hasD = DD ~= ""; local baseH = hasD and 56 or 40

                local DF = NewFrame(SC, TH.SurfaceB, 0, UDim2.new(1,0,0,baseH))
                DF.ClipsDescendants = true; DF.ZIndex = 14; NewCorner(DF, 8)
                local DStr = NewStroke(DF, TH.Border, 0.55, 1)

                local DTL = NewLabel(DF, DT, 13, Enum.Font.GothamSemibold, TH.Text, 15)
                DTL.Size = UDim2.new(1,-44,0,18); DTL.Position = UDim2.fromOffset(12, hasD and 9 or 11)
                DTL.TextYAlignment = Enum.TextYAlignment.Center

                local DChev = NewLabel(DF, "⌄", 14, Enum.Font.GothamBold, TH.TextSub, 15)
                DChev.Size = UDim2.fromOffset(18,18); DChev.Position = UDim2.new(1,-28,0, hasD and 9 or 11)
                DChev.TextXAlignment = Enum.TextXAlignment.Center; DChev.TextYAlignment = Enum.TextYAlignment.Center

                if hasD then
                    local DDL = NewLabel(DF, DD, 11, Enum.Font.Gotham, TH.TextSub, 15)
                    DDL.Size = UDim2.new(1,-44,0,14); DDL.Position = UDim2.fromOffset(12,26)
                    DDL.TextTruncate = Enum.TextTruncate.AtEnd; DDL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local DVL = NewLabel(DF, "", 11, Enum.Font.GothamMedium, TH.Accent, 15)
                DVL.Size = UDim2.new(1,-44,0,14); DVL.Position = UDim2.fromOffset(12, hasD and 40 or 24)
                DVL.TextTruncate = Enum.TextTruncate.AtEnd; DVL.TextYAlignment = Enum.TextYAlignment.Center

                local DListC = NewFrame(DF, TH.Surface, 0, UDim2.new(1,-8,0,0))
                DListC.Position = UDim2.fromOffset(4, baseH+4); DListC.ZIndex = 15
                NewCorner(DListC, 8); NewStroke(DListC, TH.Border, 0.30, 1)

                local DScroll = NewScroll(DListC, TH.BorderHover, 0.50, 16)
                DScroll.ScrollBarThickness = 2
                NewPadding(DScroll, 4,4,4,4); NewVList(DScroll, 2)

                local DClick = NewButton(DF, 16); DClick.Size = UDim2.new(1,0,0,baseH)

                local function UpdateLabel()
                    if DM then
                        local s = {}
                        for v,on in pairs(sel) do if on then table.insert(s,v) end end
                        DVL.Text = #s==0 and "None selected" or (#s==1 and s[1] or s[1].." +"..(#s-1))
                    else DVL.Text = tostring(sel or "None selected") end
                end

                local function ToggleOpen()
                    open = not open
                    local lh = open and math.min(#DV*30+8, 150) or 0
                    TwSmooth(DF,     0.22, {Size = UDim2.new(1,0,0,baseH+(open and lh+8 or 0))}):Play()
                    TwSmooth(DListC, 0.22, {Size = UDim2.new(1,-8,0,lh)}):Play()
                    TwSmooth(DChev,  0.18, {Rotation = open and 180 or 0}):Play()
                    TwSmooth(DStr,   0.16, {Color = open and TH.Accent or TH.Border, Transparency = open and 0.18 or 0.55}):Play()
                end

                DClick.MouseButton1Click:Connect(ToggleOpen)

                local function Build()
                    for _,ch in ipairs(DScroll:GetChildren()) do
                        if ch:IsA("Frame") then ch:Destroy() end
                    end
                    for i,v in ipairs(DV) do
                        local active = DM and sel[v] or (not DM and sel==v)
                        local OF = NewFrame(DScroll, TH.SurfaceB, active and 0 or 0.60, UDim2.new(1,0,0,28))
                        OF.LayoutOrder = i; OF.ZIndex = 17; NewCorner(OF, 6)

                        local OPill = NewFrame(OF, TH.Accent, active and 0.80 or 1, UDim2.fromOffset(3,14))
                        OPill.Position = UDim2.new(0,0,0.5,-7); OPill.ZIndex = 18; NewCorner(OPill, 2)

                        local OL = NewLabel(OF, v, 12, Enum.Font.GothamMedium, active and TH.Accent or TH.TextSub, 18)
                        OL.Size = UDim2.new(1,-16,1,0); OL.Position = UDim2.fromOffset(12,0)
                        OL.TextYAlignment = Enum.TextYAlignment.Center

                        local OBtn = NewButton(OF, 19)
                        OBtn.MouseEnter:Connect(function() TwSmooth(OF,0.10,{BackgroundTransparency=0.30}):Play() end)
                        OBtn.MouseLeave:Connect(function() TwSmooth(OF,0.10,{BackgroundTransparency=active and 0 or 0.60}):Play() end)
                        OBtn.MouseButton1Click:Connect(function()
                            if DM then
                                sel[v] = not sel[v]
                                TwSmooth(OL,    0.12, {TextColor3 = sel[v] and TH.Accent or TH.TextSub}):Play()
                                TwSmooth(OPill, 0.12, {BackgroundTransparency = sel[v] and 0.80 or 1}):Play()
                                UpdateLabel()
                                local s={} for sv,on in pairs(sel) do if on then table.insert(s,sv) end end
                                task.spawn(DCB, s)
                            else
                                sel = v
                                for _,ch in ipairs(DScroll:GetChildren()) do
                                    if ch:IsA("Frame") then
                                        local lbl = ch:FindFirstChildWhichIsA("TextLabel")
                                        if lbl then lbl.TextColor3 = TH.TextSub end
                                        TwSmooth(ch,0.10,{BackgroundTransparency=0.60}):Play()
                                    end
                                end
                                TwSmooth(OL,    0.12, {TextColor3 = TH.Accent}):Play()
                                TwSmooth(OPill, 0.12, {BackgroundTransparency = 0.80}):Play()
                                TwSmooth(OF,    0.10, {BackgroundTransparency = 0}):Play()
                                UpdateLabel(); ToggleOpen(); task.spawn(DCB, v)
                            end
                        end)
                    end
                end

                Build(); UpdateLabel()

                return {
                    Frame     = DF,
                    SetValue  = function(v)
                        if DM then sel={}; if type(v)=="table" then for _,sv in pairs(v) do sel[sv]=true end end
                        else sel=v end; Build(); UpdateLabel()
                    end,
                    SetValues = function(vals) DV=vals; Build(); UpdateLabel() end,
                    GetValue  = function()
                        if DM then local s={} for sv,on in pairs(sel) do if on then table.insert(s,sv) end end; return s end
                        return sel
                    end,
                }
            end

            -- ─ Input ──────────────────────────────────────────────
            function Sec:AddInput(_, c)
                local IT = c.Title or "Input"; local ID = c.Description or ""
                local IDef = c.Default or ""; local IPH = c.Placeholder or "Type here..."
                local INum = c.Numeric or false; local IFin = c.Finished or false
                local ICB = c.Callback or function() end
                local val = IDef; local hasD = ID ~= ""

                local IF, IFStr = EF(hasD, 48, 64)

                local ITL = NewLabel(IF, IT, 13, Enum.Font.GothamSemibold, TH.Text, 15)
                ITL.Size = UDim2.new(1,-24,0,18); ITL.Position = UDim2.fromOffset(12, hasD and 8 or 7)
                ITL.TextYAlignment = Enum.TextYAlignment.Center

                if hasD then
                    local IDL = NewLabel(IF, ID, 11, Enum.Font.Gotham, TH.TextSub, 15)
                    IDL.Size = UDim2.new(1,-24,0,14); IDL.Position = UDim2.fromOffset(12,24)
                    IDL.TextTruncate = Enum.TextTruncate.AtEnd; IDL.TextYAlignment = Enum.TextYAlignment.Center
                end

                local IBox = Instance.new("TextBox")
                IBox.BackgroundColor3    = TH.SurfaceC
                IBox.BackgroundTransparency = 0; IBox.BorderSizePixel = 0
                IBox.Size     = UDim2.new(1,-24,0,26); IBox.Position = UDim2.fromOffset(12, hasD and 40 or 20)
                IBox.Text     = IDef; IBox.PlaceholderText = IPH
                IBox.PlaceholderColor3 = TH.TextMuted; IBox.TextColor3 = TH.Text
                IBox.TextSize = 12; IBox.Font = Enum.Font.Gotham
                IBox.TextXAlignment = Enum.TextXAlignment.Left
                IBox.ClearTextOnFocus = false; IBox.ZIndex = 15; IBox.Parent = IF
                NewCorner(IBox, 7); NewPadding(IBox, 0,0,10,10)
                local IBStr = NewStroke(IBox, TH.Border, 0.42, 1)

                IBox.Focused:Connect(function()
                    TwSmooth(IBStr,  0.16, {Color = TH.Accent, Transparency = 0.08}):Play()
                    TwSmooth(IFStr,  0.16, {Color = TH.Accent, Transparency = 0.28}):Play()
                end)
                IBox.FocusLost:Connect(function(enter)
                    TwSmooth(IBStr,  0.16, {Color = TH.Border, Transparency = 0.42}):Play()
                    TwSmooth(IFStr,  0.16, {Color = TH.Border, Transparency = 0.55}):Play()
                    if IFin and enter then val = IBox.Text; task.spawn(ICB, val) end
                end)

                if not IFin then
                    IBox:GetPropertyChangedSignal("Text"):Connect(function()
                        if INum then
                            local cl = IBox.Text:gsub("[^%d%.%-]","")
                            if cl ~= IBox.Text then IBox.Text = cl; return end
                        end
                        val = IBox.Text; task.spawn(ICB, val)
                    end)
                end

                return {
                    Frame    = IF,
                    SetValue = function(v) IBox.Text = tostring(v); val = tostring(v) end,
                    GetValue = function() return val end,
                }
            end

            return Sec
        end

        return Tab
    end

    Window.Screen    = Screen
    Window.Main      = Main
    Window.Theme     = TH
    Window.TimerConn = timerConn

    function Window:SetIcon(id)
        TIconImg.Image = id; FloatImg.Image = id
    end

    function Window:Destroy()
        timerConn:Disconnect(); Screen:Destroy()
    end

    return Window
end

Library.Version = "2.4.5"
Library.Themes  = Themes

return Library