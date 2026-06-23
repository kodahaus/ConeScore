local _, ns = ...
local addon = ns.addon

addon.pendingDamage = {}

local damageEvents = {
    SPELL_DAMAGE = true,
    SPELL_PERIODIC_DAMAGE = true,
    RANGE_DAMAGE = true,
    SWING_DAMAGE = true,
    ENVIRONMENTAL_DAMAGE = true,
    SPELL_INSTAKILL = true,
}

local function BuildDamageCause(eventType, sourceName, spellName, environmentalType)
    if eventType == "SWING_DAMAGE" then
        local source = sourceName or addon:L("unknown_source")
        return addon:L("death_melee", source), source, 0
    end

    if eventType == "ENVIRONMENTAL_DAMAGE" then
        local label = environmentalType or addon:L("unknown_environment")
        return addon:L("death_environment", label), sourceName or label, 0
    end

    if spellName and spellName ~= "" then
        return spellName, sourceName or addon:L("unknown_source"), 0
    end

    return addon:L("unknown_cause"), sourceName or addon:L("unknown_source"), 0
end

function addon:RememberDamage(destName, eventType, sourceName, spellName, spellId, environmentalType)
    if not destName then
        return
    end

    local cause, source = BuildDamageCause(eventType, sourceName, spellName, environmentalType)
    self.pendingDamage[destName] = {
        cause = cause,
        source = source,
        spellId = spellId or 0,
        timestamp = GetTime(),
    }
end

function addon:RegisterDeath(destName)
    if not destName or not self:IsPlayerInMyRaid(destName) then
        return
    end

    local db = self:GetDB()
    local recent = self.pendingDamage[destName] or {}
    local death = {
        player = destName,
        cause = recent.cause or addon:L("unknown_cause"),
        source = recent.source or addon:L("unknown_source"),
        spellId = recent.spellId or 0,
        timestamp = time(),
    }

    db.lastDeath[destName] = death
    if db.lastTry.active then
        table.insert(db.lastTry.deaths, death)
    end

    self:BroadcastDeath(death)
    self:RequestRefresh()
end

function addon:COMBAT_LOG_EVENT_UNFILTERED()
    local combatData = { CombatLogGetCurrentEventInfo() }
    local eventType = combatData[2]
    local sourceName = combatData[5]
    local destName = combatData[9]
    local destFlags = combatData[10]

    if not destName then
        return
    end

    destName = self:NormalizeName(destName)
    sourceName = self:NormalizeName(sourceName)

    if damageEvents[eventType] and CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_RAIDMEMBER) then
        local spellId, spellName, environmentalType

        if eventType == "SWING_DAMAGE" then
            spellId = 0
            spellName = nil
        elseif eventType == "ENVIRONMENTAL_DAMAGE" then
            environmentalType = combatData[12]
            spellId = 0
            spellName = nil
        else
            spellId = combatData[12]
            spellName = combatData[13]
        end

        self:RememberDamage(destName, eventType, sourceName, spellName, spellId, environmentalType)
        return
    end

    if eventType == "UNIT_DIED" and CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_RAIDMEMBER) then
        self:RegisterDeath(destName)
    end
end
