local UserInputService = game:GetService("UserInputService")

local Elements = {}

function Elements.BuildSection(parent, name, theme, util)
    local Section = {}

    local SF = util.Frame(parent, theme.Surface, 0)
    SF.Size = UDim2.new(1, 0, 0, 0)
    SF.AutomaticSize = Enum.AutomaticSize.Y
    util.Corner(SF, 10)
    util.Stroke(SF, theme.Border, 0.30, 1)

    local SHeader = util.Frame(SF, theme.SurfaceB, 0, UDim2.new(1, 0, 0, 40))
    util.Corner(SHeader, 10)
    util.Padding(SHeader, 0, 0, 14, 14)

    local SHeaderFix = util.Frame(SHeader, theme.SurfaceB, 0, UDim2.new(1, 0, 0, 12), UDim2.new(0, 0, 1, -12))

    local SPill = util.Frame(SHeader, theme.Accent, 0, UDim2.fromOffset(3, 16))
    SPill.Position = UDim2.new(0, 0, 0.5, -8)
    util.Corner(SPill, 2)

    local STitleHolder = util.Frame(SHeader, theme.White, 1)
    STitleHolder.Position = UDim2.fromOffset(12, 0)
    STitleHolder.Size     = UDim2.new(1, -12, 1, 0)
    local STL = util.Label(STitleHolder, name or "Section", 13, Enum.Font.GothamBold, theme.Text)
    STL.TextYAlignment = Enum.TextYAlignment.Center

    local SDivider = util.Frame(SF, theme.Border, 0.50, UDim2.new(1, -28, 0, 1), UDim2.fromOffset(14, 40))

    local SC = util.Frame(SF, theme.White, 1, UDim2.new(1, -28, 0, 0), UDim2.fromOffset(14, 50))
    SC.AutomaticSize = Enum.AutomaticSize.Y
    util.ListLayout(SC, Enum.FillDirection.Vertical, 5)

    local SPadBottom = Instance.new("UIPadding")
    SPadBottom.PaddingBottom = UDim.new(0, 14)
    SPadBottom.Parent        = SF

    Section.Frame   = SF
    Section.Content = SC
    Section.Theme   = theme
    Section.Util    = util

    return Section
end

function Elements.Paragraph(section, cfg)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local PT    = cfg.Title   or ""
    local PC    = cfg.Content or ""

    local PF = util.Frame(SC, theme.SurfaceB, 0)
    PF.Size = UDim2.new(1, 0, 0, 0)
    PF.AutomaticSize = Enum.AutomaticSize.Y
    util.Corner(PF, 8)
    util.Stroke(PF, theme.Border, 0.55, 1)
    util.Padding(PF, 10, 10, 12, 12)

    local innerLayout = util.ListLayout(PF, Enum.FillDirection.Vertical, 4)

    local PTL = nil
    if PT ~= "" then
        local ptHolder = util.Frame(PF, theme.White, 1, UDim2.new(1, 0, 0, 18))
        ptHolder.AutomaticSize = Enum.AutomaticSize.Y
        PTL = util.Label(ptHolder, PT, 13, Enum.Font.GothamBold, theme.Text)
        PTL.Size = UDim2.new(1, 0, 0, 18)
        PTL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local pclHolder = util.Frame(PF, theme.White, 1, UDim2.new(1, 0, 0, 0))
    pclHolder.AutomaticSize = Enum.AutomaticSize.Y
    local PCL = util.Label(pclHolder, PC, 11, Enum.Font.Gotham, theme.TextSub)
    PCL.Size = UDim2.new(1, 0, 0, 0)
    PCL.AutomaticSize = Enum.AutomaticSize.Y
    PCL.TextWrapped   = true
    PCL.TextYAlignment = Enum.TextYAlignment.Top

    return {
        Frame      = PF,
        SetTitle   = function(v) if PTL then PTL.Text = v end end,
        SetContent = function(v) PCL.Text = v end,
    }
end

function Elements.Button(section, cfg, screenGui)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local BT    = cfg.Title       or "Button"
    local BD    = cfg.Description or ""
    local BCB   = cfg.Callback    or function() end
    local BCONF = cfg.Confirm     or false

    local hasDesc = BD ~= ""
    local BF = util.Frame(SC, theme.SurfaceB, 0, UDim2.new(1, 0, 0, hasDesc and 58 or 40))
    util.Corner(BF, 8)
    local BStr = util.Stroke(BF, theme.Border, 0.55, 1)

    local BTL = util.Label(BF, BT, 13, Enum.Font.GothamSemibold, theme.Text)
    BTL.Size     = UDim2.new(1, -48, 0, 18)
    BTL.Position = UDim2.fromOffset(12, hasDesc and 9 or 11)
    BTL.TextYAlignment = Enum.TextYAlignment.Center

    if hasDesc then
        local BDL = util.Label(BF, BD, 11, Enum.Font.Gotham, theme.TextSub)
        BDL.Size     = UDim2.new(1, -48, 0, 14)
        BDL.Position = UDim2.fromOffset(12, 28)
        BDL.TextTruncate = Enum.TextTruncate.AtEnd
        BDL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local BArrow = util.Frame(BF, theme.Accent, 0.90, UDim2.fromOffset(24, 24))
    BArrow.Position = UDim2.new(1, -34, 0.5, -12)
    util.Corner(BArrow, 7)
    local BAL = util.Label(BArrow, "›", 16, Enum.Font.GothamBold, theme.Accent)
    BAL.TextXAlignment = Enum.TextXAlignment.Center
    BAL.TextYAlignment = Enum.TextYAlignment.Center

    local BB = util.Button(BF, 10)

    BB.MouseEnter:Connect(function()
        util.Smooth(BF,     0.15, {BackgroundColor3 = theme.SurfaceC}):Play()
        util.Smooth(BTL,    0.15, {TextColor3 = theme.Accent}):Play()
        util.Smooth(BArrow, 0.15, {BackgroundTransparency = 0.75}):Play()
        util.Smooth(BStr,   0.15, {Color = theme.BorderHover, Transparency = 0.30}):Play()
    end)
    BB.MouseLeave:Connect(function()
        util.Smooth(BF,     0.15, {BackgroundColor3 = theme.SurfaceB}):Play()
        util.Smooth(BTL,    0.15, {TextColor3 = theme.Text}):Play()
        util.Smooth(BArrow, 0.15, {BackgroundTransparency = 0.90}):Play()
        util.Smooth(BStr,   0.15, {Color = theme.Border, Transparency = 0.55}):Play()
    end)

    local function ShowConfirm(onConfirm)
        local OV = util.Frame(screenGui, Color3.fromRGB(0, 0, 0), 0.55)
        OV.Size   = UDim2.fromScale(1, 1)
        OV.ZIndex = 600

        local DF = util.Frame(screenGui, theme.Surface, 0)
        DF.Size        = UDim2.fromOffset(0, 0)
        DF.Position    = UDim2.fromScale(0.5, 0.5)
        DF.AnchorPoint = Vector2.new(0.5, 0.5)
        DF.ZIndex      = 601
        util.Corner(DF, 12)
        util.Stroke(DF, theme.Border, 0.25, 1)
        util.Spring(DF, 0.30, {Size = UDim2.fromOffset(310, 138)}):Play()

        local DLine = util.Frame(DF, theme.Accent, 0, UDim2.fromOffset(3, 24))
        DLine.Position = UDim2.fromOffset(14, 16)
        util.Corner(DLine, 2)

        local DT = util.Label(DF, "Confirm Action", 14, Enum.Font.GothamBold, theme.Text, 602)
        DT.Size = UDim2.new(1, -42, 0, 20); DT.Position = UDim2.fromOffset(26, 16)

        local DX = util.Label(DF, "Are you sure you want to proceed with this action?", 11, Enum.Font.Gotham, theme.TextSub, 602)
        DX.Size = UDim2.new(1, -28, 0, 0); DX.Position = UDim2.fromOffset(14, 44)
        DX.TextWrapped = true; DX.AutomaticSize = Enum.AutomaticSize.Y

        local function makeDialogBtn(text, bg, xOffset)
            local DBF = util.Frame(DF, bg, 0, UDim2.fromOffset(92, 30))
            DBF.Position = UDim2.new(1, xOffset, 1, -42)
            DBF.ZIndex = 602
            util.Corner(DBF, 8)
            local DBL = util.Label(DBF, text, 12, Enum.Font.GothamMedium, theme.White, 603)
            DBL.TextXAlignment = Enum.TextXAlignment.Center
            DBL.TextYAlignment = Enum.TextYAlignment.Center
            local DBB = util.Button(DBF, 604)
            return DBB
        end

        local closed = false
        local function closeDialog()
            if closed then return end; closed = true
            util.Smooth(DF, 0.20, {Size = UDim2.fromOffset(0, 0)}):Play()
            util.Smooth(OV, 0.20, {BackgroundTransparency = 1}):Play()
            task.wait(0.20); OV:Destroy(); DF:Destroy()
        end

        makeDialogBtn("Cancel",  theme.SurfaceC, -208).MouseButton1Click:Connect(closeDialog)
        makeDialogBtn("Confirm", theme.Accent,   -106).MouseButton1Click:Connect(function()
            closeDialog(); task.spawn(onConfirm)
        end)
        OV.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then closeDialog() end
        end)
    end

    BB.MouseButton1Click:Connect(function()
        util.Spring(BF, 0.08, {Size = UDim2.new(1, -6, 0, hasDesc and 52 or 34)}):Play()
        task.wait(0.08)
        util.Spring(BF, 0.18, {Size = UDim2.new(1, 0, 0, hasDesc and 58 or 40)}):Play()
        if BCONF then ShowConfirm(BCB) else task.spawn(BCB) end
    end)

    return BF
end

function Elements.Toggle(section, cfg)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local TT    = cfg.Title       or "Toggle"
    local TD    = cfg.Description or ""
    local TDef  = cfg.Default     or false
    local TCB   = cfg.Callback    or function() end

    local isOn   = TDef
    local hasDesc = TD ~= ""

    local TF = util.Frame(SC, theme.SurfaceB, 0, UDim2.new(1, 0, 0, hasDesc and 58 or 40))
    util.Corner(TF, 8)
    util.Stroke(TF, theme.Border, 0.55, 1)

    local TTL = util.Label(TF, TT, 13, Enum.Font.GothamSemibold, theme.Text)
    TTL.Size     = UDim2.new(1, -58, 0, 18)
    TTL.Position = UDim2.fromOffset(12, hasDesc and 9 or 11)
    TTL.TextYAlignment = Enum.TextYAlignment.Center

    if hasDesc then
        local TDL = util.Label(TF, TD, 11, Enum.Font.Gotham, theme.TextSub)
        TDL.Size     = UDim2.new(1, -58, 0, 14)
        TDL.Position = UDim2.fromOffset(12, 28)
        TDL.TextTruncate = Enum.TextTruncate.AtEnd
        TDL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local TTrack = util.Frame(TF, isOn and theme.Accent or theme.SurfaceC, 0, UDim2.fromOffset(36, 20))
    TTrack.Position = UDim2.new(1, -46, 0.5, -10)
    util.Corner(TTrack, 10)
    local TTrackStr = util.Stroke(TTrack, isOn and theme.Accent or theme.Border, 0.45, 1)

    local TKnob = util.Frame(TTrack, theme.White, 0, UDim2.fromOffset(14, 14))
    TKnob.Position = UDim2.fromOffset(isOn and 19 or 3, 3)
    util.Corner(TKnob, 7)

    local TClick = util.Button(TF, 5)

    local function SetValue(v, silent)
        isOn = v
        util.Smooth(TTrack, 0.22, {BackgroundColor3 = isOn and theme.Accent or theme.SurfaceC}):Play()
        util.Smooth(TTrackStr, 0.22, {Color = isOn and theme.Accent or theme.Border}):Play()
        util.Spring(TKnob, 0.22, {Position = UDim2.fromOffset(isOn and 19 or 3, 3)}):Play()
        if not silent then task.spawn(TCB, isOn) end
    end

    TClick.MouseEnter:Connect(function()
        util.Smooth(TF, 0.14, {BackgroundColor3 = theme.SurfaceC}):Play()
    end)
    TClick.MouseLeave:Connect(function()
        util.Smooth(TF, 0.14, {BackgroundColor3 = theme.SurfaceB}):Play()
    end)
    TClick.MouseButton1Click:Connect(function()
        SetValue(not isOn)
    end)

    if isOn then task.spawn(TCB, isOn) end

    return {
        Frame    = TF,
        SetValue = SetValue,
        GetValue = function() return isOn end,
    }
end

function Elements.Slider(section, cfg)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local ST    = cfg.Title       or "Slider"
    local SD    = cfg.Description or ""
    local SMn   = cfg.Min         or 0
    local SMx   = cfg.Max         or 100
    local SDef  = math.clamp(cfg.Default or SMn, SMn, SMx)
    local SR    = cfg.Rounding    or 1
    local SCB   = cfg.Callback    or function() end
    local SSuf  = cfg.Suffix      or ""

    local val     = SDef
    local dragging = false
    local hasDesc  = SD ~= ""

    local SF = util.Frame(SC, theme.SurfaceB, 0, UDim2.new(1, 0, 0, hasDesc and 62 or 48))
    util.Corner(SF, 8)
    util.Stroke(SF, theme.Border, 0.55, 1)

    local STL = util.Label(SF, ST, 13, Enum.Font.GothamSemibold, theme.Text)
    STL.Size     = UDim2.new(1, -80, 0, 18)
    STL.Position = UDim2.fromOffset(12, hasDesc and 9 or 8)
    STL.TextYAlignment = Enum.TextYAlignment.Center

    local SVL = util.Label(SF, tostring(val) .. SSuf, 12, Enum.Font.GothamMedium, theme.Accent)
    SVL.Size     = UDim2.new(0, 60, 0, 18)
    SVL.Position = UDim2.new(1, -68, 0, hasDesc and 9 or 8)
    SVL.TextXAlignment = Enum.TextXAlignment.Right
    SVL.TextYAlignment = Enum.TextYAlignment.Center

    if hasDesc then
        local SDL = util.Label(SF, SD, 11, Enum.Font.Gotham, theme.TextSub)
        SDL.Size     = UDim2.new(1, -24, 0, 14)
        SDL.Position = UDim2.fromOffset(12, 26)
        SDL.TextTruncate = Enum.TextTruncate.AtEnd
        SDL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local trackY = hasDesc and 44 or 32

    local STrackBg = util.Frame(SF, theme.SurfaceC, 0, UDim2.new(1, -24, 0, 4))
    STrackBg.Position = UDim2.fromOffset(12, trackY)
    util.Corner(STrackBg, 4)

    local SFill = util.Frame(STrackBg, theme.Accent, 0, UDim2.new((val - SMn) / (SMx - SMn), 0, 1, 0))
    util.Corner(SFill, 4)

    local SKnob = util.Frame(STrackBg, theme.White, 0, UDim2.fromOffset(14, 14))
    SKnob.Position  = UDim2.new((val - SMn) / (SMx - SMn), -7, 0.5, -7)
    SKnob.ZIndex    = 5
    util.Corner(SKnob, 7)
    local SKStr = util.Stroke(SKnob, theme.Accent, 0.25, 2)

    local function SetValue(v)
        v = math.clamp(v, SMn, SMx)
        if SR and SR > 0 then v = math.round(v / SR) * SR end
        val = v
        local pct = (v - SMn) / (SMx - SMn)
        util.Smooth(SFill,  0.10, {Size     = UDim2.new(pct, 0, 1, 0)}):Play()
        util.Smooth(SKnob,  0.10, {Position = UDim2.new(pct, -7, 0.5, -7)}):Play()
        SVL.Text = tostring(v) .. SSuf
        task.spawn(SCB, v)
    end

    local function getPct(posX)
        return math.clamp(
            (posX - STrackBg.AbsolutePosition.X) / STrackBg.AbsoluteSize.X,
            0, 1
        )
    end

    local function beginDrag(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            util.Spring(SKnob,  0.14, {Size = UDim2.fromOffset(18, 18)}):Play()
            util.Smooth(SKStr,  0.14, {Transparency = 0.05}):Play()
            SetValue(SMn + (SMx - SMn) * getPct(i.Position.X))
        end
    end

    STrackBg.InputBegan:Connect(beginDrag)
    SKnob.InputBegan:Connect(beginDrag)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and (
            i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch
        ) then
            SetValue(SMn + (SMx - SMn) * getPct(i.Position.X))
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if dragging and (
            i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch
        ) then
            dragging = false
            util.Smooth(SKnob, 0.14, {Size = UDim2.fromOffset(14, 14)}):Play()
            util.Smooth(SKStr, 0.14, {Transparency = 0.25}):Play()
        end
    end)

    SetValue(val)

    return {
        Frame    = SF,
        SetValue = SetValue,
        GetValue = function() return val end,
    }
end

function Elements.Dropdown(section, cfg)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local DT    = cfg.Title       or "Dropdown"
    local DD    = cfg.Description or ""
    local DV    = cfg.Values      or {}
    local DM    = cfg.Multi       or false
    local DDef  = cfg.Default     or (DM and {} or 1)
    local DCB   = cfg.Callback    or function() end

    local sel = {}
    if DM then
        if type(DDef) == "table" then
            for _, v in pairs(DDef) do sel[v] = true end
        end
    else
        sel = type(DDef) == "number" and (DV[DDef] or DV[1]) or DDef
    end

    local isOpen  = false
    local hasDesc = DD ~= ""
    local baseH   = hasDesc and 56 or 40

    local DF = util.Frame(SC, theme.SurfaceB, 0, UDim2.new(1, 0, 0, baseH))
    DF.ClipsDescendants = true
    util.Corner(DF, 8)
    local DStr = util.Stroke(DF, theme.Border, 0.55, 1)

    local DTL = util.Label(DF, DT, 13, Enum.Font.GothamSemibold, theme.Text)
    DTL.Size     = UDim2.new(1, -44, 0, 18)
    DTL.Position = UDim2.fromOffset(12, hasDesc and 9 or 11)
    DTL.TextYAlignment = Enum.TextYAlignment.Center

    local DChev = util.Label(DF, "⌄", 14, Enum.Font.GothamBold, theme.TextSub)
    DChev.Size     = UDim2.fromOffset(18, 18)
    DChev.Position = UDim2.new(1, -28, 0, hasDesc and 9 or 11)
    DChev.TextXAlignment = Enum.TextXAlignment.Center
    DChev.TextYAlignment = Enum.TextYAlignment.Center

    if hasDesc then
        local DDL = util.Label(DF, DD, 11, Enum.Font.Gotham, theme.TextSub)
        DDL.Size     = UDim2.new(1, -44, 0, 14)
        DDL.Position = UDim2.fromOffset(12, 26)
        DDL.TextTruncate = Enum.TextTruncate.AtEnd
        DDL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local DVL = util.Label(DF, "", 11, Enum.Font.GothamMedium, theme.Accent)
    DVL.Size     = UDim2.new(1, -44, 0, 14)
    DVL.Position = UDim2.fromOffset(12, hasDesc and 40 or 24)
    DVL.TextTruncate = Enum.TextTruncate.AtEnd
    DVL.TextYAlignment = Enum.TextYAlignment.Center

    local DListContainer = util.Frame(DF, theme.Surface, 0, UDim2.new(1, -8, 0, 0))
    DListContainer.Position = UDim2.fromOffset(4, baseH + 4)
    util.Corner(DListContainer, 8)
    util.Stroke(DListContainer, theme.Border, 0.35, 1)

    local DScroll = util.ScrollFrame(DListContainer, theme.BorderHover, 0.40)
    util.Padding(DScroll, 4, 4, 4, 4)
    util.ListLayout(DScroll, Enum.FillDirection.Vertical, 2)

    local DClick = util.Button(DF, 5)
    DClick.Size = UDim2.new(1, 0, 0, baseH)

    local function UpdateLabel()
        if DM then
            local s = {}
            for v, on in pairs(sel) do if on then table.insert(s, v) end end
            if #s == 0 then DVL.Text = "None selected"
            elseif #s == 1 then DVL.Text = s[1]
            else DVL.Text = s[1] .. " +" .. (#s - 1)
            end
        else
            DVL.Text = tostring(sel or "None selected")
        end
    end

    local function ToggleOpen()
        isOpen = not isOpen
        local listH = isOpen and math.min(#DV * 30 + 8, 150) or 0
        util.Smooth(DF,              0.22, {Size = UDim2.new(1, 0, 0, baseH + (isOpen and listH + 8 or 0))}):Play()
        util.Smooth(DListContainer,  0.22, {Size = UDim2.new(1, -8, 0, listH)}):Play()
        util.Smooth(DChev,           0.18, {Rotation = isOpen and 180 or 0}):Play()
        util.Smooth(DStr,            0.16, {Color = isOpen and theme.Accent or theme.Border, Transparency = isOpen and 0.20 or 0.55}):Play()
    end

    DClick.MouseButton1Click:Connect(ToggleOpen)

    local function BuildOptions()
        for _, c in ipairs(DScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        for i, v in ipairs(DV) do
            local active = DM and sel[v] or (not DM and sel == v)
            local OF = util.Frame(DScroll, theme.SurfaceB, active and 0 or 0.60, UDim2.new(1, 0, 0, 28))
            OF.LayoutOrder = i
            util.Corner(OF, 6)

            local OAccent = util.Frame(OF, theme.Accent, active and 0.85 or 1, UDim2.fromOffset(3, 14))
            OAccent.Position = UDim2.new(0, 0, 0.5, -7)
            util.Corner(OAccent, 2)

            local OL = util.Label(OF, v, 12, Enum.Font.GothamMedium, active and theme.Accent or theme.TextSub)
            OL.Size     = UDim2.new(1, -16, 1, 0)
            OL.Position = UDim2.fromOffset(12, 0)
            OL.TextYAlignment = Enum.TextYAlignment.Center

            local OBtn = util.Button(OF, 10)

            OBtn.MouseEnter:Connect(function()
                util.Smooth(OF, 0.10, {BackgroundTransparency = 0.30}):Play()
            end)
            OBtn.MouseLeave:Connect(function()
                util.Smooth(OF, 0.10, {BackgroundTransparency = active and 0 or 0.60}):Play()
            end)

            OBtn.MouseButton1Click:Connect(function()
                if DM then
                    sel[v] = not sel[v]
                    util.Smooth(OL, 0.12, {TextColor3 = sel[v] and theme.Accent or theme.TextSub}):Play()
                    util.Smooth(OAccent, 0.12, {BackgroundTransparency = sel[v] and 0.85 or 1}):Play()
                    UpdateLabel()
                    local s = {}
                    for sv, on in pairs(sel) do if on then table.insert(s, sv) end end
                    task.spawn(DCB, s)
                else
                    sel = v
                    for _, c in ipairs(DScroll:GetChildren()) do
                        if c:IsA("Frame") then
                            local lbl = c:FindFirstChildWhichIsA("TextLabel")
                            local dot = c:FindFirstChild("Frame")
                            if lbl then lbl.TextColor3 = theme.TextSub end
                            if dot then dot.BackgroundTransparency = 1 end
                            util.Smooth(c, 0.10, {BackgroundTransparency = 0.60}):Play()
                        end
                    end
                    util.Smooth(OL, 0.12, {TextColor3 = theme.Accent}):Play()
                    util.Smooth(OAccent, 0.12, {BackgroundTransparency = 0.85}):Play()
                    util.Smooth(OF, 0.10, {BackgroundTransparency = 0}):Play()
                    UpdateLabel()
                    ToggleOpen()
                    task.spawn(DCB, v)
                end
            end)
        end
    end

    BuildOptions()
    UpdateLabel()

    return {
        Frame     = DF,
        SetValue  = function(v)
            if DM then
                sel = {}
                if type(v) == "table" then for _, sv in pairs(v) do sel[sv] = true end end
            else sel = v end
            BuildOptions(); UpdateLabel()
        end,
        SetValues = function(vals)
            DV = vals; BuildOptions(); UpdateLabel()
        end,
        GetValue  = function()
            if DM then
                local s = {}
                for sv, on in pairs(sel) do if on then table.insert(s, sv) end end
                return s
            end
            return sel
        end,
    }
end

function Elements.Input(section, cfg)
    local util  = section.Util
    local theme = section.Theme
    local SC    = section.Content
    local IT    = cfg.Title       or "Input"
    local ID    = cfg.Description or ""
    local IDef  = cfg.Default     or ""
    local IPH   = cfg.Placeholder or "Type here..."
    local INum  = cfg.Numeric     or false
    local IFin  = cfg.Finished    or false
    local ICB   = cfg.Callback    or function() end

    local val     = IDef
    local hasDesc = ID ~= ""

    local IF = util.Frame(SC, theme.SurfaceB, 0, UDim2.new(1, 0, 0, hasDesc and 64 or 48))
    util.Corner(IF, 8)
    local IFStr = util.Stroke(IF, theme.Border, 0.55, 1)

    local ITL = util.Label(IF, IT, 13, Enum.Font.GothamSemibold, theme.Text)
    ITL.Size     = UDim2.new(1, -24, 0, 18)
    ITL.Position = UDim2.fromOffset(12, hasDesc and 8 or 6)
    ITL.TextYAlignment = Enum.TextYAlignment.Center

    if hasDesc then
        local IDL = util.Label(IF, ID, 11, Enum.Font.Gotham, theme.TextSub)
        IDL.Size     = UDim2.new(1, -24, 0, 14)
        IDL.Position = UDim2.fromOffset(12, 24)
        IDL.TextTruncate = Enum.TextTruncate.AtEnd
        IDL.TextYAlignment = Enum.TextYAlignment.Center
    end

    local IBox = Instance.new("TextBox")
    IBox.BackgroundColor3    = theme.SurfaceC
    IBox.BackgroundTransparency = 0
    IBox.BorderSizePixel     = 0
    IBox.Size                = UDim2.new(1, -24, 0, 26)
    IBox.Position            = UDim2.fromOffset(12, hasDesc and 40 or 20)
    IBox.Text                = IDef
    IBox.PlaceholderText     = IPH
    IBox.PlaceholderColor3   = theme.TextMuted
    IBox.TextColor3          = theme.Text
    IBox.TextSize            = 12
    IBox.Font                = Enum.Font.Gotham
    IBox.TextXAlignment      = Enum.TextXAlignment.Left
    IBox.ClearTextOnFocus    = false
    IBox.ZIndex              = 5
    IBox.Parent              = IF
    util.Corner(IBox, 7)
    util.Padding(IBox, 0, 0, 10, 10)
    local IBStr = util.Stroke(IBox, theme.Border, 0.45, 1)

    IBox.Focused:Connect(function()
        util.Smooth(IBStr, 0.16, {Color = theme.Accent, Transparency = 0.10}):Play()
        util.Smooth(IFStr, 0.16, {Color = theme.Accent, Transparency = 0.30}):Play()
    end)
    IBox.FocusLost:Connect(function(enter)
        util.Smooth(IBStr, 0.16, {Color = theme.Border, Transparency = 0.45}):Play()
        util.Smooth(IFStr, 0.16, {Color = theme.Border, Transparency = 0.55}):Play()
        if IFin and enter then
            val = IBox.Text
            task.spawn(ICB, val)
        end
    end)

    if not IFin then
        IBox:GetPropertyChangedSignal("Text"):Connect(function()
            if INum then
                local clean = IBox.Text:gsub("[^%d%.%-]", "")
                if clean ~= IBox.Text then IBox.Text = clean; return end
            end
            val = IBox.Text
            task.spawn(ICB, val)
        end)
    end

    return {
        Frame    = IF,
        SetValue = function(v) IBox.Text = tostring(v); val = tostring(v) end,
        GetValue = function() return val end,
    }
end

return Elements