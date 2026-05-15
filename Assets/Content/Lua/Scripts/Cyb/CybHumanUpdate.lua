TL.UpdateInterval = TLConfig.Get("TL_TLUpdateInterval", 2) * 60 --每 2 秒更新一次
TL.LateUpdateInterval = TLConfig.Get("TL_TLLateUpdateInterval", 5) * 60 --每 5 秒更新一次
UpdateCooldown = 0
LateUpdateCooldown = 0
TL.DeltaTime = TL.UpdateInterval / 60
TLCyb.DamageMultiplier = TLConfig.Get("TL_cybDamageMultiplier", 1.5) --受伤倍率
local DamageConvertConfig = {
    --weight：转换后的比例
    --chance：转换到此伤害的概率
    --TLCyb_StructuralDamage结构损伤,TLCyb_ServoDamage伺服系统故障
    --TLCyb_CircuitDamage电路损坏,TLCyb_SystemDamage神经同步失调
    bleeding = {
        clear = true,
        targets = {
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 70 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 }
        }
    },
    gunshotwound = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 32 },
            { id = "TLCyb_ServoDamage", weight = 0.2, chance = 40 },
            { id = "TLCyb_CircuitDamage", weight = 0.15, chance = 25 },
            { id = "TLCyb_SystemDamage", weight = 0.3, chance = 3 }
        }
    },
    blunttrauma = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 32 },
            { id = "TLCyb_ServoDamage", weight = 0.15, chance = 40 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 27 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 1 }
        }
    },
    lacerations = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 49 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 20 },
            { id = "TLCyb_SystemDamage", weight = 0.15, chance = 5 }
        }
    },
    burn = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.05, chance = 10 },
            { id = "TLCyb_ServoDamage", weight = 0.15, chance = 70 },
            { id = "TLCyb_CircuitDamage", weight = 0.15, chance = 23 },
            { id = "TLCyb_SystemDamage", weight = 0.1, chance = 2 }
        }
    },
    bitewounds = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.04, chance = 60 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 20 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 20 },
        }
    },
    explosiondamage = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.2, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.4, chance = 25 },
            { id = "TLCyb_CircuitDamage", weight = 0.5, chance = 20 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 20 }
        }
    },
    dislocation1 = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
        }
    },
    dislocation2 = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
        }
    },
    dislocation3 = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
        }
    },
    dislocation4 = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
        }
    },
    internaldamage = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 35 },
            { id = "TLCyb_ServoDamage", weight = 0.2, chance = 35 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 25 },
            { id = "TLCyb_SystemDamage", weight = 0.05, chance = 5 }
        }
    },
    foreignbody = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.15, chance = 35 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 35 },
            { id = "TLCyb_CircuitDamage", weight = 0.15, chance = 25 },
            { id = "TLCyb_SystemDamage", weight = 0.05, chance = 5 }
        }
    },
    ra_fracture = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.02, chance = 5 }
        }
    },
    la_fracture = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.02, chance = 5 }
        }
    },
    rl_fracture = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.02, chance = 5 }
        }
    },
    ll_fracture = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.1, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.02, chance = 5 }
        }
    },
    tra_amputation = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.55, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 10 }
        }
    },
    tla_amputation = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.55, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 10 }
        }
    },
    trl_amputation = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.55, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 10 }
        }
    },
    tll_amputation = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.55, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.5, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.25, chance = 10 }
        }
    },
    ll_arterialcut = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.35, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.1, chance = 10 }
        }
    },
    rl_arterialcut = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.35, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.1, chance = 10 }
        }
    },
    la_arterialcut = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.35, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.1, chance = 10 }
        }
    },
    ra_arterialcut = {
        clear = true,
        targets = {
            { id = "TLCyb_StructuralDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_ServoDamage", weight = 0.35, chance = 30 },
            { id = "TLCyb_CircuitDamage", weight = 0.25, chance = 30 },
            { id = "TLCyb_SystemDamage", weight = 0.1, chance = 10 }
        }
    },
    arteriesclamp = {
        clear = true
    },
    surgeryincision = {
        clear = true
    },
    clampedbleeders = {
        clear = true
    },
    retractedskin = {
        clear = true
    },
    suturedi = {
        clear = true
    },
    suturedw = {
        clear = true
    },
    bonecut = {
        clear = true
    },
    gypsumcast = {
        clear = true
    },
    bandaged = {
        clear = true
    },
    dirtybandage = {
        clear = true
    },
    drilledbones = {
        clear = true
    },
    sra_amputation = {
        clear = true
    },
    sla_amputation = {
        clear = true
    },
    sll_amputation = {
        clear = true
    },
    srl_amputation = {
        clear = true
    },
}
local lastFallNum = {} --上次跌倒到现在的次数
local LastRestart = {} --上次重启到现在的次数
local RestartNoticePlayed = {} --可以进行重启提醒
TLCyb.protectFallNum = TLConfig.Get("TL_TLCybProtectFallNum", 5) --保底不会摔倒次数
TLCyb.tripChance = TLConfig.Get("TL_TLCybTripChance", 0.25) --摔倒乘数概率
--初始化
Hook.Add("roundStart", "TLCyb.Initialization", function()
    Timer.Wait(function()
        lastFallNum = {}
        LastRestart = {}
    end, 100)
end)
--正常更新 2 秒
Hook.Add("think", "TLCyb.NormalThink", function()
    if TLHF.GameIsPaused() then
        return
    end
    UpdateCooldown = UpdateCooldown - 1
    if UpdateCooldown <= 0 then
        UpdateCooldown = TL.UpdateInterval
        for character in Character.CharacterList do
            TLCyb.UpdateCharacter(character)
        end
    end
end)
--低速更新 5 秒
Hook.Add("think", "TLCyb.LateThink", function()
    if TLHF.GameIsPaused() then
        return
    end
    LateUpdateCooldown = LateUpdateCooldown - 1
    if LateUpdateCooldown <= 0 then
        LateUpdateCooldown = TL.LateUpdateInterval
        for character in Character.CharacterList do
            TL.UpdateInterval = TLConfig.Get("TL_TLUpdateInterval", 2) * 60 --每 2 秒更新一次
            TL.LateUpdateInterval = TLConfig.Get("TL_TLLateUpdateInterval", 5) * 60 --每 5 秒更新一次
            TL.DeltaTime = TL.UpdateInterval / 60
            TLCyb.LateUpdateCharacter(character)
        end
    end
end)
Hook.Patch("Barotrauma.CharacterHealth", "ApplyDamage", function(instance, ptable)
    local character = instance.Character
    local hitLimb = ptable["hitLimb"]
    local attackResult = ptable["attackResult"]
    
    if not character or character.IsDead or not character.IsHuman then return end
    if not hitLimb or not attackResult or not attackResult.Afflictions then return end

    TLCyb.TryAddLycorisSystemDamageOnHeadHit(character, hitLimb, attackResult)

    local limbType = TLHF.NormalizeLimbType(hitLimb.type)
    if not TLCyb.HF.HasTLCyber(character, limbType) then return end
    for aff in attackResult.Afflictions do
        local identifier = aff.Prefab.Identifier.Value
        if DamageConvertConfig[identifier] then
            if character and not character.Removed and not character.IsDead then
                TLCyb.ConvertDamageGroupPatch(character,hitLimb,attackResult)
                ptable.PreventExecution = true
                break
            end
        end
    end
end, Hook.HookMethodType.Before)
--低速更新 5 秒
function TLCyb.LateUpdateCharacter(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController then return end
    TLCyb.LateUpdateCharacter_UnconsciousCache(character)
    TLCyb.LateUpdateCharacter_LycorisSystemDamage(character)
    TLCyb.UpdateCharacter_Civilian(character)
end
--曼珠核心子系统异常自增
function TLCyb.LateUpdateCharacter_LycorisSystemDamage(character)
    local SystemDamage = TLHF.GetAfflictionStrength(character, "TLCyb_LycorisSystemDamage")
    if(SystemDamage >= TLConfig.Get("TLCyb_LycorisSystemDamage_AutoIncrementThreshold",80)) then
        TLHF.AddAffliction(character, "TLCyb_LycorisSystemDamage", 0.5 + math.random() * TLConfig.Get("TL_cybDamageMultiplier", 1.5))
    end
end
--曼珠核心子系统异常添加
function TLCyb.TryAddLycorisSystemDamageOnHeadHit(character, hitLimb, attackResult)
    if not character or not hitLimb or not attackResult then return end
    if hitLimb.type ~= LimbType.Head then return end
    local head = TLHF.GetLimb(character, LimbType.Head)
    if not head then return end
    if not TLHF.HasAfflictionLimb(character, "TLCyb_LycorisChip_Init", head) then return end
    local totalDamage = 0
    for aff in attackResult.Afflictions do
        if aff then
            totalDamage = totalDamage + (aff.Strength or 0)
        end
    end
    if totalDamage <= 0.1 then return end
    local chance = math.min(0.35, 0.05 + totalDamage * 0.01)
    if math.random() < chance then
        local addAmount = 0.3 + totalDamage * 0.1 * TLConfig.Get("TL_cybDamageMultiplier", 1.5)
        TLHF.AddAffliction(character, "TLCyb_LycorisSystemDamage", addAmount)
    end
end
--强制昏迷检查
function TLCyb.LateUpdateCharacter_UnconsciousCache(character)
    if character ~= nil and character ~= nil then
        if not TLHF.ShouldBeUnconscious(character) then return end
        character.Stun = math.max(character.Stun, 5)
    end
end
--正常更新 2 秒
function TLCyb.UpdateCharacter(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController then return end
    TLCyb.UpdateCharacter_LycorisChip(character)
    TLCyb.UpdateCharacter_CrawlState(character)
    TLCyb.UpdateCharacter_CivilianLegEffects(character)
    TLCyb.UpdateCharacter_BreakLimb(character)
    TLCyb.UpdateCharacter_LockArms(character)
end
--完全损坏爬行状态更新，TLCyb_SystemDamage，TLCyb_ServoDamage
function TLCyb.UpdateCharacter_CrawlState(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController then return end

    local leftLeg = TLHF.GetLimb(character, LimbType.LeftLeg)
    local rightLeg = TLHF.GetLimb(character, LimbType.RightLeg)
    if not leftLeg or not rightLeg then return end

    if not TLCyb.HF.HasTLCyber(character, LimbType.LeftLeg) then return end
    if not TLCyb.HF.HasTLCyber(character, LimbType.RightLeg) then return end

    local leftSystem = TLHF.GetAfflictionLimbStrength(character, "TLCyb_SystemDamage", leftLeg, 0)
    local rightSystem = TLHF.GetAfflictionLimbStrength(character, "TLCyb_SystemDamage", rightLeg, 0)

    local leftServo = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ServoDamage", leftLeg, 0)
    local rightServo = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ServoDamage", rightLeg, 0)

    local crawlStrength = math.max(
        math.min(leftSystem, rightSystem),
        math.min(leftServo, rightServo)
    )
    local shouldCrawl = false

    --双腿系统损坏 >= 60 爬行
    --双腿伺服损坏 >= 80 爬行
    --权重 双腿系统/伺服损坏 >= 150 爬行
    local leftDisableScore = leftSystem * 0.8 + leftServo * 0.5
    local rightDisableScore = rightSystem * 0.8 + rightServo * 0.5
    local totalDisableScore = leftDisableScore + rightDisableScore
    local shouldCrawl =
    (leftSystem >= TLConfig.Get("TLCyb_SystemDamageCrawlThreshold", 60) and rightSystem >= TLConfig.Get("TLCyb_SystemDamageCrawlThreshold", 60))
    or (leftServo >= TLConfig.Get("TLCyb_ServoDamageCrawlThreshold", 80) and rightServo >= TLConfig.Get("TLCyb_ServoDamageCrawlThreshold", 80))
    or (totalDisableScore >= TLConfig.Get("TLCyb_totalDisableScoreoDamageCrawlThreshold", 150))
    if shouldCrawl then
        TLHF.SetAffliction(character, "TL_CrawlState", 100)
    else
        TLHF.SetAffliction(character, "TL_CrawlState", 0)
    end
end
--完全损毁，断肢检测
function TLCyb.UpdateCharacter_BreakLimb(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController then return end

    local checkLimbs = {
        LimbType.LeftArm,
        LimbType.RightArm,
        LimbType.LeftLeg,
        LimbType.RightLeg
    }
    
    for _, limbType in pairs(checkLimbs) do
        local limb = TLHF.GetLimb(character, limbType)
        if limb and TLCyb.HF.HasTLCyber(character, limbType) then
            local structuralDamage = TLHF.GetAfflictionLimbStrength(character, "TLCyb_StructuralDamage", limb)
            if structuralDamage >= 99 then
                if TLHF.HasNeurotraumaLoaded() then
                    if limbType == LimbType.LeftLeg then
                        TLHF.SetAffliction(character, "sll_amputation", 100)
                    elseif limbType == LimbType.RightLeg then
                        TLHF.SetAffliction(character, "srl_amputation", 100)
                    elseif limbType == LimbType.LeftArm then
                        TLHF.SetAffliction(character, "sla_amputation", 100)
                    elseif limbType == LimbType.RightArm then
                        TLHF.SetAffliction(character, "sra_amputation", 100)
                    end
                end
                if limbType == LimbType.LeftLeg then
                    TLHF.SetAfflictionLimb(character, "TLCyb_ClosedWound", limb,100)
                    TLHF.ClearAllTLCybAff(character,limb)
                elseif limbType == LimbType.RightLeg then
                    TLHF.SetAfflictionLimb(character, "TLCyb_ClosedWound", limb,100)
                    TLHF.ClearAllTLCybAff(character,limb)
                elseif limbType == LimbType.LeftArm then
                    TLHF.SetAfflictionLimb(character, "TLCyb_ClosedWound", limb,100)
                    TLHF.ClearAllTLCybAff(character,limb)
                elseif limbType == LimbType.RightArm then
                    TLHF.SetAfflictionLimb(character, "TLCyb_ClosedWound", limb,100)
                    TLHF.ClearAllTLCybAff(character,limb)
                end
                --TL断肢逻辑
                TLHF.PlaySound("TLCyb_LimbBreak_Sound",character)
                if character == Character.Controlled then
                    Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                        Lib.ReadXmlRichText("TLCyb_LimbBreak_init"), "GUITLCyb_LycorisChip")
                end
            end
        end
    end
end
--锁手逻辑
function TLCyb.UpdateCharacter_LockArms(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController or  not character.Inventory then return end

    local leftShouldLock = false
    local rightShouldLock = false
    local leftLimb = TLHF.GetLimb(character, LimbType.LeftArm)
    local rightLimb = TLHF.GetLimb(character, LimbType.RightArm)
    if leftLimb then
        local closedWound = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ClosedWound", leftLimb, 0)
        local circuit = TLHF.GetAfflictionLimbStrength(character, "TLCyb_CircuitDamage", leftLimb, 0)
        local system = TLHF.GetAfflictionLimbStrength(character, "TLCyb_SystemDamage", leftLimb, 0)
        local servo = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ServoDamage", leftLimb, 0)
        local structural = TLHF.GetAfflictionLimbStrength(character, "TLCyb_StructuralDamage", leftLimb, 0)
        leftShouldLock = system>=70
        leftShouldLock = (circuit >= 99 or system >= 99 or servo >= 99 or structural >= 99 or closedWound >= 99)
    end
    if rightLimb then
        local closedWound = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ClosedWound", rightLimb, 0)
        local circuit = TLHF.GetAfflictionLimbStrength(character, "TLCyb_CircuitDamage", rightLimb, 0)
        local system = TLHF.GetAfflictionLimbStrength(character, "TLCyb_SystemDamage", rightLimb, 0)
        local servo = TLHF.GetAfflictionLimbStrength(character, "TLCyb_ServoDamage", rightLimb, 0)
        local structural = TLHF.GetAfflictionLimbStrength(character, "TLCyb_StructuralDamage", rightLimb, 0)
        rightShouldLock = system>=70
        rightShouldLock = (circuit >= 99 or system >= 99 or servo >= 99 or structural >= 99 or closedWound >= 99)
    end
    local leftLockItem = character.Inventory.FindItemByIdentifier("armlock2", false)
    local rightLockItem = character.Inventory.FindItemByIdentifier("armlock1", false)
    local leftLockedNow = leftLockItem ~= nil
    local rightLockedNow = rightLockItem ~= nil

    if leftLockedNow and not leftShouldLock then
        TLHF.RemoveItem(leftLockItem)
    end
    if rightLockedNow and not rightShouldLock then
        TLHF.RemoveItem(rightLockItem)
    end

    if not leftLockedNow and leftShouldLock then
        TLHF.DropItemsFromLockedArms(character,leftShouldLock,rightShouldLock)
        TLHF.ForceArmLock(character, "armlock2")
    end
    if not rightLockedNow and rightShouldLock then
        TLHF.DropItemsFromLockedArms(character,leftShouldLock,rightShouldLock)
        TLHF.ForceArmLock(character, "armlock1")
    end
end
--民用机械腿AFF更新摔倒判定，TLCyb_CircuitDamage
function TLCyb.UpdateCharacter_CivilianLegEffects(character)
    if not character or character.Removed or character.IsDead then return end
    if not character.IsHuman or not character.AnimController then return end
    local leftLimb = TLHF.GetLimb(character, LimbType.LeftLeg)
    local rightLimb = TLHF.GetLimb(character, LimbType.RightLeg)
    if not leftLimb or not rightLimb then return end
    if not TLCyb.HF.HasTLCyber(character, LimbType.LeftLeg) and not TLCyb.HF.HasTLCyber(character, LimbType.RightLeg) then
        return
    end
    local charId = character.ID
    lastFallNum[charId] = lastFallNum[charId] or 0
    local leftCircuit = TLHF.GetAfflictionLimbStrength(character, "TLCyb_CircuitDamage", leftLimb, 0)
    local rightCircuit = TLHF.GetAfflictionLimbStrength(character, "TLCyb_CircuitDamage", rightLimb, 0)
    local avgCircuit = (leftCircuit + rightCircuit) / 2
    if avgCircuit > 30 then
        TLCyb.tripChance = TLConfig.Get("TL_TLCybTripChance", 0.25)
        local tripChance = (avgCircuit / 100) * TLCyb.tripChance
        -- 先累计安全次数
        lastFallNum[charId] = lastFallNum[charId] + 1
        -- 超过保护次数后，才允许真正摔倒
        TLCyb.protectFallNum = TLConfig.Get("TL_TLCybProtectFallNum", 5)
        if lastFallNum[charId] > TLCyb.protectFallNum and math.random() < tripChance then
            character.Stun = math.max(character.Stun, 0.5 + avgCircuit / 50)
            lastFallNum[charId] = 0
        end
    else
        -- 损伤不高时，计数清零
        lastFallNum[charId] = 0
    end
end
--Lycoris芯片
function TLCyb.UpdateCharacter_LycorisChip(character)

    local head = character.AnimController.GetLimb(LimbType.Head)
    if not TLHF.HasAfflictionLimb(character, "TLCyb_LycorisChip_Init", head, 0.1) then return end

    local MainLimb = character.AnimController.MainLimb
    if TLHF.HasAffliction(character,"psychosis") then
        TLHF.AddAffliction(character, "psychosis", -10 * TL.DeltaTime)
    end

    local charId = character.ID
    RestartNoticePlayed[charId] = RestartNoticePlayed[charId] or false
    if character.Removed or character.IsDead then
        if character and character.ID then
            LastRestart[character.ID] = nil
            RestartNoticePlayed[character.ID] = nil
        end
        return
    end
    if TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") > 90 then
        if TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") == 100 then
            TLHF.SetAffliction(character, "TL_StunState", 5)
        else
            TLHF.SetAffliction(character, "TL_StunState", 5)
            TLHF.SetAffliction(character, "TLCyb_LycorisSystemDamage", 100)
            TLHF.PlaySound("TLCyb_Lycoris_OFFline_Sound", character)
            if character == Character.Controlled then
                Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                    Lib.ReadXmlRichText("TLCyb_Lycoris_OFFline"), "GUITLCyb_LycorisChip")
            end
        end
    end
    if TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") >= 80 and TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") <= 90 then
        TLHF.SetAffliction(character, "TL_StunState", 1.5)
        if LastRestart[charId] == nil then
            if not RestartNoticePlayed[charId] then
                TLHF.PlaySound("TLCyb_Lycoris_Restart_Sound", character)
                if character == Character.Controlled then
                    Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                        Lib.ReadXmlRichText("TLCyb_Lycoris_Restart"), "GUITLCyb_LycorisChip")
                end
                RestartNoticePlayed[charId] = true
            end
            TLHF.SetAffliction(character, "TLCyb_LycorisSystemDamage", 75)
            LastRestart[charId] = 0
        else
            LastRestart[charId] = LastRestart[charId] + 1
            if LastRestart[charId] >= 10 then
                if not RestartNoticePlayed[charId] then
                    TLHF.PlaySound("TLCyb_Lycoris_Restart", character)
                    if character == Character.Controlled then
                        Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                            Lib.ReadXmlRichText("TLCyb_Lycoris_Restart"), "GUITLCyb_LycorisChip")
                    end
                    RestartNoticePlayed[charId] = true
                end

                TLHF.SetAffliction(character, "TLCyb_LycorisSystemDamage", 75)
                LastRestart[charId] = 0
            else
                if not RestartNoticePlayed[charId] then
                    TLHF.PlaySound("TLCyb_Lycoris_CantRestart_Sound", character)
                    if character == Character.Controlled then
                        Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                            Lib.ReadXmlRichText("TLCyb_Lycoris_CantRestart"), "GUITLCyb_LycorisChip")
                    end
                    RestartNoticePlayed[charId] = true
                end
            end
        end
    else
        RestartNoticePlayed[charId] = false
        TLHF.AddAffliction(character, "TL_StunState", -0.25 * TL.DeltaTime)
        if TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") <= 70 then
            TLHF.AddAffliction(character, "TLCyb_LycorisSystemDamage", -0.1 * TL.DeltaTime)
            if TLHF.GetAfflictionStrength(character,"TLCyb_LycorisSystemDamage") <= 20 then
                RestartNoticePlayed[charId] = false
            end
        end
    end
    if TLHF.HasAffliction(character,"concussion") then
        TLHF.AddAffliction(character, "concussion", -0.5 * TL.DeltaTime)
    end
    if TLHF.HasNeurotraumaLoaded() then 
        if TLHF.HasAffliction(character, "cerebralhypoxia") then
            TLHF.AddAfflictionLimb(character, "cerebralhypoxia", MainLimb, -1 * TL.DeltaTime)
        end
        if TLHF.HasAffliction(character, "sym_unconsciousness") then
            TLHF.AddAfflictionLimb(character, "sym_unconsciousness", MainLimb, -0.5 * TL.DeltaTime)
        end
        if TLHF.HasAffliction(character, "traumaticshock") then
            TLHF.AddAfflictionLimb(character, "traumaticshock", MainLimb, -1 * TL.DeltaTime)
        end
    end
end
--民用机械
function TLCyb.UpdateCharacter_Civilian(character)
    local function updateLeg(limbType)
        local limb = TLHF.GetLimb(character,limbType)
        if limb == nil then return end
        if not TLCyb.HF.IsCybLimb(character,limbType) then return end
        TLCyb.ConvertDamageGroup(character, limb)
    end
    updateLeg(LimbType.LeftLeg)
    updateLeg(LimbType.RightLeg)
    updateLeg(LimbType.LeftArm)
    updateLeg(LimbType.RightArm)
end
--伤害转换
function TLCyb.ConvertDamageGroup(character,limb,qualityMultiplier)
    qualityMultiplier = qualityMultiplier or 1
    if not limb or not limb then return end
    local needAdds = {}
    local function addPending(identifier, amount)
        if amount <= 0 then return end
        needAdds[identifier] = (needAdds[identifier] or 0) + amount
    end
    local function pickWeightedTarget(targets)
        local totalWeight = 0

        for _, target in ipairs(targets) do
            totalWeight = totalWeight + (target.chance or 0)
        end

        if totalWeight <= 0 then return nil end

        local roll = math.random() * totalWeight
        local current = 0

        for _, target in ipairs(targets) do
            current = current + (target.chance or 0)
            if roll <= current then
                return target
            end
        end

        return targets[#targets]
    end
    TLCyb.DamageMultiplier = TLConfig.Get("TL_cybDamageMultiplier", 1.5)
    for sourceAff, config in pairs(DamageConvertConfig) do
        local amount = TLHF.GetAfflictionLimbStrength(character, sourceAff, limb, 0)
        if amount > 0.1 then
            if config.targets and #config.targets > 0 then
                local selectAff = pickWeightedTarget(config.targets)
                if selectAff then
                    local weight = selectAff.weight or 1
                   
                    addPending(selectAff.id, amount * weight * qualityMultiplier * TLCyb.DamageMultiplier)
                end
            end
            if config.clear then
                TLHF.SetAfflictionLimb(character, sourceAff, limb, 0)
            end
        end
    end
    for identifier, amount in pairs(needAdds) do
        TLHF.AddAfflictionLimb(character, identifier, limb, amount)
    end
end
--伤害转换钩子版
function TLCyb.ConvertDamageGroupPatch(character,limb,attackResult,qualityMultiplier)
    qualityMultiplier = qualityMultiplier or 1
    if not limb or not limb then return end
    local needAdds = {}
    local function addPending(identifier, amount)
        if amount <= 0 then return end
        needAdds[identifier] = (needAdds[identifier] or 0) + amount
    end
    local function pickWeightedTarget(targets)
        local totalWeight = 0

        for _, target in ipairs(targets) do
            totalWeight = totalWeight + (target.chance or 0)
        end

        if totalWeight <= 0 then return nil end

        local roll = math.random() * totalWeight
        local current = 0

        for _, target in ipairs(targets) do
            current = current + (target.chance or 0)
            if roll <= current then
                return target
            end
        end

        return targets[#targets]
    end
    TLCyb.DamageMultiplier = TLConfig.Get("TL_cybDamageMultiplier", 1.5)
    for aff in attackResult.Afflictions do
        if aff and aff.Prefab then
            local sourceAff = aff.Prefab.Identifier.Value
            local config = DamageConvertConfig[sourceAff]

            if config then
                local amount = aff.Strength or 0

                if amount > 0.1 and config.targets and #config.targets > 0 then
                    local selectAff = pickWeightedTarget(config.targets)
                    if selectAff then
                        local weight = selectAff.weight or 1
                        addPending(
                            selectAff.id,
                            amount * weight * qualityMultiplier * TLCyb.DamageMultiplier
                        )
                    end
                end
            end
        end
    end
    for identifier, amount in pairs(needAdds) do
        TLHF.AddAfflictionLimb(character, identifier, limb, amount)
    end
end



-- --无法生效，似乎只读IsUnconscious状态，不驱动布娃娃
-- Hook.Patch("Barotrauma.CharacterHealth", "get_IsUnconscious", function(instance, ptable)
--     --instance:当前实例CharacterHealth
--     --ptable：参数表，用于设定ptable.PreventExecution = true，阻止函数执行
--     if instance == nil or instance.Character == nil then return end
--     local character = instance.Character
--     if character.IsDead or not character.IsHuman or character.AnimController == nil then return end
--     print("TLCyb.UpdateCharacter_IsUnconscious:", character.Name)
--     local isUnconscious = TLHF.ShouldBeUnconscious(character)
--     if not isUnconscious then return end
--     ptable.PreventExecution = true
--     print("TLCyb.UpdateCharacter_IsUnconscious:", character.Name, isUnconscious)
--     local res = character.IsDead or
--         (
--             isUnconscious
--             and not character.HasAbilityFlag(AbilityFlags.AlwaysStayConscious)
--         )
--     print(res)
--     character.IsUnconscious = res
--     return res
-- end, Hook.HookMethodType.After)