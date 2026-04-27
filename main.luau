local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AlexJOKDetector"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local notificationSound = Instance.new("Sound")
notificationSound.SoundId = "rbxassetid://3398620867"
notificationSound.Volume = 0.5
notificationSound.Parent = SoundService

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 620)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = screenGui
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = mainFrame.Position
shadow.Size = mainFrame.Size + UDim2.new(0, 20, 0, 20)
shadow.Image = "rbxasset://textures/ui/Controls/DropShadow/DropShadow.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.3
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(12, 12, 256 - 12, 256 - 12)
shadow.ZIndex = mainFrame.ZIndex - 1

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, -20, 0, 2)
titleLine.Position = UDim2.new(0, 10, 1, -2)
titleLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLine.BackgroundTransparency = 0.5
titleLine.BorderSizePixel = 0
titleLine.Parent = titleBar

local lineCorner = Instance.new("UICorner")
lineCorner.CornerRadius = UDim.new(0, 1)
lineCorner.Parent = titleLine

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 35, 0, 35)
logoFrame.Position = UDim2.new(0, 8, 0, 5)
logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logoFrame.BackgroundTransparency = 0.2
logoFrame.BorderSizePixel = 0
logoFrame.Parent = titleBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logoFrame

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.Position = UDim2.new(0, 0, 0, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "AJ"
logoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
logoIcon.TextSize = 14
logoIcon.Font = Enum.Font.GothamBold
logoIcon.Parent = logoFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -250, 1, 0)
titleLabel.Position = UDim2.new(0, 50, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Alex JOK - FrontEvill  v5.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 35, 0, 35)
hideButton.Position = UDim2.new(1, -80, 0, 5)
hideButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hideButton.BackgroundTransparency = 0.2
hideButton.BorderSizePixel = 0
hideButton.Text = "-"
hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideButton.TextSize = 18
hideButton.Font = Enum.Font.GothamBold
hideButton.Parent = titleBar

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local assetsFrame = Instance.new("Frame")
assetsFrame.Size = UDim2.new(1, -20, 1, -55)
assetsFrame.Position = UDim2.new(0, 10, 0, 45)
assetsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
assetsFrame.BackgroundTransparency = 0.2
assetsFrame.BorderSizePixel = 0
assetsFrame.Parent = mainFrame

local assetsCorner = Instance.new("UICorner")
assetsCorner.CornerRadius = UDim.new(0, 10)
assetsCorner.Parent = assetsFrame

local assetsTitle = Instance.new("TextLabel")
assetsTitle.Size = UDim2.new(1, 0, 0, 30)
assetsTitle.Position = UDim2.new(0, 0, 0, 0)
assetsTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
assetsTitle.BackgroundTransparency = 0.2
assetsTitle.BorderSizePixel = 0
assetsTitle.Text = "ASSETS DETECTOR"
assetsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
assetsTitle.TextSize = 14
assetsTitle.Font = Enum.Font.GothamBold
assetsTitle.Parent = assetsFrame

local assetsTitleCorner = Instance.new("UICorner")
assetsTitleCorner.CornerRadius = UDim.new(0, 10)
assetsTitleCorner.Parent = assetsTitle

local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 50)
statsFrame.Position = UDim2.new(0, 10, 0, 35)
statsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = assetsFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Active - Monitoring New Assets"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statsFrame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -10, 0, 20)
countLabel.Position = UDim2.new(0, 5, 0, 25)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Found: 0 assets"
countLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
countLabel.TextSize = 11
countLabel.Font = Enum.Font.Gotham
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = statsFrame

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 70)
buttonFrame.Position = UDim2.new(0, 10, 0, 90)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = assetsFrame

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0, 100, 0, 30)
clearButton.Position = UDim2.new(0, 0, 0, 0)
clearButton.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
clearButton.BackgroundTransparency = 0.2
clearButton.BorderSizePixel = 0
clearButton.Text = "Clear Screen"
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.TextSize = 11
clearButton.Font = Enum.Font.GothamBold
clearButton.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 8)
clearCorner.Parent = clearButton

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 100, 0, 30)
saveButton.Position = UDim2.new(0, 110, 0, 0)
saveButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
saveButton.BackgroundTransparency = 0.2
saveButton.BorderSizePixel = 0
saveButton.Text = "Save File"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextSize = 11
saveButton.Font = Enum.Font.GothamBold
saveButton.Parent = buttonFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveButton

local deleteFileButton = Instance.new("TextButton")
deleteFileButton.Size = UDim2.new(0, 120, 0, 30)
deleteFileButton.Position = UDim2.new(0, 220, 0, 0)
deleteFileButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
deleteFileButton.BackgroundTransparency = 0.2
deleteFileButton.BorderSizePixel = 0
deleteFileButton.Text = "Delete All ID (File)"
deleteFileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteFileButton.TextSize = 11
deleteFileButton.Font = Enum.Font.GothamBold
deleteFileButton.Parent = buttonFrame

local deleteFileCorner = Instance.new("UICorner")
deleteFileCorner.CornerRadius = UDim.new(0, 8)
deleteFileCorner.Parent = deleteFileButton

local controlToolButton = Instance.new("TextButton")
controlToolButton.Size = UDim2.new(0, 130, 0, 30)
controlToolButton.Position = UDim2.new(0, 350, 0, 0)
controlToolButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
controlToolButton.BackgroundTransparency = 0.2
controlToolButton.BorderSizePixel = 0
controlToolButton.Text = "Targeting Player"
controlToolButton.TextColor3 = Color3.fromRGB(255, 255, 255)
controlToolButton.TextSize = 11
controlToolButton.Font = Enum.Font.GothamBold
controlToolButton.Parent = buttonFrame

local controlToolCorner = Instance.new("UICorner")
controlToolCorner.CornerRadius = UDim.new(0, 8)
controlToolCorner.Parent = controlToolButton

local idsLogButton = Instance.new("TextButton")
idsLogButton.Size = UDim2.new(0, 80, 0, 30)
idsLogButton.Position = UDim2.new(0, 490, 0, 0)
idsLogButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
idsLogButton.BackgroundTransparency = 0.2
idsLogButton.BorderSizePixel = 0
idsLogButton.Text = "IDs Log"
idsLogButton.TextColor3 = Color3.fromRGB(255, 255, 255)
idsLogButton.TextSize = 11
idsLogButton.Font = Enum.Font.GothamBold
idsLogButton.Parent = buttonFrame

local idsLogCorner = Instance.new("UICorner")
idsLogCorner.CornerRadius = UDim.new(0, 8)
idsLogCorner.Parent = idsLogButton

local idsLogPanel = Instance.new("Frame")
idsLogPanel.Size = UDim2.new(0, 500, 0, 520)
idsLogPanel.Position = UDim2.new(0.5, -250, 0.5, -260)
idsLogPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
idsLogPanel.BackgroundTransparency = 0.2
idsLogPanel.BorderSizePixel = 0
idsLogPanel.Visible = false
idsLogPanel.ZIndex = 10
idsLogPanel.Parent = screenGui

local idsLogPanelCorner = Instance.new("UICorner")
idsLogPanelCorner.CornerRadius = UDim.new(0, 12)
idsLogPanelCorner.Parent = idsLogPanel

local idsLogTitleBar = Instance.new("Frame")
idsLogTitleBar.Size = UDim2.new(1, 0, 0, 40)
idsLogTitleBar.Position = UDim2.new(0, 0, 0, 0)
idsLogTitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
idsLogTitleBar.BackgroundTransparency = 0.2
idsLogTitleBar.BorderSizePixel = 0
idsLogTitleBar.ZIndex = 10
idsLogTitleBar.Parent = idsLogPanel

local idsLogTitleBarCorner = Instance.new("UICorner")
idsLogTitleBarCorner.CornerRadius = UDim.new(0, 12)
idsLogTitleBarCorner.Parent = idsLogTitleBar

local idsLogTitle = Instance.new("TextLabel")
idsLogTitle.Size = UDim2.new(1, -60, 1, 0)
idsLogTitle.Position = UDim2.new(0, 12, 0, 0)
idsLogTitle.BackgroundTransparency = 1
idsLogTitle.Text = "Detected IDs Log - Alex JOK"
idsLogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
idsLogTitle.TextSize = 14
idsLogTitle.Font = Enum.Font.GothamBold
idsLogTitle.TextXAlignment = Enum.TextXAlignment.Left
idsLogTitle.ZIndex = 10
idsLogTitle.Parent = idsLogTitleBar

local idsLogCloseBtn = Instance.new("TextButton")
idsLogCloseBtn.Size = UDim2.new(0, 30, 0, 30)
idsLogCloseBtn.Position = UDim2.new(1, -38, 0, 5)
idsLogCloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
idsLogCloseBtn.BackgroundTransparency = 0.2
idsLogCloseBtn.BorderSizePixel = 0
idsLogCloseBtn.Text = "X"
idsLogCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
idsLogCloseBtn.TextSize = 14
idsLogCloseBtn.Font = Enum.Font.GothamBold
idsLogCloseBtn.ZIndex = 10
idsLogCloseBtn.Parent = idsLogTitleBar

local idsLogCloseBtnCorner = Instance.new("UICorner")
idsLogCloseBtnCorner.CornerRadius = UDim.new(0, 6)
idsLogCloseBtnCorner.Parent = idsLogCloseBtn

local idsLogDivider = Instance.new("Frame")
idsLogDivider.Size = UDim2.new(1, -20, 0, 1)
idsLogDivider.Position = UDim2.new(0, 10, 0, 41)
idsLogDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
idsLogDivider.BackgroundTransparency = 0.7
idsLogDivider.BorderSizePixel = 0
idsLogDivider.ZIndex = 10
idsLogDivider.Parent = idsLogPanel

local idsLogScroll = Instance.new("ScrollingFrame")
idsLogScroll.Size = UDim2.new(1, -20, 1, -55)
idsLogScroll.Position = UDim2.new(0, 10, 0, 48)
idsLogScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
idsLogScroll.BackgroundTransparency = 0.3
idsLogScroll.BorderSizePixel = 0
idsLogScroll.ScrollBarThickness = 6
idsLogScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
idsLogScroll.ZIndex = 10
idsLogScroll.Parent = idsLogPanel

local idsLogScrollCorner = Instance.new("UICorner")
idsLogScrollCorner.CornerRadius = UDim.new(0, 8)
idsLogScrollCorner.Parent = idsLogScroll

local idsLogListLayout = Instance.new("UIListLayout")
idsLogListLayout.Padding = UDim.new(0, 4)
idsLogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
idsLogListLayout.Parent = idsLogScroll

local assetScrollFrame = Instance.new("ScrollingFrame")
assetScrollFrame.Size = UDim2.new(1, -20, 1, -170)
assetScrollFrame.Position = UDim2.new(0, 10, 0, 165)
assetScrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
assetScrollFrame.BackgroundTransparency = 0.2
assetScrollFrame.BorderSizePixel = 0
assetScrollFrame.ScrollBarThickness = 8
assetScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
assetScrollFrame.Parent = assetsFrame

local assetScrollCorner = Instance.new("UICorner")
assetScrollCorner.CornerRadius = UDim.new(0, 8)
assetScrollCorner.Parent = assetScrollFrame

local assetListLayout = Instance.new("UIListLayout")
assetListLayout.Padding = UDim.new(0, 5)
assetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
assetListLayout.Parent = assetScrollFrame

local detectedAssets = {}
local savedAssets = {}
local assetCount = 0
local isVisible = true
local existingGUIs = {}
local isScanning = false
local playerConnections = {}
local permanentlyDetectedAssets = {}
local monitoredPlayers = {}
local idsLogVisible = false

local assetTypes = {
    ["Sound"] = {color = Color3.fromRGB(255, 150, 100), patterns = {"SoundId"}},
    ["Image/Decal"] = {color = Color3.fromRGB(100, 255, 150), patterns = {"Image", "Texture", "ImageRectOffset", "ImageRectSize"}},
    ["Animation"] = {color = Color3.fromRGB(255, 100, 255), patterns = {"AnimationId"}},
    ["Mesh"] = {color = Color3.fromRGB(100, 150, 255), patterns = {"MeshId", "TextureId"}},
    ["Skybox"] = {color = Color3.fromRGB(255, 255, 100), patterns = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}},
    ["Shirt/Pants"] = {color = Color3.fromRGB(150, 255, 255), patterns = {"ShirtTemplate", "PantsTemplate"}},
    ["Web Link"] = {color = Color3.fromRGB(255, 200, 50), patterns = {}},
    ["Other"] = {color = Color3.fromRGB(200, 200, 200), patterns = {}}
}

local animationTypes = {
    ["fall"]  = {name = "Fall Animation",  color = Color3.fromRGB(255, 100, 100)},
    ["climb"] = {name = "Climb Animation", color = Color3.fromRGB(150, 100, 255)},
    ["jump"]  = {name = "Jump Animation",  color = Color3.fromRGB(100, 255, 100)},
    ["run"]   = {name = "Run Animation",   color = Color3.fromRGB(255, 200, 100)},
    ["walk"]  = {name = "Walk Animation",  color = Color3.fromRGB(100, 200, 255)},
    ["idle"]  = {name = "Idle Animation",  color = Color3.fromRGB(200, 200, 200)},
}

local assetPatterns = {
    "rbxassetid://([%d,]+)",
    "http://www%.roblox%.com/asset/%?id=([%d,]+)",
    "https://www%.roblox%.com/asset/%?id=([%d,]+)",
    "rbxasset://([%S]+)",
    "content://([%S]+)",
    "(https?://[%w%-%._~:/?#%[%]@!%$&'%(%)%*%+,;=]+)"
}

local function showRobloxNotification(title, text, icon, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = icon or "rbxassetid://3398620867",
            Duration = duration or 5
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
        "https://www%.roblox%.com/asset/%?id=([%d,]+)"
    }
    for _, pattern in pairs(patterns) do
        local match = string.match(text, pattern)
        if match then
            return match
        end
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

local function saveAssetToFile(assetData)
    local fileName = "AlexJOK_FrontEvill_Assets.lua"
    local assetInfo = {
        id = assetData.url,
        type = assetData.assetType,
        object = assetData.objectName,
        property = assetData.propertyName,
        path = assetData.fullPath,
        originalText = assetData.originalText,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        animationType = assetData.animationType or nil
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
        if i < #savedAssets then
            content = content .. ","
        end
        content = content .. "\n"
    end
    content = content .. "}\n\nreturn detectedAssets"
    writefile(fileName, content)
end

local function addIdsLogEntry(assetUrl, assetType, objectName, propertyName, fullPath, animationType, timestamp)
    local entryCount = #idsLogScroll:GetChildren() - 1
    local entryRow = Instance.new("Frame")
    entryRow.Size = UDim2.new(1, -8, 0, 70)
    entryRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    entryRow.BackgroundTransparency = 0.3
    entryRow.BorderSizePixel = 0
    entryRow.LayoutOrder = entryCount + 1
    entryRow.ZIndex = 11
    entryRow.Parent = idsLogScroll

    local entryRowCorner = Instance.new("UICorner")
    entryRowCorner.CornerRadius = UDim.new(0, 6)
    entryRowCorner.Parent = entryRow

    local indexLabel = Instance.new("TextLabel")
    indexLabel.Size = UDim2.new(0, 30, 0, 16)
    indexLabel.Position = UDim2.new(0, 6, 0, 5)
    indexLabel.BackgroundTransparency = 1
    indexLabel.Text = "#" .. tostring(entryCount + 1)
    indexLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    indexLabel.TextSize = 9
    indexLabel.Font = Enum.Font.GothamBold
    indexLabel.TextXAlignment = Enum.TextXAlignment.Left
    indexLabel.ZIndex = 11
    indexLabel.Parent = entryRow

    local typeTag = Instance.new("TextLabel")
    typeTag.Size = UDim2.new(0, 110, 0, 16)
    typeTag.Position = UDim2.new(0, 40, 0, 5)
    typeTag.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    typeTag.BackgroundTransparency = 0.2
    typeTag.BorderSizePixel = 0
    typeTag.Text = animationType or assetType
    typeTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeTag.TextSize = 9
    typeTag.Font = Enum.Font.GothamBold
    typeTag.ZIndex = 11
    typeTag.Parent = entryRow

    local typeTagCorner = Instance.new("UICorner")
    typeTagCorner.CornerRadius = UDim.new(0, 4)
    typeTagCorner.Parent = typeTag

    local timeTag = Instance.new("TextLabel")
    timeTag.Size = UDim2.new(0, 80, 0, 16)
    timeTag.Position = UDim2.new(1, -86, 0, 5)
    timeTag.BackgroundTransparency = 1
    timeTag.Text = timestamp
    timeTag.TextColor3 = Color3.fromRGB(100, 255, 100)
    timeTag.TextSize = 8
    timeTag.Font = Enum.Font.Gotham
    timeTag.ZIndex = 11
    timeTag.Parent = entryRow

    local idRow = Instance.new("TextLabel")
    idRow.Size = UDim2.new(1, -12, 0, 14)
    idRow.Position = UDim2.new(0, 6, 0, 25)
    idRow.BackgroundTransparency = 1
    idRow.Text = "ID: " .. assetUrl
    idRow.TextColor3 = Color3.fromRGB(255, 255, 255)
    idRow.TextSize = 9
    idRow.Font = Enum.Font.GothamBold
    idRow.TextXAlignment = Enum.TextXAlignment.Left
    idRow.TextTruncate = Enum.TextTruncate.AtEnd
    idRow.ZIndex = 11
    idRow.Parent = entryRow

    local objRow = Instance.new("TextLabel")
    objRow.Size = UDim2.new(1, -12, 0, 12)
    objRow.Position = UDim2.new(0, 6, 0, 41)
    objRow.BackgroundTransparency = 1
    objRow.Text = "Object: " .. objectName .. "  |  Property: " .. propertyName
    objRow.TextColor3 = Color3.fromRGB(180, 180, 255)
    objRow.TextSize = 8
    objRow.Font = Enum.Font.Gotham
    objRow.TextXAlignment = Enum.TextXAlignment.Left
    objRow.TextTruncate = Enum.TextTruncate.AtEnd
    objRow.ZIndex = 11
    objRow.Parent = entryRow

    local pathRow = Instance.new("TextLabel")
    pathRow.Size = UDim2.new(1, -12, 0, 12)
    pathRow.Position = UDim2.new(0, 6, 0, 55)
    pathRow.BackgroundTransparency = 1
    pathRow.Text = "Path: " .. fullPath
    pathRow.TextColor3 = Color3.fromRGB(150, 150, 150)
    pathRow.TextSize = 8
    pathRow.Font = Enum.Font.Gotham
    pathRow.TextXAlignment = Enum.TextXAlignment.Left
    pathRow.TextTruncate = Enum.TextTruncate.AtEnd
    pathRow.ZIndex = 11
    pathRow.Parent = entryRow

    local copyLogBtn = Instance.new("TextButton")
    copyLogBtn.Size = UDim2.new(0, 44, 0, 16)
    copyLogBtn.Position = UDim2.new(1, -50, 0, 25)
    copyLogBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    copyLogBtn.BackgroundTransparency = 0.2
    copyLogBtn.BorderSizePixel = 0
    copyLogBtn.Text = "Copy"
    copyLogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyLogBtn.TextSize = 8
    copyLogBtn.Font = Enum.Font.GothamBold
    copyLogBtn.ZIndex = 11
    copyLogBtn.Parent = entryRow

    local copyLogBtnCorner = Instance.new("UICorner")
    copyLogBtnCorner.CornerRadius = UDim.new(0, 4)
    copyLogBtnCorner.Parent = copyLogBtn

    copyLogBtn.MouseButton1Click:Connect(function()
        local baseId = string.match(assetUrl, "(%d+)")
        setclipboard(baseId or assetUrl)
        copyLogBtn.Text = "Done"
        spawn(function()
            wait(1.5)
            if copyLogBtn and copyLogBtn.Parent then
                copyLogBtn.Text = "Copy"
            end
        end)
    end)

    idsLogScroll.CanvasSize = UDim2.new(0, 0, 0, idsLogListLayout.AbsoluteContentSize.Y + 10)
end

local function createAssetEntry(assetUrl, propertyName, objectName, fullPath, assetType, typeColor, originalText, animationType)
    local entryFrame = Instance.new("Frame")
    entryFrame.Size = UDim2.new(1, -10, 0, 110)
    entryFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    entryFrame.BackgroundTransparency = 0.2
    entryFrame.BorderSizePixel = 0
    entryFrame.Parent = assetScrollFrame

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 8)
    entryCorner.Parent = entryFrame

    local entryTween = TweenService:Create(
        entryFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.2}
    )

    entryFrame.BackgroundTransparency = 1
    entryTween:Play()

    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0, 4, 1, 0)
    highlight.Position = UDim2.new(0, 0, 0, 0)
    highlight.BackgroundColor3 = typeColor
    highlight.BorderSizePixel = 0
    highlight.Parent = entryFrame

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 8)
    highlightCorner.Parent = highlight

    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(0, 110, 0, 20)
    typeLabel.Position = UDim2.new(0, 8, 0, 5)
    typeLabel.BackgroundColor3 = typeColor
    typeLabel.BackgroundTransparency = 0.2
    typeLabel.BorderSizePixel = 0
    typeLabel.Text = animationType or assetType
    typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeLabel.TextSize = 10
    typeLabel.Font = Enum.Font.GothamBold
    typeLabel.Parent = entryFrame

    local typeLabelCorner = Instance.new("UICorner")
    typeLabelCorner.CornerRadius = UDim.new(0, 4)
    typeLabelCorner.Parent = typeLabel

    local urlLabel = Instance.new("TextLabel")
    urlLabel.Size = UDim2.new(1, -200, 0, 16)
    urlLabel.Position = UDim2.new(0, 8, 0, 28)
    urlLabel.BackgroundTransparency = 1
    urlLabel.Text = "ID: " .. assetUrl
    urlLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    urlLabel.TextSize = 10
    urlLabel.Font = Enum.Font.GothamBold
    urlLabel.TextXAlignment = Enum.TextXAlignment.Left
    urlLabel.TextTruncate = Enum.TextTruncate.AtEnd
    urlLabel.Parent = entryFrame

    local objectLabel = Instance.new("TextLabel")
    objectLabel.Size = UDim2.new(1, -200, 0, 14)
    objectLabel.Position = UDim2.new(0, 8, 0, 46)
    objectLabel.BackgroundTransparency = 1
    objectLabel.Text = "Object: " .. objectName
    objectLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    objectLabel.TextSize = 9
    objectLabel.Font = Enum.Font.Gotham
    objectLabel.TextXAlignment = Enum.TextXAlignment.Left
    objectLabel.TextTruncate = Enum.TextTruncate.AtEnd
    objectLabel.Parent = entryFrame

    local propertyLabel = Instance.new("TextLabel")
    propertyLabel.Size = UDim2.new(1, -200, 0, 14)
    propertyLabel.Position = UDim2.new(0, 8, 0, 62)
    propertyLabel.BackgroundTransparency = 1
    propertyLabel.Text = "Property: " .. propertyName
    propertyLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
    propertyLabel.TextSize = 9
    propertyLabel.Font = Enum.Font.Gotham
    propertyLabel.TextXAlignment = Enum.TextXAlignment.Left
    propertyLabel.TextTruncate = Enum.TextTruncate.AtEnd
    propertyLabel.Parent = entryFrame

    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -200, 0, 14)
    timeLabel.Position = UDim2.new(0, 8, 0, 78)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Found: " .. os.date("%H:%M:%S")
    timeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timeLabel.TextSize = 8
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = entryFrame

    local buttonWidth = 55
    local buttonHeight = 20
    local buttonSpacing = 5

    local copyIdButton = Instance.new("TextButton")
    copyIdButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    copyIdButton.Position = UDim2.new(1, -(buttonWidth * 2 + buttonSpacing + 10), 0, 8)
    copyIdButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    copyIdButton.BackgroundTransparency = 0.2
    copyIdButton.BorderSizePixel = 0
    copyIdButton.Text = "Copy ID"
    copyIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyIdButton.TextSize = 8
    copyIdButton.Font = Enum.Font.GothamBold
    copyIdButton.Parent = entryFrame

    local copyIdCorner = Instance.new("UICorner")
    copyIdCorner.CornerRadius = UDim.new(0, 4)
    copyIdCorner.Parent = copyIdButton

    local copyFullIdButton = Instance.new("TextButton")
    copyFullIdButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    copyFullIdButton.Position = UDim2.new(1, -(buttonWidth + 10), 0, 8)
    copyFullIdButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    copyFullIdButton.BackgroundTransparency = 0.2
    copyFullIdButton.BorderSizePixel = 0
    copyFullIdButton.Text = "Full ID"
    copyFullIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyFullIdButton.TextSize = 8
    copyFullIdButton.Font = Enum.Font.GothamBold
    copyFullIdButton.Parent = entryFrame

    local copyFullIdCorner = Instance.new("UICorner")
    copyFullIdCorner.CornerRadius = UDim.new(0, 4)
    copyFullIdCorner.Parent = copyFullIdButton

    local copyLineButton = Instance.new("TextButton")
    copyLineButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    copyLineButton.Position = UDim2.new(1, -(buttonWidth * 2 + buttonSpacing + 10), 0, 33)
    copyLineButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    copyLineButton.BackgroundTransparency = 0.2
    copyLineButton.BorderSizePixel = 0
    copyLineButton.Text = "Line"
    copyLineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyLineButton.TextSize = 8
    copyLineButton.Font = Enum.Font.GothamBold
    copyLineButton.Parent = entryFrame

    local copyLineCorner = Instance.new("UICorner")
    copyLineCorner.CornerRadius = UDim.new(0, 4)
    copyLineCorner.Parent = copyLineButton

    local copyPathButton = Instance.new("TextButton")
    copyPathButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    copyPathButton.Position = UDim2.new(1, -(buttonWidth + 10), 0, 33)
    copyPathButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    copyPathButton.BackgroundTransparency = 0.2
    copyPathButton.BorderSizePixel = 0
    copyPathButton.Text = "Path"
    copyPathButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyPathButton.TextSize = 8
    copyPathButton.Font = Enum.Font.GothamBold
    copyPathButton.Parent = entryFrame

    local copyPathCorner = Instance.new("UICorner")
    copyPathCorner.CornerRadius = UDim.new(0, 4)
    copyPathCorner.Parent = copyPathButton

    copyIdButton.MouseButton1Click:Connect(function()
        local baseId = string.match(assetUrl, "(%d+)")
        setclipboard(baseId or assetUrl)
        copyIdButton.Text = "Done"
        copyIdButton.BackgroundTransparency = 0.5
        spawn(function()
            wait(1.5)
            if copyIdButton and copyIdButton.Parent then
                copyIdButton.Text = "Copy ID"
                copyIdButton.BackgroundTransparency = 0.2
            end
        end)
    end)

    copyFullIdButton.MouseButton1Click:Connect(function()
        local fullId = extractFullId(originalText) or assetUrl
        setclipboard(fullId)
        copyFullIdButton.Text = "Done"
        copyFullIdButton.BackgroundTransparency = 0.5
        spawn(function()
            wait(1.5)
            if copyFullIdButton and copyFullIdButton.Parent then
                copyFullIdButton.Text = "Full ID"
                copyFullIdButton.BackgroundTransparency = 0.2
            end
        end)
    end)

    copyLineButton.MouseButton1Click:Connect(function()
        setclipboard(originalText)
        copyLineButton.Text = "Done"
        copyLineButton.BackgroundTransparency = 0.5
        spawn(function()
            wait(1.5)
            if copyLineButton and copyLineButton.Parent then
                copyLineButton.Text = "Line"
                copyLineButton.BackgroundTransparency = 0.2
            end
        end)
    end)

    copyPathButton.MouseButton1Click:Connect(function()
        setclipboard(fullPath)
        copyPathButton.Text = "Done"
        copyPathButton.BackgroundTransparency = 0.5
        spawn(function()
            wait(1.5)
            if copyPathButton and copyPathButton.Parent then
                copyPathButton.Text = "Path"
                copyPathButton.BackgroundTransparency = 0.2
            end
        end)
    end)

    return entryFrame
end

local function clearAllAssets()
    for _, child in pairs(assetScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= assetListLayout then
            child:Destroy()
        end
    end
    detectedAssets = {}
    assetCount = 0
    countLabel.Text = "Found: 0 assets"
    assetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function saveAllAssets()
    if #savedAssets > 0 then
        local fileName = "AlexJOK_FrontEvill_Assets.lua"
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
            if i < #savedAssets then
                content = content .. ","
            end
            content = content .. "\n"
        end
        content = content .. "}\n\nreturn detectedAssets"
        writefile(fileName, content)
        saveButton.Text = "Saved"
        saveButton.BackgroundTransparency = 0.5
        showRobloxNotification("Alex JOK", "Assets saved successfully!")
        spawn(function()
            wait(2)
            if saveButton and saveButton.Parent then
                saveButton.Text = "Save File"
                saveButton.BackgroundTransparency = 0.2
            end
        end)
    end
end

local function deleteAllFiles()
    savedAssets = {}
    local fileName = "AlexJOK_FrontEvill_Assets.lua"
    if isfile(fileName) then
        delfile(fileName)
    end
    deleteFileButton.Text = "Deleted"
    deleteFileButton.BackgroundTransparency = 0.5
    showRobloxNotification("Alex JOK", "All files deleted successfully!")
    spawn(function()
        wait(2)
        if deleteFileButton and deleteFileButton.Parent then
            deleteFileButton.Text = "Delete All ID (File)"
            deleteFileButton.BackgroundTransparency = 0.2
        end
    end)
end

local function updateAssetScrollSize()
    assetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, assetListLayout.AbsoluteContentSize.Y + 15)
end

local function savePlayerAnimations(playerName, playerAnimations)
    local fileName = "Player_" .. playerName .. "_Animations.lua"
    local content = "local playerAnimations = {\n"
    content = content .. "    playerName = \"" .. playerName .. "\",\n"
    content = content .. "    animations = {\n"
    for animType, animData in pairs(playerAnimations) do
        if animData.id then
            content = content .. "        " .. animType .. " = {\n"
            content = content .. "            id = \"" .. animData.id .. "\",\n"
            content = content .. "            name = \"" .. animData.name .. "\",\n"
            content = content .. "            timestamp = \"" .. os.date("%Y-%m-%d %H:%M:%S") .. "\"\n"
            content = content .. "        },\n"
        end
    end
    content = content .. "    }\n"
    content = content .. "}\n\nreturn playerAnimations"
    writefile(fileName, content)
    showRobloxNotification("Player Animations", "Downloaded " .. playerName .. " animations!")
end

local function getFullPath(obj)
    local path = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path = current.Name .. "." .. path
        current = current.Parent
    end
    return path
end

local function scanObjectForContent(obj)
    local foundAssets = {}
    local propertiesToCheck = {
        "Image", "Texture", "Decal", "SoundId", "MeshId", "TextureId",
        "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp",
        "ShirtTemplate", "PantsTemplate", "AnimationId", "Text", "Value"
    }
    for _, property in pairs(propertiesToCheck) do
        local success, value = pcall(function() return obj[property] end)
        if success and typeof(value) == "string" and value ~= "" then
            local assets = extractAssets(value)
            for _, asset in pairs(assets) do
                local assetType, typeColor = getAssetType(property, value)
                local fullPath = getFullPath(obj)
                table.insert(foundAssets, {
                    url = asset,
                    propertyName = property,
                    objectName = obj.Name,
                    fullPath = fullPath,
                    assetType = assetType,
                    typeColor = typeColor,
                    originalText = value
                })
            end
        end
    end
    return foundAssets
end

local function addAsset(assetData)
    local identifier = assetData.url
    if assetData.assetType ~= "Web Link" then
        local baseId = string.match(assetData.url, "(%d+)")
        if baseId then
            identifier = baseId
        end
    end

    if identifier and not permanentlyDetectedAssets[identifier] and isScanning then
        permanentlyDetectedAssets[identifier] = true
        detectedAssets[identifier] = true
        assetCount = assetCount + 1
        countLabel.Text = "Found: " .. assetCount .. " assets"

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

        local saveData = {
            url = assetData.url,
            assetType = assetData.assetType,
            objectName = assetData.objectName,
            propertyName = assetData.propertyName,
            fullPath = assetData.fullPath,
            originalText = assetData.originalText,
            animationType = assetData.animationType
        }
        saveAssetToFile(saveData)

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
        "idle.Animation2"
    }

    spawn(function()
        while isScanning do
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                if targetPlayer.Character then
                    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        local animate = targetPlayer.Character:FindFirstChild("Animate")
                        if animate then
                            for _, path in pairs(animationPaths) do
                                local pathParts = string.split(path, ".")
                                local current = animate
                                local animType = pathParts[1]
                                for i, part in pairs(pathParts) do
                                    if current then
                                        current = current:FindFirstChild(part)
                                    end
                                end
                                if current and current:IsA("Animation") then
                                    local animId = current.AnimationId
                                    if animId and animId ~= "" then
                                        local baseId = string.match(animId, "(%d+)")
                                        if baseId and not permanentlyDetectedAssets[baseId] then
                                            local assets = extractAssets(animId)
                                            for _, asset in pairs(assets) do
                                                local animName, animColor = getAnimationType(animId, animType)
                                                local assetData = {
                                                    url = asset,
                                                    propertyName = "AnimationId",
                                                    objectName = targetPlayer.Name .. "_" .. animType,
                                                    fullPath = "Players." .. targetPlayer.Name .. ".Character.Animate." .. path,
                                                    assetType = "Animation",
                                                    typeColor = animColor,
                                                    originalText = animId,
                                                    animationType = animName
                                                }
                                                addAsset(assetData)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            wait(1)
        end
    end)
end

local function createControlTool()
    for _, P in ipairs(player.Backpack:GetChildren()) do
        if P.Name == "ClickTarget" then
            P:Destroy()
        end
    end
    if player.Character then
        for _, P in ipairs(player.Character:GetChildren()) do
            if P.Name == "ClickTarget" then
                P:Destroy()
            end
        end
    end

    local GetTargetTool = Instance.new("Tool")
    GetTargetTool.Name = "ClickTarget"
    GetTargetTool.RequiresHandle = false
    GetTargetTool.TextureId = "rbxassetid://13769558274"
    GetTargetTool.ToolTip = "Choose Player for Animation Download"

    local function ActivateTool()
        local Hit = player:GetMouse().Target
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
                        local animationPaths = {
                            fall  = "fall.FallAnim",
                            climb = "climb.ClimbAnim",
                            jump  = "jump.JumpAnim",
                            run   = "run.RunAnim",
                            walk  = "walk.WalkAnim",
                            idle1 = "idle.Animation1",
                            idle2 = "idle.Animation2"
                        }
                        for animKey, path in pairs(animationPaths) do
                            local pathParts = string.split(path, ".")
                            local current = animate
                            for _, part in pairs(pathParts) do
                                if current then
                                    current = current:FindFirstChild(part)
                                end
                            end
                            if current and current:IsA("Animation") then
                                local animId = current.AnimationId
                                if animId and animId ~= "" then
                                    local baseId = string.match(animId, "(%d+)")
                                    if baseId then
                                        local animType = string.split(path, ".")[1]
                                        local animName, _ = getAnimationType(animId, animType)
                                        playerAnimations[animKey] = {
                                            id = baseId,
                                            name = animName,
                                            fullId = animId
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
                if next(playerAnimations) then
                    savePlayerAnimations(Person.Name, playerAnimations)
                else
                    showRobloxNotification("Player Target", "No animations found for " .. Person.Name)
                end
            elseif Person == player then
                showRobloxNotification("Player Target", "Cannot target yourself!")
            end
        end
    end

    GetTargetTool.Activated:Connect(function()
        ActivateTool()
    end)

    GetTargetTool.Parent = player.Backpack
end

local function toggleIdsLog()
    if idsLogVisible then
        local tweenOut = TweenService:Create(idsLogPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            idsLogPanel.Visible = false
            idsLogPanel.Size = UDim2.new(0, 500, 0, 520)
            idsLogPanel.Position = UDim2.new(0.5, -250, 0.5, -260)
        end)
        idsLogVisible = false
    else
        idsLogPanel.Size = UDim2.new(0, 0, 0, 0)
        idsLogPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        idsLogPanel.Visible = true
        local tweenIn = TweenService:Create(idsLogPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 520),
            Position = UDim2.new(0.5, -250, 0.5, -260)
        })
        tweenIn:Play()
        idsLogVisible = true
    end
end

local function toggleVisibility()
    if isVisible then
        local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -325, -1, 0)})
        local shadowOut = TweenService:Create(shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -325, -1, 0)})
        fadeOut:Play()
        shadowOut:Play()
        isVisible = false
    else
        mainFrame.Position = UDim2.new(0.5, -325, -1, 0)
        shadow.Position = UDim2.new(0.5, -325, -1, 0)
        local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -325, 0.5, -310)})
        local shadowIn = TweenService:Create(shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -325, 0.5, -310)})
        fadeIn:Play()
        shadowIn:Play()
        isVisible = true
    end
end

local function onGuiAdded(gui)
    if gui:IsA("ScreenGui") or gui:IsA("GuiBase") then
        if existingGUIs[gui] then
            return
        end
        spawn(function()
            wait(0.5)
            local function scanNewGui(obj)
                if not isScanning then return end
                local assets = scanObjectForContent(obj)
                for _, asset in pairs(assets) do
                    addAsset(asset)
                end
                for _, child in pairs(obj:GetChildren()) do
                    if child then
                        scanNewGui(child)
                    end
                end
            end
            scanNewGui(gui)
            gui.DescendantAdded:Connect(function(descendant)
                if isScanning then
                    local assets = scanObjectForContent(descendant)
                    for _, asset in pairs(assets) do
                        addAsset(asset)
                    end
                end
            end)
        end)
    end
end

local function registerExistingGUIs()
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            existingGUIs[gui] = true
        end
    end
end

spawn(function()
    statusLabel.Text = "Waiting 2 seconds before scanning..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    wait(2)
    isScanning = true
    statusLabel.Text = "Status: Active - Monitoring All Player Animations"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    monitorPlayerAnimations()
    showRobloxNotification("Alex JOK - FrontEvill", "Detector Started! Press B to hide/show")
end)

registerExistingGUIs()
playerGui.ChildAdded:Connect(onGuiAdded)

if CoreGui then
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            existingGUIs[gui] = true
        end
    end
    CoreGui.ChildAdded:Connect(onGuiAdded)
end

clearButton.MouseButton1Click:Connect(clearAllAssets)
saveButton.MouseButton1Click:Connect(saveAllAssets)
deleteFileButton.MouseButton1Click:Connect(deleteAllFiles)
controlToolButton.MouseButton1Click:Connect(createControlTool)
idsLogButton.MouseButton1Click:Connect(toggleIdsLog)
idsLogCloseBtn.MouseButton1Click:Connect(toggleIdsLog)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
        toggleVisibility()
    end
end)

local dragToggle = nil
local dragSpeed = 0.15
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(mainFrame, TweenInfo.new(dragSpeed), {Position = newPosition}):Play()
    TweenService:Create(shadow, TweenInfo.new(dragSpeed), {Position = newPosition}):Play()
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInput(input)
        end
    end
end)

hideButton.MouseButton1Click:Connect(toggleVisibility)

closeButton.MouseButton1Click:Connect(function()
    isScanning = false
    local tweenClose = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tweenClose:Play()
    tweenClose.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

local function addButtonEffects(button)
    local originalSize = button.Size
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = originalSize + UDim2.new(0, 4, 0, 4)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = originalSize}):Play()
    end)
end

addButtonEffects(hideButton)
addButtonEffects(closeButton)
addButtonEffects(clearButton)
addButtonEffects(saveButton)
addButtonEffects(deleteFileButton)
addButtonEffects(controlToolButton)
addButtonEffects(idsLogButton)
addButtonEffects(idsLogCloseBtn)
