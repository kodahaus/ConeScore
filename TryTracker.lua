local _, ns = ...
local addon = ns.addon

function addon:StartTry(trigger)
    local db = self:GetDB()
    db.lastTry.active = true
    db.lastTry.startedAt = GetTime()
    db.lastTry.endedAt = 0
    db.lastTry.trigger = trigger or "manual"
    wipe(db.lastTry.deaths)

    self.tryEncounterActive = trigger == "encounter"
    self:RequestRefresh()
end

function addon:EndTry(trigger)
    local db = self:GetDB()
    if not db.lastTry.active then
        return
    end

    db.lastTry.active = false
    db.lastTry.endedAt = GetTime()
    db.lastTry.trigger = trigger or db.lastTry.trigger

    db.history.lastCompletedTry = {}
    for index, death in ipairs(db.lastTry.deaths) do
        db.history.lastCompletedTry[index] = {
            player = death.player,
            cause = death.cause,
            source = death.source,
            spellId = death.spellId,
            timestamp = death.timestamp,
        }
    end

    self.tryEncounterActive = false
    self:RequestRefresh()
end

function addon:GetCompletedTryDeaths()
    return self:GetDB().history.lastCompletedTry or {}
end

function addon:ENCOUNTER_START()
    self:StartTry("encounter")
end

function addon:ENCOUNTER_END()
    self:EndTry("encounter_end")
end

function addon:PLAYER_REGEN_DISABLED()
    if IsInRaid() and not self:GetDB().lastTry.active then
        self:StartTry("combat")
    end
end

function addon:PLAYER_REGEN_ENABLED()
    if self.tryEncounterActive then
        return
    end

    if IsInRaid() then
        C_Timer.After(3, function()
            if not InCombatLockdown() then
                addon:EndTry("combat_end")
            end
        end)
    end
end
