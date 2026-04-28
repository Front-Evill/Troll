local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Alex JOK",
    SubTitle = "FrontEvill v5.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(660, 560),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.B
})

local Tabs = {
    Detector  = Window:AddTab({ Title = "Detector",   Icon = "scan-search" }),
    Animations = Window:AddTab({ Title = "Animations", Icon = "activity"    }),
    Log        = Window:AddTab({ Title = "IDs Log",    Icon = "file-text"   }),
    Settings   = Window:AddTab({ Title = "Settings",   Icon = "settings"    }),
}

local detectedAssets         = {}
local savedAssets             = {}
local assetCount              = 0
local isScanning              = false
local existingGUIs            = {}
local permanentlyDetectedAssets = {}

local assetTypes = {
    ["Sound"]       = { color = Color3.fromRGB(255, 150, 100), patterns = { "SoundId" } },
    ["Image/Decal"] = { color = Color3.fromRGB(100, 255, 150), patterns = { "Image", "Texture", "ImageRectOffset", "ImageRectSize" } },
    ["Animation"]   = { color = Color3.fromRGB(255, 100, 255), patterns = { "AnimationId" } },
    ["Mesh"]        = { color = Color3.fromRGB(100, 150, 255), patterns = { "MeshId", "TextureId" } },
    ["Skybox"]      = { color = Color3.fromRGB(255, 255, 100), patterns = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" } },
    ["Shirt/Pants"] = { color = Color3.fromRGB(150, 255, 255), patterns = { "ShirtTemplate", "PantsTemplate" } },
    ["Web Link"]    = { color = Color3.fromRGB(255, 200, 50),  patterns = {} },
    ["Other"]       = { color = Color3.fromRGB(200, 200, 200), patterns = {} },
}

local animationTypes = {
    ["fall"]  = { name = "Fall Animation",  color = Color3.fromRGB(255, 100, 100) },
    ["climb"] = { name = "Climb Animation", color = Color3.fromRGB(150, 100, 255) },
    ["jump"]  = { name = "Jump Animation",  color = Color3.fromRGB(100, 255, 100) },
    ["run"]   = { name = "Run Animation",   color = Color3.fromRGB(255, 200, 100) },
    ["walk"]  = { name = "Walk Animation",  color = Color3.fromRGB(100, 200, 255) },
    ["idle"]  = { name = "Idle Animation",  color = Color3.fromRGB(200, 200, 200) },
}

local assetPatterns = {
    "rbxassetid://([%d,]+)",
    "http://www%.roblox%.com/asset/%?id=([%d,]+)",
    "https://www%.roblox%.com/asset/%?id=([%d,]+)",
    "rbxasset://([%S]+)",
    "content://([%S]+)",
    "(https?://[%w%-%._~:/?#%[%]@!%$&'%(%)%*%+,;=]+)",
}

local function showRobloxNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = title,
            Text     = text,
            Duration = duration or 5,
        })
    end)
end

local function getAssetType(propertyName, value)
    if string.match(value, "^https?://") then
        return "Web Link", assetTypes["Web Link"].color
    end
    for typeName, typeData in pairs(assetTypes) do
        for _, pattern in pairs(typeData.patterns) do
            if string.find(propertyName, pattern) then
                return typeName, typeData.color
            end
        end
    end
    return "Other", assetTypes["Other"].color
end

local function getAnimationType(animationId, animType)
    if animType and animationTypes[animType] then
        return animationTypes[animType].name, animationTypes[animType].color
    end
    return "Custom Animation", Color3.fromRGB(255, 100, 255)
end

local function extractFullId(text)
    local patterns = {
        "rbxassetid://([%d,]+)",
        "http://www%.roblox%.com/asset/%?id=([%d,]+)",
        "https://www%.roblox%.com/asset/%?id=([%d,]+)",
    }
    for _, pattern in pairs(patterns) do
        local match = string.match(text, pattern)
        if match then return match end
    end
    return nil
end

local function extractAssets(text)
    local foundAssets = {}
    for _, pattern in pairs(assetPatterns) do
        for match in string.gmatch(text, pattern) do
            if match and match ~= "" then
                if string.match(pattern, "https") then
                    table.insert(foundAssets, match)
                else
                    local baseId = string.match(match, "(%d+)")
                    if baseId and not permanentlyDetectedAssets[baseId] then
                        table.insert(foundAssets, match)
                    end
                end
            end
        end
    end
    return foundAssets
end

local function getFullPath(obj)
    local path    = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path    = current.Name .. "." .. path
        current = current.Parent
    end
    return path
end

local function scanObjectForContent(obj)
    local foundAssets        = {}
    local propertiesToCheck  = {
        "Image", "Texture", "Decal", "SoundId", "MeshId", "TextureId",
        "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp",
        "ShirtTemplate", "PantsTemplate", "AnimationId", "Text", "Value",
    }
    for _, property in pairs(propertiesToCheck) do
        local success, value = pcall(function() return obj[property] end)
        if success and typeof(value) == "string" and value ~= "" then
            local assets = extractAssets(value)
            for _, asset in pairs(assets) do
                local assetType, typeColor = getAssetType(property, value)
                local fullPath = getFullPath(obj)
                table.insert(foundAssets, {
                    url          = asset,
                    propertyName = property,
                    objectName   = obj.Name,
                    fullPath     = fullPath,
                    assetType    = assetType,
                    typeColor    = typeColor,
                    originalText = value,
                })
            end
        end
    end
    return foundAssets
end

local statusLabel
local countLabel

local function buildStatusBar(container)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 50)
    bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bar.BackgroundTransparency = 0.4
    bar.BorderSizePixel = 0
    bar.Parent = container

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = bar

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft   = UDim.new(0, 10)
    padding.PaddingTop    = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent        = bar

    statusLabel = Instance.new("TextLabel")
    statusLabel.Size                = UDim2.new(1, -10, 0, 18)
    statusLabel.Position            = UDim2.new(0, 0, 0, 2)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text                = "Status: Waiting..."
    statusLabel.TextColor3          = Color3.fromRGB(255, 255, 100)
    statusLabel.TextSize            = 12
    statusLabel.Font                = Enum.Font.GothamBold
    statusLabel.TextXAlignment      = Enum.TextXAlignment.Left
    statusLabel.Parent              = bar

    countLabel = Instance.new("TextLabel")
    countLabel.Size                = UDim2.new(1, -10, 0, 16)
    countLabel.Position            = UDim2.new(0, 0, 0, 22)
    countLabel.BackgroundTransparency = 1
    countLabel.Text                = "Found: 0 assets"
    countLabel.TextColor3          = Color3.fromRGB(255, 255, 255)
    countLabel.TextSize            = 11
    countLabel.Font                = Enum.Font.Gotham
    countLabel.TextXAlignment      = Enum.TextXAlignment.Left
    countLabel.Parent              = bar
end

local assetScrollFrame
local assetListLayout

local function buildAssetList(container)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 320)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.Parent = container

    assetScrollFrame = Instance.new("ScrollingFrame")
    assetScrollFrame.Size                   = UDim2.fromScale(1, 1)
    assetScrollFrame.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
    assetScrollFrame.BackgroundTransparency = 0.5
    assetScrollFrame.BorderSizePixel        = 0
    assetScrollFrame.ScrollBarThickness     = 4
    assetScrollFrame.ScrollBarImageColor3   = Color3.fromRGB(255, 255, 255)
    assetScrollFrame.ScrollBarImageTransparency = 0.6
    assetScrollFrame.CanvasSize             = UDim2.fromScale(0, 0)
    assetScrollFrame.Parent                 = wrapper

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent       = assetScrollFrame

    assetListLayout = Instance.new("UIListLayout")
    assetListLayout.Padding   = UDim.new(0, 5)
    assetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    assetListLayout.Parent    = assetScrollFrame

    local innerPad = Instance.new("UIPadding")
    innerPad.PaddingLeft   = UDim.new(0, 5)
    innerPad.PaddingRight  = UDim.new(0, 5)
    innerPad.PaddingTop    = UDim.new(0, 5)
    innerPad.PaddingBottom = UDim.new(0, 5)
    innerPad.Parent        = assetScrollFrame
end

local idsLogScrollFrame
local idsLogListLayout

local function buildIdsLog(container)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 400)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.Parent = container

    idsLogScrollFrame = Instance.new("ScrollingFrame")
    idsLogScrollFrame.Size                   = UDim2.fromScale(1, 1)
    idsLogScrollFrame.BackgroundColor3       = Color3.fromRGB(20, 20, 20)
    idsLogScrollFrame.BackgroundTransparency = 0.5
    idsLogScrollFrame.BorderSizePixel        = 0
    idsLogScrollFrame.ScrollBarThickness     = 4
    idsLogScrollFrame.ScrollBarImageColor3   = Color3.fromRGB(255, 255, 255)
    idsLogScrollFrame.ScrollBarImageTransparency = 0.6
    idsLogScrollFrame.CanvasSize             = UDim2.fromScale(0, 0)
    idsLogScrollFrame.Parent                 = wrapper

    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent       = idsLogScrollFrame

    idsLogListLayout = Instance.new("UIListLayout")
    idsLogListLayout.Padding   = UDim.new(0, 4)
    idsLogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    idsLogListLayout.Parent    = idsLogScrollFrame

    local innerPad = Instance.new("UIPadding")
    innerPad.PaddingLeft   = UDim.new(0, 5)
    innerPad.PaddingRight  = UDim.new(0, 5)
    innerPad.PaddingTop    = UDim.new(0, 5)
    innerPad.PaddingBottom = UDim.new(0, 5)
    innerPad.Parent        = idsLogScrollFrame
end

local function updateAssetScrollSize()
    assetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, assetListLayout.AbsoluteContentSize.Y + 15)
end

local function createAssetEntry(assetUrl, propertyName, objectName, fullPath, assetType, typeColor, originalText, animationType)
    local entryFrame = Instance.new("Frame")
    entryFrame.Size                   = UDim2.new(1, -4, 0, 110)
    entryFrame.BackgroundColor3       = Color3.fromRGB(35, 35, 40)
    entryFrame.BackgroundTransparency = 0.15
    entryFrame.BorderSizePixel        = 0
    entryFrame.Parent                 = assetScrollFrame

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 8)
    entryCorner.Parent       = entryFrame

    entryFrame.BackgroundTransparency = 1
    TweenService:Create(entryFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { BackgroundTransparency = 0.15 }):Play()

    local highlight = Instance.new("Frame")
    highlight.Size            = UDim2.new(0, 4, 1, 0)
    highlight.BackgroundColor3 = typeColor
    highlight.BorderSizePixel = 0
    highlight.Parent          = entryFrame

    local hlCorner = Instance.new("UICorner")
    hlCorner.CornerRadius = UDim.new(0, 8)
    hlCorner.Parent       = highlight

    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size                   = UDim2.new(0, 120, 0, 20)
    typeLabel.Position               = UDim2.new(0, 10, 0, 6)
    typeLabel.BackgroundColor3       = typeColor
    typeLabel.BackgroundTransparency = 0.25
    typeLabel.BorderSizePixel        = 0
    typeLabel.Text                   = animationType or assetType
    typeLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
    typeLabel.TextSize               = 10
    typeLabel.Font                   = Enum.Font.GothamBold
    typeLabel.Parent                 = entryFrame

    local typeLabelCorner = Instance.new("UICorner")
    typeLabelCorner.CornerRadius = UDim.new(0, 4)
    typeLabelCorner.Parent       = typeLabel

    local urlLabel = Instance.new("TextLabel")
    urlLabel.Size                = UDim2.new(1, -200, 0, 16)
    urlLabel.Position            = UDim2.new(0, 10, 0, 30)
    urlLabel.BackgroundTransparency = 1
    urlLabel.Text                = "ID: " .. assetUrl
    urlLabel.TextColor3          = Color3.fromRGB(255, 255, 255)
    urlLabel.TextSize            = 10
    urlLabel.Font                = Enum.Font.GothamBold
    urlLabel.TextXAlignment      = Enum.TextXAlignment.Left
    urlLabel.TextTruncate        = Enum.TextTruncate.AtEnd
    urlLabel.Parent              = entryFrame

    local objectLabel = Instance.new("TextLabel")
    objectLabel.Size             = UDim2.new(1, -200, 0, 14)
    objectLabel.Position         = UDim2.new(0, 10, 0, 48)
    objectLabel.BackgroundTransparency = 1
    objectLabel.Text             = "Object: " .. objectName
    objectLabel.TextColor3       = Color3.fromRGB(180, 180, 255)
    objectLabel.TextSize         = 9
    objectLabel.Font             = Enum.Font.Gotham
    objectLabel.TextXAlignment   = Enum.TextXAlignment.Left
    objectLabel.TextTruncate     = Enum.TextTruncate.AtEnd
    objectLabel.Parent           = entryFrame

    local propLabel = Instance.new("TextLabel")
    propLabel.Size               = UDim2.new(1, -200, 0, 14)
    propLabel.Position           = UDim2.new(0, 10, 0, 64)
    propLabel.BackgroundTransparency = 1
    propLabel.Text               = "Property: " .. propertyName
    propLabel.TextColor3         = Color3.fromRGB(255, 255, 150)
    propLabel.TextSize           = 9
    propLabel.Font               = Enum.Font.Gotham
    propLabel.TextXAlignment     = Enum.TextXAlignment.Left
    propLabel.TextTruncate       = Enum.TextTruncate.AtEnd
    propLabel.Parent             = entryFrame

    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size               = UDim2.new(1, -200, 0, 14)
    timeLabel.Position           = UDim2.new(0, 10, 0, 80)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text               = "Found: " .. os.date("%H:%M:%S")
    timeLabel.TextColor3         = Color3.fromRGB(100, 255, 100)
    timeLabel.TextSize           = 8
    timeLabel.Font               = Enum.Font.Gotham
    timeLabel.TextXAlignment     = Enum.TextXAlignment.Left
    timeLabel.Parent             = entryFrame

    local bw, bh, bs = 55, 20, 5

    local function makeEntryBtn(label, xOffset, yOffset)
        local btn = Instance.new("TextButton")
        btn.Size                   = UDim2.new(0, bw, 0, bh)
        btn.Position               = UDim2.new(1, xOffset, 0, yOffset)
        btn.BackgroundColor3       = Color3.fromRGB(50, 50, 55)
        btn.BackgroundTransparency = 0.1
        btn.BorderSizePixel        = 0
        btn.Text                   = label
        btn.TextColor3             = Color3.fromRGB(255, 255, 255)
        btn.TextSize               = 9
        btn.Font                   = Enum.Font.GothamBold
        btn.Parent                 = entryFrame
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent       = btn
        return btn
    end

    local copyIdBtn    = makeEntryBtn("Copy ID", -(bw * 2 + bs + 8), 8)
    local copyFullBtn  = makeEntryBtn("Full ID",  -(bw       + 8),     8)
    local copyLineBtn  = makeEntryBtn("Line",     -(bw * 2 + bs + 8), 32)
    local copyPathBtn  = makeEntryBtn("Path",     -(bw       + 8),     32)

    local function flashDone(btn, original)
        btn.Text = "Done"
        btn.BackgroundTransparency = 0.45
        task.delay(1.5, function()
            if btn and btn.Parent then
                btn.Text = original
                btn.BackgroundTransparency = 0.1
            end
        end)
    end

    copyIdBtn.MouseButton1Click:Connect(function()
        setclipboard(string.match(assetUrl, "(%d+)") or assetUrl)
        flashDone(copyIdBtn, "Copy ID")
    end)
    copyFullBtn.MouseButton1Click:Connect(function()
        setclipboard(extractFullId(originalText) or assetUrl)
        flashDone(copyFullBtn, "Full ID")
    end)
    copyLineBtn.MouseButton1Click:Connect(function()
        setclipboard(originalText)
        flashDone(copyLineBtn, "Line")
    end)
    copyPathBtn.MouseButton1Click:Connect(function()
        setclipboard(fullPath)
        flashDone(copyPathBtn, "Path")
    end)

    return entryFrame
end

local function addIdsLogEntry(assetUrl, assetType, objectName, propertyName, fullPath, animationType, timestamp)
    local count = #idsLogScrollFrame:GetChildren() - 1

    local row = Instance.new("Frame")
    row.Size                   = UDim2.new(1, -4, 0, 72)
    row.BackgroundColor3       = Color3.fromRGB(35, 35, 40)
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel        = 0
    row.LayoutOrder            = count + 1
    row.Parent                 = idsLogScrollFrame

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent       = row

    local indexLbl = Instance.new("TextLabel")
    indexLbl.Size                = UDim2.new(0, 30, 0, 16)
    indexLbl.Position            = UDim2.new(0, 6, 0, 5)
    indexLbl.BackgroundTransparency = 1
    indexLbl.Text                = "#" .. tostring(count + 1)
    indexLbl.TextColor3          = Color3.fromRGB(180, 180, 180)
    indexLbl.TextSize            = 9
    indexLbl.Font                = Enum.Font.GothamBold
    indexLbl.TextXAlignment      = Enum.TextXAlignment.Left
    indexLbl.Parent              = row

    local typeTag = Instance.new("TextLabel")
    typeTag.Size                   = UDim2.new(0, 110, 0, 16)
    typeTag.Position               = UDim2.new(0, 40, 0, 5)
    typeTag.BackgroundColor3       = Color3.fromRGB(50, 50, 55)
    typeTag.BackgroundTransparency = 0.1
    typeTag.BorderSizePixel        = 0
    typeTag.Text                   = animationType or assetType
    typeTag.TextColor3             = Color3.fromRGB(255, 255, 255)
    typeTag.TextSize               = 9
    typeTag.Font                   = Enum.Font.GothamBold
    typeTag.Parent                 = row

    local typeTagCorner = Instance.new("UICorner")
    typeTagCorner.CornerRadius = UDim.new(0, 4)
    typeTagCorner.Parent       = typeTag

    local timeLbl = Instance.new("TextLabel")
    timeLbl.Size                = UDim2.new(0, 80, 0, 16)
    timeLbl.Position            = UDim2.new(1, -86, 0, 5)
    timeLbl.BackgroundTransparency = 1
    timeLbl.Text                = timestamp
    timeLbl.TextColor3          = Color3.fromRGB(100, 255, 100)
    timeLbl.TextSize            = 8
    timeLbl.Font                = Enum.Font.Gotham
    timeLbl.Parent              = row

    local idRow = Instance.new("TextLabel")
    idRow.Size              = UDim2.new(1, -60, 0, 14)
    idRow.Position          = UDim2.new(0, 6, 0, 26)
    idRow.BackgroundTransparency = 1
    idRow.Text              = "ID: " .. assetUrl
    idRow.TextColor3        = Color3.fromRGB(255, 255, 255)
    idRow.TextSize          = 9
    idRow.Font              = Enum.Font.GothamBold
    idRow.TextXAlignment    = Enum.TextXAlignment.Left
    idRow.TextTruncate      = Enum.TextTruncate.AtEnd
    idRow.Parent            = row

    local objRow = Instance.new("TextLabel")
    objRow.Size             = UDim2.new(1, -12, 0, 12)
    objRow.Position         = UDim2.new(0, 6, 0, 43)
    objRow.BackgroundTransparency = 1
    objRow.Text             = "Object: " .. objectName .. "  |  Property: " .. propertyName
    objRow.TextColor3       = Color3.fromRGB(180, 180, 255)
    objRow.TextSize         = 8
    objRow.Font             = Enum.Font.Gotham
    objRow.TextXAlignment   = Enum.TextXAlignment.Left
    objRow.TextTruncate     = Enum.TextTruncate.AtEnd
    objRow.Parent           = row

    local pathRow = Instance.new("TextLabel")
    pathRow.Size            = UDim2.new(1, -12, 0, 12)
    pathRow.Position        = UDim2.new(0, 6, 0, 57)
    pathRow.BackgroundTransparency = 1
    pathRow.Text            = "Path: " .. fullPath
    pathRow.TextColor3      = Color3.fromRGB(150, 150, 150)
    pathRow.TextSize        = 8
    pathRow.Font            = Enum.Font.Gotham
    pathRow.TextXAlignment  = Enum.TextXAlignment.Left
    pathRow.TextTruncate    = Enum.TextTruncate.AtEnd
    pathRow.Parent          = row

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size                   = UDim2.new(0, 44, 0, 16)
    copyBtn.Position               = UDim2.new(1, -50, 0, 26)
    copyBtn.BackgroundColor3       = Color3.fromRGB(50, 50, 55)
    copyBtn.BackgroundTransparency = 0.1
    copyBtn.BorderSizePixel        = 0
    copyBtn.Text                   = "Copy"
    copyBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize               = 8
    copyBtn.Font                   = Enum.Font.GothamBold
    copyBtn.Parent                 = row

    local copyBtnCorner = Instance.new("UICorner")
    copyBtnCorner.CornerRadius = UDim.new(0, 4)
    copyBtnCorner.Parent       = copyBtn

    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(string.match(assetUrl, "(%d+)") or assetUrl)
        copyBtn.Text = "Done"
        task.delay(1.5, function()
            if copyBtn and copyBtn.Parent then
                copyBtn.Text = "Copy"
            end
        end)
    end)

    idsLogScrollFrame.CanvasSize = UDim2.new(0, 0, 0, idsLogListLayout.AbsoluteContentSize.Y + 10)
end

local function saveAssetToFile(assetData)
    local fileName = "AlexJOK_FrontEvill_Assets.lua"
    local assetInfo = {
        id            = assetData.url,
        type          = assetData.assetType,
        object        = assetData.objectName,
        property      = assetData.propertyName,
        path          = assetData.fullPath,
        originalText  = assetData.originalText,
        timestamp     = os.date("%Y-%m-%d %H:%M:%S"),
        animationType = assetData.animationType or nil,
    }
    table.insert(savedAssets, assetInfo)

    local content = "local detectedAssets = {\n"
    for i, asset in pairs(savedAssets) do
        content = content .. "    [" .. i .. "] = {\n"
        content = content .. "        id = \"" .. asset.id .. "\",\n"
        content = content .. "        type = \"" .. asset.type .. "\",\n"
        content = content .. "        object = \"" .. asset.object .. "\",\n"
        content = content .. "        property = \"" .. asset.property .. "\",\n"
        content = content .. "        path = \"" .. asset.path .. "\",\n"
        content = content .. "        originalText = \"" .. asset.originalText .. "\",\n"
        if asset.animationType then
            content = content .. "        animationType = \"" .. asset.animationType .. "\",\n"
        end
        content = content .. "        timestamp = \"" .. asset.timestamp .. "\"\n"
        content = content .. "    }"
        if i < #savedAssets then content = content .. "," end
        content = content .. "\n"
    end
    content = content .. "}\n\nreturn detectedAssets"
    writefile(fileName, content)
end

local function addAsset(assetData)
    local identifier = assetData.url
    if assetData.assetType ~= "Web Link" then
        local baseId = string.match(assetData.url, "(%d+)")
        if baseId then identifier = baseId end
    end
    if identifier and not permanentlyDetectedAssets[identifier] and isScanning then
        permanentlyDetectedAssets[identifier] = true
        detectedAssets[identifier]            = true
        assetCount                            = assetCount + 1
        if countLabel then
            countLabel.Text = "Found: " .. assetCount .. " assets"
        end

        createAssetEntry(
            assetData.url,
            assetData.propertyName,
            assetData.objectName,
            assetData.fullPath,
            assetData.assetType,
            assetData.typeColor,
            assetData.originalText,
            assetData.animationType
        )

        local ts = os.date("%H:%M:%S")
        addIdsLogEntry(
            assetData.url,
            assetData.assetType,
            assetData.objectName,
            assetData.propertyName,
            assetData.fullPath,
            assetData.animationType,
            ts
        )

        saveAssetToFile(assetData)
        updateAssetScrollSize()

        local notifType = assetData.animationType or assetData.assetType
        showRobloxNotification("Alex JOK Detector", "New " .. notifType .. " detected from " .. assetData.objectName)
    end
end

local function monitorPlayerAnimations()
    local animationPaths = {
        "fall.FallAnim",
        "climb.ClimbAnim",
        "jump.JumpAnim",
        "run.RunAnim",
        "walk.WalkAnim",
        "idle.Animation1",
        "idle.Animation2",
    }
    task.spawn(function()
        while isScanning do
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer.Character then
                    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        local animate = targetPlayer.Character:FindFirstChild("Animate")
                        if animate then
                            for _, path in pairs(animationPaths) do
                                local pathParts = string.split(path, ".")
                                local current   = animate
                                local animType  = pathParts[1]
                                for _, part in pairs(pathParts) do
                                    if current then current = current:FindFirstChild(part) end
                                end
                                if current and current:IsA("Animation") then
                                    local animId = current.AnimationId
                                    if animId and animId ~= "" then
                                        local baseId = string.match(animId, "(%d+)")
                                        if baseId and not permanentlyDetectedAssets[baseId] then
                                            for _, asset in pairs(extractAssets(animId)) do
                                                local animName, animColor = getAnimationType(animId, animType)
                                                addAsset({
                                                    url          = asset,
                                                    propertyName = "AnimationId",
                                                    objectName   = targetPlayer.Name .. "_" .. animType,
                                                    fullPath     = "Players." .. targetPlayer.Name .. ".Character.Animate." .. path,
                                                    assetType    = "Animation",
                                                    typeColor    = animColor,
                                                    originalText = animId,
                                                    animationType = animName,
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

local function savePlayerAnimationsToFolder(personName, playerAnimations)
    local folderName = "ANimations Id"

    if not isfolder(folderName) then
        makefolder(folderName)
    end

    local fileName = folderName .. "/" .. personName .. ".lua"

    local existingIds = {}
    if isfile(fileName) then
        local raw = readfile(fileName)
        for key, id in string.gmatch(raw, "(%w+)%s*=%s*{[^}]*id%s*=%s*\"(%d+)\"") do
            existingIds[key] = id
        end
    end

    local hasChanges = not isfile(fileName)
    if not hasChanges then
        for animKey, animData in pairs(playerAnimations) do
            if existingIds[animKey] ~= animData.id then
                hasChanges = true
                break
            end
        end
    end

    if not hasChanges then
        showRobloxNotification("ANimations Id", personName .. " - IDs unchanged, skipped")
        return
    end

    local lines = {}
    table.insert(lines, "return {")
    table.insert(lines, "    playerName = \"" .. personName .. "\",")
    table.insert(lines, "    savedAt = \"" .. os.date("%Y-%m-%d %H:%M:%S") .. "\",")
    table.insert(lines, "    animations = {")
    for animKey, animData in pairs(playerAnimations) do
        if animData.id then
            table.insert(lines, "        " .. animKey .. " = {")
            table.insert(lines, "            id = \"" .. animData.id .. "\",")
            table.insert(lines, "            name = \"" .. (animData.name or animKey) .. "\",")
            table.insert(lines, "            fullId = \"" .. (animData.fullId or "") .. "\",")
            table.insert(lines, "            savedAt = \"" .. os.date("%Y-%m-%d %H:%M:%S") .. "\"")
            table.insert(lines, "        },")
        end
    end
    table.insert(lines, "    }")
    table.insert(lines, "}")

    writefile(fileName, table.concat(lines, "\n"))
    showRobloxNotification("ANimations Id", "Saved " .. personName .. " -> ANimations Id/" .. personName .. ".lua")
end

local function createControlTool()
    for _, P in ipairs(player.Backpack:GetChildren()) do
        if P.Name == "ClickTarget" then P:Destroy() end
    end
    if player.Character then
        for _, P in ipairs(player.Character:GetChildren()) do
            if P.Name == "ClickTarget" then P:Destroy() end
        end
    end

    local GetTargetTool         = Instance.new("Tool")
    GetTargetTool.Name          = "ClickTarget"
    GetTargetTool.RequiresHandle = false
    GetTargetTool.TextureId     = "rbxassetid://13769558274"
    GetTargetTool.ToolTip       = "Choose Player for Animation Download"

    local animationPaths = {
        fall  = "fall.FallAnim",
        climb = "climb.ClimbAnim",
        jump  = "jump.JumpAnim",
        run   = "run.RunAnim",
        walk  = "walk.WalkAnim",
        idle1 = "idle.Animation1",
        idle2 = "idle.Animation2",
    }

    local function ActivateTool()
        local Hit    = player:GetMouse().Target
        local Person = nil
        if Hit and Hit.Parent then
            if Hit.Parent:IsA("Model") then
                Person = Players:GetPlayerFromCharacter(Hit.Parent)
            elseif Hit.Parent:IsA("Accessory") then
                Person = Players:GetPlayerFromCharacter(Hit.Parent.Parent)
            end
            if Person and Person ~= player then
                local playerAnimations = {}
                if Person.Character then
                    local animate = Person.Character:FindFirstChild("Animate")
                    if animate then
                        for animKey, path in pairs(animationPaths) do
                            local pathParts = string.split(path, ".")
                            local current   = animate
                            for _, part in pairs(pathParts) do
                                if current then current = current:FindFirstChild(part) end
                            end
                            if current and current:IsA("Animation") then
                                local animId = current.AnimationId
                                if animId and animId ~= "" then
                                    local baseId = string.match(animId, "(%d+)")
                                    if baseId then
                                        local animType = string.split(path, ".")[1]
                                        local animName, _ = getAnimationType(animId, animType)
                                        playerAnimations[animKey] = {
                                            id     = baseId,
                                            name   = animName,
                                            fullId = animId,
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
                if next(playerAnimations) then
                    savePlayerAnimationsToFolder(Person.Name, playerAnimations)
                else
                    showRobloxNotification("Player Target", "No animations found for " .. Person.Name)
                end
            elseif Person == player then
                showRobloxNotification("Player Target", "Cannot target yourself!")
            end
        end
    end

    GetTargetTool.Activated:Connect(ActivateTool)
    GetTargetTool.Parent = player.Backpack
end

local function clearAllAssets()
    for _, child in pairs(assetScrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    detectedAssets = {}
    assetCount     = 0
    if countLabel then countLabel.Text = "Found: 0 assets" end
    assetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function saveAllAssets()
    if #savedAssets > 0 then
        local fileName = "AlexJOK_FrontEvill_Assets.lua"
        local content  = "local detectedAssets = {\n"
        for i, asset in pairs(savedAssets) do
            content = content .. "    [" .. i .. "] = {\n"
            content = content .. "        id = \"" .. asset.id .. "\",\n"
            content = content .. "        type = \"" .. asset.type .. "\",\n"
            content = content .. "        object = \"" .. asset.object .. "\",\n"
            content = content .. "        property = \"" .. asset.property .. "\",\n"
            content = content .. "        path = \"" .. asset.path .. "\",\n"
            content = content .. "        originalText = \"" .. asset.originalText .. "\",\n"
            if asset.animationType then
                content = content .. "        animationType = \"" .. asset.animationType .. "\",\n"
            end
            content = content .. "        timestamp = \"" .. asset.timestamp .. "\"\n"
            content = content .. "    }"
            if i < #savedAssets then content = content .. "," end
            content = content .. "\n"
        end
        content = content .. "}\n\nreturn detectedAssets"
        writefile(fileName, content)
        showRobloxNotification("Alex JOK", "Assets saved to " .. fileName)
    end
end

local function deleteAllFiles()
    savedAssets = {}
    local fileName = "AlexJOK_FrontEvill_Assets.lua"
    if isfile(fileName) then delfile(fileName) end
    showRobloxNotification("Alex JOK", "All asset files deleted.")
end

local function registerExistingGUIs()
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            existingGUIs[gui] = true
        end
    end
end

local function onGuiAdded(gui)
    if gui:IsA("ScreenGui") or gui:IsA("GuiBase") then
        if existingGUIs[gui] then return end
        task.spawn(function()
            task.wait(0.5)
            local function scanNewGui(obj)
                if not isScanning then return end
                for _, asset in pairs(scanObjectForContent(obj)) do
                    addAsset(asset)
                end
                for _, child in pairs(obj:GetChildren()) do
                    if child then scanNewGui(child) end
                end
            end
            scanNewGui(gui)
            gui.DescendantAdded:Connect(function(descendant)
                if isScanning then
                    for _, asset in pairs(scanObjectForContent(descendant)) do
                        addAsset(asset)
                    end
                end
            end)
        end)
    end
end

buildStatusBar(Tabs.Detector.Container)
buildAssetList(Tabs.Detector.Container)

Tabs.Detector:AddButton({
    Title       = "Clear Screen",
    Description = "Remove all detected assets from the list",
    Callback    = clearAllAssets,
})

Tabs.Detector:AddButton({
    Title       = "Save File",
    Description = "Save all detected assets to AlexJOK_FrontEvill_Assets.lua",
    Callback    = saveAllAssets,
})

Tabs.Detector:AddButton({
    Title       = "Delete All IDs (File)",
    Description = "Delete the saved assets file from disk",
    Callback    = deleteAllFiles,
})

Tabs.Animations:AddParagraph({
    Title   = "Targeting Player",
    Content = "Press the button below to equip the targeting tool.\nClick on any player to save their animation IDs to:\n ANimations Id/<PlayerName>.lua\nFiles are created per player and only updated when IDs change.",
})

Tabs.Animations:AddButton({
    Title       = "Equip Targeting Tool",
    Description = "Gives you a tool - click a player to download their animations",
    Callback    = createControlTool,
})

buildIdsLog(Tabs.Log.Container)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("AlexJOKFluent")
SaveManager:SetFolder("AlexJOKFluent/config")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

task.spawn(function()
    if statusLabel then
        statusLabel.Text      = "Status: Waiting 2 seconds..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
    task.wait(2)
    isScanning = true
    if statusLabel then
        statusLabel.Text       = "Status: Active - Monitoring All Player Animations"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    monitorPlayerAnimations()
    Fluent:Notify({
        Title   = "Alex JOK",
        Content = "Detector started! Press B to hide/show.",
        Duration = 6,
    })
end)

registerExistingGUIs()
playerGui.ChildAdded:Connect(onGuiAdded)

if CoreGui then
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            existingGUIs[gui] = true end
    end
    CoreGui.ChildAdded:Connect(onGuiAdded)
end

SaveManager:LoadAutoloadConfig()
