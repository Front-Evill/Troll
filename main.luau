-- ╔══════════════════════════════════════════════════════════════╗
-- ║         Alex JOK  –  Script Logger  v7.0                    ║
-- ║         Fixed & Upgraded for Delta Executor (Mobile)        ║
-- ║         Multi-hook: loadstring / load / HttpGet /           ║
-- ║         request / http_request / syn.request / require      ║
-- ╚══════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local StarterGui       = game:GetService("StarterGui")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ── Fluent UI library ────────────────────────────────────────────
local Fluent           = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager      = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ── Core references (saved BEFORE any hooks are installed) ───────
local originalLoadstring = loadstring
local originalLoad       = load

-- ── State ────────────────────────────────────────────────────────
local capturedScripts = {}
local capturedCount   = 0
local seenHashes      = {}      -- deduplication
local hookInstalled   = false
local listScrollFrame
local listLayout
local counterLabel
local statusLabel
local FOLDER = "AlexJOK_Scripts"

-- ── Source-type colours (used by addEntry badges) ────────────────
local SOURCE_COLORS = {
    loadstring   = Color3.fromRGB(0,   100, 200),
    load         = Color3.fromRGB(0,   150, 160),
    HttpGet      = Color3.fromRGB(200, 110,   0),
    request      = Color3.fromRGB(130,   0, 180),
    http_request = Color3.fromRGB(140,  20, 140),
    ["syn.request"] = Color3.fromRGB(180,   0, 100),
    require      = Color3.fromRGB( 30, 140,  60),
    unknown      = Color3.fromRGB( 80,  80,  80),
}

-- ═══════════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = title,
            Text     = text,
            Duration = 5,
        })
    end)
end

local function ensureFolder()
    pcall(function()
        if not isfolder(FOLDER) then makefolder(FOLDER) end
    end)
end

local function writeFile(path, content)
    local ok, err = pcall(writefile, path, content)
    return ok, err
end

local function readFile(path)
    local ok, data = pcall(readfile, path)
    if ok and data then return data end
    return nil
end

local function lineCount(code)
    local n = 1
    for _ in code:gmatch("\n") do n = n + 1 end
    return n
end

-- Simple fast hash for deduplication (first 4 KB + total length)
local function hashCode(s)
    local h = 5381
    local cap = math.min(#s, 4096)
    for i = 1, cap do
        h = (h * 31 + string.byte(s, i)) % 2147483647
    end
    return tostring(h) .. "_" .. tostring(#s)
end

-- Extract a meaningful filename from a URL
local function extractNameFromURL(url)
    if type(url) ~= "string" or url == "" then return nil end

    -- GitHub raw: raw.githubusercontent.com/<user>/<repo>/<ref>/<path>/file.lua
    local user, file = url:match("raw%.githubusercontent%.com/([^/]+)/[^/]+/[^/]+/.*/([^/?#]+)$")
    if not file then
        user, file = url:match("raw%.githubusercontent%.com/([^/]+)/[^/]+/[^/]+/([^/?#]+)$")
    end
    if file then
        local base = file:gsub("%.lua$", ""):gsub("[^%w%-%._]", "_"):sub(1, 30)
        local u    = user:sub(1, 12):gsub("[^%w%-%._]", "_")
        return (u .. "_" .. base):sub(1, 40)
    end

    -- General: grab the last path segment
    local seg = url:match("/([^/?#]+)%.[Ll][Uu][Aa]") or url:match("/([^/?#]+)$")
    if seg and #seg > 0 then
        return seg:gsub("%.lua$", ""):gsub("[^%w%-%._]", "_"):sub(1, 40)
    end

    -- Fallback: domain slug
    local domain = url:match("https?://([^/]+)")
    if domain then
        return domain:gsub("[^%w%-]", "_"):sub(1, 28) .. "_dl"
    end

    return nil
end

-- Heuristic: does this string look like Lua source?
local function isProbablyScript(s)
    if type(s) ~= "string" or #s < 12 then return false end
    local head = s:sub(1, 6)
    -- Reject common binary / data formats
    if head:sub(1, 4) == "\27Lua"       then return true  end -- pre-compiled Lua bytecode
    if head:sub(1, 4) == "\137PNG"      then return false end
    if head:sub(1, 3) == "GIF"          then return false end
    if head:sub(1, 2) == "\255\216"     then return false end -- JPEG
    if head:sub(1, 4) == "RIFF"         then return false end
    if head:sub(1, 1) == "{"            then return false end -- JSON object
    if head:sub(1, 1) == "["            then return false end -- JSON array
    if head:sub(1, 5) == "<?xml"        then return false end
    if head:sub(1, 6) == "<html>"       then return false end
    -- Lua keyword presence is a strong signal
    local probe = s:sub(1, 512)
    if probe:match("local%s+")   then return true end
    if probe:match("function%s") then return true end
    if probe:match("%-%-")        then return true end
    if probe:match("game[%.:%(]") then return true end
    if probe:match("workspace")   then return true end
    if probe:match("require%(")   then return true end
    if probe:match("print%(")     then return true end
    if probe:match("end%s")       then return true end
    -- Worst case: accept it anyway (let the user decide)
    return true
end

-- ═══════════════════════════════════════════════════════════════════
--  UNIFIED CAPTURE FUNCTION
--  All hooks funnel through here.
-- ═══════════════════════════════════════════════════════════════════

local function captureScript(code, source, hint)
    -- Basic type + length guard
    if type(code) ~= "string" or #code < 10 then return end

    -- Deduplication via hash
    local h = hashCode(code)
    if seenHashes[h] then return end
    seenHashes[h] = true

    -- Build a meaningful file name
    local baseName
    if hint and hint:match("^https?://") then
        baseName = extractNameFromURL(hint) or (source or "script")
    elseif hint and type(hint) == "string" and #hint > 0 then
        baseName = hint:gsub("[^%w%-%._]", "_"):sub(1, 38)
        if baseName == "" or baseName == "_" then baseName = source or "script" end
    else
        baseName = source or "script"
    end

    capturedCount = capturedCount + 1
    local fileName = baseName .. "_" .. capturedCount .. ".lua"

    local data = {
        index    = capturedCount,
        code     = code,
        fileName = fileName,
        source   = source or "unknown",
        hint     = hint or "",
        time     = os.date("%H:%M:%S"),
    }

    table.insert(capturedScripts, data)
    ensureFolder()
    writeFile(FOLDER .. "/" .. fileName, code)

    -- UI updates run on the main scheduler so they never block hooks
    task.spawn(function()
        if counterLabel then
            counterLabel.Text = "Captured: " .. capturedCount
        end
        if statusLabel then
            statusLabel.Text       = "Script Logger  –  Active"
            statusLabel.TextColor3 = Color3.fromRGB(86, 182, 86)
        end
        addEntry(data)
        notify("Alex JOK", string.format("#%d  [%s]  %s", capturedCount, source or "?", fileName))
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--  SCRIPT EDITOR  (unchanged from original, kept fully intact)
-- ═══════════════════════════════════════════════════════════════════

local function openEditor(scriptData)
    local existing = playerGui:FindFirstChild("_ScriptEditorGui")
    if existing then existing:Destroy() end

    local liveCode = scriptData.code
    local fileName = scriptData.fileName

    local editorGui = Instance.new("ScreenGui")
    editorGui.Name           = "_ScriptEditorGui"
    editorGui.ResetOnSpawn   = false
    editorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    editorGui.IgnoreGuiInset = true
    editorGui.DisplayOrder   = 999
    editorGui.Parent         = playerGui

    local backdrop = Instance.new("TextButton")
    backdrop.Size                   = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 0.45
    backdrop.BorderSizePixel        = 0
    backdrop.Text                   = ""
    backdrop.ZIndex                 = 1
    backdrop.Parent                 = editorGui

    local WIN_W = 740
    local WIN_H = 540

    local win = Instance.new("Frame")
    win.Size             = UDim2.fromOffset(WIN_W * 0.88, WIN_H * 0.88)
    win.Position         = UDim2.fromScale(0.5, 0.5)
    win.AnchorPoint      = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    win.BorderSizePixel  = 0
    win.ZIndex           = 2
    win.ClipsDescendants = true
    win.Parent           = editorGui

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 8)
    winCorner.Parent       = win

    local winStroke = Instance.new("UIStroke")
    winStroke.Color        = Color3.fromRGB(0, 122, 204)
    winStroke.Thickness    = 1.2
    winStroke.Transparency = 0.55
    winStroke.Parent       = win

    local TITLE_H = 32

    local titleBar = Instance.new("Frame")
    titleBar.Size             = UDim2.new(1, 0, 0, TITLE_H)
    titleBar.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    titleBar.BorderSizePixel  = 0
    titleBar.ZIndex           = 3
    titleBar.Parent           = win

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 8)
    tbCorner.Parent       = titleBar

    local tbBottomFix = Instance.new("Frame")
    tbBottomFix.Size             = UDim2.new(1, 0, 0, 10)
    tbBottomFix.Position         = UDim2.new(0, 0, 1, -10)
    tbBottomFix.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    tbBottomFix.BorderSizePixel  = 0
    tbBottomFix.ZIndex           = 3
    tbBottomFix.Parent           = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size                   = UDim2.new(1, -110, 1, 0)
    titleText.Position               = UDim2.new(0, 12, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text                   = fileName
    titleText.TextColor3             = Color3.fromRGB(200, 200, 200)
    titleText.TextSize               = 11
    titleText.Font                   = Enum.Font.Code
    titleText.TextXAlignment         = Enum.TextXAlignment.Left
    titleText.TextTruncate           = Enum.TextTruncate.AtEnd
    titleText.ZIndex                 = 4
    titleText.Parent                 = titleBar

    local closeX = Instance.new("TextButton")
    closeX.Size             = UDim2.new(0, 16, 0, 16)
    closeX.Position         = UDim2.new(1, -24, 0.5, -8)
    closeX.BackgroundColor3 = Color3.fromRGB(196, 43, 28)
    closeX.BorderSizePixel  = 0
    closeX.Text             = "x"
    closeX.TextColor3       = Color3.fromRGB(255, 255, 255)
    closeX.TextSize         = 9
    closeX.Font             = Enum.Font.GothamBold
    closeX.ZIndex           = 5
    closeX.Parent           = titleBar

    local closeXCorner = Instance.new("UICorner")
    closeXCorner.CornerRadius = UDim.new(1, 0)
    closeXCorner.Parent       = closeX

    closeX.MouseButton1Click:Connect(function() editorGui:Destroy() end)
    backdrop.MouseButton1Click:Connect(function() editorGui:Destroy() end)

    local dragging  = false
    local dragStart = nil
    local winStart  = nil

    titleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            winStart  = win.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            win.Position = UDim2.new(
                winStart.X.Scale, winStart.X.Offset + d.X,
                winStart.Y.Scale, winStart.Y.Offset + d.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local TAB_H = 26

    local tabBar = Instance.new("Frame")
    tabBar.Size             = UDim2.new(1, 0, 0, TAB_H)
    tabBar.Position         = UDim2.new(0, 0, 0, TITLE_H)
    tabBar.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    tabBar.BorderSizePixel  = 0
    tabBar.ZIndex           = 3
    tabBar.Parent           = win

    local activeTab = Instance.new("Frame")
    activeTab.Size             = UDim2.new(0, 220, 1, 0)
    activeTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    activeTab.BorderSizePixel  = 0
    activeTab.ZIndex           = 4
    activeTab.Parent           = tabBar

    local tabAccent = Instance.new("Frame")
    tabAccent.Size             = UDim2.new(1, 0, 0, 2)
    tabAccent.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
    tabAccent.BorderSizePixel  = 0
    tabAccent.ZIndex           = 5
    tabAccent.Parent           = activeTab

    local tabText = Instance.new("TextLabel")
    tabText.Size                   = UDim2.new(1, -12, 1, 0)
    tabText.Position               = UDim2.new(0, 8, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text                   = fileName
    tabText.TextColor3             = Color3.fromRGB(220, 220, 220)
    tabText.TextSize               = 10
    tabText.Font                   = Enum.Font.Code
    tabText.TextXAlignment         = Enum.TextXAlignment.Left
    tabText.TextTruncate           = Enum.TextTruncate.AtEnd
    tabText.ZIndex                 = 5
    tabText.Parent                 = activeTab

    local TOOLBAR_H = 38
    local STATUS_H  = 22
    local editorTop = TITLE_H + TAB_H
    local editorH   = WIN_H - editorTop - TOOLBAR_H - STATUS_H

    local editorFrame = Instance.new("Frame")
    editorFrame.Size             = UDim2.new(1, 0, 0, editorH)
    editorFrame.Position         = UDim2.new(0, 0, 0, editorTop)
    editorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    editorFrame.BorderSizePixel  = 0
    editorFrame.ClipsDescendants = true
    editorFrame.ZIndex           = 3
    editorFrame.Parent           = win

    local GUTTER_W = 52

    local gutter = Instance.new("Frame")
    gutter.Size             = UDim2.new(0, GUTTER_W, 1, 0)
    gutter.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    gutter.BorderSizePixel  = 0
    gutter.ClipsDescendants = true
    gutter.ZIndex           = 4
    gutter.Parent           = editorFrame

    local gutterScroll = Instance.new("ScrollingFrame")
    gutterScroll.Size                = UDim2.fromScale(1, 1)
    gutterScroll.BackgroundTransparency = 1
    gutterScroll.BorderSizePixel     = 0
    gutterScroll.ScrollBarThickness  = 0
    gutterScroll.CanvasSize          = UDim2.fromScale(0, 0)
    gutterScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    gutterScroll.ScrollingEnabled    = false
    gutterScroll.ZIndex              = 4
    gutterScroll.Parent              = gutter

    local gutterLayout = Instance.new("UIListLayout")
    gutterLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gutterLayout.Padding   = UDim.new(0, 0)
    gutterLayout.Parent    = gutterScroll

    local codeScroll = Instance.new("ScrollingFrame")
    codeScroll.Size                       = UDim2.new(1, -GUTTER_W, 1, 0)
    codeScroll.Position                   = UDim2.new(0, GUTTER_W, 0, 0)
    codeScroll.BackgroundColor3           = Color3.fromRGB(30, 30, 30)
    codeScroll.BorderSizePixel            = 0
    codeScroll.ScrollBarThickness         = 6
    codeScroll.ScrollBarImageColor3       = Color3.fromRGB(80, 80, 80)
    codeScroll.ScrollBarImageTransparency = 0.2
    codeScroll.CanvasSize                 = UDim2.fromScale(0, 0)
    codeScroll.AutomaticCanvasSize        = Enum.AutomaticSize.Y
    codeScroll.ZIndex                     = 4
    codeScroll.Parent                     = editorFrame

    codeScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        gutterScroll.CanvasPosition = Vector2.new(0, codeScroll.CanvasPosition.Y)
    end)

    local codeBox = Instance.new("TextBox")
    codeBox.Size               = UDim2.new(1, -14, 1, 0)
    codeBox.Position           = UDim2.new(0, 8, 0, 4)
    codeBox.BackgroundTransparency = 1
    codeBox.Text               = liveCode
    codeBox.TextColor3         = Color3.fromRGB(212, 212, 212)
    codeBox.PlaceholderColor3  = Color3.fromRGB(90, 90, 90)
    codeBox.PlaceholderText    = "-- empty"
    codeBox.TextSize           = 13
    codeBox.Font               = Enum.Font.Code
    codeBox.TextXAlignment     = Enum.TextXAlignment.Left
    codeBox.TextYAlignment     = Enum.TextYAlignment.Top
    codeBox.MultiLine          = true
    codeBox.ClearTextOnFocus   = false
    codeBox.TextWrapped        = false
    codeBox.AutomaticSize      = Enum.AutomaticSize.Y
    codeBox.ZIndex             = 5
    codeBox.Parent             = codeScroll

    local LINE_H = 17

    local function rebuildGutter(code)
        for _, ch in pairs(gutterScroll:GetChildren()) do
            if ch:IsA("TextLabel") then ch:Destroy() end
        end
        local n = math.min(lineCount(code), 5000)
        for i = 1, n do
            local ln = Instance.new("TextLabel")
            ln.Size                   = UDim2.new(1, -6, 0, LINE_H)
            ln.BackgroundTransparency = 1
            ln.Text                   = tostring(i)
            ln.TextColor3             = Color3.fromRGB(90, 90, 90)
            ln.TextSize               = 13
            ln.Font                   = Enum.Font.Code
            ln.TextXAlignment         = Enum.TextXAlignment.Right
            ln.LayoutOrder            = i
            ln.ZIndex                 = 4
            ln.Parent                 = gutterScroll
        end
    end

    rebuildGutter(liveCode)

    local rebounce = false
    codeBox:GetPropertyChangedSignal("Text"):Connect(function()
        liveCode = codeBox.Text
        if not rebounce then
            rebounce = true
            task.delay(0.4, function()
                rebounce = false
                rebuildGutter(liveCode)
            end)
        end
    end)

    local toolbarY = editorTop + editorH

    local toolbar = Instance.new("Frame")
    toolbar.Size             = UDim2.new(1, 0, 0, TOOLBAR_H)
    toolbar.Position         = UDim2.new(0, 0, 0, toolbarY)
    toolbar.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    toolbar.BorderSizePixel  = 0
    toolbar.ZIndex           = 3
    toolbar.Parent           = win

    local tbTopFix = Instance.new("Frame")
    tbTopFix.Size             = UDim2.new(1, 0, 0, 10)
    tbTopFix.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    tbTopFix.BorderSizePixel  = 0
    tbTopFix.ZIndex           = 3
    tbTopFix.Parent           = toolbar

    local function makeBtn(label, xOff, w, bg)
        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(0, w, 0, 26)
        btn.Position               = UDim2.new(0, xOff, 0.5, -13)
        btn.BackgroundColor3       = bg
        btn.BackgroundTransparency = 0.05
        btn.BorderSizePixel        = 0
        btn.Text                   = label
        btn.TextColor3             = Color3.fromRGB(240, 240, 240)
        btn.TextSize               = 10
        btn.Font                   = Enum.Font.GothamBold
        btn.ZIndex                 = 5
        btn.Parent                 = toolbar
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent       = btn
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.05}):Play()
        end)
        return btn
    end

    local G         = 8
    local copyBtn   = makeBtn("Copy",    G,              80,  Color3.fromRGB(0,   95, 165))
    local saveBtn   = makeBtn("Save",    G + 88,         80,  Color3.fromRGB(0,  125,  55))
    local saveAsBtn = makeBtn("Save As", G + 176,        90,  Color3.fromRGB(80,  60,   0))
    local execBtn   = makeBtn("Execute", G + 274,        90,  Color3.fromRGB(105,  0, 175))
    local closeBtn  = makeBtn("Close",   WIN_W - G - 80, 80,  Color3.fromRGB(155, 28,  28))

    local statusBar = Instance.new("Frame")
    statusBar.Size             = UDim2.new(1, 0, 0, STATUS_H)
    statusBar.Position         = UDim2.new(0, 0, 0, toolbarY + TOOLBAR_H)
    statusBar.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
    statusBar.BorderSizePixel  = 0
    statusBar.ZIndex           = 3
    statusBar.Parent           = win

    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(0, 8)
    sbCorner.Parent       = statusBar

    local sbTopFix = Instance.new("Frame")
    sbTopFix.Size             = UDim2.new(1, 0, 0, 10)
    sbTopFix.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
    sbTopFix.BorderSizePixel  = 0
    sbTopFix.ZIndex           = 3
    sbTopFix.Parent           = statusBar

    local sbText = Instance.new("TextLabel")
    sbText.Size                   = UDim2.new(1, -10, 1, 0)
    sbText.Position               = UDim2.new(0, 8, 0, 0)
    sbText.BackgroundTransparency = 1
    sbText.TextColor3             = Color3.fromRGB(255, 255, 255)
    sbText.TextSize               = 10
    sbText.Font                   = Enum.Font.Code
    sbText.TextXAlignment         = Enum.TextXAlignment.Left
    sbText.ZIndex                 = 4
    sbText.Parent                 = statusBar

    local function refreshStatus()
        local ln = lineCount(liveCode)
        local ch = #liveCode
        sbText.Text = "Lua   Lines: " .. ln .. "   Chars: " .. ch .. "   " .. fileName
    end

    refreshStatus()

    codeBox:GetPropertyChangedSignal("Text"):Connect(function()
        task.defer(refreshStatus)
    end)

    local function flash(btn, orig)
        btn.Text = "Done"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = orig end
        end)
    end

    copyBtn.MouseButton1Click:Connect(function()
        pcall(setclipboard, liveCode)
        flash(copyBtn, "Copy")
    end)

    saveBtn.MouseButton1Click:Connect(function()
        ensureFolder()
        local ok, err = writeFile(FOLDER .. "/" .. fileName, liveCode)
        if ok then
            notify("Alex JOK", "Saved: " .. fileName)
        else
            notify("Alex JOK", "Save failed: " .. tostring(err))
        end
        flash(saveBtn, "Save")
    end)

    saveAsBtn.MouseButton1Click:Connect(function()
        ensureFolder()
        local newName = "edited_" .. os.date("%H%M%S") .. ".lua"
        writeFile(FOLDER .. "/" .. newName, liveCode)
        fileName = newName
        titleText.Text = fileName
        tabText.Text   = fileName
        refreshStatus()
        notify("Alex JOK", "Saved as: " .. newName)
        flash(saveAsBtn, "Save As")
    end)

    execBtn.MouseButton1Click:Connect(function()
        local fn, err = originalLoadstring(liveCode)
        if fn then
            task.spawn(fn)
            notify("Alex JOK", "Executed: " .. fileName)
        else
            notify("Alex JOK", "Syntax error: " .. tostring(err))
        end
        flash(execBtn, "Execute")
    end)

    closeBtn.MouseButton1Click:Connect(function() editorGui:Destroy() end)

    TweenService:Create(win, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(WIN_W, WIN_H),
    }):Play()
end

-- ═══════════════════════════════════════════════════════════════════
--  ENTRY CARD  (upgraded: now shows source-type badge)
-- ═══════════════════════════════════════════════════════════════════

function addEntry(data)
    if not listScrollFrame then return end

    local idx    = data.index
    local code   = data.code
    local fname  = data.fileName
    local ts     = data.time
    local src    = data.source or "unknown"
    local lines  = lineCount(code)

    -- First non-empty line as preview
    local preview = "(empty)"
    for line in code:gmatch("[^\n]+") do
        local t = line:match("^%s*(.-)%s*$")
        if t ~= "" then
            preview = t
            break
        end
    end
    if #preview > 62 then preview = preview:sub(1, 62) .. "..." end

    local srcColor = SOURCE_COLORS[src] or SOURCE_COLORS["unknown"]

    local entry = Instance.new("Frame")
    entry.Size                   = UDim2.new(1, -4, 0, 118)
    entry.BackgroundColor3       = Color3.fromRGB(28, 30, 40)
    entry.BackgroundTransparency = 1
    entry.BorderSizePixel        = 0
    entry.LayoutOrder            = idx
    entry.Parent                 = listScrollFrame

    local eCorner = Instance.new("UICorner")
    eCorner.CornerRadius = UDim.new(0, 8)
    eCorner.Parent       = entry

    -- Left accent bar (colour = source type)
    local accent = Instance.new("Frame")
    accent.Size             = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = srcColor
    accent.BorderSizePixel  = 0
    accent.Parent           = entry

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 3)
    accentCorner.Parent       = accent

    -- Index badge
    local badge = Instance.new("TextLabel")
    badge.Size                   = UDim2.new(0, 34, 0, 18)
    badge.Position               = UDim2.new(0, 10, 0, 6)
    badge.BackgroundColor3       = Color3.fromRGB(0, 80, 160)
    badge.BackgroundTransparency = 0
    badge.BorderSizePixel        = 0
    badge.Text                   = "#" .. idx
    badge.TextColor3             = Color3.fromRGB(255, 255, 255)
    badge.TextSize               = 9
    badge.Font                   = Enum.Font.GothamBold
    badge.Parent                 = entry

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 4)
    badgeCorner.Parent       = badge

    -- Timestamp
    local timeLbl = Instance.new("TextLabel")
    timeLbl.Size                   = UDim2.new(0, 60, 0, 18)
    timeLbl.Position               = UDim2.new(0, 48, 0, 6)
    timeLbl.BackgroundTransparency = 1
    timeLbl.Text                   = ts
    timeLbl.TextColor3             = Color3.fromRGB(86, 182, 86)
    timeLbl.TextSize               = 9
    timeLbl.Font                   = Enum.Font.Code
    timeLbl.TextXAlignment         = Enum.TextXAlignment.Left
    timeLbl.Parent                 = entry

    -- Lines / chars
    local linesLbl = Instance.new("TextLabel")
    linesLbl.Size                   = UDim2.new(0, 100, 0, 18)
    linesLbl.Position               = UDim2.new(0, 112, 0, 6)
    linesLbl.BackgroundTransparency = 1
    linesLbl.Text                   = lines .. " ln  |  " .. #code .. " ch"
    linesLbl.TextColor3             = Color3.fromRGB(140, 140, 170)
    linesLbl.TextSize               = 9
    linesLbl.Font                   = Enum.Font.Code
    linesLbl.TextXAlignment         = Enum.TextXAlignment.Left
    linesLbl.Parent                 = entry

    -- Source-type badge  ← NEW
    local srcBadge = Instance.new("TextLabel")
    srcBadge.Size                   = UDim2.new(0, 80, 0, 16)
    srcBadge.Position               = UDim2.new(1, -90, 0, 8)
    srcBadge.BackgroundColor3       = srcColor
    srcBadge.BackgroundTransparency = 0.25
    srcBadge.BorderSizePixel        = 0
    srcBadge.Text                   = src
    srcBadge.TextColor3             = Color3.fromRGB(255, 255, 255)
    srcBadge.TextSize               = 8
    srcBadge.Font                   = Enum.Font.GothamBold
    srcBadge.TextXAlignment         = Enum.TextXAlignment.Center
    srcBadge.Parent                 = entry

    local srcCorner = Instance.new("UICorner")
    srcCorner.CornerRadius = UDim.new(0, 4)
    srcCorner.Parent       = srcBadge

    -- File name
    local fileLbl = Instance.new("TextLabel")
    fileLbl.Size                   = UDim2.new(1, -16, 0, 14)
    fileLbl.Position               = UDim2.new(0, 10, 0, 27)
    fileLbl.BackgroundTransparency = 1
    fileLbl.Text                   = fname
    fileLbl.TextColor3             = Color3.fromRGB(220, 170, 75)
    fileLbl.TextSize               = 9
    fileLbl.Font                   = Enum.Font.GothamBold
    fileLbl.TextXAlignment         = Enum.TextXAlignment.Left
    fileLbl.TextTruncate           = Enum.TextTruncate.AtEnd
    fileLbl.Parent                 = entry

    -- Code preview bar
    local previewBar = Instance.new("Frame")
    previewBar.Size                   = UDim2.new(1, -16, 0, 22)
    previewBar.Position               = UDim2.new(0, 10, 0, 44)
    previewBar.BackgroundColor3       = Color3.fromRGB(18, 18, 24)
    previewBar.BackgroundTransparency = 0
    previewBar.BorderSizePixel        = 0
    previewBar.Parent                 = entry

    local pbCorner = Instance.new("UICorner")
    pbCorner.CornerRadius = UDim.new(0, 4)
    pbCorner.Parent       = previewBar

    local previewLbl = Instance.new("TextLabel")
    previewLbl.Size                   = UDim2.new(1, -10, 1, 0)
    previewLbl.Position               = UDim2.new(0, 6, 0, 0)
    previewLbl.BackgroundTransparency = 1
    previewLbl.Text                   = preview
    previewLbl.TextColor3             = Color3.fromRGB(144, 212, 144)
    previewLbl.TextSize               = 10
    previewLbl.Font                   = Enum.Font.Code
    previewLbl.TextXAlignment         = Enum.TextXAlignment.Left
    previewLbl.TextTruncate           = Enum.TextTruncate.AtEnd
    previewLbl.Parent                 = previewBar

    -- Action buttons
    local BW   = 82
    local BH   = 20
    local BGAP = 5

    local function mkBtn(label, xi, bg)
        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(0, BW, 0, BH)
        btn.Position               = UDim2.new(0, 10 + xi * (BW + BGAP), 0, 72)
        btn.BackgroundColor3       = bg
        btn.BackgroundTransparency = 0.05
        btn.BorderSizePixel        = 0
        btn.Text                   = label
        btn.TextColor3             = Color3.fromRGB(240, 240, 240)
        btn.TextSize               = 9
        btn.Font                   = Enum.Font.GothamBold
        btn.Parent                 = entry
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent       = btn
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.05}):Play()
        end)
        return btn
    end

    local editBtn   = mkBtn("Edit / View", 0, Color3.fromRGB(0,   88, 160))
    local copyBtn   = mkBtn("Copy Code",   1, Color3.fromRGB(0,  118,  52))
    local execBtn2  = mkBtn("Execute",     2, Color3.fromRGB(98,   0, 172))
    local deleteBtn = mkBtn("Delete",      3, Color3.fromRGB(155,  26,  26))

    local function flash(btn, orig)
        btn.Text = "Done"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = orig end
        end)
    end

    editBtn.MouseButton1Click:Connect(function()
        local liveCode2 = code
        pcall(function()
            local path = FOLDER .. "/" .. fname
            if isfile(path) then
                local raw = readFile(path)
                if raw and #raw > 0 then liveCode2 = raw end
            end
        end)
        openEditor({ index = idx, code = liveCode2, fileName = fname, time = ts })
    end)

    copyBtn.MouseButton1Click:Connect(function()
        pcall(setclipboard, code)
        flash(copyBtn, "Copy Code")
    end)

    execBtn2.MouseButton1Click:Connect(function()
        local fn, err = originalLoadstring(code)
        if fn then
            task.spawn(fn)
            notify("Alex JOK", "Executed script #" .. idx)
        else
            notify("Alex JOK", "Error: " .. tostring(err))
        end
        flash(execBtn2, "Execute")
    end)

    deleteBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local path = FOLDER .. "/" .. fname
            if isfile(path) then delfile(path) end
        end)
        TweenService:Create(entry, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
        task.delay(0.2, function()
            if entry and entry.Parent then entry:Destroy() end
            if listLayout then
                listScrollFrame.CanvasSize =
                    UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
            end
        end)
        notify("Alex JOK", "Deleted: " .. fname)
    end)

    listScrollFrame.CanvasSize =
        UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)

    TweenService:Create(entry, TweenInfo.new(0.22, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 0}):Play()
end

-- ═══════════════════════════════════════════════════════════════════
--  MULTI-HOOK INSTALLER
--  Covers: loadstring, load, game:HttpGet, request, http_request,
--          syn.request, fluxus/celery aliases, require (log only)
-- ═══════════════════════════════════════════════════════════════════

local function installHooks()
    -- Executor environment globals
    local genv = (getgenv and getgenv()) or _G

    -- Detect executor hook capabilities
    local canHookFunc = type(hookfunction) == "function"
    local canNewCC    = type(newcclosure)  == "function"

    -- Wrap a replacement in a newcclosure if possible (helps bypass read-only checks)
    local function wrap(fn)
        if canNewCC then
            return newcclosure(fn)
        end
        return fn
    end

    -- Try hookfunction first, fall back to global override
    local function applyHook(orig, replacement, globalKey)
        local wrapped = wrap(replacement)
        if canHookFunc and orig then
            local ok = pcall(hookfunction, orig, wrapped)
            if ok then return true end
        end
        -- Global override fallback
        if globalKey then
            local ok2 = pcall(function() genv[globalKey] = wrapped end)
            return ok2
        end
        return false
    end

    local hookResults = {}

    -- ── 1. loadstring ──────────────────────────────────────────────
    do
        local orig = genv.loadstring or loadstring
        originalLoadstring = orig   -- keep our reference current
        local replacement = function(code, chunkname)
            pcall(captureScript, code, "loadstring", chunkname)
            return orig(code, chunkname)
        end
        local ok = applyHook(orig, replacement, "loadstring")
        hookResults.loadstring = ok
    end

    -- ── 2. load  (may differ from loadstring on some executors) ────
    do
        local orig = genv.load
        if orig and orig ~= genv.loadstring then
            originalLoad = orig
            local replacement = function(code, chunkname, ...)
                if type(code) == "string" then
                    pcall(captureScript, code, "load", chunkname)
                end
                return orig(code, chunkname, ...)
            end
            local ok = applyHook(orig, replacement, "load")
            hookResults.load = ok
        end
    end

    -- ── 3. game:HttpGet ────────────────────────────────────────────
    --  We hook AFTER the download so we get the actual Lua source.
    do
        local origHG = game.HttpGet
        if origHG then
            local replacement = function(self, url, async)
                local result = origHG(self, url, async)
                if type(result) == "string" and isProbablyScript(result) then
                    pcall(captureScript, result, "HttpGet", url)
                end
                return result
            end
            local ok = pcall(function()
                if canHookFunc then
                    hookfunction(origHG, wrap(replacement))
                end
            end)
            -- Also patch via rawset on the instance as a fallback
            if not ok then
                pcall(function()
                    local mt = getrawmetatable and getrawmetatable(game)
                    if mt then
                        local oldIndex = mt.__index
                        setreadonly(mt, false)
                        mt.__index = wrap(function(self2, key)
                            if key == "HttpGet" then
                                return replacement
                            end
                            return oldIndex(self2, key)
                        end)
                        setreadonly(mt, true)
                    end
                end)
            end
            hookResults.HttpGet = ok
        end
    end

    -- ── 4. request  (Delta native + common aliases) ────────────────
    local requestAliases = { "request", "http_request", "https_request" }
    for _, name in ipairs(requestAliases) do
        local orig = genv[name]
        if type(orig) == "function" then
            local capName = name  -- closure copy
            local replacement = function(opts)
                local result = orig(opts)
                if type(result) == "table" then
                    local body = result.Body or result.body
                    if type(body) == "string" and isProbablyScript(body) then
                        local url = (type(opts) == "table" and (opts.Url or opts.url)) or capName
                        pcall(captureScript, body, capName, url)
                    end
                end
                return result
            end
            local ok = applyHook(orig, replacement, name)
            hookResults[name] = ok
        end
    end

    -- ── 5. syn.request  (Synapse / Delta compatibility layer) ──────
    pcall(function()
        if syn and type(syn.request) == "function" and canHookFunc and canNewCC then
            local orig = syn.request
            local replacement = newcclosure(function(opts)
                local result = orig(opts)
                if type(result) == "table" then
                    local body = result.Body or result.body
                    if type(body) == "string" and isProbablyScript(body) then
                        local url = (type(opts) == "table" and (opts.Url or opts.url)) or "syn.request"
                        pcall(captureScript, body, "syn.request", url)
                    end
                end
                return result
            end)
            hookfunction(orig, replacement)
            hookResults["syn.request"] = true
        end
    end)

    -- ── 6. require  (log module usage; source code not accessible) ─
    pcall(function()
        local orig = genv.require
        if type(orig) == "function" then
            local replacement = function(module)
                -- We can't extract Lua source from a ModuleScript,
                -- but we can log that it was required and optionally
                -- capture any string passed (rare pattern some loaders use).
                if type(module) == "string" and isProbablyScript(module) then
                    pcall(captureScript, module, "require", nil)
                end
                return orig(module)
            end
            -- Avoid hooking if it would break the game's require chain
            -- Only apply global override (hookfunction on require is risky)
            pcall(function() genv.require = wrap(replacement) end)
            hookResults.require = true
        end
    end)

    -- ── 7. fluxus / celery executor aliases ────────────────────────
    pcall(function()
        local extras = { "fluxus", "celery" }
        for _, ns in ipairs(extras) do
            local env = genv[ns]
            if type(env) == "table" and type(env.request) == "function" and canHookFunc and canNewCC then
                local orig = env.request
                local nsName = ns .. ".request"
                local replacement = newcclosure(function(opts)
                    local result = orig(opts)
                    if type(result) == "table" then
                        local body = result.Body or result.body
                        if type(body) == "string" and isProbablyScript(body) then
                            local url = (type(opts) == "table" and (opts.Url or opts.url)) or nsName
                            pcall(captureScript, body, nsName, url)
                        end
                    end
                    return result
                end)
                pcall(hookfunction, orig, replacement)
            end
        end
    end)

    -- ── Report ─────────────────────────────────────────────────────
    hookInstalled = hookResults.loadstring == true

    local activeMethods = {}
    for method, ok in pairs(hookResults) do
        if ok then table.insert(activeMethods, method) end
    end
    table.sort(activeMethods)

    task.delay(1, function()
        if hookInstalled then
            notify("Alex JOK",
                "Hooks active: " .. table.concat(activeMethods, ", "))
        else
            notify("Alex JOK",
                "loadstring hook blocked. Partial hooks: " ..
                table.concat(activeMethods, ", "))
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--  LOGGER UI  (unchanged)
-- ═══════════════════════════════════════════════════════════════════

local function buildLoggerUI(container)
    local topBar = Instance.new("Frame")
    topBar.Size                   = UDim2.new(1, 0, 0, 44)
    topBar.BackgroundColor3       = Color3.fromRGB(22, 22, 30)
    topBar.BackgroundTransparency = 0.1
    topBar.BorderSizePixel        = 0
    topBar.Parent                 = container

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent       = topBar

    local topPad = Instance.new("UIPadding")
    topPad.PaddingLeft = UDim.new(0, 12)
    topPad.PaddingTop  = UDim.new(0, 6)
    topPad.Parent      = topBar

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size                   = UDim2.new(0.65, 0, 0, 18)
    statusLabel.Position               = UDim2.new(0, 0, 0, 2)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text                   = "Waiting for scripts..."
    statusLabel.TextColor3             = Color3.fromRGB(255, 215, 55)
    statusLabel.TextSize               = 11
    statusLabel.Font                   = Enum.Font.GothamBold
    statusLabel.TextXAlignment         = Enum.TextXAlignment.Left
    statusLabel.Parent                 = topBar

    counterLabel = Instance.new("TextLabel")
    counterLabel.Size                   = UDim2.new(0.35, -12, 0, 14)
    counterLabel.Position               = UDim2.new(0.65, 0, 0, 6)
    counterLabel.BackgroundTransparency = 1
    counterLabel.Text                   = "Captured: 0"
    counterLabel.TextColor3             = Color3.fromRGB(145, 255, 158)
    counterLabel.TextSize               = 10
    counterLabel.Font                   = Enum.Font.Code
    counterLabel.TextXAlignment         = Enum.TextXAlignment.Right
    counterLabel.Parent                 = topBar

    local wrapper = Instance.new("Frame")
    wrapper.Size                   = UDim2.new(1, 0, 0, 345)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel        = 0
    wrapper.Parent                 = container

    listScrollFrame = Instance.new("ScrollingFrame")
    listScrollFrame.Size                       = UDim2.fromScale(1, 1)
    listScrollFrame.BackgroundColor3           = Color3.fromRGB(18, 18, 24)
    listScrollFrame.BackgroundTransparency     = 0.1
    listScrollFrame.BorderSizePixel            = 0
    listScrollFrame.ScrollBarThickness         = 5
    listScrollFrame.ScrollBarImageColor3       = Color3.fromRGB(0, 122, 204)
    listScrollFrame.ScrollBarImageTransparency = 0.3
    listScrollFrame.CanvasSize                 = UDim2.fromScale(0, 0)
    listScrollFrame.Parent                     = wrapper

    local sfCorner = Instance.new("UICorner")
    sfCorner.CornerRadius = UDim.new(0, 8)
    sfCorner.Parent       = listScrollFrame

    listLayout = Instance.new("UIListLayout")
    listLayout.Padding   = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent    = listScrollFrame

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0, 6)
    pad.PaddingRight  = UDim.new(0, 6)
    pad.PaddingTop    = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.Parent        = listScrollFrame
end

-- ═══════════════════════════════════════════════════════════════════
--  FLUENT WINDOW
-- ═══════════════════════════════════════════════════════════════════

local Window = Fluent:CreateWindow({
    Title       = "Alex JOK",
    SubTitle    = "FRontEVill was here | v7.0",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(660, 560),
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.B,
})

local Tabs = {
    Logger   = Window:AddTab({ Title = "Script Logger", Icon = "code-2"   }),
    Settings = Window:AddTab({ Title = "Settings",      Icon = "settings" }),
}

buildLoggerUI(Tabs.Logger.Container)

-- Install hooks after UI is ready (deferred so Fluent finishes first)
task.defer(installHooks)

-- ── Buttons ──────────────────────────────────────────────────────

Tabs.Logger:AddButton({
    Title       = "Clear Log",
    Description = "Remove all entries from the list",
    Callback    = function()
        for _, ch in pairs(listScrollFrame:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        capturedScripts = {}
        capturedCount   = 0
        seenHashes      = {}
        if counterLabel then counterLabel.Text = "Captured: 0" end
        if statusLabel then
            statusLabel.Text       = "Waiting for scripts..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 215, 55)
        end
        listScrollFrame.CanvasSize = UDim2.fromScale(0, 0)
        notify("Alex JOK", "Log cleared.")
    end,
})

Tabs.Logger:AddButton({
    Title       = "Delete All Files",
    Description = "Delete all saved script files from disk",
    Callback    = function()
        pcall(function()
            if isfolder(FOLDER) then
                for _, f in pairs(listfiles(FOLDER)) do
                    if isfile(f) then delfile(f) end
                end
            end
        end)
        notify("Alex JOK", "All files deleted.")
    end,
})

Tabs.Logger:AddButton({
    Title       = "Reinstall Hooks",
    Description = "Re-apply all hooks (use after other scripts may have overwritten them)",
    Callback    = function()
        pcall(installHooks)
        notify("Alex JOK", "Hooks reinstalled.")
    end,
})

-- ── Save / Interface managers ────────────────────────────────────

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("AlexJOKFluent")
SaveManager:SetFolder("AlexJOKFluent/config")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title    = "Alex JOK",
    Content  = "FRontEVill v7.0 loaded.  Press B to toggle.",
    Duration = 6,
})

SaveManager:LoadAutoloadConfig()
