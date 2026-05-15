TLCyb.HF = {}
TLCyb.HF._ntCompatPatched = false
function TLCyb.HF.HasTLCyber(character, limbType)
    if not character or not limbType then return false end
    limbType = TLHF.NormalizeLimbType(limbType)
    local limb = TLHF.GetLimb(character, limbType)
    if not limb then return false end
    if limbType == LimbType.LeftLeg or limbType == LimbType.RightLeg then
        return TLHF.HasAfflictionLimb(character, "TLCyb_CivilianLeg_Init", limb, 0.1)
    end
    if limbType == LimbType.LeftArm or limbType == LimbType.RightArm then
        return TLHF.HasAfflictionLimb(character, "TLCyb_CivilianArm_Init", limb, 0.1)
    end
    --继续添加
    return false
end
function TLCyb.HF.HasNTCyber(character,limbType)
    if not character or not limbType then return false end
    limbType = TLHF.NormalizeLimbType(limbType)
    local limb = TLHF.GetLimb(character, limbType)
    if not limb then return false end
    
    if TLHF.HasAfflictionLimb(character, "ntc_cyberlimb", limb, 0.1) then
        return true
    end
    if TLHF.HasAfflictionLimb(character, "ntc_cyberarm", limb, 0.1) then
        return true
    end
    if TLHF.HasAfflictionLimb(character, "ntc_cyberleg", limb, 0.1) then
        return true
    end

    if limbType == LimbType.Head and TLHF.HasAfflictionLimb(character, "ntc_cyberbrain", limb, 0.1) then
        return true
    end

    return false
end
--兼容 Neurotrauma/赛博拓展
function TLCyb.HF.ApplyNTCyberCompatPatches()
    if  not TLHF.HasNeurotraumaLoaded() then return end
    if NT == nil then return end
    if TLCyb.HF._ntCompatPatched then return end
    TLCyb.HF._ntCompatPatched = true
    -- BreakLimb 断肢
    if NT.BreakLimb ~= nil then
        local oldBreakLimb = NT.BreakLimb
        NT.BreakLimb = function(character, limbType, strength)
            strength = strength or 5
            limbType = TLHF.NormalizeLimbType(limbType)

            -- 只拦正向伤害，负数治疗/清除不要拦
            if strength > 0 and TLCyb.HF.IsAnyCyberLimb(character, limbType) then return end

            return oldBreakLimb(character, limbType, strength)
        end
    end
    -- DislocateLimb 脱臼肢体
    if NT.DislocateLimb ~= nil then
        local oldDislocateLimb = NT.DislocateLimb
        NT.DislocateLimb = function(character, limbType, strength)
            strength = strength or 1
            limbType = TLHF.NormalizeLimbType(limbType)

            if strength > 0 and TLCyb.HF.IsAnyCyberLimb(character, limbType) then return end

            return oldDislocateLimb(character, limbType, strength)
        end
    end
    -- ArteryCutLimb 动脉破裂
    if NT.ArteryCutLimb ~= nil then
        local oldArteryCutLimb = NT.ArteryCutLimb
        NT.ArteryCutLimb = function(character, limbType, strength)
            strength = strength or 5
            limbType = TLHF.NormalizeLimbType(limbType)

            if strength > 0 and TLCyb.HF.IsAnyCyberLimb(character, limbType) then return end

            return oldArteryCutLimb(character, limbType, strength)
        end
    end
    -- TraumamputateLimb 创伤截肢
    if NT.TraumamputateLimb ~= nil then
        local oldTraumamputateLimb = NT.TraumamputateLimb
        NT.TraumamputateLimb = function(character, limbType, attacker)
            limbType = TLHF.NormalizeLimbType(limbType)

            if TLCyb.HF.IsAnyCyberLimb(character, limbType) then return end

            return oldTraumamputateLimb(character, limbType, attacker)
        end
    end
    -- TraumamputateLimbMinusItem 创伤截肢
    if NT.TraumamputateLimbMinusItem ~= nil then
        local oldTraumamputateLimbMinusItem = NT.TraumamputateLimbMinusItem
        NT.TraumamputateLimbMinusItem = function(character, limbType)
            limbType = TLHF.NormalizeLimbType(limbType)

            if TLCyb.HF.IsAnyCyberLimb(character, limbType) then return end

            return oldTraumamputateLimbMinusItem(character, limbType)
        end
    end

    if not TLHF.HasNeurotraumaCybLoaded() then return end
    local oldCyberifyLimb = NTCyb.CyberifyLimb
    NTCyb.CyberifyLimb = function(character, limbType, isWaterproof)
        limbType = TLHF.NormalizeLimbType(limbType)

        if TLCyb.HF.HasTLCyber(character, limbType) then return end

        return oldCyberifyLimb(character, limbType, isWaterproof)
    end
end
-- 任意义体判定：TL + NT赛博
function TLCyb.HF.IsAnyCyberLimb(character, limbType)
    return TLCyb.HF.HasTLCyber(character, limbType) or TLCyb.HF.HasNTCyber(character, limbType)
end
-- 是否已被 另一套 义体占用
function TLCyb.HF.HasOtherCyberInstalled(character, limbType)
    return TLCyb.HF.IsAnyCyberLimb(character, limbType)
end
-- 是否是TL义体
function TLCyb.HF.IsCybLimb(character,limbType)
    return TLCyb.HF.HasTLCyber(character, limbType)
end
function TLCyb.HF.InstallCybLimb(target, limb,identifier)
    if not target or not limb then return end
    local limbType = TLHF.NormalizeLimbType(limb.type)
    if TLCyb.HF.HasOtherCyberInstalled(target, limbType) then return end
    TLHF.SetAfflictionLimb(target,identifier,limb,500)
end
function TLCyb.HF.IsInstallLycoris(character)
    if not character then return false end
    local limb = TLHF.GetLimb(character,LimbType.Head)
    if not limb then return false end
    return TLHF.HasAfflictionLimb(character,"TLCyb_LycorisChip_Init",limb)
end