local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Util = {}

function Util.Tween(obj, dur, style, dir, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(
            dur,
            style or Enum.EasingStyle.Quint,
            dir   or Enum.EasingDirection.Out
        ),
        props
    )
end

function Util.Spring(obj, dur, props)
    return Util.Tween(obj, dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out, props)
end

function Util.Smooth(obj, dur, props)
    return Util.Tween(obj, dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, props)
end

function Util.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

function Util.Stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color           = color          or Color3.fromRGB(255, 255, 255)
    s.Transparency    = transparency   or 0
    s.Thickness       = thickness      or 1
    s.Parent          = parent
    return s
end

function Util.Padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent        = parent
    return p
end

function Util.ListLayout(parent, dir, pad, ha, va)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment = ha  or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va  or Enum.VerticalAlignment.Top
    l.Padding             = UDim.new(0, pad or 0)
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent              = parent
    return l
end

function Util.Frame(parent, bg, transparency, size, position, zindex)
    local f = Instance.new("Frame")
    f.BackgroundColor3    = bg            or Color3.fromRGB(0, 0, 0)
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel     = 0
    f.Size                = size          or UDim2.fromScale(1, 1)
    f.Position            = position      or UDim2.fromScale(0, 0)
    f.ZIndex              = zindex        or 1
    f.Parent              = parent
    return f
end

function Util.Label(parent, text, size, font, color, zindex)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text        = text   or ""
    l.TextSize    = size   or 13
    l.Font        = font   or Enum.Font.GothamMedium
    l.TextColor3  = color  or Color3.fromRGB(255, 255, 255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex      = zindex or 1
    l.Size        = UDim2.fromScale(1, 1)
    l.Parent      = parent
    return l
end

function Util.Button(parent, zindex)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.BorderSizePixel        = 0
    b.Text                   = ""
    b.AutoButtonColor        = false
    b.ZIndex                 = zindex or 1
    b.Size                   = UDim2.fromScale(1, 1)
    b.Parent                 = parent
    return b
end

function Util.ScrollFrame(parent, barColor, barTransparency, zindex)
    local s = Instance.new("ScrollingFrame")
    s.BackgroundTransparency  = 1
    s.BorderSizePixel         = 0
    s.ScrollBarThickness      = 3
    s.ScrollBarImageColor3    = barColor          or Color3.fromRGB(80, 80, 100)
    s.ScrollBarImageTransparency = barTransparency or 0.30
    s.CanvasSize              = UDim2.new(0, 0, 0, 0)
    s.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    s.ZIndex                  = zindex            or 1
    s.Size                    = UDim2.fromScale(1, 1)
    s.Parent                  = parent
    return s
end

function Util.MakeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Util.FormatUptime(seconds)
    local h  = math.floor(seconds / 3600)
    local m  = math.floor((seconds % 3600) / 60)
    local s  = math.floor(seconds % 60)
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

function Util.AccountAge(player)
    local days = player.AccountAge
    if days < 30    then return days .. "d"
    elseif days < 365 then return math.floor(days / 30) .. "mo"
    else                return math.floor(days / 365) .. "y"
    end
end

function Util.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

return Util
