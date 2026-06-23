local _, ns = ...
local addon = ns.addon

function addon:RefreshRoster()
    self.roster = self.roster or {}
    wipe(self.roster)

    if not IsInRaid() then
        return
    end

    for i = 1, GetNumGroupMembers() do
        local unit = "raid" .. i
        local fullName = GetUnitName(unit, true)
        if fullName then
            table.insert(self.roster, {
                unit = unit,
                name = fullName,
                group = select(3, GetRaidRosterInfo(i)) or 0,
                classFile = select(6, GetRaidRosterInfo(i)),
            })
        end
    end

    table.sort(self.roster, function(a, b)
        if a.group == b.group then
            return a.name < b.name
        end
        return a.group < b.group
    end)
end

function addon:GetRoster()
    if not self.roster then
        self:RefreshRoster()
    end

    return self.roster or {}
end

function addon:GetScore(fullName)
    local db = self:GetDB()
    return db.scores[fullName] or 0
end

function addon:SetScore(fullName, score, source)
    if not fullName then
        return
    end

    local db = self:GetDB()
    db.scores[fullName] = math.max(0, tonumber(score) or 0)

    if source ~= "sync" then
        self:BroadcastScore(fullName, db.scores[fullName])
    end

    self:RequestRefresh()
end

function addon:AdjustScore(fullName, delta)
    if not self:IsOfficer() then
        self:Print(self:L("officer_edit_only"))
        return
    end

    if not self:IsPlayerInMyRaid(fullName) then
        self:Print(self:L("player_no_longer_in_raid"))
        return
    end

    self:ApplyScoreNote(fullName, delta)
    self:SetScore(fullName, self:GetScore(fullName) + delta, "local")
end
