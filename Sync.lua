local _, ns = ...
local addon = ns.addon

local function SplitMessage(message)
    local parts = {}
    local text = tostring(message or "")
    local startIndex = 1

    while true do
        local tabIndex = string.find(text, "\t", startIndex, true)
        if not tabIndex then
            parts[#parts + 1] = string.sub(text, startIndex)
            break
        end

        parts[#parts + 1] = string.sub(text, startIndex, tabIndex - 1)
        startIndex = tabIndex + 1
    end
    return parts
end

function addon:SendAddonMessage(message, channelOverride, target)
    if not IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return
    end

    local channel = channelOverride or (IsInRaid() and "RAID" or "PARTY")
    C_ChatInfo.SendAddonMessage(self.prefix, message, channel, target)
end

function addon:BroadcastScore(fullName, score)
    self:SendAddonMessage(table.concat({
        "SCORE",
        fullName,
        tostring(score),
    }, "\t"))
end

function addon:BroadcastDeath(death)
    self:SendAddonMessage(table.concat({
        "DEATH",
        death.player or "",
        death.cause or "",
        death.source or "",
        tostring(death.spellId or 0),
        tostring(death.timestamp or time()),
    }, "\t"))
end

function addon:SerializeDailyToastPayload(data)
    local payload = {
        data and data.label or "",
        data and data.savedAtText or "",
        data and data.savedTimeText or "",
        data and data.raidwideSoundFile or "",
    }

    for index = 1, 3 do
        local entry = data and data.entries and data.entries[index] or nil
        payload[#payload + 1] = entry and (entry.name or "") or ""
        payload[#payload + 1] = entry and (entry.classFile or "") or ""
        payload[#payload + 1] = entry and tostring(entry.score or 0) or "0"
    end

    return table.concat(payload, "\t")
end

function addon:BroadcastDailyToast(logEntry)
    local toastData = self:BuildDailyToastEntries(logEntry)
    toastData.raidwideSoundFile = self:GetRandomRaidwideSoundFile()
    if self.ShowDailyToast then
        self:ShowDailyToast(toastData)
    end

    self:SendAddonMessage("DAYTOAST\t" .. self:SerializeDailyToastPayload(toastData))
end

function addon:ParseDailyToastParts(parts)
    local parsed = {
        label = parts[2] or "Raid",
        savedAtText = parts[3] or "",
        savedTimeText = parts[4] or "",
        raidwideSoundFile = parts[5] or "",
        entries = {},
    }

    local offset = 6
    for _ = 1, 3 do
        local name = parts[offset]
        local classFile = parts[offset + 1]
        local score = tonumber(parts[offset + 2]) or 0
        if name and name ~= "" and score > 0 then
            parsed.entries[#parsed.entries + 1] = {
                name = name,
                shortName = self:GetShortName(name),
                classFile = classFile ~= "" and classFile or nil,
                score = score,
            }
        end
        offset = offset + 3
    end

    return parsed
end

function addon:RequestSync()
    self:SendAddonMessage("REQSYNC")
end

function addon:SendVoteAddonMessage(command, payload, channelOverride, target)
    self:SendAddonMessage(table.concat({
        command or "",
        tostring(payload or ""),
    }, "\t"), channelOverride, target)
end

function addon:CanSenderControl(sender)
    if not sender or not IsInRaid() then
        return false
    end

    for i = 1, GetNumGroupMembers() do
        local name, rank = GetRaidRosterInfo(i)
        local fullName = self:NormalizeName(name)
        if fullName == sender then
            return rank and rank > 0
        end
    end

    return false
end

function addon:HandleSyncRequest(sender)
    if not self:IsOfficer() then
        return
    end

    for fullName, score in pairs(self:GetDB().scores) do
        C_ChatInfo.SendAddonMessage(self.prefix, table.concat({
            "SCORE",
            fullName,
            tostring(score),
        }, "\t"), "WHISPER", sender)
    end
end

function addon:CHAT_MSG_ADDON(prefix, message, channel, sender)
    if prefix ~= self.prefix then
        return
    end

    sender = self:NormalizeName(sender)
    local parts = SplitMessage(message)
    local command = parts[1]

    if command == "REQSYNC" then
        self:HandleSyncRequest(sender)
        return
    end

    if command == "SCORE" then
        if not self:CanSenderControl(sender) then
            return
        end

        self:RefreshRoster()
        local fullName = self:ResolveRosterEntryName(parts[2])
        local score = tonumber(parts[3]) or 0
        self:SetScore(fullName, score, "sync")
        return
    end

    if command == "DEATH" then
        self:RefreshRoster()
        local playerName = self:ResolveRosterEntryName(parts[2])
        if not playerName then
            return
        end

        self:GetDB().lastDeath[playerName] = {
            player = playerName,
            cause = parts[3] or self:L("unknown_cause"),
            source = parts[4] or self:L("unknown_source"),
            spellId = tonumber(parts[5]) or 0,
            timestamp = tonumber(parts[6]) or time(),
        }
        self:RequestRefresh()
        return
    end

    if command == "DAYTOAST" then
        local localPlayer = self:NormalizeName(GetUnitName("player", true))
        if sender and self:NormalizeName(sender) == localPlayer then
            return
        end

        if self.ShowDailyToast then
            self:ShowDailyToast(self:ParseDailyToastParts(parts))
        end
        return
    end

    if command == "VOTEOPEN" then
        self:HandleIncomingVoteOpen(parts[2] or "", parts[3] or "", parts[4] or "", sender)
        return
    end

    if command == "VOTECAST" then
        self:HandleIncomingVoteMessage("CAST", parts[2] or "", sender)
        return
    end

    if command == "VOTESTATE" then
        self:HandleIncomingVoteMessage("STATE", parts[2] or "", sender)
        return
    end

    if command == "VOTECLOSE" then
        self:HandleIncomingVoteMessage("CLOSE", parts[2] or "", sender)
    end
end
