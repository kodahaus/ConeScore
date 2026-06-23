local _, ns = ...
local addon = ns.addon

local MAX_ROWS = 40
local MAX_VOTE_BUTTONS = 40
local MAIN_WIDTH = 430
local MAIN_HEIGHT = 560
local MIN_WIDTH = 380
local MIN_HEIGHT = 420
local MAX_WIDTH = 920
local MAX_HEIGHT = 760
local ROW_HEIGHT = 18
local ROW_SPACING = 2
local ROW_STEP = ROW_HEIGHT + ROW_SPACING
local FONT_PATH = "Interface\\AddOns\\ConeScore\\Media\\Fonts\\Expressway.ttf"
local ICON_BASE_PATH = "Interface\\AddOns\\ConeScore\\Media\\Icons\\"
local ASSET_BASE_PATH = "Interface\\AddOns\\ConeScore\\Media\\Assets\\"
local SOUND_BASE_PATH = "Interface\\AddOns\\ConeScore\\Media\\Sounds\\"
local RAIDWIDE_SOUND_BASE_PATH = SOUND_BASE_PATH .. "Raidwide Sounds\\"
local RAIDWINNER_SOUND_BASE_PATH = SOUND_BASE_PATH .. "Raidwinner Sounds\\"
local CLOSE_ICON_PATH = ICON_BASE_PATH .. "X"
local ICON_HIDE_NO = ICON_BASE_PATH .. "HideNo"
local ICON_HIDE_YES = ICON_BASE_PATH .. "HideYes"
local ICON_LIST = ICON_BASE_PATH .. "List"
local ICON_LOCKED = ICON_BASE_PATH .. "Locked"
local ICON_UNLOCKED = ICON_BASE_PATH .. "Unlocked"
local ICON_PLUS = ICON_BASE_PATH .. "Plus"
local ICON_MINUS = ICON_BASE_PATH .. "Minus"
local ICON_PIN_YES = ICON_BASE_PATH .. "PinYe"
local ICON_PIN_NO = ICON_BASE_PATH .. "PinNo"
local ICON_PLAY = ICON_BASE_PATH .. "play"
local ICON_POST = ICON_BASE_PATH .. "post"
local ICON_RESET = ICON_BASE_PATH .. "reset"
local ICON_STAR = ICON_BASE_PATH .. "star.tga"
local ICON_STOP = ICON_BASE_PATH .. "stop.tga"
local ICON_CROWN = ICON_BASE_PATH .. "crown.tga"
local ICON_SOUND_YES = ICON_BASE_PATH .. "soundyes"
local ICON_SOUND_NO = ICON_BASE_PATH .. "soundno"
local RAIDWIDE_SOUND_FILES = {
    "anime-wow-sound-effect.mp3",
    "lego-breaking.mp3",
    "lego-yoda-death-sound-effect.mp3",
    "perfect-fart.mp3",
    "spongebob-fail.mp3",
    "vcs-sao-mt-ruim.mp3",
}
local RAIDWINNER_SOUND_FILES = {
    "carnicero-vamos-parar-de-jogar-agora.mp3",
    "eu-nao-acredito-nao-charlene.mp3",
    "fail-sound-effect.mp3",
    "meme-hysterical-laughter.mp3",
    "meninamulher.mp3",
    "o-genetica-ruim.mp3",
    "parabens-viu-seu-coco_rPXxWo0.mp3",
    "parafbens.mp3",
    "risada_carlos_alberto_mp3cut.mp3",
    "sad-trombone-sound-effect-wah-wah-wah-fail-sound-fail-horns.mp3",
    "sujeito-ruim.mp3",
    "tava-ruim-tava-bom-mas-parece-que-piorou_3.mp3",
    "vou-resumir-com-duas-palavras_160k.mp3",
}
local BORDER_COLOR = { 0.96, 0.78, 0.12, 0.85 }
local PANEL_COLOR = { 0.01, 0.01, 0.01, 0.90 }
local SURFACE_COLOR = { 0.04, 0.04, 0.04, 0.88 }
local SURFACE_ALT = { 0.07, 0.07, 0.07, 0.88 }
local MUTED_COLOR = { 0.63, 0.67, 0.72, 1 }
local HIGHLIGHT_COLOR = { 1.00, 0.84, 0.18, 1 }
local ApplyMainLayout
local ApplySummaryLayout
local SetTooltip
local function L(key, ...)
    return addon:L(key, ...)
end
local LOGS_PANEL_WIDTH = 340
local MIN_SUMMARY_WIDTH = 300
local MAX_SUMMARY_WIDTH = 520
local LIVE_REFRESH_INTERVAL = 0.75
local AUTO_SYNC_INTERVAL = 5
local SUMMARY_ROW_HEIGHT = 24
local VOTE_WINDOW_WIDTH_TWO_COLS = 420
local VOTE_WINDOW_WIDTH_THREE_COLS = 620
local VOTE_WINDOW_HEIGHT = 320
local VOTE_SETUP_WIDTH_TWO_COLS = 420
local VOTE_SETUP_WIDTH_THREE_COLS = 620
local VOTE_SETUP_HEIGHT = 380
local VOTE_RESULTS_WIDTH = 360
local VOTE_RESULTS_HEIGHT = 320
local DAILY_TOAST_WIDTH = 322
local DAILY_TOAST_HEIGHT = 192
local WINNER_TOAST_WIDTH = 430
local WINNER_TOAST_HEIGHT = 250

local function AttachWindowIntroAnimation(frame, offsetX, offsetY, duration)
    if not frame or frame._introAnimationAttached then
        return
    end

    local intro = frame:CreateAnimationGroup()
    intro:SetToFinalAlpha(true)

    local alpha = intro:CreateAnimation("Alpha")
    alpha:SetOrder(1)
    alpha:SetFromAlpha(0)
    alpha:SetToAlpha(1)
    alpha:SetDuration(duration or 0.18)
    alpha:SetSmoothing("OUT")

    local translation = intro:CreateAnimation("Translation")
    translation:SetOrder(1)
    translation:SetOffset(offsetX or 0, offsetY or 4)
    translation:SetDuration(duration or 0.22)
    translation:SetSmoothing("OUT")

    intro:SetScript("OnPlay", function()
        frame:SetAlpha(0)
    end)

    intro:SetScript("OnFinished", function()
        frame:SetAlpha(1)
    end)

    frame._introAnimation = intro
    frame._introAnimationAttached = true
    frame:HookScript("OnShow", function(self)
        if self._introAnimation then
            self._introAnimation:Stop()
            self:SetAlpha(0)
            self._introAnimation:Play()
        end
    end)
end

local function UpdateAccentColor()
    local _, classFile = UnitClass("player")
    local color = classFile and RAID_CLASS_COLORS[classFile]
    if color then
        BORDER_COLOR[1] = color.r
        BORDER_COLOR[2] = color.g
        BORDER_COLOR[3] = color.b
    else
        BORDER_COLOR[1] = 0.96
        BORDER_COLOR[2] = 0.78
        BORDER_COLOR[3] = 0.12
    end
end

local function GetPlayerClassColor()
    local _, classFile = UnitClass("player")
    local color = classFile and RAID_CLASS_COLORS[classFile]
    if color then
        return color.r, color.g, color.b
    end

    return BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3]
end

local function GetFontPath()
    if type(SharedMedia) == "table" and type(SharedMedia.Fetch) == "function" then
        local ok, path = pcall(SharedMedia.Fetch, SharedMedia, "font", "Expressway")
        if ok and path and path ~= "" then
            return path
        end
    end

    return FONT_PATH
end

local function ApplyFont(fontString, size, style, r, g, b, a)
    fontString:SetFont(GetFontPath(), size, style or "")
    if r then
        fontString:SetTextColor(r, g, b, a or 1)
    end
end

local function CreateFlatPanel(frame, bgColor, borderColor)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(unpack(bgColor or PANEL_COLOR))
    frame:SetBackdropBorderColor(unpack(borderColor or BORDER_COLOR))
end

local function EnsureRoundedFrameFill(target, inset)
    if not target then
        return
    end

    inset = tonumber(inset) or 16
    if target._roundedPieces and target._roundedInset == inset then
        return
    end

    target._roundedInset = inset

    if not target._roundedMid then
        target._roundedMid = target:CreateTexture(nil, "ARTWORK")
        target._roundedLeftTop = target:CreateTexture(nil, "ARTWORK")
        target._roundedLeftBottom = target:CreateTexture(nil, "ARTWORK")
        target._roundedRightTop = target:CreateTexture(nil, "ARTWORK")
        target._roundedRightBottom = target:CreateTexture(nil, "ARTWORK")
        target._roundedLeftEdge = target:CreateTexture(nil, "ARTWORK")
        target._roundedRightEdge = target:CreateTexture(nil, "ARTWORK")

        target._roundedMid:SetTexture(ASSET_BASE_PATH .. "mid_frame.tga")
        target._roundedLeftTop:SetTexture(ASSET_BASE_PATH .. "left_rounded_cap_top.tga")
        target._roundedLeftBottom:SetTexture(ASSET_BASE_PATH .. "left_rounded_cap_bottom.tga")
        target._roundedRightTop:SetTexture(ASSET_BASE_PATH .. "right_rounded_cap_top.tga")
        target._roundedRightBottom:SetTexture(ASSET_BASE_PATH .. "right_rounded_cap_bottom.tga")
        target._roundedLeftEdge:SetTexture(ASSET_BASE_PATH .. "edge_fill.tga")
        target._roundedRightEdge:SetTexture(ASSET_BASE_PATH .. "edge_fill.tga")

        target._roundedPieces = {
            target._roundedMid,
            target._roundedLeftTop,
            target._roundedLeftBottom,
            target._roundedRightTop,
            target._roundedRightBottom,
            target._roundedLeftEdge,
            target._roundedRightEdge,
        }
    end

    local height = target:GetHeight() or 24
    local cornerSize = math.max(1, math.min(inset, math.floor(height / 2)))
    local edgeH = math.max(1, height - (cornerSize * 2))

    target._roundedMid:ClearAllPoints()
    target._roundedMid:SetPoint("TOPLEFT", target, "TOPLEFT", inset, 0)
    target._roundedMid:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -inset, 0)

    target._roundedLeftTop:ClearAllPoints()
    target._roundedLeftTop:SetSize(inset, cornerSize)
    target._roundedLeftTop:SetPoint("TOPLEFT", target, "TOPLEFT", 0, 0)

    target._roundedLeftBottom:ClearAllPoints()
    target._roundedLeftBottom:SetSize(inset, cornerSize)
    target._roundedLeftBottom:SetPoint("BOTTOMLEFT", target, "BOTTOMLEFT", 0, 0)

    target._roundedRightTop:ClearAllPoints()
    target._roundedRightTop:SetSize(inset, cornerSize)
    target._roundedRightTop:SetPoint("TOPRIGHT", target, "TOPRIGHT", 0, 0)

    target._roundedRightBottom:ClearAllPoints()
    target._roundedRightBottom:SetSize(inset, cornerSize)
    target._roundedRightBottom:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", 0, 0)

    target._roundedLeftEdge:ClearAllPoints()
    target._roundedLeftEdge:SetSize(inset, edgeH)
    target._roundedLeftEdge:SetPoint("TOPLEFT", target._roundedLeftTop, "BOTTOMLEFT", 0, 0)
    target._roundedLeftEdge:SetPoint("BOTTOMLEFT", target._roundedLeftBottom, "TOPLEFT", 0, 0)

    target._roundedRightEdge:ClearAllPoints()
    target._roundedRightEdge:SetSize(inset, edgeH)
    target._roundedRightEdge:SetPoint("TOPRIGHT", target._roundedRightTop, "BOTTOMRIGHT", 0, 0)
    target._roundedRightEdge:SetPoint("BOTTOMRIGHT", target._roundedRightBottom, "TOPRIGHT", 0, 0)

    for _, piece in ipairs(target._roundedPieces) do
        piece:Show()
    end
end

local function TintRoundedFrameFill(target, r, g, b, a)
    if not target or not target._roundedPieces then
        return
    end

    for _, piece in ipairs(target._roundedPieces) do
        piece:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
    end
end

local function HideNativeBackdropPieces(target)
    if not target then
        return
    end

    local pieces = {
        "TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner",
        "TopEdge", "BottomEdge", "LeftEdge", "RightEdge", "Center",
    }

    for _, key in ipairs(pieces) do
        local piece = target[key]
        if piece then
            piece:SetAlpha(0)
            piece:Hide()
        end
    end
end

local function ApplyRoundedWindowTheme(frame, inset, color)
    if not frame then
        return
    end

    local tint = color or { 0.02, 0.02, 0.03, 0.98 }
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0, 0)
    EnsureRoundedFrameFill(frame, inset or 16)
    TintRoundedFrameFill(frame, tint[1], tint[2], tint[3], tint[4])
    HideNativeBackdropPieces(frame)
end

local function StyleRoundedAccentButton(button, width, height, label)
    if not button then
        return
    end

    local baseR, baseG, baseB, baseA = 0.07, 0.09, 0.11, 0.96
    local hoverR, hoverG, hoverB, hoverA = 0.11, 0.14, 0.17, 0.99

    button:SetSize(width, height)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    button:SetBackdropColor(0, 0, 0, 0)
    button:SetBackdropBorderColor(0, 0, 0, 0)
    button:SetHighlightTexture("")
    button:SetPushedTextOffset(0, 0)
    button:SetText(label or "")
    EnsureRoundedFrameFill(button, 10)
    TintRoundedFrameFill(button, baseR, baseG, baseB, baseA)
    HideNativeBackdropPieces(button)

    local text = button:GetFontString()
    if text then
        ApplyFont(text, 12, "", 1, 0.90, 0.30, 1)
    end

    button._roundedBaseTint = { baseR, baseG, baseB, baseA }
    button._roundedHoverTint = { hoverR, hoverG, hoverB, hoverA }

    button:SetScript("OnEnter", function(self)
        local tint = self._roundedHoverTint or self._roundedBaseTint
        TintRoundedFrameFill(self, tint[1], tint[2], tint[3], tint[4])
        if self.leadingIcon then
            self.leadingIcon:SetVertexColor(1, 0.96, 0.50, 1)
        end
    end)

    button:SetScript("OnLeave", function(self)
        local tint = self._roundedBaseTint
        if tint then
            TintRoundedFrameFill(self, tint[1], tint[2], tint[3], tint[4])
        end
        if self.leadingIcon then
            self.leadingIcon:SetVertexColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
        end
    end)
end

local function StyleRoundedHeaderBand(frame)
    if not frame then
        return
    end

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0, 0)
    EnsureRoundedFrameFill(frame, 10)
    TintRoundedFrameFill(frame, 0.10, 0.11, 0.13, 0.98)
    HideNativeBackdropPieces(frame)
end

local function StyleVotePlayerButton(button, width, height)
    if not button then
        return
    end

    button:SetSize(width, height)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    button:SetBackdropColor(0, 0, 0, 0)
    button:SetBackdropBorderColor(0, 0, 0, 0)
    button:SetHighlightTexture("")
    button:SetPushedTextOffset(0, 0)
    button:SetText("")
    EnsureRoundedFrameFill(button, 8)
    HideNativeBackdropPieces(button)
    TintRoundedFrameFill(button, 0.08, 0.09, 0.11, 0.94)
end

local function SetVotePlayerButtonTint(button, classFile, hovered)
    if not button then
        return
    end

    local baseR, baseG, baseB = 0.07, 0.08, 0.10
    local alpha = hovered and 0.99 or 0.95
    local lift = hovered and 0.04 or 0

    TintRoundedFrameFill(
        button,
        math.min(1, baseR + lift),
        math.min(1, baseG + lift),
        math.min(1, baseB + lift),
        alpha
    )
end

local function CreateColorCheckbox(parent, size)
    local box = CreateFrame("Button", nil, parent, "BackdropTemplate")
    box:SetSize(size or 14, size or 14)
    box:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    box:SetBackdropColor(0.03, 0.03, 0.04, 0.96)
    box:SetBackdropBorderColor(0.18, 0.18, 0.20, 1)

    box.fill = box:CreateTexture(nil, "ARTWORK")
    box.fill:SetPoint("TOPLEFT", 2, -2)
    box.fill:SetPoint("BOTTOMRIGHT", -2, 2)
    box.fill:SetTexture("Interface\\Buttons\\WHITE8X8")
    box.fill:Hide()

    function box:SetChecked(checked)
        self.checked = checked and true or false
        if self.checked then
            self.fill:Show()
        else
            self.fill:Hide()
        end
    end

    function box:GetChecked()
        return self.checked and true or false
    end

    function box:SetTint(r, g, b)
        self.fill:SetVertexColor(r or HIGHLIGHT_COLOR[1], g or HIGHLIGHT_COLOR[2], b or HIGHLIGHT_COLOR[3], 0.95)
    end

    box:SetChecked(false)
    box:SetTint(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3])
    return box
end

local function CreateAccent(parent, height, alpha)
    local accent = parent:CreateTexture(nil, "ARTWORK")
    accent:SetTexture("Interface\\Buttons\\WHITE8X8")
    accent:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], alpha or 0.16)
    accent:SetPoint("TOPLEFT", 1, -1)
    accent:SetPoint("TOPRIGHT", -1, -1)
    accent:SetHeight(height)
    return accent
end

local function StyleFlatButton(button, width, height, label, isAccent)
    button:SetSize(width, height)
    CreateFlatPanel(button, isAccent and { 0.09, 0.09, 0.09, 0.94 } or { 0.04, 0.04, 0.04, 0.94 }, isAccent and BORDER_COLOR or { 0.16, 0.16, 0.16, 1 })
    button:SetHighlightTexture("")
    button:SetPushedTextOffset(0, 0)
    button:SetText(label)

    local text = button:GetFontString()
    if text then
        ApplyFont(text, 12, "", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
    end

    button:SetScript("OnEnter", function(self)
        local bg = isAccent and { 0.14, 0.14, 0.14, 0.98 } or { 0.09, 0.09, 0.09, 0.98 }
        self:SetBackdropColor(unpack(bg))
    end)

    button:SetScript("OnLeave", function(self)
        local bg = isAccent and { 0.09, 0.09, 0.09, 0.94 } or { 0.04, 0.04, 0.04, 0.94 }
        self:SetBackdropColor(unpack(bg))
    end)
end

local function StyleIconButton(button, width, height, texturePath)
    button:SetSize(width, height)
    button:SetBackdrop(nil)
    button:SetHighlightTexture("")
    button:SetText("")

    button.icon = button.icon or button:CreateTexture(nil, "ARTWORK")
    button.icon:SetPoint("CENTER")
    button.icon:SetSize(math.max(10, width - 8), math.max(10, height - 8))
    button.icon:SetTexture(texturePath)
    button.icon:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 1)

    button:SetScript("OnEnter", function(self)
        if self.icon then
            self.icon:SetVertexColor(1, 1, 1, 1)
        end
    end)

    button:SetScript("OnLeave", function(self)
        if self.icon then
            self.icon:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 1)
        end
    end)
end

local function StyleMiniButton(button, label)
    StyleFlatButton(button, 24, 22, label, false)
end

local function SetButtonIcon(button, texturePath, iconSize, useHighlightColor)
    if not button then
        return
    end

    button:SetText("")
    button:SetBackdrop(nil)
    button:SetHighlightTexture("")
    button:SetPushedTextOffset(0, 0)
    button.icon = button.icon or button:CreateTexture(nil, "ARTWORK")
    button.icon:ClearAllPoints()
    button.icon:SetPoint("CENTER")
    button.icon:SetSize(iconSize or 12, iconSize or 12)
    button.icon:SetTexture(texturePath)

    local baseR, baseG, baseB
    if useHighlightColor then
        baseR, baseG, baseB = HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3]
    else
        baseR, baseG, baseB = BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3]
    end
    button.icon:SetVertexColor(baseR, baseG, baseB, 1)

    if not button._coneIconHoverStyled then
        button:SetScript("OnEnter", function(self)
            if self.icon then
                self.icon:SetVertexColor(1, 1, 1, 1)
            end
        end)

        button:SetScript("OnLeave", function(self)
            if self.icon then
                local color = self._coneIconBaseColor or HIGHLIGHT_COLOR
                self.icon:SetVertexColor(color[1], color[2], color[3], 1)
            end
        end)

        button._coneIconHoverStyled = true
    end

    button._coneIconBaseColor = { baseR, baseG, baseB }
end

local function SetButtonLeadingIcon(button, texturePath, iconSize)
    if not button then
        return
    end

    local text = button:GetFontString()
    button.leadingIcon = button.leadingIcon or button:CreateTexture(nil, "ARTWORK")
    button.leadingIcon:ClearAllPoints()
    button.leadingIcon:SetPoint("LEFT", 8, 0)
    button.leadingIcon:SetSize(iconSize or 12, iconSize or 12)
    button.leadingIcon:SetTexture(texturePath)
    if button.leadingIcon.SetDesaturated then
        button.leadingIcon:SetDesaturated(true)
    end
    button.leadingIcon:SetVertexColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
    button.leadingIcon:SetBlendMode("ADD")
    if text then
        text:ClearAllPoints()
        text:SetPoint("LEFT", button.leadingIcon, "RIGHT", 6, 0)
        text:SetPoint("RIGHT", -8, 0)
    end
end

local function AttachButtonTooltip(button, title, lines)
    button:HookScript("OnEnter", function(self)
        SetTooltip(self, title, lines)
    end)
    button:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function CreateSectionLabel(parent, text)
    local label = parent:CreateFontString(nil, "OVERLAY")
    ApplyFont(label, 11, "OUTLINE", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    label:SetText(text)
    return label
end

local function StyleFlatEditBox(editBox, width, height)
    editBox:SetSize(width, height)
    CreateFlatPanel(editBox, { 0.03, 0.03, 0.03, 0.92 }, { 0.16, 0.16, 0.16, 1 })
    editBox:SetAutoFocus(false)
    editBox:SetTextInsets(8, 8, 0, 0)
    editBox:SetFont(GetFontPath(), 12, "")
    editBox:SetTextColor(0.92, 0.93, 0.95, 1)
end

local function AttachPlaceholder(editBox, text)
    local placeholder = editBox:CreateFontString(nil, "OVERLAY")
    placeholder:SetPoint("LEFT", 8, 0)
    placeholder:SetPoint("RIGHT", -8, 0)
    placeholder:SetJustifyH("LEFT")
    ApplyFont(placeholder, 12, "", 0.48, 0.52, 0.58, 1)
    placeholder:SetText(text)
    editBox.placeholder = placeholder

    local function RefreshPlaceholder()
        local current = editBox:GetText()
        placeholder:SetShown(not current or current == "")
    end

    editBox:SetScript("OnTextChanged", RefreshPlaceholder)
    editBox:SetScript("OnEditFocusGained", RefreshPlaceholder)
    editBox:SetScript("OnEditFocusLost", RefreshPlaceholder)
    RefreshPlaceholder()
end

local function CreateResizeHandle(frame)
    frame:SetResizable(true)

    local handle = CreateFrame("Button", nil, frame, "BackdropTemplate")
    handle:SetSize(18, 18)
    handle:SetPoint("BOTTOMRIGHT", -4, 4)
    handle:EnableMouse(true)

    handle.texture = handle:CreateTexture(nil, "OVERLAY")
    handle.texture:SetAllPoints()
    handle.texture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    handle.texture:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.95)

    handle:SetScript("OnMouseDown", function()
        local ui = addon.GetUIState and addon:GetUIState() or {}
        if ui.locked then
            return
        end
        frame:StartSizing("BOTTOMRIGHT")
    end)
    handle:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
        if addon.SaveMainWindowState then
            addon:SaveMainWindowState()
        end
        if addon.RefreshUI then
            addon:RefreshUI()
        end
    end)

    frame:SetScript("OnSizeChanged", function(self, width, height)
        local clampedWidth = math.max(MIN_WIDTH, math.min(MAX_WIDTH, width or MIN_WIDTH))
        local clampedHeight = math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, height or MIN_HEIGHT))
        if clampedWidth ~= width or clampedHeight ~= height then
            self:SetSize(clampedWidth, clampedHeight)
            return
        end

        if self.layoutFunc then
            self.layoutFunc(self)
        end

        if self.refreshFunc then
            self.refreshFunc(addon)
        end

        if addon.SaveMainWindowState and self == addon.mainWindow then
            addon:SaveMainWindowState()
        end
    end)

    frame.resizeHandle = handle
end

local function CreateWidthResizeHandle(frame, minWidth, maxWidth)
    local handle = CreateFrame("Button", nil, frame, "BackdropTemplate")
    handle:SetSize(18, 18)
    handle:SetPoint("BOTTOMRIGHT", -4, 4)
    handle:EnableMouse(true)

    handle.texture = handle:CreateTexture(nil, "OVERLAY")
    handle.texture:SetAllPoints()
    handle.texture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    handle.texture:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.95)

    handle:SetScript("OnMouseDown", function(self)
        local scale = UIParent:GetScale()
        local cursorX = GetCursorPosition()
        self.dragOriginX = cursorX / scale
        self.startWidth = frame:GetWidth()
        frame:SetScript("OnUpdate", function(resizedFrame)
            local currentCursorX = GetCursorPosition() / scale
            local nextWidth = math.max(minWidth, math.min(maxWidth, self.startWidth + (currentCursorX - self.dragOriginX)))
            resizedFrame:SetWidth(nextWidth)
            if resizedFrame.layoutFunc then
                resizedFrame.layoutFunc(resizedFrame)
            end
            if resizedFrame.refreshFunc then
                resizedFrame.refreshFunc(addon)
            end
        end)
    end)

    handle:SetScript("OnMouseUp", function()
        frame:SetScript("OnUpdate", nil)
        if addon.SaveSummaryWindowState then
            addon:SaveSummaryWindowState()
        end
        if addon.RefreshSummaryUI then
            addon:RefreshSummaryUI()
        end
    end)

    frame.resizeHandle = handle
end

local function GetClassColor(classFile)
    if not classFile then
        return 0.92, 0.93, 0.95
    end

    local color = RAID_CLASS_COLORS[classFile]
    if color then
        return color.r, color.g, color.b
    end

    return 0.92, 0.93, 0.95
end

local function ColorizeName(name, classFile)
    local r, g, b = GetClassColor(classFile)
    return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, tostring(name or "?"))
end

local function ApplyToastEntry(textObject, entry, rankLabel)
    if not textObject then
        return
    end

    if not entry then
        textObject:SetText("")
        return
    end

    textObject:SetText(string.format("%s %s  |cffffd54f%d|r", rankLabel or "", ColorizeName(entry.shortName or entry.name, entry.classFile), entry.score or 0))
end

local function IsLocalPlayerName(fullName)
    local localPlayer = addon.NormalizeName and addon:NormalizeName(GetUnitName("player", true)) or nil
    local targetPlayer = addon.NormalizeName and addon:NormalizeName(fullName) or fullName
    return localPlayer and targetPlayer and localPlayer == targetPlayer
end

local function PickRandomSoundFile(fileList)
    if not fileList or #fileList == 0 then
        return nil
    end

    return fileList[random(#fileList)]
end

local function BuildRaidwideSoundPath(fileName)
    if not fileName or fileName == "" then
        return nil
    end

    return RAIDWIDE_SOUND_BASE_PATH .. fileName
end

local function BuildWinnerSoundPath(fileName)
    if not fileName or fileName == "" then
        return nil
    end

    return RAIDWINNER_SOUND_BASE_PATH .. fileName
end

function addon:GetRandomRaidwideSoundFile()
    return PickRandomSoundFile(RAIDWIDE_SOUND_FILES)
end

function addon:GetRandomWinnerSoundPath()
    local fileName = PickRandomSoundFile(RAIDWINNER_SOUND_FILES)
    return BuildWinnerSoundPath(fileName)
end

function addon:IsSoundEnabled()
    local ui = self:GetUIState()
    return ui.soundEnabled ~= false
end

function addon:ToggleSoundEnabled()
    local ui = self:GetUIState()
    ui.soundEnabled = not (ui.soundEnabled ~= false)
    self:RequestRefresh()
end

local function SortLogPlayers(players)
    table.sort(players, function(a, b)
        if (a.score or 0) == (b.score or 0) then
            if (a.group or 0) == (b.group or 0) then
                return (a.shortName or a.name or "") < (b.shortName or b.name or "")
            end
            return (a.group or 0) < (b.group or 0)
        end
        return (a.score or 0) > (b.score or 0)
    end)
    return players
end

local function ClonePlayers(players)
    local cloned = {}
    for i, player in ipairs(players or {}) do
        if (player.score or 0) > 0 then
            cloned[#cloned + 1] = {
                name = player.name,
                shortName = player.shortName,
                score = player.score,
                group = player.group,
                classFile = player.classFile,
                note = player.note,
            }
        end
    end
    return cloned
end

local function GetDisplayRoster(viewMode)
    local roster = {}
    local ui = addon.GetUIState and addon:GetUIState() or {}
    local sortMode = ui.sortMode or "group"
    local showZeroScores
    if viewMode == "pinned" then
        showZeroScores = ui.showZeroScoresPinned
    else
        showZeroScores = ui.showZeroScoresMain
    end

    if showZeroScores == nil then
        showZeroScores = ui.showZeroScores
    end
    if showZeroScores == nil then
        showZeroScores = true
    end

    for _, member in ipairs(addon:GetRoster() or {}) do
        local score = addon:GetScore(member.name)
        if showZeroScores or (score and score > 0) then
            roster[#roster + 1] = {
                unit = member.unit,
                name = member.name,
                group = member.group,
                classFile = member.classFile,
                score = score,
            }
        end
    end

    table.sort(roster, function(a, b)
        if viewMode == "pinned" then
            if (a.score or 0) == (b.score or 0) then
                return (a.name or "") < (b.name or "")
            end
            return (a.score or 0) > (b.score or 0)
        end

        if sortMode == "score" then
            if (a.score or 0) == (b.score or 0) then
                return (a.name or "") < (b.name or "")
            end
            return (a.score or 0) > (b.score or 0)
        end

        if sortMode == "alpha" then
            return (a.name or "") < (b.name or "")
        end

        if sortMode == "class" then
            if (a.classFile or "") == (b.classFile or "") then
                return (a.name or "") < (b.name or "")
            end
            return (a.classFile or "") < (b.classFile or "")
        end

        if (a.group or 0) == (b.group or 0) then
            return (a.name or "") < (b.name or "")
        end
        return (a.group or 0) < (b.group or 0)
    end)

    return roster
end

local function ApplyWindowScale(frame)
    if not frame then
        return
    end

    local ui = addon.GetUIState and addon:GetUIState() or {}
    local scale = tonumber(ui.windowScale) or 1
    if scale < 0.8 then
        scale = 0.8
    elseif scale > 1.3 then
        scale = 1.3
    end

    frame:SetScale(scale)
    if addon.configWindow then
        addon.configWindow:SetScale(scale)
    end
    if addon.pinnedWindow then
        addon.pinnedWindow:SetScale(scale)
    end
end

local function GetNameSortLabel(sortMode)
    if sortMode == "alpha" then
        return L("sort_player_alpha")
    end
    if sortMode == "class" then
        return L("sort_player_class")
    end
    return L("sort_player")
end

local function LayoutFooterButtons(frame, canControlVote, officer)
    if not frame or not frame.footer then
        return
    end

    frame.logsToggleButton:ClearAllPoints()
    frame.logsToggleButton:SetPoint("LEFT", frame.footer, "LEFT", 0, 0)

    frame.scaleUpButton:ClearAllPoints()
    frame.scaleUpButton:SetPoint("RIGHT", frame.footer, "RIGHT", 0, 0)

    frame.scaleDownButton:ClearAllPoints()
    frame.scaleDownButton:SetPoint("RIGHT", frame.scaleUpButton, "LEFT", -4, 0)

    frame.scaleLabel:ClearAllPoints()
    frame.scaleLabel:SetPoint("RIGHT", frame.scaleDownButton, "LEFT", -8, 0)
    frame.scaleLabel:SetPoint("LEFT", frame.footer, "LEFT", 0, 0)

    local previous = frame.logsToggleButton

    if canControlVote then
        frame.voteButton:ClearAllPoints()
        frame.voteButton:SetPoint("LEFT", previous, "RIGHT", 10, 0)
        previous = frame.voteButton
    end

    if officer then
        frame.postButton:ClearAllPoints()
        frame.postButton:SetPoint("LEFT", previous, "RIGHT", 8, 0)
        previous = frame.postButton

        frame.filterButton:ClearAllPoints()
        frame.filterButton:SetPoint("LEFT", previous, "RIGHT", 8, 0)
        previous = frame.filterButton

        frame.resetButton:ClearAllPoints()
        frame.resetButton:SetPoint("LEFT", previous, "RIGHT", 8, 0)
    end
end

local function ApplyPinnedWindowStyle(frame, enabled)
    if not frame then
        return
    end

    if enabled then
        frame:EnableMouse(false)
        frame:SetBackdropColor(0, 0, 0, 0)
        frame:SetBackdropBorderColor(0, 0, 0, 0)
        TintRoundedFrameFill(frame, 0.02, 0.02, 0.03, 0)
        if frame.headerBand then
            frame.headerBand:Hide()
        end
        if frame.title then
            frame.title:Hide()
        end
        if frame.userHint then
            frame.userHint:Hide()
        end
        if frame.voteHint then
            frame.voteHint:Hide()
        end
        if frame.footer then
            frame.footer:Hide()
        end
        if frame.coneLogButton then
            frame.coneLogButton:Hide()
        end
        if frame.close then
            frame.close:Hide()
        end
        if frame.resizeHandle then
            frame.resizeHandle:Hide()
        end
        if frame.scrollBar then
            frame.scrollBar:Hide()
        end
        if frame.content then
            frame.content:ClearAllPoints()
            frame.content:SetPoint("TOPLEFT", 8, -8)
            frame.content:SetPoint("BOTTOMRIGHT", -8, 8)
        end
        if addon.summaryWindow then
            addon.summaryWindow:Hide()
        end
        if addon.configWindow then
            addon.configWindow:Hide()
        end
    else
        frame:EnableMouse(true)
        ApplyRoundedWindowTheme(frame, 16)
        if frame.headerBand then
            frame.headerBand:Show()
        end
        if frame.title then
            frame.title:Show()
        end
        if frame.footer then
            frame.footer:Show()
        end
        if frame.close then
            frame.close:Show()
        end
        if frame.resizeHandle then
            frame.resizeHandle:Show()
        end
        if frame.content then
            frame.content:ClearAllPoints()
            frame.content:SetPoint("TOPLEFT", 14, -92)
            frame.content:SetPoint("BOTTOMRIGHT", -18, 42)
        end
    end
end

SetTooltip = function(owner, title, lines)
    if not owner then
        return
    end

    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    if title and title ~= "" then
        GameTooltip:AddLine(title, 1, 1, 1)
    end

    for _, line in ipairs(lines or {}) do
        GameTooltip:AddLine(line, 0.80, 0.83, 0.88, true)
    end

    GameTooltip:Show()
end

local function GetVoteGroups(eligibleSet)
    local grouped = {}
    local highestGroup = 0

    for _, member in ipairs(addon:GetRoster() or {}) do
        if not eligibleSet or eligibleSet[member.name] then
        local groupId = member.group or 0
        if groupId > highestGroup then
            highestGroup = groupId
        end
        grouped[groupId] = grouped[groupId] or {}
        grouped[groupId][#grouped[groupId] + 1] = member
        end
    end

    local ordered = {}
    for groupId = 1, highestGroup do
        if grouped[groupId] and #grouped[groupId] > 0 then
            ordered[#ordered + 1] = {
                group = groupId,
                members = grouped[groupId],
            }
        end
    end

    if grouped[0] and #grouped[0] > 0 then
        ordered[#ordered + 1] = {
            group = 0,
            members = grouped[0],
        }
    end

    return ordered
end

local function SetRowBackground(row, colorTable)
    row.bg:SetColorTexture(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
end

ApplyMainLayout = function(frame)
    if not frame or not frame.content then
        return
    end

    local ui = addon.GetUIState and addon:GetUIState() or {}
    local pinned = ui.pinnedMode and true or false
    local contentWidth = math.max(MIN_WIDTH - 36, frame.content:GetWidth() or (MAIN_WIDTH - 36))
    local buttonWidth = 20
    local buttonGap = 4
    local rightPadding = pinned and 2 or 4
    local nameLeft = 12
    local plusLeft
    local minusLeft
    local scoreLeft
    local nameWidth

    if pinned then
        plusLeft = contentWidth - buttonWidth - rightPadding
        minusLeft = plusLeft - buttonWidth - buttonGap
        nameWidth = math.max(72, math.min(118, contentWidth - 72))
        scoreLeft = nameLeft + nameWidth + 2
    else
        plusLeft = contentWidth - buttonWidth - rightPadding
        minusLeft = plusLeft - buttonWidth - buttonGap
        scoreLeft = minusLeft - 34
        nameWidth = math.max(118, scoreLeft - nameLeft - 10)
    end

    frame.headerScore:ClearAllPoints()
    frame.headerScore:SetPoint("LEFT", scoreLeft - 2, 0)
    frame.headerNameButton:ClearAllPoints()
    frame.headerNameButton:SetPoint("TOPLEFT", frame.headerBand, "TOPLEFT", 0, 0)
    frame.headerNameButton:SetPoint("BOTTOMLEFT", frame.headerBand, "BOTTOMLEFT", 0, 0)
    frame.headerNameButton:SetWidth(scoreLeft - 8)
    frame.headerScoreButton:ClearAllPoints()
    frame.headerScoreButton:SetPoint("TOPLEFT", frame.headerBand, "TOPLEFT", scoreLeft - 10, 0)
    frame.headerScoreButton:SetPoint("BOTTOMRIGHT", frame.headerBand, "BOTTOMRIGHT", 0, 0)

    for _, row in ipairs(frame.rows or {}) do
        row:SetWidth(contentWidth)

        row.divider:ClearAllPoints()
        row.divider:SetPoint("TOPLEFT", 0, 0)
        row.divider:SetPoint("TOPRIGHT", 0, 0)

        row.name:ClearAllPoints()
        row.name:SetPoint("LEFT", nameLeft, 0)
        row.name:SetWidth(nameWidth)

        row.score:ClearAllPoints()
        row.score:SetPoint("LEFT", scoreLeft, 0)
        row.score:SetWidth(pinned and 26 or 32)
        row.score:SetJustifyH(pinned and "LEFT" or "CENTER")

        row.minus:ClearAllPoints()
        row.minus:SetPoint("LEFT", minusLeft, 0)

        row.plus:ClearAllPoints()
        row.plus:SetPoint("LEFT", plusLeft, 0)
    end
end

ApplySummaryLayout = function(frame)
    if not frame or not frame.content then
        return
    end

    local contentWidth = math.max(320, frame.content:GetWidth() or 320)
    for _, row in ipairs(frame.rows or {}) do
        row:SetWidth(contentWidth)
    end
end

function addon:BuildMainWindow()
    UpdateAccentColor()
    local ui = self:GetUIState()
    local mainState = ui.main or {}

    local frame = CreateFrame("Frame", "ConeScoreMainFrame", UIParent, "BackdropTemplate")
    frame:SetSize(mainState.width or MAIN_WIDTH, mainState.height or MAIN_HEIGHT)
    frame:SetPoint(mainState.point or "CENTER", UIParent, mainState.relativePoint or mainState.point or "CENTER", mainState.x or 0, mainState.y or 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        local uiState = addon:GetUIState()
        if uiState.locked then
            return
        end
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        addon:SaveMainWindowState()
    end)
    frame:Hide()
    frame.liveRefreshElapsed = 0
    frame.autoSyncElapsed = 0
    frame.layoutFunc = ApplyMainLayout
    frame.refreshFunc = addon.RefreshUI
    CreateResizeHandle(frame)
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 18, "OUTLINE", 1, 1, 1, 1)
    do
        local r, g, b = GetPlayerClassColor()
        frame.title:SetText(string.format("|cff%02x%02x%02xCone|rScore", r * 255, g * 255, b * 255))
    end

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 22, 22, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        frame:Hide()
    end)

    frame.soundButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.soundButton:SetPoint("RIGHT", frame.close, "LEFT", -8, 0)
    StyleMiniButton(frame.soundButton, "S")
    frame.soundButton:SetBackdrop(nil)
    frame.soundButton:SetHighlightTexture("")
    frame.soundButton:SetPushedTextOffset(0, 0)
    SetButtonIcon(frame.soundButton, ICON_SOUND_YES, 12, true)
    frame.soundButton:SetScript("OnClick", function()
        addon:ToggleSoundEnabled()
    end)
    AttachButtonTooltip(frame.soundButton, L("tooltip_sound"), {
        L("tooltip_sound_desc"),
    })

    frame.pinButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.pinButton:SetPoint("RIGHT", frame.soundButton, "LEFT", -8, 0)
    StyleMiniButton(frame.pinButton, "P")
    SetButtonIcon(frame.pinButton, ICON_PIN_NO, 12, true)
    frame.pinButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        uiState.pinnedMode = true
        addon:SaveMainWindowState()
        if addon.mainWindow then
            addon.mainWindow:Hide()
        end
        if addon.pinnedWindow then
            addon.pinnedWindow.userHidden = false
            addon:RefreshPinnedWindow(true)
        end
    end)
    AttachButtonTooltip(frame.pinButton, L("tooltip_pin"), {
        L("tooltip_pin_desc"),
    })

    frame.lockButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.lockButton:SetPoint("RIGHT", frame.pinButton, "LEFT", -6, 0)
    StyleMiniButton(frame.lockButton, "K")
    SetButtonIcon(frame.lockButton, ICON_UNLOCKED, 12, true)
    frame.lockButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        uiState.locked = not uiState.locked
        addon:SaveMainWindowState()
        addon:RequestRefresh()
    end)
    AttachButtonTooltip(frame.lockButton, L("tooltip_lock"), {
        L("tooltip_lock_desc"),
    })

    frame.coneLogButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.coneLogButton:SetPoint("RIGHT", frame.lockButton, "LEFT", -8, 0)
    StyleRoundedAccentButton(frame.coneLogButton, 96, 22, L("start_log"))
    SetButtonLeadingIcon(frame.coneLogButton, ICON_PLAY, 12)
    frame.coneLogButton:SetScript("OnClick", function()
        local activeLog = addon.GetActiveConeLog and addon:GetActiveConeLog() or nil
        if activeLog then
            addon:CloseConeLog()
        elseif addon.ShowConeLogPrompt then
            addon:ShowConeLogPrompt()
        end
    end)

    frame.footer = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.footer:SetPoint("BOTTOMLEFT", 14, 12)
    frame.footer:SetPoint("BOTTOMRIGHT", -18, 12)
    frame.footer:SetHeight(22)

    frame.voteButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleRoundedAccentButton(frame.voteButton, 82, 22, L("vote"))
    SetButtonLeadingIcon(frame.voteButton, ICON_STAR, 11)
    if frame.voteButton.leadingIcon then
        frame.voteButton.leadingIcon:SetVertexColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
        frame.voteButton.leadingIcon:SetBlendMode("ADD")
    end
    frame.voteButton:SetScript("OnClick", function()
        local activeLog = addon.GetActiveConeLog and addon:GetActiveConeLog() or nil
        local label = activeLog and activeLog.label or ""
        addon:ToggleVoteFromUI(label)
    end)

    frame.postButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.postButton, "S")
    SetButtonIcon(frame.postButton, ICON_POST, 12, true)
    frame.postButton:SetScript("OnClick", function()
        addon:PostScoreResults()
    end)
    AttachButtonTooltip(frame.postButton, L("tooltip_post"), {
        L("tooltip_post_desc"),
    })

    frame.logsToggleButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.logsToggleButton, "L")
    SetButtonIcon(frame.logsToggleButton, ICON_LIST, 12, true)
    frame.logsToggleButton:SetScript("OnClick", function()
        addon:ToggleLogsPanel()
    end)
    AttachButtonTooltip(frame.logsToggleButton, L("tooltip_logs"), {
        L("tooltip_logs_desc"),
    })

    frame.filterButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.filterButton, "0")
    SetButtonIcon(frame.filterButton, ICON_HIDE_NO, 12, true)
    frame.filterButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        local current = uiState.showZeroScoresMain
        if current == nil then
            current = uiState.showZeroScores
        end
        if current == nil then
            current = true
        end
        uiState.showZeroScoresMain = not current
        addon.scrollOffset = 0
        addon:RequestRefresh()
    end)
    AttachButtonTooltip(frame.filterButton, L("tooltip_hide_zero"), {
        L("tooltip_hide_zero_desc"),
    })

    frame.resetButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.resetButton, "X")
    SetButtonIcon(frame.resetButton, ICON_RESET, 12, true)
    frame.resetButton.resetArmedUntil = 0
    frame.resetButton:SetScript("OnClick", function(self)
        if (GetTime() or 0) > (self.resetArmedUntil or 0) then
            self.resetArmedUntil = (GetTime() or 0) + 3
            addon:Print(addon:L("reset_confirm"))
            return
        end

        self.resetArmedUntil = 0
        addon:ResetAllScores()
    end)
    AttachButtonTooltip(frame.resetButton, L("tooltip_reset"), {
        L("tooltip_reset_desc"),
    })

    frame.scaleDownButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.scaleDownButton, "-")
    SetButtonIcon(frame.scaleDownButton, ICON_MINUS, 12, true)
    frame.scaleDownButton:SetScript("OnClick", function()
        addon:AdjustWindowScale(-0.05)
    end)
    AttachButtonTooltip(frame.scaleDownButton, L("tooltip_scale_down"), {
        L("tooltip_scale_down_desc"),
    })

    frame.scaleUpButton = CreateFrame("Button", nil, frame.footer, "BackdropTemplate")
    StyleMiniButton(frame.scaleUpButton, "+")
    SetButtonIcon(frame.scaleUpButton, ICON_PLUS, 12, true)
    frame.scaleUpButton:SetScript("OnClick", function()
        addon:AdjustWindowScale(0.05)
    end)
    AttachButtonTooltip(frame.scaleUpButton, L("tooltip_scale_up"), {
        L("tooltip_scale_up_desc"),
    })

    frame.voteHint = frame.footer:CreateFontString(nil, "OVERLAY")
    frame.voteHint:Hide()

    frame.scaleLabel = frame.footer:CreateFontString(nil, "OVERLAY")
    frame.scaleLabel:SetJustifyH("RIGHT")
    ApplyFont(frame.scaleLabel, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)

    frame.userHint = frame:CreateFontString(nil, "OVERLAY")
    frame.userHint:SetPoint("TOPLEFT", 14, -46)
    frame.userHint:SetPoint("RIGHT", -18, -46)
    frame.userHint:SetJustifyH("LEFT")
    ApplyFont(frame.userHint, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.userHint:SetText(L("user_hint"))

    frame.headerBand = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.headerBand:SetPoint("TOPLEFT", 14, -68)
    frame.headerBand:SetPoint("TOPRIGHT", -18, -68)
    frame.headerBand:SetHeight(22)
    StyleRoundedHeaderBand(frame.headerBand)

    frame.headerNameButton = CreateFrame("Button", nil, frame.headerBand)
    frame.headerNameButton:RegisterForClicks("LeftButtonUp")
    frame.headerNameButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        if uiState.sortMode == "alpha" then
            uiState.sortMode = "class"
        elseif uiState.sortMode == "class" then
            uiState.sortMode = "group"
        else
            uiState.sortMode = "alpha"
        end
        addon.scrollOffset = 0
        addon:RequestRefresh()
    end)

    frame.headerName = CreateSectionLabel(frame.headerBand, L("header_player"))
    frame.headerName:SetPoint("LEFT", 14, 0)

    frame.headerScoreButton = CreateFrame("Button", nil, frame.headerBand)
    frame.headerScoreButton:RegisterForClicks("LeftButtonUp")
    frame.headerScoreButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        uiState.sortMode = "score"
        addon.scrollOffset = 0
        addon:RequestRefresh()
    end)

    frame.headerScore = CreateSectionLabel(frame.headerBand, L("header_conescore"))
    frame.headerScore:SetPoint("LEFT", 248, 0)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 14, -92)
    frame.content:SetPoint("BOTTOMRIGHT", -18, 42)
    if frame.content.SetClipsChildren then
        frame.content:SetClipsChildren(true)
    end

    frame.rows = {}
    for i = 1, MAX_ROWS do
        local row = CreateFrame("Frame", nil, frame.content)
        row:SetSize(MAIN_WIDTH - 36, ROW_HEIGHT)
        row:SetPoint("TOPLEFT", 0, -((i - 1) * ROW_STEP))

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()

        row.divider = row:CreateTexture(nil, "ARTWORK")
        row.divider:SetTexture("Interface\\Buttons\\WHITE8X8")
        row.divider:SetHeight(1)
        row.divider:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.35)
        row.divider:Hide()

        row.name = row:CreateFontString(nil, "OVERLAY")
        row.name:SetPoint("LEFT", 12, 0)
        row.name:SetWidth(208)
        row.name:SetJustifyH("LEFT")
        ApplyFont(row.name, 11, "", 1, 1, 1, 1)
        row.name:SetShadowColor(0, 0, 0, 1)
        row.name:SetShadowOffset(1, -1)

        row.score = row:CreateFontString(nil, "OVERLAY")
        row.score:SetPoint("LEFT", 246, 0)
        row.score:SetWidth(36)
        row.score:SetJustifyH("CENTER")
        ApplyFont(row.score, 12, "OUTLINE", 1, 1, 1, 1)
        row.score:SetShadowColor(0, 0, 0, 1)
        row.score:SetShadowOffset(1, -1)

        row.minus = CreateFrame("Button", nil, row, "BackdropTemplate")
        row.minus:SetPoint("LEFT", 294, 0)
        StyleFlatButton(row.minus, 20, 16, "-", false)
        SetButtonIcon(row.minus, ICON_MINUS, 10, true)

        row.plus = CreateFrame("Button", nil, row, "BackdropTemplate")
        row.plus:SetPoint("LEFT", 318, 0)
        StyleFlatButton(row.plus, 20, 16, "+", false)
        SetButtonIcon(row.plus, ICON_PLUS, 10, true)

        frame.rows[i] = row
    end

    frame.scrollBar = CreateFrame("Slider", nil, frame, "BackdropTemplate")
    frame.scrollBar:SetPoint("TOPRIGHT", -8, -92)
    frame.scrollBar:SetPoint("BOTTOMRIGHT", -8, 42)
    frame.scrollBar:SetWidth(12)
    CreateFlatPanel(frame.scrollBar, { 0.09, 0.10, 0.12, 0.98 }, { 0.22, 0.24, 0.29, 1 })
    frame.scrollBar:SetOrientation("VERTICAL")
    frame.scrollBar:SetMinMaxValues(0, 0)
    frame.scrollBar:SetValueStep(1)
    frame.scrollBar:SetObeyStepOnDrag(true)

    frame.scrollThumb = frame.scrollBar:CreateTexture(nil, "OVERLAY")
    frame.scrollThumb:SetTexture("Interface\\Buttons\\WHITE8X8")
    frame.scrollThumb:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.9)
    frame.scrollThumb:SetSize(10, 36)
    frame.scrollBar:SetThumbTexture(frame.scrollThumb)
    frame.scrollBar:SetScript("OnValueChanged", function(_, value)
        addon.scrollOffset = math.floor(value or 0)
        addon:RefreshUI()
    end)
    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(_, delta)
        local current = frame.scrollBar:GetValue() or 0
        local minValue, maxValue = frame.scrollBar:GetMinMaxValues()
        local nextValue = math.max(minValue or 0, math.min(maxValue or 0, current - delta))
        frame.scrollBar:SetValue(nextValue)
    end)

    frame:SetScript("OnShow", function(self)
        self.liveRefreshElapsed = 0
        self.autoSyncElapsed = 0
        addon:RefreshUI()
    end)

    frame:SetScript("OnHide", function(self)
        self.liveRefreshElapsed = 0
        self.autoSyncElapsed = 0
        addon:SaveMainWindowState()
        if addon.summaryWindow then
            addon.summaryWindow:Hide()
        end
        if addon.configWindow then
            addon.configWindow:Hide()
        end
        if addon.voteWindow then
            addon.voteWindow:Hide()
        end
        local uiState = addon:GetUIState()
        if uiState.pinnedMode and IsInRaid() and addon.pinnedWindow then
            addon.pinnedWindow.userHidden = false
            addon:RefreshPinnedWindow(true)
        end
    end)

    frame:SetScript("OnUpdate", function(self, elapsed)
        self.liveRefreshElapsed = (self.liveRefreshElapsed or 0) + (elapsed or 0)
        self.autoSyncElapsed = (self.autoSyncElapsed or 0) + (elapsed or 0)
        if self.liveRefreshElapsed < LIVE_REFRESH_INTERVAL then
            if self.autoSyncElapsed >= AUTO_SYNC_INTERVAL and addon.RequestSync and IsInGroup(LE_PARTY_CATEGORY_HOME) and not addon:IsOfficer() then
                self.autoSyncElapsed = 0
                addon:RequestSync()
            end
            return
        end

        self.liveRefreshElapsed = 0
        if self.autoSyncElapsed >= AUTO_SYNC_INTERVAL and addon.RequestSync and IsInGroup(LE_PARTY_CATEGORY_HOME) and not addon:IsOfficer() then
            self.autoSyncElapsed = 0
            addon:RequestSync()
        end
        addon:RefreshUI()
    end)

    self.mainWindow = frame
    ApplyWindowScale(frame)
    ApplyPinnedWindowStyle(frame, false)
    ApplyMainLayout(frame)
    AttachWindowIntroAnimation(frame, 0, 5, 0.22)
end

function addon:BuildSummaryWindow()
    UpdateAccentColor()
    local ui = self:GetUIState()
    local summaryState = ui.summary or {}

    local parent = self.mainWindow
    local frame = CreateFrame("Frame", "ConeScoreSummaryFrame", parent, "BackdropTemplate")
    frame:SetWidth(summaryState.width or LOGS_PANEL_WIDTH)
    frame:SetPoint("TOPRIGHT", parent, "TOPLEFT", -8, 0)
    frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", -8, 0)
    frame:Hide()
    frame.layoutFunc = ApplySummaryLayout
    frame.refreshFunc = addon.RefreshSummaryUI
    ApplyRoundedWindowTheme(frame, 16)
    CreateWidthResizeHandle(frame, MIN_SUMMARY_WIDTH, MAX_SUMMARY_WIDTH)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 20, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("saved_logs"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -3)
    ApplyFont(frame.subtitle, 12, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("saved_logs_subtitle"))

    frame.backButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.backButton:SetPoint("TOPRIGHT", -48, -16)
    StyleFlatButton(frame.backButton, 44, 22, L("back"), false)
    frame.backButton:SetScript("OnClick", function()
        addon.selectedLogEntry = nil
        addon.summaryMode = "logs"
        addon.summaryScrollOffset = 0
        addon:RefreshSummaryUI()
    end)
    frame.backButton:Hide()

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        addon:ToggleSummaryWindow(false)
    end)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 18, -76)
    frame.content:SetPoint("BOTTOMRIGHT", -34, 16)
    if frame.content.SetClipsChildren then
        frame.content:SetClipsChildren(true)
    end

    frame.rows = {}
    for i = 1, 24 do
        local row = CreateFrame("Button", nil, frame.content)
        row:SetSize(448, 24)
        row:SetPoint("TOPLEFT", 0, -((i - 1) * SUMMARY_ROW_HEIGHT))
        row:RegisterForClicks("LeftButtonUp")

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        SetRowBackground(row, i % 2 == 0 and SURFACE_ALT or SURFACE_COLOR)

        row.text = row:CreateFontString(nil, "OVERLAY")
        row.text:SetPoint("LEFT", 10, 0)
        row.text:SetPoint("RIGHT", -10, 0)
        row.text:SetJustifyH("LEFT")
        ApplyFont(row.text, 12, "", 0.90, 0.92, 0.95, 1)

        row:SetScript("OnEnter", function(self)
            if self.isClickable then
                SetRowBackground(self, { 0.10, 0.10, 0.10, 0.94 })
            end
        end)
        row:SetScript("OnLeave", function(self)
            if self.defaultBg then
                SetRowBackground(self, self.defaultBg)
            end
        end)

        frame.rows[i] = row
    end

    frame.scrollBar = CreateFrame("Slider", nil, frame, "BackdropTemplate")
    frame.scrollBar:SetPoint("TOPRIGHT", -14, -76)
    frame.scrollBar:SetPoint("BOTTOMRIGHT", -14, 16)
    frame.scrollBar:SetWidth(12)
    CreateFlatPanel(frame.scrollBar, { 0.09, 0.10, 0.12, 0.98 }, { 0.22, 0.24, 0.29, 1 })
    frame.scrollBar:SetOrientation("VERTICAL")
    frame.scrollBar:SetMinMaxValues(0, 0)
    frame.scrollBar:SetValueStep(1)
    frame.scrollBar:SetObeyStepOnDrag(true)

    frame.scrollThumb = frame.scrollBar:CreateTexture(nil, "OVERLAY")
    frame.scrollThumb:SetTexture("Interface\\Buttons\\WHITE8X8")
    frame.scrollThumb:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.9)
    frame.scrollThumb:SetSize(10, 36)
    frame.scrollBar:SetThumbTexture(frame.scrollThumb)
    frame.scrollBar:SetScript("OnValueChanged", function(_, value)
        addon.summaryScrollOffset = math.floor(value or 0)
        addon:RefreshSummaryUI()
    end)
    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(_, delta)
        local current = frame.scrollBar:GetValue() or 0
        local minValue, maxValue = frame.scrollBar:GetMinMaxValues()
        local nextValue = math.max(minValue or 0, math.min(maxValue or 0, current - delta))
        frame.scrollBar:SetValue(nextValue)
    end)

    self.summaryWindow = frame
    ApplySummaryLayout(frame)
    AttachWindowIntroAnimation(frame, -8, 0, 0.20)
end

function addon:AdjustWindowScale(delta)
    local ui = self:GetUIState()
    local nextScale = (tonumber(ui.windowScale) or 1) + (delta or 0)
    if nextScale < 0.8 then
        nextScale = 0.8
    elseif nextScale > 1.3 then
        nextScale = 1.3
    end

    ui.windowScale = nextScale
    ApplyWindowScale(self.mainWindow)
    self:SaveMainWindowState()
    self:RequestRefresh()
end

function addon:BuildVoteWindow()
    UpdateAccentColor()

    local frame = CreateFrame("Frame", "ConeScoreVoteFrame", UIParent, "BackdropTemplate")
    frame:SetSize(VOTE_WINDOW_WIDTH_TWO_COLS, VOTE_WINDOW_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 20, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("conescore_vote"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -3)
    ApplyFont(frame.subtitle, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("vote_click_name"))

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        addon:HideVoteWindow()
    end)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 16, -56)
    frame.content:SetPoint("BOTTOMRIGHT", -16, 16)

    frame.groupHeaders = {}
    for i = 1, 8 do
        local header = frame.content:CreateFontString(nil, "OVERLAY")
        ApplyFont(header, 11, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
        header:SetJustifyH("LEFT")
        frame.groupHeaders[i] = header
    end

    frame.voteButtons = {}
    for i = 1, MAX_VOTE_BUTTONS do
        local button = CreateFrame("Button", nil, frame.content, "BackdropTemplate")
        StyleVotePlayerButton(button, 160, 20)
        button:RegisterForClicks("LeftButtonUp")

        button:SetText("")
        button.nameText = button:CreateFontString(nil, "OVERLAY")
        button.nameText:SetPoint("LEFT", 8, 0)
        button.nameText:SetPoint("RIGHT", -8, 0)
        button.nameText:SetJustifyH("LEFT")
        ApplyFont(button.nameText, 11, "", 0.90, 0.92, 0.95, 1)

        button:SetScript("OnEnter", function(self)
            local playerName = self.playerName and addon:GetShortName(self.playerName) or "Unknown"
            SetVotePlayerButtonTint(self, self.classFile, true)
            SetTooltip(self, playerName, {
                L("tooltip_vote_player"),
            })
        end)
        button:SetScript("OnLeave", function(self)
            SetVotePlayerButtonTint(self, self.classFile, false)
            GameTooltip:Hide()
        end)

        frame.voteButtons[i] = button
    end

    frame.emptyState = frame.content:CreateFontString(nil, "OVERLAY")
    frame.emptyState:SetPoint("CENTER")
    ApplyFont(frame.emptyState, 12, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.emptyState:SetText(L("vote_no_active"))
    frame.emptyState:Hide()

    self.voteWindow = frame
    AttachWindowIntroAnimation(frame, 0, 5, 0.20)
end

function addon:BuildVoteSetupWindow()
    local frame = CreateFrame("Frame", "ConeScoreVoteSetupFrame", UIParent, "BackdropTemplate")
    frame:SetSize(VOTE_SETUP_WIDTH_TWO_COLS, VOTE_SETUP_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", -40, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 20, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("vote_pool"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -3)
    ApplyFont(frame.subtitle, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("vote_pool_subtitle"))

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        addon:HideVoteSetupWindow()
    end)

    frame.selectAll = CreateColorCheckbox(frame, 14)
    frame.selectAll:SetPoint("TOPRIGHT", -18, -50)
    frame.selectAll.text = frame:CreateFontString(nil, "OVERLAY")
    frame.selectAll.text:SetPoint("RIGHT", frame.selectAll, "LEFT", -6, 0)
    frame.selectAll.text:SetJustifyH("RIGHT")
    ApplyFont(frame.selectAll.text, 11, "", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
    frame.selectAll.text:SetText(L("select_all"))

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 16, -72)
    frame.content:SetPoint("BOTTOMRIGHT", -16, 48)

    frame.groupHeaders = {}
    for i = 1, 8 do
        local header = frame.content:CreateFontString(nil, "OVERLAY")
        ApplyFont(header, 11, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
        header:SetJustifyH("LEFT")
        frame.groupHeaders[i] = header
    end

    frame.rows = {}
    for i = 1, MAX_VOTE_BUTTONS do
        local row = CreateFrame("Button", nil, frame.content, "BackdropTemplate")
        StyleVotePlayerButton(row, 160, 20)
        row:RegisterForClicks("LeftButtonUp")

        row.check = CreateColorCheckbox(row, 12)
        row.check:SetPoint("LEFT", 6, 0)

        row.nameText = row:CreateFontString(nil, "OVERLAY")
        row.nameText:SetPoint("LEFT", row.check, "RIGHT", 6, 0)
        row.nameText:SetPoint("RIGHT", -8, 0)
        row.nameText:SetJustifyH("LEFT")
        ApplyFont(row.nameText, 11, "", 0.90, 0.92, 0.95, 1)

        row:SetScript("OnEnter", function(self)
            SetVotePlayerButtonTint(self, self.classFile, true)
        end)
        row:SetScript("OnLeave", function(self)
            SetVotePlayerButtonTint(self, self.classFile, false)
        end)
        row:SetScript("OnClick", function(self)
            if not self.playerName then
                return
            end
            self.check:SetChecked(not self.check:GetChecked())
            addon:UpdateVoteSetupSelection(self.playerName, self.check:GetChecked())
        end)
        row.check:SetScript("OnClick", function(self)
            local parent = self:GetParent()
            if not parent or not parent.playerName then
                return
            end
            addon:UpdateVoteSetupSelection(parent.playerName, self:GetChecked())
        end)

        frame.rows[i] = row
    end

    frame.confirmButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.confirmButton:SetPoint("BOTTOMRIGHT", -16, 16)
    StyleRoundedAccentButton(frame.confirmButton, 92, 22, "Open Vote")
    frame.confirmButton:SetScript("OnClick", function()
        local selectedTargets = {}
        local selection = frame.selectedTargets or {}
        for _, member in ipairs(addon:GetRoster() or {}) do
            if selection[member.name] then
                selectedTargets[#selectedTargets + 1] = member.name
            end
        end

        if addon:OpenVote(frame.pendingLabel or "", selectedTargets) then
            addon:HideVoteSetupWindow()
        end
    end)

    frame.cancelButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.cancelButton:SetPoint("RIGHT", frame.confirmButton, "LEFT", -8, 0)
    StyleFlatButton(frame.cancelButton, 70, 22, "Cancel", false)
    frame.cancelButton:SetScript("OnClick", function()
        addon:HideVoteSetupWindow()
    end)

    frame.emptyState = frame.content:CreateFontString(nil, "OVERLAY")
    frame.emptyState:SetPoint("CENTER")
    ApplyFont(frame.emptyState, 12, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.emptyState:SetText(L("no_raid_members"))
    frame.emptyState:Hide()

    frame.selectAll:SetScript("OnClick", function(self)
        self:SetChecked(not self:GetChecked())
        local checked = self:GetChecked() and true or false
        for _, member in ipairs(addon:GetRoster() or {}) do
            frame.selectedTargets[member.name] = checked
        end
        addon:RefreshVoteSetupWindow()
    end)

    self.voteSetupWindow = frame
    AttachWindowIntroAnimation(frame, 0, 5, 0.20)
end

function addon:UpdateVoteSetupSelection(playerName, isChecked)
    if not self.voteSetupWindow or not playerName then
        return
    end

    self.voteSetupWindow.selectedTargets = self.voteSetupWindow.selectedTargets or {}
    self.voteSetupWindow.selectedTargets[playerName] = isChecked and true or false

    local allChecked = true
    local hasAny = false
    for _, member in ipairs(self:GetRoster() or {}) do
        hasAny = true
        if not self.voteSetupWindow.selectedTargets[member.name] then
            allChecked = false
            break
        end
    end

    self.voteSetupWindow.selectAll:SetChecked(hasAny and allChecked)
end

function addon:ShowVoteSetupWindow(label)
    if not self:IsRaidLeader() then
        self:Print(self:L("vote_open_rl_only"))
        return
    end

    if not self.voteSetupWindow then
        return
    end

    self:RefreshRoster()
    local frame = self.voteSetupWindow
    frame.pendingLabel = label or ""
    frame.selectedTargets = {}
    for _, member in ipairs(self:GetRoster() or {}) do
        frame.selectedTargets[member.name] = true
    end
    frame.selectAll:SetTint(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3])

    self:RefreshVoteSetupWindow()
    frame:Show()
end

function addon:HideVoteSetupWindow()
    if self.voteSetupWindow then
        self.voteSetupWindow:Hide()
    end
end

function addon:RefreshVoteSetupWindow()
    if not self.voteSetupWindow then
        return
    end

    local frame = self.voteSetupWindow
    self:RefreshRoster()

    local groups = GetVoteGroups()
    local groupCount = #groups
    local columns = groupCount > 4 and 3 or 2
    local frameWidth = columns == 3 and VOTE_SETUP_WIDTH_THREE_COLS or VOTE_SETUP_WIDTH_TWO_COLS
    local columnWidth = columns == 3 and 164 or 168
    local columnGap = 12
    local rowHeight = 20
    local rowGap = 4
    local groupHeaderGap = 18
    local startX = 0
    local startY = -4
    local buttonIndex = 1

    frame:SetWidth(frameWidth)

    for _, header in ipairs(frame.groupHeaders) do
        header:Hide()
    end

    for _, row in ipairs(frame.rows) do
        row:Hide()
        row.playerName = nil
        row.classFile = nil
    end

    frame.emptyState:SetShown(groupCount == 0)

    for groupIndex, groupData in ipairs(groups) do
        local header = frame.groupHeaders[groupIndex]
        local column = (groupIndex - 1) % columns
        local rowBlock = math.floor((groupIndex - 1) / columns)
        local x = startX + (column * (columnWidth + columnGap))
        local y = startY - (rowBlock * 116)

        if header then
            header:ClearAllPoints()
            header:SetPoint("TOPLEFT", x, y)
            header:SetText(groupData.group > 0 and L("group_label", groupData.group) or L("extra_label"))
            header:Show()
        end

        for memberIndex, member in ipairs(groupData.members or {}) do
            local row = frame.rows[buttonIndex]
            if not row then
                break
            end

            buttonIndex = buttonIndex + 1
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", x, y - groupHeaderGap - ((memberIndex - 1) * (rowHeight + rowGap)))
            row:SetSize(columnWidth, rowHeight)
            row.playerName = member.name
            row.classFile = member.classFile

            local classR, classG, classB = GetClassColor(member.classFile)
            ApplyFont(row.nameText, 11, "", classR, classG, classB, 1)
            row.nameText:SetText(self:GetShortName(member.name))
            row.check:SetTint(classR, classG, classB)
            row.check:SetChecked(frame.selectedTargets and frame.selectedTargets[member.name] or false)
            SetVotePlayerButtonTint(row, member.classFile, false)
            row:Show()
        end
    end

    local allChecked = true
    local hasAny = false
    for _, member in ipairs(self:GetRoster() or {}) do
        hasAny = true
        if not (frame.selectedTargets and frame.selectedTargets[member.name]) then
            allChecked = false
            break
        end
    end
    frame.selectAll:SetChecked(hasAny and allChecked)
end

function addon:BuildVoteResultsWindow()
    UpdateAccentColor()

    local frame = CreateFrame("Frame", "ConeScoreVoteResultsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(VOTE_RESULTS_WIDTH, VOTE_RESULTS_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 80, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 20, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("vote_results"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -3)
    ApplyFont(frame.subtitle, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("latest_vote_tally"))

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        addon:HideVoteResultsWindow()
    end)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 16, -56)
    frame.content:SetPoint("BOTTOMRIGHT", -30, 16)

    frame.rows = {}
    for i = 1, 12 do
        local row = CreateFrame("Frame", nil, frame.content)
        row:SetSize(300, 22)
        row:SetPoint("TOPLEFT", 0, -((i - 1) * 24))

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()

        row.text = row:CreateFontString(nil, "OVERLAY")
        row.text:SetPoint("LEFT", 8, 0)
        row.text:SetPoint("RIGHT", -8, 0)
        row.text:SetJustifyH("LEFT")
        ApplyFont(row.text, 12, "", 0.90, 0.92, 0.95, 1)

        frame.rows[i] = row
    end

    frame.emptyState = frame.content:CreateFontString(nil, "OVERLAY")
    frame.emptyState:SetPoint("CENTER")
    ApplyFont(frame.emptyState, 12, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.emptyState:SetText(L("no_vote_results"))
    frame.emptyState:Hide()

    self.voteResultsWindow = frame
    AttachWindowIntroAnimation(frame, 0, 5, 0.20)
end

function addon:BuildDailyToastWindow()
    local frame = CreateFrame("Frame", "ConeScoreDailyToastFrame", UIParent, "BackdropTemplate")
    frame:SetSize(DAILY_TOAST_WIDTH, DAILY_TOAST_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 18, -16)
    ApplyFont(frame.title, 18, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("top3_title"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -3)
    frame.subtitle:SetPoint("RIGHT", -18, 0)
    frame.subtitle:SetJustifyH("LEFT")
    ApplyFont(frame.subtitle, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("top3_subtitle"))

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        frame:Hide()
    end)

    frame.winnerPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.winnerPanel:SetPoint("TOPLEFT", 18, -60)
    frame.winnerPanel:SetPoint("TOPRIGHT", -18, -60)
    frame.winnerPanel:SetHeight(58)
    StyleRoundedHeaderBand(frame.winnerPanel)

    frame.crown = frame.winnerPanel:CreateTexture(nil, "ARTWORK")
    frame.crown:SetPoint("LEFT", 14, 0)
    frame.crown:SetSize(24, 24)
    frame.crown:SetTexture(ICON_CROWN)
    frame.crown:SetVertexColor(1, 0.84, 0.18, 1)
    frame.crown:SetBlendMode("ADD")

    frame.winnerLabel = frame.winnerPanel:CreateFontString(nil, "OVERLAY")
    frame.winnerLabel:SetPoint("TOPLEFT", frame.crown, "TOPRIGHT", 10, 0)
    ApplyFont(frame.winnerLabel, 10, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
    frame.winnerLabel:SetText(L("top_cone"))

    frame.winnerName = frame.winnerPanel:CreateFontString(nil, "OVERLAY")
    frame.winnerName:SetPoint("TOPLEFT", frame.winnerLabel, "BOTTOMLEFT", 0, -2)
    frame.winnerName:SetPoint("RIGHT", -68, -8)
    frame.winnerName:SetJustifyH("LEFT")
    ApplyFont(frame.winnerName, 18, "OUTLINE", 1, 1, 1, 1)

    frame.winnerScore = frame.winnerPanel:CreateFontString(nil, "OVERLAY")
    frame.winnerScore:SetPoint("RIGHT", -14, 0)
    frame.winnerScore:SetJustifyH("RIGHT")
    ApplyFont(frame.winnerScore, 20, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)

    frame.rows = {}
    for index = 1, 2 do
        local row = CreateFrame("Frame", nil, frame)
        row:SetPoint("TOPLEFT", 18, -122 - ((index - 1) * 26))
        row:SetPoint("TOPRIGHT", -18, -122 - ((index - 1) * 26))
        row:SetHeight(22)

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        SetRowBackground(row, index % 2 == 0 and SURFACE_ALT or SURFACE_COLOR)

        row.text = row:CreateFontString(nil, "OVERLAY")
        row.text:SetPoint("LEFT", 10, 0)
        row.text:SetPoint("RIGHT", -10, 0)
        row.text:SetJustifyH("LEFT")
        ApplyFont(row.text, 13, "", 0.90, 0.92, 0.95, 1)

        frame.rows[index] = row
    end

    frame.emptyState = frame:CreateFontString(nil, "OVERLAY")
    frame.emptyState:SetPoint("TOPLEFT", 18, -128)
    frame.emptyState:SetPoint("RIGHT", -18, -128)
    frame.emptyState:SetJustifyH("LEFT")
    ApplyFont(frame.emptyState, 12, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.emptyState:SetText(L("clean_raid"))
    frame.emptyState:Hide()

    self.dailyToastWindow = frame
    AttachWindowIntroAnimation(frame, 0, 8, 0.24)
end

function addon:BuildWinnerToastWindow()
    local frame = CreateFrame("Frame", "ConeScoreWinnerToastFrame", UIParent, "BackdropTemplate")
    frame:SetSize(WINNER_TOAST_WIDTH, WINNER_TOAST_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 34)
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.close = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.close:SetPoint("TOPRIGHT", -16, -16)
    StyleIconButton(frame.close, 24, 24, CLOSE_ICON_PATH)
    frame.close:SetScript("OnClick", function()
        frame:Hide()
    end)

    frame.kicker = frame:CreateFontString(nil, "OVERLAY")
    frame.kicker:SetPoint("TOPLEFT", 22, -18)
    ApplyFont(frame.kicker, 11, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
    frame.kicker:SetText(L("cone_of_day"))

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", frame.kicker, "BOTTOMLEFT", 0, -6)
    frame.title:SetPoint("RIGHT", -52, 0)
    frame.title:SetJustifyH("LEFT")
    ApplyFont(frame.title, 28, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("congratulations"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -6)
    frame.subtitle:SetPoint("RIGHT", -22, 0)
    frame.subtitle:SetJustifyH("LEFT")
    ApplyFont(frame.subtitle, 13, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("cone_day_subtitle"))

    frame.heroPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.heroPanel:SetPoint("TOPLEFT", 22, -104)
    frame.heroPanel:SetPoint("TOPRIGHT", -22, -104)
    frame.heroPanel:SetHeight(78)
    StyleRoundedHeaderBand(frame.heroPanel)

    frame.crown = frame.heroPanel:CreateTexture(nil, "ARTWORK")
    frame.crown:SetPoint("LEFT", 18, 0)
    frame.crown:SetSize(30, 30)
    frame.crown:SetTexture(ICON_CROWN)
    frame.crown:SetVertexColor(1, 0.84, 0.18, 1)
    frame.crown:SetBlendMode("ADD")

    frame.name = frame.heroPanel:CreateFontString(nil, "OVERLAY")
    frame.name:SetPoint("LEFT", frame.crown, "RIGHT", 14, 0)
    frame.name:SetPoint("RIGHT", -90, 0)
    frame.name:SetJustifyH("LEFT")
    ApplyFont(frame.name, 24, "OUTLINE", 1, 1, 1, 1)

    frame.score = frame.heroPanel:CreateFontString(nil, "OVERLAY")
    frame.score:SetPoint("RIGHT", -18, 0)
    frame.score:SetJustifyH("RIGHT")
    ApplyFont(frame.score, 32, "OUTLINE", HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)

    frame.body = frame:CreateFontString(nil, "OVERLAY")
    frame.body:SetPoint("TOPLEFT", frame.heroPanel, "BOTTOMLEFT", 2, -16)
    frame.body:SetPoint("RIGHT", -24, 0)
    frame.body:SetJustifyH("LEFT")
    frame.body:SetJustifyV("TOP")
    ApplyFont(frame.body, 14, "", 0.92, 0.93, 0.95, 1)
    frame.body:SetText(L("cone_day_body"))

    frame.logDivider = frame:CreateTexture(nil, "ARTWORK")
    frame.logDivider:SetTexture("Interface\\Buttons\\WHITE8X8")
    frame.logDivider:SetPoint("LEFT", 22, 28)
    frame.logDivider:SetPoint("RIGHT", -22, 28)
    frame.logDivider:SetHeight(1)
    frame.logDivider:SetVertexColor(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], 0.22)

    frame.logInfo = frame:CreateFontString(nil, "OVERLAY")
    frame.logInfo:SetPoint("BOTTOMLEFT", 22, 8)
    frame.logInfo:SetPoint("BOTTOMRIGHT", -22, 8)
    frame.logInfo:SetJustifyH("LEFT")
    ApplyFont(frame.logInfo, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)

    self.winnerToastWindow = frame
    AttachWindowIntroAnimation(frame, 0, 10, 0.26)
end

function addon:BuildConeLogPromptWindow()
    local frame = CreateFrame("Frame", "ConeScoreConeLogPrompt", UIParent, "BackdropTemplate")
    frame:SetSize(300, 140)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    ApplyFont(frame.title, 16, "OUTLINE", 1, 1, 1, 1)
    frame.title:SetText(L("start_conelog"))

    frame.subtitle = frame:CreateFontString(nil, "OVERLAY")
    frame.subtitle:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -4)
    ApplyFont(frame.subtitle, 11, "", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 1)
    frame.subtitle:SetText(L("conelog_prompt"))

    frame.editBox = CreateFrame("EditBox", nil, frame, "BackdropTemplate")
    frame.editBox:SetPoint("TOPLEFT", 16, -58)
    StyleFlatEditBox(frame.editBox, 268, 24)
    frame.editBox:SetText("")
    AttachPlaceholder(frame.editBox, L("conelog_name_placeholder"))

    frame.confirmButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.confirmButton:SetPoint("BOTTOMRIGHT", -16, 16)
    StyleFlatButton(frame.confirmButton, 70, 22, L("start"), true)
    frame.confirmButton:SetScript("OnClick", function()
        local label = frame.editBox:GetText()
        if addon:StartConeLog(label) then
            addon:HideConeLogPrompt()
        end
    end)

    frame.cancelButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    frame.cancelButton:SetPoint("RIGHT", frame.confirmButton, "LEFT", -8, 0)
    StyleFlatButton(frame.cancelButton, 70, 22, L("cancel"), false)
    frame.cancelButton:SetScript("OnClick", function()
        addon:HideConeLogPrompt()
    end)

    self.coneLogPrompt = frame
    AttachWindowIntroAnimation(frame, 0, 4, 0.18)
end

function addon:ShowConeLogPrompt()
    if not self.coneLogPrompt then
        return
    end

    self.coneLogPrompt.editBox:SetText("")
    self.coneLogPrompt:Show()
    self.coneLogPrompt.editBox:SetFocus()
end

function addon:HideConeLogPrompt()
    if self.coneLogPrompt then
        self.coneLogPrompt.editBox:ClearFocus()
        self.coneLogPrompt:Hide()
    end
end

function addon:BuildPinnedWindow()
    local ui = self:GetUIState()
    local pinnedState = ui.pinned or {}

    local frame = CreateFrame("Frame", "ConeScorePinnedFrame", UIParent, "BackdropTemplate")
    frame:SetSize(170, 120)
    frame:SetPoint(
        pinnedState.point or "CENTER",
        UIParent,
        pinnedState.relativePoint or pinnedState.point or "CENTER",
        pinnedState.x or 280,
        pinnedState.y or 0
    )
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)
    frame:Hide()
    ApplyRoundedWindowTheme(frame, 16, { 0.02, 0.02, 0.03, 0.16 })

    frame:SetScript("OnDragStart", function(self)
        local pinnedUi = addon:GetUIState().pinned or {}
        if pinnedUi.locked then
            return
        end
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        addon:SavePinnedWindowState()
    end)

    frame.content = CreateFrame("Frame", nil, frame)
    frame.content:SetPoint("TOPLEFT", 4, -22)
    frame.content:SetPoint("BOTTOMRIGHT", -4, 4)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetPoint("TOPLEFT", 3, -6)
    ApplyFont(frame.title, 9, "OUTLINE", MUTED_COLOR[1], MUTED_COLOR[2], MUTED_COLOR[3], 0.95)
    frame.title:SetText("ConeScore")

    frame.controls = CreateFrame("Frame", nil, frame)
    frame.controls:SetSize(72, 18)
    frame.controls:SetPoint("TOPRIGHT", -2, -2)
    frame.controls:Hide()
    frame.controls:SetFrameStrata("HIGH")

    frame.pinButton = CreateFrame("Button", nil, frame.controls, "BackdropTemplate")
    frame.pinButton:SetPoint("TOPRIGHT", 0, 0)
    StyleMiniButton(frame.pinButton, "P")
    SetButtonIcon(frame.pinButton, ICON_PIN_YES, 10, true)
    frame.pinButton:SetSize(18, 18)
    frame.pinButton:GetFontString():SetFont(GetFontPath(), 10, "")
    frame.pinButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        uiState.pinnedMode = false
        if addon.pinnedWindow then
            addon.pinnedWindow.userHidden = true
            addon.pinnedWindow:Hide()
        end
        if addon.mainWindow then
            addon.mainWindow:ClearAllPoints()
            local mainState = addon:GetUIState().main or {}
            addon.mainWindow:SetPoint(
                mainState.point or "CENTER",
                UIParent,
                mainState.relativePoint or mainState.point or "CENTER",
                mainState.x or 0,
                mainState.y or 0
            )
            addon.mainWindow:Show()
            addon:RefreshUI()
        end
    end)
    AttachButtonTooltip(frame.pinButton, L("tooltip_open_ui"), {
        L("tooltip_open_ui_desc"),
    })

    frame.lockButton = CreateFrame("Button", nil, frame.controls, "BackdropTemplate")
    frame.lockButton:SetPoint("RIGHT", frame.pinButton, "LEFT", -4, 0)
    StyleMiniButton(frame.lockButton, "K")
    SetButtonIcon(frame.lockButton, ICON_UNLOCKED, 10, true)
    frame.lockButton:SetSize(18, 18)
    frame.lockButton:GetFontString():SetFont(GetFontPath(), 10, "")
    frame.lockButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        uiState.pinned = uiState.pinned or {}
        uiState.pinned.locked = not uiState.pinned.locked
        addon:RefreshPinnedWindow()
    end)
    AttachButtonTooltip(frame.lockButton, L("tooltip_lock"), {
        L("tooltip_lock_desc"),
    })

    frame.filterButton = CreateFrame("Button", nil, frame.controls, "BackdropTemplate")
    frame.filterButton:SetPoint("RIGHT", frame.lockButton, "LEFT", -4, 0)
    StyleMiniButton(frame.filterButton, "0")
    SetButtonIcon(frame.filterButton, ICON_HIDE_NO, 10, true)
    frame.filterButton:SetSize(18, 18)
    frame.filterButton:GetFontString():SetFont(GetFontPath(), 10, "")
    frame.filterButton:SetScript("OnClick", function()
        local uiState = addon:GetUIState()
        local current = uiState.showZeroScoresPinned
        if current == nil then
            current = uiState.showZeroScores
        end
        if current == nil then
            current = true
        end
        uiState.showZeroScoresPinned = not current
        addon.scrollOffset = 0
        addon:RequestRefresh()
    end)
    AttachButtonTooltip(frame.filterButton, L("tooltip_hide_zero"), {
        L("tooltip_hide_zero_desc"),
    })

    frame.rows = {}
    for i = 1, MAX_ROWS do
        local row = CreateFrame("Frame", nil, frame.content)
        row:SetSize(150, 16)
        row:SetPoint("TOPLEFT", 0, -((i - 1) * 16))

        row.name = row:CreateFontString(nil, "OVERLAY")
        row.name:SetPoint("LEFT", 0, 0)
        row.name:SetWidth(112)
        row.name:SetJustifyH("LEFT")
        ApplyFont(row.name, 12, "OUTLINE", 1, 1, 1, 1)
        row.name:SetShadowColor(0, 0, 0, 1)
        row.name:SetShadowOffset(1, -1)

        row.score = row:CreateFontString(nil, "OVERLAY")
        row.score:SetPoint("LEFT", 110, 0)
        row.score:SetWidth(24)
        row.score:SetJustifyH("CENTER")
        ApplyFont(row.score, 13, "OUTLINE", 1, 1, 1, 1)
        row.score:SetShadowColor(0, 0, 0, 1)
        row.score:SetShadowOffset(1, -1)

        frame.rows[i] = row
    end

    frame:SetScript("OnUpdate", function(self)
        local showControls = self:IsMouseOver() or self.controls:IsMouseOver()
        self.controls:SetShown(showControls)
    end)

    self.pinnedWindow = frame
end

function addon:RefreshPinnedWindow(forceShow)
    if not self.pinnedWindow then
        return
    end

    local ui = self:GetUIState()
    if not forceShow and self.pinnedWindow.userHidden then
        return
    end
    local roster = GetDisplayRoster("pinned")
    local visibleCount = 0
    local width = 0

    self:RefreshRoster()
    roster = GetDisplayRoster("pinned")

    for i, row in ipairs(self.pinnedWindow.rows) do
        local member = roster[i]
        if member then
            local classR, classG, classB = GetClassColor(member.classFile)
            ApplyFont(row.name, 12, "OUTLINE", classR, classG, classB, 1)
            ApplyFont(row.score, 13, "OUTLINE", 1, 1, 1, 1)
            row.name:SetText(self:GetShortName(member.name))
            row.score:SetText(member.score or 0)
            row:Show()
            visibleCount = i
            local rowWidth = math.max(
                row.name:GetStringWidth() + row.score:GetStringWidth() + 14,
                70
            )
            if rowWidth > width then
                width = rowWidth
            end
        else
            row.name:SetText("")
            row.score:SetText("")
            row:Hide()
        end
    end

    visibleCount = math.max(visibleCount, 1)
    width = math.max(width, 88)
    local pinnedLocked = ((ui.pinned or {}).locked) and true or false
    self.pinnedWindow:SetSize(width + 18, (visibleCount * 16) + 26)
    SetButtonIcon(self.pinnedWindow.pinButton, ICON_PIN_YES, 10, true)
    SetButtonIcon(self.pinnedWindow.lockButton, ((ui.pinned or {}).locked) and ICON_LOCKED or ICON_UNLOCKED, 10, true)
    local pinnedShowZero = ui.showZeroScoresPinned
    if pinnedShowZero == nil then
        pinnedShowZero = ui.showZeroScores
    end
    if pinnedShowZero == nil then
        pinnedShowZero = true
    end
    SetButtonIcon(self.pinnedWindow.filterButton, (pinnedShowZero == false) and ICON_HIDE_YES or ICON_HIDE_NO, 10, true)
    TintRoundedFrameFill(self.pinnedWindow, 0.02, 0.02, 0.03, pinnedLocked and 0 or 0.16)
    self.pinnedWindow:SetBackdropColor(0, 0, 0, 0)
    self.pinnedWindow:SetBackdropBorderColor(0, 0, 0, 0)
    if forceShow or not self.pinnedWindow.userHidden then
        self.pinnedWindow:Show()
    end
end

function addon:ShowVoteResultsWindow()
    if not self.voteResultsWindow then
        return
    end

    self:RefreshVoteResultsWindow()
    self.voteResultsWindow:Show()
end

function addon:ShowDailyToast(data)
    if not self.dailyToastWindow then
        return
    end

    local frame = self.dailyToastWindow
    local entries = (data and data.entries) or {}
    local winner = entries[1]
    local second = entries[2]
    local third = entries[3]
    local subtitleBits = {}
    local soundPath = BuildRaidwideSoundPath(data and data.raidwideSoundFile or nil)

    if winner and IsLocalPlayerName(winner.name) and self.ShowWinnerToast then
        frame:Hide()
        self:ShowWinnerToast(data)
        return
    end

    if data and data.label and data.label ~= "" then
        subtitleBits[#subtitleBits + 1] = data.label
    end
    if data and data.savedAtText and data.savedAtText ~= "" then
        subtitleBits[#subtitleBits + 1] = data.savedAtText
    end
    if data and data.savedTimeText and data.savedTimeText ~= "" then
        subtitleBits[#subtitleBits + 1] = data.savedTimeText
    end

    frame.subtitle:SetText(#subtitleBits > 0 and table.concat(subtitleBits, " - ") or L("top3_subtitle"))

    if winner then
        local classR, classG, classB = GetClassColor(winner.classFile)
        frame.winnerPanel:Show()
        frame.emptyState:Hide()
        ApplyFont(frame.winnerName, 18, "OUTLINE", classR, classG, classB, 1)
        frame.winnerName:SetText(winner.shortName or self:GetShortName(winner.name))
        frame.winnerScore:SetText(winner.score or 0)
    else
        frame.winnerPanel:Hide()
        frame.emptyState:Show()
    end

    ApplyToastEntry(frame.rows[1] and frame.rows[1].text, second, "|cffffd54f2.|r")
    ApplyToastEntry(frame.rows[2] and frame.rows[2].text, third, "|cffffd54f3.|r")
    if frame.rows[1] then
        frame.rows[1]:SetShown(second ~= nil)
    end
    if frame.rows[2] then
        frame.rows[2]:SetShown(third ~= nil)
    end

    frame:Show()
    if soundPath and self:IsSoundEnabled() then
        PlaySoundFile(soundPath, "Master")
    end
end

function addon:ShowWinnerToast(data)
    if not self.winnerToastWindow then
        return
    end

    local frame = self.winnerToastWindow
    local entries = (data and data.entries) or {}
    local winner = entries[1]
    local infoBits = {}
    local soundPath = self.GetRandomWinnerSoundPath and self:GetRandomWinnerSoundPath() or nil

    if not winner then
        return
    end

    if self.dailyToastWindow then
        self.dailyToastWindow:Hide()
    end

    if data and data.label and data.label ~= "" then
        infoBits[#infoBits + 1] = data.label
    end
    if data and data.savedAtText and data.savedAtText ~= "" then
        infoBits[#infoBits + 1] = data.savedAtText
    end
    if data and data.savedTimeText and data.savedTimeText ~= "" then
        infoBits[#infoBits + 1] = data.savedTimeText
    end

    local classR, classG, classB = GetClassColor(winner.classFile)
    ApplyFont(frame.name, 24, "OUTLINE", classR, classG, classB, 1)
    frame.name:SetText(winner.shortName or self:GetShortName(winner.name))
    frame.score:SetText(winner.score or 0)
    frame.logInfo:SetText(#infoBits > 0 and table.concat(infoBits, " - ") or L("daily_winner_fallback"))
    frame:Show()
    if soundPath and self:IsSoundEnabled() then
        PlaySoundFile(soundPath, "Master")
    end
end

function addon:HideVoteResultsWindow()
    if self.voteResultsWindow then
        self.voteResultsWindow:Hide()
    end
end

function addon:RefreshVoteResultsWindow()
    if not self.voteResultsWindow then
        return
    end

    local frame = self.voteResultsWindow
    local results = (self.voteSession and self.voteSession.lastResults) or {}

    if #results == 0 then
        frame.emptyState:Show()
    else
        frame.emptyState:Hide()
    end

    for i, row in ipairs(frame.rows) do
        local entry = results[i]
        if entry then
            local classFile = self.GetClassFileForPlayerName and self:GetClassFileForPlayerName(entry.target) or nil
            local voteCount = entry.votes or 0
            row.text:SetText(self:L("votes_for_fmt", voteCount, ColorizeName(self:GetShortName(entry.target), classFile)))
            SetRowBackground(row, i % 2 == 0 and SURFACE_ALT or SURFACE_COLOR)
            row:Show()
        else
            row.text:SetText("")
            row:Hide()
        end
    end
end

function addon:ShowVoteWindow()
    if not self.voteWindow then
        return
    end

    self:RefreshVoteWindow()
    self.voteWindow:Show()
end

function addon:HideVoteWindow()
    if self.voteWindow then
        self.voteWindow:Hide()
    end
end

function addon:RefreshVoteWindow()
    if not self.voteWindow then
        return
    end

    local frame = self.voteWindow
    self:RefreshRoster()
    local eligibleSet = self:GetVoteEligibleTargetSet()

    local hasActiveVote = self.voteSession and self.voteSession.isOpen and self.voteSession.controller
    if not hasActiveVote then
        frame.emptyState:SetText(L("vote_no_active"))
        frame.emptyState:Show()
        for _, header in ipairs(frame.groupHeaders) do
            header:Hide()
        end
        for _, button in ipairs(frame.voteButtons) do
            button:Hide()
            button.playerName = nil
            button.classFile = nil
        end
        return
    end

    local groups = GetVoteGroups(eligibleSet)
    local groupCount = #groups
    if groupCount == 0 then
        frame.emptyState:SetText(L("no_eligible_vote_targets"))
        frame.emptyState:Show()
        for _, header in ipairs(frame.groupHeaders) do
            header:Hide()
        end
        for _, button in ipairs(frame.voteButtons) do
            button:Hide()
            button.playerName = nil
            button.classFile = nil
        end
        return
    end

    local columns = groupCount > 4 and 3 or 2
    local frameWidth = columns == 3 and VOTE_WINDOW_WIDTH_THREE_COLS or VOTE_WINDOW_WIDTH_TWO_COLS
    local columnWidth = columns == 3 and 164 or 168
    local columnGap = 12
    local rowHeight = 20
    local rowGap = 4
    local groupHeaderGap = 18
    local startX = 0
    local startY = -4
    local buttonIndex = 1

    frame:SetWidth(frameWidth)
    frame.emptyState:Hide()
    frame.subtitle:SetText(L("vote_whisper_flow", self:GetShortName(self.voteSession.controller)))

    for _, header in ipairs(frame.groupHeaders) do
        header:Hide()
    end

    for _, button in ipairs(frame.voteButtons) do
        button:Hide()
        button.playerName = nil
        button.classFile = nil
    end

    for groupIndex, groupData in ipairs(groups) do
        local header = frame.groupHeaders[groupIndex]
        local column = (groupIndex - 1) % columns
        local rowBlock = math.floor((groupIndex - 1) / columns)
        local x = startX + (column * (columnWidth + columnGap))
        local y = startY - (rowBlock * 116)

        if header then
            header:ClearAllPoints()
            header:SetPoint("TOPLEFT", x, y)
            header:SetText(groupData.group > 0 and L("group_label", groupData.group) or L("extra_label"))
            header:Show()
        end

        for memberIndex, member in ipairs(groupData.members or {}) do
            local button = frame.voteButtons[buttonIndex]
            if not button then
                break
            end

            buttonIndex = buttonIndex + 1
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", x, y - groupHeaderGap - ((memberIndex - 1) * (rowHeight + rowGap)))
            button:SetSize(columnWidth, rowHeight)
            button.playerName = member.name
            button.classFile = member.classFile

            local classR, classG, classB = GetClassColor(member.classFile)
            if button.nameText then
                ApplyFont(button.nameText, 11, "", classR, classG, classB, 1)
                button.nameText:SetText(self:GetShortName(member.name))
            end

            SetVotePlayerButtonTint(button, member.classFile, false)

            button:SetScript("OnClick", function(self)
                if self.playerName then
                    addon:CastVote(self.playerName)
                end
            end)
            button:Show()
        end
    end
end

function addon:ToggleMainWindow()
    local ui = self:GetUIState()
    if ui.pinnedMode then
        if self.pinnedWindow then
            self.pinnedWindow.userHidden = true
            self.pinnedWindow:Hide()
        end
        if self.mainWindow then
            self:RefreshRoster()
            if self.RequestSync then
                self:RequestSync()
            end
            self.mainWindow:Show()
            self:RefreshUI()
            local summaryState = self:GetUIState().summary or {}
            if summaryState.isOpen then
                self:ToggleSummaryWindow(true, summaryState.mode or "logs")
            end
        end
        return
    end

    if self.mainWindow:IsShown() then
        self.mainWindow:Hide()
    else
        self:RefreshRoster()
        if self.RequestSync then
            self:RequestSync()
        end
        self.mainWindow:Show()
        self:RefreshUI()
        local summaryState = self:GetUIState().summary or {}
        if summaryState.isOpen then
            self:ToggleSummaryWindow(true, summaryState.mode or "logs")
        end
    end
end

function addon:ToggleLogsPanel()
    if not self.summaryWindow then
        return
    end

    local inLogsMode = (self.summaryMode == "logs" or self.summaryMode == "log_detail")
    if self.summaryWindow:IsShown() and inLogsMode then
        self:ToggleSummaryWindow(false)
        return
    end

    self.selectedLogEntry = nil
    self.summaryScrollOffset = 0
    self:ToggleSummaryWindow(true, "logs")
end

function addon:ToggleSummaryWindow(forceOpen, mode)
    if not self.summaryWindow then
        return
    end

    if mode then
        self.summaryMode = mode
    end

    local shouldOpen = forceOpen
    if shouldOpen == nil then
        shouldOpen = not self.summaryWindow:IsShown()
    end

    if shouldOpen then
        self:RefreshRoster()
        self.summaryWindow:Show()
        self:RefreshSummaryUI()
        self:SaveSummaryWindowState()
    else
        self.summaryWindow:Hide()
        self.selectedLogEntry = nil
        self.summaryMode = "logs"
        self:SaveSummaryWindowState()
    end
end

local function GetVisibleRowCount(frame)
    local usableHeight = frame.content:GetHeight()
    if not usableHeight or usableHeight <= 0 then
        return 0
    end

    return math.max(0, math.floor((usableHeight + ROW_SPACING) / ROW_STEP))
end

local function GetSummaryVisibleRowCount(frame)
    local usableHeight = frame.content:GetHeight()
    if not usableHeight or usableHeight <= 0 then
        return 0
    end

    return math.max(0, math.floor(usableHeight / SUMMARY_ROW_HEIGHT))
end

function addon:RefreshUI()
    if not self.mainWindow then
        return
    end

    self:RefreshRoster()

    local frame = self.mainWindow
    local ui = self:GetUIState()
    ApplyMainLayout(frame)
    local officer = self:IsOfficer()
    local canControlVote = officer
    local pinned = false
    local roster = GetDisplayRoster("main")
    local visibleRows = GetVisibleRowCount(frame)
    local totalRows = #roster
    local maxOffset = math.max(0, totalRows - visibleRows)
    local scrollOffset = math.min(self.scrollOffset or 0, maxOffset)
    self.scrollOffset = scrollOffset

    ApplyWindowScale(frame)
    ApplyPinnedWindowStyle(frame, false)
    frame.scrollBar:SetMinMaxValues(0, maxOffset)
    frame.scrollBar:SetShown((maxOffset > 0) and not pinned)
    if math.floor(frame.scrollBar:GetValue() or 0) ~= scrollOffset then
        frame.scrollBar:SetValue(scrollOffset)
    end

    frame.headerName:SetText(GetNameSortLabel(ui.sortMode or "group"))
    frame.headerScore:SetText(L("header_conescore"))
    SetButtonIcon(frame.pinButton, ICON_PIN_NO, 12, true)
    SetButtonIcon(frame.lockButton, ui.locked and ICON_LOCKED or ICON_UNLOCKED, 12, true)
    if frame.soundButton then
        SetButtonIcon(frame.soundButton, (ui.soundEnabled ~= false) and ICON_SOUND_YES or ICON_SOUND_NO, 12, true)
    end
    if frame.resizeHandle then
        frame.resizeHandle:SetShown(not ui.locked)
    end
    frame.lockButton:Show()
    frame.logsToggleButton:Show()
    frame.coneLogButton:SetShown(officer)
    frame.voteButton:SetShown(canControlVote)
    frame.postButton:SetShown(officer)
    frame.logsToggleButton:SetShown(true)
    frame.filterButton:SetShown(officer)
    frame.resetButton:SetShown(officer)
    frame.scaleDownButton:SetShown(true)
    frame.scaleUpButton:SetShown(true)
    LayoutFooterButtons(frame, canControlVote, officer)
    frame.scaleLabel:SetText(L("window_scale"))
    frame.userHint:SetShown(not officer)
    local activeLog = self.GetActiveConeLog and self:GetActiveConeLog() or nil
    frame.coneLogButton:SetText(activeLog and L("close_log") or L("start_log"))
    SetButtonLeadingIcon(frame.coneLogButton, activeLog and ICON_STOP or ICON_PLAY, 12)
    if frame.coneLogButton.leadingIcon then
        frame.coneLogButton.leadingIcon:SetVertexColor(HIGHLIGHT_COLOR[1], HIGHLIGHT_COLOR[2], HIGHLIGHT_COLOR[3], 1)
        frame.coneLogButton.leadingIcon:SetBlendMode("ADD")
    end
    local mainShowZero = ui.showZeroScoresMain
    if mainShowZero == nil then
        mainShowZero = ui.showZeroScores
    end
    if mainShowZero == nil then
        mainShowZero = true
    end
    SetButtonIcon(frame.filterButton, (mainShowZero == false) and ICON_HIDE_YES or ICON_HIDE_NO, 12, true)
    if canControlVote then
        frame.voteButton:SetText((self.voteSession and self.voteSession.isOpen) and L("close") or L("vote"))
    else
        frame.voteHint:Hide()
    end

    for i = 1, MAX_ROWS do
        local row = frame.rows[i]
        local rosterIndex = scrollOffset + i
        local member = i <= visibleRows and roster[rosterIndex] or nil

        if member then
            local previousMember = roster[rosterIndex - 1]
            local groupMode = (ui.sortMode or "group") == "group"
            local isNewGroup = groupMode and ((not previousMember) or member.group ~= previousMember.group)

            local classR, classG, classB = GetClassColor(member.classFile)
            ApplyFont(row.name, 11, "", classR, classG, classB, 1)
            ApplyFont(row.score, 12, "OUTLINE", 1, 1, 1, 1)
            row.name:SetShadowColor(0, 0, 0, 0.9)
            row.name:SetShadowOffset(1, -1)
            row.score:SetShadowColor(0, 0, 0, 1)
            row.score:SetShadowOffset(1, -1)
            row.name:SetText(self:GetShortName(member.name))
            row.score:SetText(member.score or 0)
            row.minus:SetShown(officer)
            row.plus:SetShown(officer)
            row.minus:SetScript("OnClick", function()
                addon:AdjustScore(member.name, -1)
            end)
            row.plus:SetScript("OnClick", function()
                addon:AdjustScore(member.name, 1)
            end)
            local note = addon:GetPlayerNote(member.name)
            row:SetScript("OnEnter", function(self)
                if note and note ~= "" then
                    SetTooltip(self, addon:GetShortName(member.name), {
                        addon:L("tooltip_member_score", member.score or 0),
                        addon:L("tooltip_last_note", note),
                    })
                end
            end)
            row:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            SetRowBackground(row, i % 2 == 0 and SURFACE_ALT or SURFACE_COLOR)
            row.divider:SetShown(isNewGroup and rosterIndex > 1)
            row:Show()
        else
            row.name:SetText("")
            row.score:SetText("")
            row.minus:Hide()
            row.plus:Hide()
            row.divider:Hide()
            row:SetScript("OnEnter", nil)
            row:SetScript("OnLeave", nil)
            row:Hide()
        end
    end

    self:RefreshVoteWindow()
    self:RefreshSummaryUI()
    if ui.pinnedMode and self.pinnedWindow then
        self:RefreshPinnedWindow()
    end
end

function addon:RefreshSummaryUI()
    if not self.summaryWindow then
        return
    end

    local frame = self.summaryWindow
    ApplySummaryLayout(frame)
    local mode = self.summaryMode or "logs"
    local entries
    local emptyText

    if mode == "log_detail" and self.selectedLogEntry then
        frame.backButton:Show()
        frame.title:SetText(self.selectedLogEntry.label or L("saved_log"))
        frame.subtitle:SetText(string.format("%s %s", self.selectedLogEntry.savedAtText or "--/--/----", self.selectedLogEntry.savedTimeText or ""))
        entries = SortLogPlayers(ClonePlayers(self.selectedLogEntry.players or {}))
        emptyText = L("empty_log_detail")
    else
        frame.backButton:Hide()
        frame.title:SetText(L("saved_logs"))
        frame.subtitle:SetText(L("saved_logs_subtitle"))
        entries = self:GetSavedLogs()
        emptyText = L("empty_logs")
    end

    local visibleRows = GetSummaryVisibleRowCount(frame)
    local totalRows = #entries
    local maxOffset = math.max(0, totalRows - visibleRows)
    local scrollOffset = math.min(self.summaryScrollOffset or 0, maxOffset)
    self.summaryScrollOffset = scrollOffset

    frame.scrollBar:SetMinMaxValues(0, maxOffset)
    frame.scrollBar:SetShown(maxOffset > 0)
    if math.floor(frame.scrollBar:GetValue() or 0) ~= scrollOffset then
        frame.scrollBar:SetValue(scrollOffset)
    end

    for i, row in ipairs(frame.rows) do
        local entry = i <= visibleRows and entries[scrollOffset + i] or nil
        if entry then
            row.isClickable = false
            if mode == "log_detail" then
                local playerName = entry.shortName or entry.name or "Unknown"
                local scoreText = tostring(entry.score or 0)
                local noteText = entry.note and entry.note ~= "" and ("  |cff9ea6b5" .. entry.note .. "|r") or ""
                row.text:SetText(string.format("%s  -  %s%s", ColorizeName(playerName, entry.classFile), scoreText, noteText))
                row:SetScript("OnClick", nil)
            else
                row.text:SetText(string.format("%d. |cffefc44a%s|r  |cff9ea6b5%s %s|r", i, entry.label or L("raid_default"), entry.savedAtText or "--/--/----", entry.savedTimeText or ""))
                row.isClickable = true
                local selectedEntry = entry
                row:SetScript("OnClick", function()
                    addon.selectedLogEntry = selectedEntry
                    addon.summaryMode = "log_detail"
                    addon.summaryScrollOffset = 0
                    addon:RefreshSummaryUI()
                end)
            end
            row.defaultBg = i % 2 == 0 and SURFACE_ALT or SURFACE_COLOR
            SetRowBackground(row, row.defaultBg)
            row:Show()
        else
            row.text:SetText("")
            row.isClickable = false
            row.defaultBg = nil
            row:SetScript("OnClick", nil)
            if i == 1 and totalRows == 0 then
                row.text:SetText(emptyText or "")
                row.defaultBg = SURFACE_COLOR
                SetRowBackground(row, row.defaultBg)
                row:Show()
            else
                row:Hide()
            end
        end
    end

    self:SaveSummaryWindowState()
end
