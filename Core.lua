local addonName, ns = ...

ConeScore = {}
local addon = ConeScore
ns.addon = addon

addon.locale = GetLocale() == "ptBR" and "ptBR" or "enUS"
addon.strings = {
    enUS = {
        raid_default = "Raid",
        print_prefix = "ConeScore",
        use_vote_chat_in_raid = "You must be in a raid to use vote chat.",
        join_raid_save_log = "Join a raid before saving a daily log.",
        log_saved = "Log saved: %s (%s)",
        join_raid_start_log = "Join a raid before starting a ConeLog.",
        log_already_active = "A ConeLog is already active.",
        conelog_name_required = "ConeLog name is required.",
        log_started = "ConeLog started: %s",
        no_active_log = "No active ConeLog to close.",
        log_closed = "ConeLog closed: %s",
        officer_post_only = "Only the raid leader or an assistant can post ConeScore results.",
        no_scores_to_post = "No non-zero ConeScore entries to post.",
        post_header = "ConeScore ------------",
        post_footer = "------------------------",
        loaded_message = "Loaded. Use /cs to open ConeScore.",
        roster_refreshed = "Raid roster refreshed.",
        reset_officer_only = "Only the raid leader or an assistant can reset ConeScore.",
        all_scores_reset = "All ConeScore values were reset for the current raid.",
        vote_open_rl_only = "Only the raid leader can open voting.",
        vote_pick_one = "Pick at least one raid member for the vote.",
        vote_opened_with_label = "ConeScore Vote opened for %s. Whisper %s with the player name to vote.",
        vote_opened = "ConeScore Vote opened. Whisper %s with the player name to vote.",
        vote_control_officer_only = "Only the raid leader or an assistant can open or close voting.",
        vote_closed = "ConeScore Vote closed.",
        vote_target_must_be_raid = "Vote target must be a player currently in the raid.",
        vote_target_not_eligible = "That player is not in the current vote pool.",
        voted_for_cone = "Voted %s for Cone.",
        vote_controller_missing = "No active ConeScore vote controller found yet. Try again in a moment.",
        vote_usage = "Usage: /cs vote open, /cs vote close, or /cs vote PlayerName",
        vote_closed_no_votes = "ConeScore Vote closed. No votes received.",
        vote_results_header = "ConeScore Vote results:",
        votes_for_player = "%d votes for %s",
        vote_opened_local_with_label = "Vote opened for %s. Whisper %s with the player name to vote.",
        vote_opened_local = "Vote opened. Whisper %s with the player name to vote.",
        whisper_exact_name = "ConeScore: vote by whispering the exact player name from the raid.",
        whisper_not_in_pool = "ConeScore: that player is not in the current vote pool.",
        officer_edit_only = "Only the raid leader or an assistant can edit ConeScore.",
        player_no_longer_in_raid = "That player is no longer in the raid.",
        death_melee = "Melee from %s",
        unknown_source = "unknown",
        death_environment = "Environmental damage: %s",
        unknown_environment = "environment",
        unknown_cause = "Unknown cause",
        sort_player = "Player",
        sort_player_alpha = "Player A-Z",
        sort_player_class = "Player Class",
        tooltip_sound = "Sound",
        tooltip_sound_desc = "Toggle ConeScore toast sounds.",
        tooltip_pin = "Pin",
        tooltip_pin_desc = "Show the lightweight pinned board.",
        tooltip_lock = "Lock",
        tooltip_lock_desc = "Lock or unlock the main window.",
        tooltip_post = "Post",
        tooltip_post_desc = "Post current ConeScore results to raid chat.",
        tooltip_logs = "Logs",
        tooltip_logs_desc = "Open saved ConeLogs.",
        tooltip_hide_zero = "Hide Zero",
        tooltip_hide_zero_desc = "Toggle zero-score players.",
        tooltip_reset = "Reset",
        tooltip_reset_desc = "Double-click to reset current raid scores.",
        tooltip_scale_down = "Scale Down",
        tooltip_scale_down_desc = "Reduce window scale.",
        tooltip_scale_up = "Scale Up",
        tooltip_scale_up_desc = "Increase window scale.",
        tooltip_open_ui = "Open UI",
        tooltip_open_ui_desc = "Return to the main window.",
        tooltip_vote_player = "Click to vote for this player.",
        reset_confirm = "Click Reset again within 3 seconds to clear current raid scores.",
        user_hint = "Track the current ConeScore live.",
        header_player = "Player",
        header_conescore = "ConeScore",
        saved_logs = "Saved Logs",
        saved_logs_subtitle = "Manual snapshots from the last 7 days",
        back = "Back",
        conescore_vote = "ConeScore Vote",
        vote_click_name = "Click a player name to vote.",
        vote_no_active = "No active vote.",
        vote_pool = "Vote Pool",
        vote_pool_subtitle = "Pick which raid members can receive votes.",
        select_all = "Select All",
        no_raid_members = "No raid members available.",
        group_label = "GROUP %d",
        extra_label = "EXTRA",
        vote_results = "Vote Results",
        latest_vote_tally = "Latest ConeScore vote tally",
        no_vote_results = "No vote results yet.",
        top3_title = "ConeScore Top 3",
        top3_subtitle = "Final standings for the latest raid log.",
        top_cone = "TOP CONE",
        clean_raid = "Clean raid. No cones crowned tonight.",
        cone_of_day = "CONE OF THE DAY",
        congratulations = "Congratulations.",
        cone_day_subtitle = "You are today's Cone. A performance for the history books.",
        cone_day_body = "Against all odds, you rose above the raid and secured the finest ConeScore of the night.",
        daily_winner_fallback = "ConeScore daily winner",
        start_conelog = "Start ConeLog",
        conelog_prompt = "Choose a name for this raid log.",
        conelog_name_placeholder = "ConeLog name",
        start = "Start",
        cancel = "Cancel",
        no_eligible_vote_targets = "No eligible vote targets.",
        vote_whisper_flow = "Whisper flow is active. Click a player to vote via %s.",
        sound_on = "S",
        sound_off = "M",
        window_scale = "Window Scale",
        close_log = "Close Log",
        start_log = "Start Log",
        vote = "Vote",
        close = "Close",
        tooltip_member_score = "ConeScore: %d",
        tooltip_last_note = "Last note: %s",
        saved_log = "Saved Log",
        empty_log_detail = "No non-zero ConeScore entries in this log.",
        empty_logs = "No saved logs yet.",
        votes_for_fmt = "|cffffd54f%d|r votes for %s",
    },
    ptBR = {
        raid_default = "Raid",
        print_prefix = "ConeScore",
        use_vote_chat_in_raid = "Voce precisa estar em uma raid para usar a votacao no chat.",
        join_raid_save_log = "Entre em uma raid antes de salvar um ConeLog.",
        log_saved = "Log salvo: %s (%s)",
        join_raid_start_log = "Entre em uma raid antes de iniciar um ConeLog.",
        log_already_active = "Ja existe um ConeLog ativo.",
        conelog_name_required = "O nome do ConeLog e obrigatorio.",
        log_started = "ConeLog iniciado: %s",
        no_active_log = "Nao ha ConeLog ativo para fechar.",
        log_closed = "ConeLog fechado: %s",
        officer_post_only = "Apenas o raid leader ou um assistente pode postar os resultados do ConeScore.",
        no_scores_to_post = "Nao ha entradas com ConeScore acima de zero para postar.",
        post_header = "ConeScore ------------",
        post_footer = "------------------------",
        loaded_message = "Carregado. Use /cs para abrir o ConeScore.",
        roster_refreshed = "Roster da raid atualizado.",
        reset_officer_only = "Apenas o raid leader ou um assistente pode resetar o ConeScore.",
        all_scores_reset = "Todos os valores do ConeScore foram resetados para a raid atual.",
        vote_open_rl_only = "Apenas o raid leader pode abrir a votacao.",
        vote_pick_one = "Escolha pelo menos um membro da raid para a votacao.",
        vote_opened_with_label = "Votacao do ConeScore aberta para %s. Whisper para %s com o nome do player para votar.",
        vote_opened = "Votacao do ConeScore aberta. Whisper para %s com o nome do player para votar.",
        vote_control_officer_only = "Apenas o raid leader ou um assistente pode abrir ou fechar a votacao.",
        vote_closed = "Votacao do ConeScore fechada.",
        vote_target_must_be_raid = "O alvo do voto precisa ser um player que esteja na raid no momento.",
        vote_target_not_eligible = "Esse player nao esta na pool atual da votacao.",
        voted_for_cone = "Voce votou em %s para Cone.",
        vote_controller_missing = "Nenhum controlador de votacao do ConeScore foi encontrado ainda. Tente novamente em instantes.",
        vote_usage = "Uso: /cs vote open, /cs vote close ou /cs vote NomeDoPlayer",
        vote_closed_no_votes = "Votacao do ConeScore fechada. Nenhum voto recebido.",
        vote_results_header = "Resultados da votacao do ConeScore:",
        votes_for_player = "%d votos para %s",
        vote_opened_local_with_label = "Votacao aberta para %s. Whisper para %s com o nome do player para votar.",
        vote_opened_local = "Votacao aberta. Whisper para %s com o nome do player para votar.",
        whisper_exact_name = "ConeScore: vote mandando whisper com o nome exato do player na raid.",
        whisper_not_in_pool = "ConeScore: esse player nao esta na pool atual da votacao.",
        officer_edit_only = "Apenas o raid leader ou um assistente pode editar o ConeScore.",
        player_no_longer_in_raid = "Esse player nao esta mais na raid.",
        death_melee = "Melee de %s",
        unknown_source = "desconhecido",
        death_environment = "Dano ambiental: %s",
        unknown_environment = "ambiente",
        unknown_cause = "Causa desconhecida",
        sort_player = "Player",
        sort_player_alpha = "Player A-Z",
        sort_player_class = "Classe",
        tooltip_sound = "Som",
        tooltip_sound_desc = "Liga ou desliga os sons dos toasts do ConeScore.",
        tooltip_pin = "Fixar",
        tooltip_pin_desc = "Mostra a versao leve fixada na tela.",
        tooltip_lock = "Travar",
        tooltip_lock_desc = "Trava ou destrava a janela principal.",
        tooltip_post = "Postar",
        tooltip_post_desc = "Posta os resultados atuais do ConeScore no chat da raid.",
        tooltip_logs = "Logs",
        tooltip_logs_desc = "Abre os ConeLogs salvos.",
        tooltip_hide_zero = "Esconder Zero",
        tooltip_hide_zero_desc = "Alterna a exibicao de players com zero.",
        tooltip_reset = "Resetar",
        tooltip_reset_desc = "Clique duas vezes para resetar os scores da raid atual.",
        tooltip_scale_down = "Diminuir Escala",
        tooltip_scale_down_desc = "Reduz a escala da janela.",
        tooltip_scale_up = "Aumentar Escala",
        tooltip_scale_up_desc = "Aumenta a escala da janela.",
        tooltip_open_ui = "Abrir UI",
        tooltip_open_ui_desc = "Volta para a janela principal.",
        tooltip_vote_player = "Clique para votar neste player.",
        reset_confirm = "Clique em Reset novamente em ate 3 segundos para limpar os scores da raid atual.",
        user_hint = "Acompanhe o ConeScore atual em tempo real.",
        header_player = "Player",
        header_conescore = "ConeScore",
        saved_logs = "Logs Salvos",
        saved_logs_subtitle = "Snapshots manuais dos ultimos 7 dias",
        back = "Voltar",
        conescore_vote = "Votacao ConeScore",
        vote_click_name = "Clique no nome de um player para votar.",
        vote_no_active = "Nenhuma votacao ativa.",
        vote_pool = "Pool de Votos",
        vote_pool_subtitle = "Escolha quais membros da raid podem receber votos.",
        select_all = "Selecionar Todos",
        no_raid_members = "Nenhum membro de raid disponivel.",
        group_label = "GRUPO %d",
        extra_label = "EXTRA",
        vote_results = "Resultado da Votacao",
        latest_vote_tally = "Ultima contagem da votacao do ConeScore",
        no_vote_results = "Ainda nao ha resultados da votacao.",
        top3_title = "Top 3 ConeScore",
        top3_subtitle = "Classificacao final do ultimo log da raid.",
        top_cone = "TOP CONE",
        clean_raid = "Raid limpa. Nenhum cone coroado hoje.",
        cone_of_day = "CONE DO DIA",
        congratulations = "Parabens.",
        cone_day_subtitle = "Voce e o Cone de hoje. Uma performance digna dos livros de historia.",
        cone_day_body = "Contra todas as probabilidades, voce superou a raid e garantiu o melhor ConeScore da noite.",
        daily_winner_fallback = "Vencedor diario do ConeScore",
        start_conelog = "Iniciar ConeLog",
        conelog_prompt = "Escolha um nome para este log da raid.",
        conelog_name_placeholder = "Nome do ConeLog",
        start = "Iniciar",
        cancel = "Cancelar",
        no_eligible_vote_targets = "Nao ha alvos elegiveis para a votacao.",
        vote_whisper_flow = "O fluxo via whisper esta ativo. Clique em um player para votar via %s.",
        sound_on = "S",
        sound_off = "M",
        window_scale = "Escala da Janela",
        close_log = "Fechar Log",
        start_log = "Iniciar Log",
        vote = "Votar",
        close = "Fechar",
        tooltip_member_score = "ConeScore: %d",
        tooltip_last_note = "Ultima nota: %s",
        saved_log = "Log Salvo",
        empty_log_detail = "Nao ha entradas com ConeScore acima de zero neste log.",
        empty_logs = "Ainda nao ha logs salvos.",
        votes_for_fmt = "|cffffd54f%d|r votos para %s",
    },
}

function addon:L(key, ...)
    local localeTable = self.strings[self.locale] or self.strings.enUS or {}
    local fallbackTable = self.strings.enUS or {}
    local value = localeTable[key] or fallbackTable[key] or key
    if select("#", ...) > 0 then
        return string.format(value, ...)
    end
    return value
end

local PREFIX = "ConeScore"
addon.defaults = {
    scores = {},
    notes = {},
    lastDeath = {},
    lastTry = {
        active = false,
        deaths = {},
        startedAt = 0,
        endedAt = 0,
        trigger = "",
    },
    history = {
        lastCompletedTry = {},
        savedLogs = {},
        activeConeLog = nil,
    },
    ui = {
        compactMode = false,
        pinnedMode = false,
        showZeroScores = true,
        showZeroScoresMain = true,
        showZeroScoresPinned = true,
        soundEnabled = true,
        localeOverride = nil,
        sortMode = "group",
        locked = false,
        windowScale = 1,
        main = {
            width = 620,
            height = 560,
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = 0,
        },
        pinned = {
            point = "CENTER",
            relativePoint = "CENTER",
            x = 280,
            y = 0,
            locked = false,
        },
        summary = {
            width = 340,
            isOpen = false,
            mode = "logs",
        },
    },
}

local loaderFrame = CreateFrame("Frame")
addon.frame = loaderFrame

local function CopyDefaults(target, source)
    if type(source) ~= "table" then
        return
    end

    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            CopyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

function addon:GetDB()
    return ConeScoreDB
end

function addon:ResolveLocale()
    local db = self:GetDB() or {}
    local ui = db.ui or {}
    local override = ui.localeOverride
    if override == "ptBR" or override == "enUS" then
        self.locale = override
        return self.locale
    end

    self.locale = GetLocale() == "ptBR" and "ptBR" or "enUS"
    return self.locale
end

function addon:SetLocaleOverride(localeCode)
    local ui = self:GetUIState()
    if localeCode == "ptBR" or localeCode == "enUS" then
        ui.localeOverride = localeCode
    else
        ui.localeOverride = nil
    end

    self:ResolveLocale()
end

function addon:IsOfficer()
    return IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
end

function addon:IsRaidLeader()
    return IsInRaid() and UnitIsGroupLeader("player")
end

function addon:IsPlayerInMyRaid(fullName)
    if not fullName or not IsInRaid() then
        return false
    end

    for i = 1, GetNumGroupMembers() do
        local unit = "raid" .. i
        local name = GetUnitName(unit, true)
        if name == fullName then
            return true
        end
    end

    return false
end

function addon:ResolveRaidPlayerName(name)
    local trimmed = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "" or not IsInRaid() then
        return nil
    end

    local lowered = trimmed:lower()
    for i = 1, GetNumGroupMembers() do
        local unit = "raid" .. i
        local fullName = GetUnitName(unit, true)
        if fullName then
            local shortName = self:GetShortName(fullName)
            if fullName:lower() == lowered or shortName:lower() == lowered then
                return fullName
            end
        end
    end

    return nil
end

function addon:NormalizeName(name)
    if not name or name == "" then
        return nil
    end

    if name:find("-", 1, true) then
        return name
    end

    local realm = GetNormalizedRealmName()
    if realm and realm ~= "" then
        return name .. "-" .. realm
    end

    return name
end

function addon:GetShortName(fullName)
    if not fullName then
        return "?"
    end

    return Ambiguate(fullName, "short")
end

function addon:GetClassFileForPlayerName(name)
    local shortName = self:GetShortName(name)
    for _, member in ipairs(self:GetRoster() or {}) do
        if member.name == name or self:GetShortName(member.name) == name or self:GetShortName(member.name) == shortName then
            return member.classFile
        end
    end

    return nil
end

function addon:ResolveRosterEntryName(name)
    if not name then
        return nil
    end

    local normalized = self:NormalizeName(name)
    local shortName = self:GetShortName(name)
    for _, member in ipairs(self:GetRoster() or {}) do
        local memberName = member.name
        if memberName == name or memberName == normalized then
            return memberName
        end

        if self:GetShortName(memberName) == name or self:GetShortName(memberName) == shortName then
            return memberName
        end
    end

    return normalized or name
end

function addon:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff98" .. self:L("print_prefix") .. "|r " .. tostring(message))
end

function addon:SendRaidNotice(message)
    if not IsInRaid() then
        self:Print(self:L("use_vote_chat_in_raid"))
        return false
    end

    SendChatMessage(message, "RAID")
    return true
end

function addon:RequestRefresh()
    if self.RefreshUI then
        self:RefreshUI()
    end
end

function addon:UpdateRaidAutoPinned()
    local ui = self:GetUIState()

    if IsInRaid() then
        ui.pinnedMode = true
        if self.mainWindow and not self.mainWindow:IsShown() and self.RefreshPinnedWindow then
            if self.pinnedWindow then
                self.pinnedWindow.userHidden = false
            end
            self:RefreshPinnedWindow(true)
        end
        return
    end

    ui.pinnedMode = false
    if self.pinnedWindow then
        self.pinnedWindow.userHidden = true
        self.pinnedWindow:Hide()
    end
end

function addon:GetUIState()
    local db = self:GetDB()
    db.ui = db.ui or {}
    return db.ui
end

function addon:SaveMainWindowState()
    if not self.mainWindow then
        return
    end

    local ui = self:GetUIState()
    ui.main = ui.main or {}

    local point, _, relativePoint, x, y = self.mainWindow:GetPoint(1)
    ui.main.point = point or "CENTER"
    ui.main.relativePoint = relativePoint or point or "CENTER"
    ui.main.x = x or 0
    ui.main.y = y or 0
    ui.main.width = math.floor((self.mainWindow:GetWidth() or 620) + 0.5)
    ui.main.height = math.floor((self.mainWindow:GetHeight() or 560) + 0.5)
end

function addon:SaveSummaryWindowState()
    if not self.summaryWindow then
        return
    end

    local ui = self:GetUIState()
    ui.summary = ui.summary or {}
    ui.summary.width = math.floor((self.summaryWindow:GetWidth() or 340) + 0.5)
    ui.summary.isOpen = self.summaryWindow:IsShown() and true or false
    ui.summary.mode = self.summaryMode or "logs"
end

function addon:SavePinnedWindowState()
    if not self.pinnedWindow then
        return
    end

    local ui = self:GetUIState()
    ui.pinned = ui.pinned or {}

    local point, _, relativePoint, x, y = self.pinnedWindow:GetPoint(1)
    ui.pinned.point = point or "CENTER"
    ui.pinned.relativePoint = relativePoint or point or "CENTER"
    ui.pinned.x = x or 0
    ui.pinned.y = y or 0
end

function addon:InitDB()
    ConeScoreDB = ConeScoreDB or {}
    CopyDefaults(ConeScoreDB, self.defaults)
    self:ResolveLocale()
    self:PruneSavedLogs()
end

function addon:GetSavedLogs()
    local db = self:GetDB()
    db.history = db.history or {}
    db.history.savedLogs = db.history.savedLogs or {}
    return db.history.savedLogs
end

function addon:GetActiveConeLog()
    local db = self:GetDB()
    db.history = db.history or {}
    return db.history.activeConeLog
end

function addon:SetActiveConeLog(entry)
    local db = self:GetDB()
    db.history = db.history or {}
    db.history.activeConeLog = entry
end

function addon:PruneSavedLogs()
    local weekInSeconds = 7 * 24 * 60 * 60
    local now = time()
    local logs = self:GetSavedLogs()
    local kept = {}

    for _, entry in ipairs(logs) do
        if type(entry) == "table" and type(entry.savedAt) == "number" and (now - entry.savedAt) <= weekInSeconds then
            kept[#kept + 1] = entry
        end
    end

    self:GetDB().history.savedLogs = kept
end

function addon:SaveCurrentLog(label)
    self:RefreshRoster()

    local roster = self:GetRoster()
    if #roster == 0 then
        self:Print(self:L("join_raid_save_log"))
        return false
    end

    self:PruneSavedLogs()

    local trimmedLabel = tostring(label or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if trimmedLabel == "" then
        trimmedLabel = self:L("raid_default")
    end

    local entry = {
        label = trimmedLabel,
        savedAt = time(),
        savedAtText = date("%d/%m/%Y"),
        savedTimeText = date("%H:%M"),
        players = {},
    }

    for _, member in ipairs(roster) do
        entry.players[#entry.players + 1] = {
            name = member.name,
            shortName = self:GetShortName(member.name),
            score = self:GetScore(member.name),
            group = member.group,
            classFile = member.classFile,
            note = self:GetPlayerNote(member.name),
        }
    end

    table.insert(self:GetSavedLogs(), 1, entry)
    self:PruneSavedLogs()
    self:Print(self:L("log_saved", entry.label, entry.savedAtText))
    self:RefreshSummaryUI()
    return entry
end

function addon:StartConeLog(label)
    self:RefreshRoster()

    if #self:GetRoster() == 0 then
        self:Print(self:L("join_raid_start_log"))
        return false
    end

    if self:GetActiveConeLog() then
        self:Print(self:L("log_already_active"))
        return false
    end

    local trimmedLabel = tostring(label or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if trimmedLabel == "" then
        self:Print(self:L("conelog_name_required"))
        return false
    end

    self:SetActiveConeLog({
        label = trimmedLabel,
        startedAt = time(),
        startedAtText = date("%d/%m/%Y"),
        startedTimeText = date("%H:%M"),
    })
    self:Print(self:L("log_started", trimmedLabel))
    self:RequestRefresh()
    return true
end

function addon:CloseConeLog()
    local activeLog = self:GetActiveConeLog()
    if not activeLog then
        self:Print(self:L("no_active_log"))
        return false
    end

    local savedEntry = self:SaveCurrentLog(activeLog.label)
    if not savedEntry then
        return false
    end

    if self.BroadcastDailyToast then
        self:BroadcastDailyToast(savedEntry)
    end

    self:SetActiveConeLog(nil)
    self:ResetAllScores()
    self:Print(self:L("log_closed", activeLog.label or self:L("raid_default")))
    self:RequestRefresh()
    return true
end

function addon:GetSortedScoreResults()
    self:RefreshRoster()

    local results = {}
    for _, member in ipairs(self:GetRoster() or {}) do
        local score = self:GetScore(member.name)
        if score and score > 0 then
            results[#results + 1] = {
                name = member.name,
                shortName = self:GetShortName(member.name),
                score = score,
                group = member.group,
                classFile = member.classFile,
            }
        end
    end

    table.sort(results, function(a, b)
        if a.score == b.score then
            return (a.shortName or a.name or "") < (b.shortName or b.name or "")
        end
        return a.score > b.score
    end)

    return results
end

function addon:GetTopScoreEntries(players, limit)
    local results = {}

    for _, player in ipairs(players or {}) do
        local score = tonumber(player.score) or 0
        if score > 0 then
            results[#results + 1] = {
                name = player.name,
                shortName = player.shortName or self:GetShortName(player.name),
                score = score,
                group = player.group,
                classFile = player.classFile,
            }
        end
    end

    table.sort(results, function(a, b)
        if a.score == b.score then
            return (a.shortName or a.name or "") < (b.shortName or b.name or "")
        end
        return a.score > b.score
    end)

    local capped = {}
    local maxCount = math.max(0, tonumber(limit) or 3)
    for index = 1, math.min(#results, maxCount) do
        capped[#capped + 1] = results[index]
    end

    return capped
end

function addon:BuildDailyToastEntries(entry)
    local topEntries = self:GetTopScoreEntries(entry and entry.players or nil, 3)
    return {
        label = entry and entry.label or self:L("raid_default"),
        savedAtText = entry and entry.savedAtText or date("%d/%m/%Y"),
        savedTimeText = entry and entry.savedTimeText or date("%H:%M"),
        entries = topEntries,
    }
end

function addon:PostScoreResults()
    if not self:IsOfficer() then
        self:Print(self:L("officer_post_only"))
        return
    end

    local results = self:GetSortedScoreResults()
    if #results == 0 then
        self:Print(self:L("no_scores_to_post"))
        return
    end

    self:SendRaidNotice(self:L("post_header"))
    for _, entry in ipairs(results) do
        self:SendRaidNotice(string.format("%s - %d", entry.shortName or self:GetShortName(entry.name), entry.score or 0))
    end
    self:SendRaidNotice(self:L("post_footer"))
end

function addon:OnInitialize()
    self:InitDB()
    self.voteSession = {
        isOpen = false,
        label = nil,
        controller = nil,
        eligibleTargets = {},
        votesBySender = {},
        countsByTarget = {},
        lastResults = {},
    }
    self.summaryMode = "logs"

    C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
    self.prefix = PREFIX

    self:BuildMainWindow()
    self:BuildSummaryWindow()
    self:BuildPinnedWindow()
    self:BuildVoteWindow()
    self:BuildVoteSetupWindow()
    self:BuildVoteResultsWindow()
    self:BuildConeLogPromptWindow()
    self:BuildDailyToastWindow()
    self:BuildWinnerToastWindow()
    self:RefreshRoster()
    self:RequestSync()
    self:RequestRefresh()

    SLASH_CONESCORE1 = "/conescore"
    SLASH_CONESCORE2 = "/cone"
    SLASH_CONESCORE3 = "/cs"
    SlashCmdList.CONESCORE = function(msg)
        local raw = (msg or ""):gsub("^%s+", ""):gsub("%s+$", "")
        local lower = raw:lower()
        if lower == "summary" or lower == "logs" then
            addon:RefreshRoster()
            addon:ToggleSummaryWindow()
        elseif lower == "lang pt" or lower == "lang ptbr" then
            addon:SetLocaleOverride("ptBR")
            addon:Print("Language override set to ptBR. Reloading UI...")
            ReloadUI()
        elseif lower == "lang en" or lower == "lang enus" then
            addon:SetLocaleOverride("enUS")
            addon:Print("Language override set to enUS. Reloading UI...")
            ReloadUI()
        elseif lower == "lang auto" then
            addon:SetLocaleOverride(nil)
            addon:Print("Language override cleared. Reloading UI...")
            ReloadUI()
        elseif lower:find("^vote") == 1 then
            addon:HandleVoteCommand(raw)
        elseif lower == "refresh" then
            addon:RefreshRoster()
            addon:RequestRefresh()
            addon:Print(addon:L("roster_refreshed"))
        else
            addon:ToggleMainWindow()
        end
    end

    self:Print(self:L("loaded_message"))
end

function addon:GetPlayerNote(fullName)
    if not fullName then
        return nil
    end

    local db = self:GetDB()
    db.notes = db.notes or {}
    return db.notes[fullName]
end

function addon:SetPlayerNote(fullName, note)
    if not fullName then
        return
    end

    local db = self:GetDB()
    db.notes = db.notes or {}

    local trimmed = tostring(note or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "" then
        db.notes[fullName] = nil
    else
        db.notes[fullName] = trimmed
    end
end

function addon:ClearDraftNote()
    if self.mainWindow and self.mainWindow.noteBox then
        self.mainWindow.noteBox:SetText("")
    end
end

function addon:GetDraftNote()
    if self.mainWindow and self.mainWindow.noteBox then
        return self.mainWindow.noteBox:GetText()
    end
    return ""
end

function addon:ApplyScoreNote(fullName, delta)
    if not fullName or not delta or delta == 0 then
        return
    end

    if delta > 0 then
        self:SetPlayerNote(fullName, self:GetDraftNote())
    elseif self:GetScore(fullName) + delta <= 0 then
        self:SetPlayerNote(fullName, nil)
    end
end

function addon:ResetAllScores()
    if not self:IsOfficer() then
        self:Print(self:L("reset_officer_only"))
        return
    end

    self:RefreshRoster()

    local db = self:GetDB()
    db.notes = db.notes or {}
    for _, member in ipairs(self:GetRoster() or {}) do
        db.scores[member.name] = 0
        db.notes[member.name] = nil
        self:BroadcastScore(member.name, 0)
    end

    self:ClearDraftNote()
    self:Print(self:L("all_scores_reset"))
    self:RequestRefresh()
end

function addon:NormalizeEligibleVoteTargets(targets)
    self:RefreshRoster()

    local resolved = {}
    local seen = {}
    local roster = self:GetRoster() or {}

    if type(targets) ~= "table" or #targets == 0 then
        for _, member in ipairs(roster) do
            if member.name and not seen[member.name] then
                seen[member.name] = true
                resolved[#resolved + 1] = member.name
            end
        end
        return resolved
    end

    for _, target in ipairs(targets) do
        local resolvedTarget = self:ResolveRaidPlayerName(target) or self:ResolveRosterEntryName(target)
        if resolvedTarget and not seen[resolvedTarget] and self:IsPlayerInMyRaid(resolvedTarget) then
            seen[resolvedTarget] = true
            resolved[#resolved + 1] = resolvedTarget
        end
    end

    return resolved
end

function addon:GetVoteEligibleTargets()
    return (self.voteSession and self.voteSession.eligibleTargets) or {}
end

function addon:GetVoteEligibleTargetSet()
    local set = {}
    for _, target in ipairs(self:GetVoteEligibleTargets()) do
        set[target] = true
    end
    return set
end

function addon:IsVoteTargetEligible(target)
    local resolvedTarget = self:ResolveRosterEntryName(target)
    if not resolvedTarget then
        return false
    end

    local eligible = self:GetVoteEligibleTargets()
    if #eligible == 0 then
        return true
    end

    for _, entry in ipairs(eligible) do
        if entry == resolvedTarget then
            return true
        end
    end

    return false
end

function addon:SerializeEligibleVoteTargets(targets)
    local chunks = {}
    for _, target in ipairs(targets or {}) do
        if target and target ~= "" then
            chunks[#chunks + 1] = target
        end
    end
    return table.concat(chunks, ";")
end

function addon:ParseEligibleVoteTargets(payload)
    local targets = {}
    for chunk in string.gmatch(tostring(payload or ""), "([^;]+)") do
        local resolvedTarget = self:ResolveRosterEntryName(chunk)
        if resolvedTarget then
            targets[#targets + 1] = resolvedTarget
        end
    end
    return self:NormalizeEligibleVoteTargets(targets)
end

function addon:OpenVote(label, eligibleTargets)
    if not self:IsRaidLeader() then
        self:Print(self:L("vote_open_rl_only"))
        return false
    end

    local trimmedLabel = tostring(label or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local controller = self:GetRaidLeaderName() or self:NormalizeName(GetUnitName("player", true))
    local normalizedEligibleTargets = self:NormalizeEligibleVoteTargets(eligibleTargets)
    if #normalizedEligibleTargets == 0 then
        self:Print(self:L("vote_pick_one"))
        return false
    end

    self.voteSession.isOpen = true
    self.voteSession.label = trimmedLabel ~= "" and trimmedLabel or nil
    self.voteSession.controller = controller
    self.voteSession.eligibleTargets = normalizedEligibleTargets
    self.voteSession.votesBySender = {}
    self.voteSession.countsByTarget = {}
    self.voteSession.lastResults = {}

    self:SendAddonMessage(table.concat({
        "VOTEOPEN",
        self.voteSession.controller or "",
        self.voteSession.label or "",
        self:SerializeEligibleVoteTargets(self.voteSession.eligibleTargets),
    }, "\t"))
    self:BroadcastVoteState()
    self:SendRaidNotice(self.voteSession.label and self:L("vote_opened_with_label", self.voteSession.label, self:GetShortName(self.voteSession.controller)) or self:L("vote_opened", self:GetShortName(self.voteSession.controller)))
    self:RequestRefresh()
    return true
end

function addon:CloseVote()
    if not self:IsOfficer() then
        self:Print(self:L("vote_control_officer_only"))
        return
    end

    self.voteSession.lastResults = self:GetSortedVoteResults()
    self.voteSession.isOpen = false

    self:SendVoteAddonMessage("VOTESTATE", self:SerializeVoteResults())

    self:SendVoteAddonMessage("VOTECLOSE", "")
    self:SendRaidNotice(self:L("vote_closed"))
    self:AnnounceVoteResults()
    if self.HideVoteWindow then
        self:HideVoteWindow()
    end
    if self.ShowVoteResultsWindow then
        self:ShowVoteResultsWindow()
    end
    self.voteSession.controller = nil
    self.voteSession.label = nil
    self.voteSession.eligibleTargets = {}
    self:RequestRefresh()
end

function addon:ToggleVoteFromUI(label)
    if self.voteSession and self.voteSession.isOpen then
        self:CloseVote()
    else
        if self.ShowVoteSetupWindow then
            self:ShowVoteSetupWindow(label)
        else
            self:OpenVote(label)
        end
    end

    self:RequestRefresh()
end

function addon:CastVote(targetName)
    local resolvedTarget = self:ResolveRaidPlayerName(targetName)
    if not resolvedTarget then
        self:Print(self:L("vote_target_must_be_raid"))
        return
    end

    if not self:IsVoteTargetEligible(resolvedTarget) then
        self:Print(self:L("vote_target_not_eligible"))
        return
    end

    local shortTarget = self:GetShortName(resolvedTarget)
    local controller = self.voteSession and self.voteSession.controller or nil
    if not controller then
        self:RefreshRoster()
        controller = self:GetCurrentVoteFallbackController()
    end

    if controller and self:IsLocalVoteController() then
        local playerName = self:NormalizeName(GetUnitName("player", true))
        self:RegisterVote(playerName, resolvedTarget)
        self:BroadcastVoteState()
        self:Print(self:L("voted_for_cone", shortTarget))
    elseif controller then
        self:SendWhisper(controller, shortTarget)
        self:Print(self:L("voted_for_cone", shortTarget))
    else
        self:Print(self:L("vote_controller_missing"))
    end
end

function addon:HandleVoteCommand(raw)
    local arg = raw:match("^vote%s+(.+)$") or ""
    local lowerArg = arg:lower()

    if lowerArg == "" then
        self:Print(self:L("vote_usage"))
        return
    end

    if lowerArg:find("^open") == 1 then
        local label = arg:match("^open%s+(.+)$") or ""
        if self.ShowVoteSetupWindow then
            self:ShowVoteSetupWindow(label)
        else
            self:OpenVote(label)
        end
        return
    end

    if lowerArg == "close" then
        self:CloseVote()
        return
    end

    self:CastVote(arg)
end

function addon:IsVoteController(sender)
    sender = self:NormalizeName(sender)
    if not sender or not IsInRaid() then
        return false
    end

    for i = 1, GetNumGroupMembers() do
        local name, rank = GetRaidRosterInfo(i)
        if self:NormalizeName(name) == sender then
            return rank and rank > 0
        end
    end

    return false
end

function addon:GetCurrentVoteFallbackController()
    if not IsInRaid() then
        return nil
    end

    for i = 1, GetNumGroupMembers() do
        local name, rank = GetRaidRosterInfo(i)
        if name and rank == 2 then
            return self:NormalizeName(name)
        end
    end

    for i = 1, GetNumGroupMembers() do
        local name, rank = GetRaidRosterInfo(i)
        if name and rank and rank > 0 then
            return self:NormalizeName(name)
        end
    end

    return nil
end

function addon:GetRaidLeaderName()
    if not IsInRaid() then
        return nil
    end

    for i = 1, GetNumGroupMembers() do
        local name, rank = GetRaidRosterInfo(i)
        if name and rank == 2 then
            return self:NormalizeName(name)
        end
    end

    return nil
end

function addon:IsLocalVoteController()
    local localPlayer = self:NormalizeName(GetUnitName("player", true))
    local controller = self.voteSession and self.voteSession.controller or nil
    return localPlayer and controller and localPlayer == controller
end

function addon:SerializeVoteResults()
    local results = self:GetSortedVoteResults()
    local chunks = {}
    for _, entry in ipairs(results) do
        if entry.target and entry.votes and entry.votes > 0 then
            chunks[#chunks + 1] = string.format("%s:%d", entry.target, entry.votes)
        end
    end
    return table.concat(chunks, ";")
end

function addon:ApplyVoteStatePayload(payload)
    self.voteSession.countsByTarget = {}
    self.voteSession.lastResults = {}

    local text = tostring(payload or "")
    if text == "" then
        return
    end

    for chunk in string.gmatch(text, "([^;]+)") do
        local target, votesText = chunk:match("^(.-):(%d+)$")
        if target and votesText then
            local resolvedTarget = self:ResolveRosterEntryName(target)
            local votes = tonumber(votesText) or 0
            if resolvedTarget and votes > 0 then
                self.voteSession.countsByTarget[resolvedTarget] = votes
            end
        end
    end

    self.voteSession.lastResults = self:GetSortedVoteResults()
end

function addon:BroadcastVoteState()
    if not self.voteSession or not self.voteSession.isOpen or not self:IsLocalVoteController() then
        return
    end

    self.voteSession.lastResults = self:GetSortedVoteResults()
    self:SendVoteAddonMessage("VOTESTATE", self:SerializeVoteResults())
end

function addon:RegisterVote(sender, target)
    local normalizedSender = self:NormalizeName(sender)
    local resolvedTarget = self:ResolveRaidPlayerName(target)
    if not normalizedSender or not resolvedTarget or not self.voteSession.isOpen or not self:IsVoteTargetEligible(resolvedTarget) then
        return
    end

    local previousTarget = self.voteSession.votesBySender[normalizedSender]
    if previousTarget and self.voteSession.countsByTarget[previousTarget] then
        self.voteSession.countsByTarget[previousTarget] = math.max(0, self.voteSession.countsByTarget[previousTarget] - 1)
        if self.voteSession.countsByTarget[previousTarget] == 0 then
            self.voteSession.countsByTarget[previousTarget] = nil
        end
    end

    self.voteSession.votesBySender[normalizedSender] = resolvedTarget
    self.voteSession.countsByTarget[resolvedTarget] = (self.voteSession.countsByTarget[resolvedTarget] or 0) + 1
    self.voteSession.lastResults = self:GetSortedVoteResults()
end

function addon:GetSortedVoteResults()
    local results = {}
    for target, votes in pairs(self.voteSession.countsByTarget or {}) do
        results[#results + 1] = {
            target = target,
            votes = votes,
        }
    end

    table.sort(results, function(a, b)
        if a.votes == b.votes then
            return a.target < b.target
        end
        return a.votes > b.votes
    end)

    return results
end

function addon:AnnounceVoteResults()
    local results = self.voteSession.lastResults or {}
    if #results == 0 then
        self:SendRaidNotice(self:L("vote_closed_no_votes"))
        return
    end

    self:SendRaidNotice(self:L("vote_results_header"))
    for _, entry in ipairs(results) do
        self:SendRaidNotice(self:L("votes_for_player", entry.votes, self:GetShortName(entry.target)))
    end
end

function addon:SendWhisper(target, message)
    if not target or not message or message == "" then
        return
    end

    SendChatMessage(message, "WHISPER", nil, target)
end

function addon:HandleIncomingVoteOpen(controllerName, label, eligiblePayload, sender)
    local normalizedSender = self:NormalizeName(sender)
    local resolvedController = self:NormalizeName(controllerName) or normalizedSender
    if not normalizedSender or not resolvedController then
        return
    end

    local cleanLabel = tostring(label or "")
    local eligibleTargets = self:ParseEligibleVoteTargets(eligiblePayload)
    self.voteSession.isOpen = true
    self.voteSession.label = cleanLabel ~= "" and cleanLabel or nil
    self.voteSession.controller = resolvedController
    self.voteSession.eligibleTargets = eligibleTargets
    self.voteSession.votesBySender = {}
    self.voteSession.countsByTarget = {}
    self.voteSession.lastResults = {}
    self.summaryMode = "logs"
    self:Print(self.voteSession.label and self:L("vote_opened_local_with_label", self.voteSession.label, self:GetShortName(self.voteSession.controller)) or self:L("vote_opened_local", self:GetShortName(self.voteSession.controller)))
    if self.RefreshVoteWindow then
        self:RefreshVoteWindow()
    end
    if self.ShowVoteWindow then
        self:ShowVoteWindow()
    end
    self:RequestRefresh()
end

function addon:CHAT_MSG_WHISPER(message, sender)
    if not self.voteSession or not self.voteSession.isOpen or not self:IsLocalVoteController() then
        return
    end

    local normalizedSender = self:NormalizeName(sender)
    if not normalizedSender or not self:IsPlayerInMyRaid(self:ResolveRosterEntryName(normalizedSender)) then
        return
    end

    local resolvedTarget = self:ResolveRaidPlayerName(message)
    if not resolvedTarget then
        self:SendWhisper(sender, self:L("whisper_exact_name"))
        return
    end

    if not self:IsVoteTargetEligible(resolvedTarget) then
        self:SendWhisper(sender, self:L("whisper_not_in_pool"))
        return
    end

    self:RegisterVote(normalizedSender, resolvedTarget)
    self:BroadcastVoteState()
    self:SendWhisper(sender, self:L("voted_for_cone", self:GetShortName(resolvedTarget)))
end

function addon:HandleIncomingVoteMessage(kind, payload, author)
    local normalizedAuthor = self:NormalizeName(author)

    if kind == "OPEN" then
        return
    end

    if kind == "CAST" then
        if self:IsLocalVoteController() then
            self:RegisterVote(normalizedAuthor, payload)
            self:BroadcastVoteState()
        end
        return
    end

    if kind == "STATE" then
        self:ApplyVoteStatePayload(payload)
        if self.RefreshVoteWindow then
            self:RefreshVoteWindow()
        end
        if self.RefreshVoteResultsWindow then
            self:RefreshVoteResultsWindow()
        end
        return
    end

    if kind == "CLOSE" then
        if not normalizedAuthor then
            return
        end

        self.voteSession.lastResults = self:GetSortedVoteResults()
        self.voteSession.isOpen = false
        self.voteSession.controller = nil
        self.voteSession.eligibleTargets = {}
        if self.HideVoteWindow then
            self:HideVoteWindow()
        end
        if self.ShowVoteResultsWindow then
            self:ShowVoteResultsWindow()
        end
        self:RequestRefresh()
    end
end

function addon:OnEvent(event, ...)
    if self[event] then
        self[event](self, ...)
    end
end

function addon:GROUP_ROSTER_UPDATE()
    self:RefreshRoster()
    self:UpdateRaidAutoPinned()
    self:RequestRefresh()
    C_Timer.After(0.25, function()
        addon:RefreshRoster()
        addon:UpdateRaidAutoPinned()
        addon:RequestRefresh()
    end)
end

function addon:PLAYER_ENTERING_WORLD()
    self:RefreshRoster()
    self:UpdateRaidAutoPinned()
    self:RequestRefresh()
    C_Timer.After(0.5, function()
        addon:RefreshRoster()
        addon:UpdateRaidAutoPinned()
        addon:RequestRefresh()
    end)
end

loaderFrame:SetScript("OnEvent", function(_, event, ...)
    addon:OnEvent(event, ...)
end)

loaderFrame:RegisterEvent("ADDON_LOADED")
loaderFrame:RegisterEvent("CHAT_MSG_ADDON")
loaderFrame:RegisterEvent("CHAT_MSG_WHISPER")
loaderFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
loaderFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

function addon:ADDON_LOADED(loadedName)
    if loadedName ~= addonName then
        return
    end

    loaderFrame:UnregisterEvent("ADDON_LOADED")
    self:OnInitialize()
end
