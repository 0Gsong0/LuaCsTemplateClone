TLCyb.ItemShader = {}
TLCyb.ItemShaderStartsWith = {}

Hook.Add("item.applyTreatment", "TLCyb.ItemShader", function(item, usingCharacter, targetCharacter, limb)
    if not item or not targetCharacter or not limb then return end

    local identifier = item.Prefab.Identifier.Value
    if identifier == nil then return end

    -- 1. 精确匹配
    local ItemFunction = TLCyb.ItemShader[identifier]
    if ItemFunction ~= nil then
        ItemFunction(item, usingCharacter, targetCharacter, limb)
        return
    end

    -- 2. 前缀匹配
    for prefix , ItemFunction in pairs(TLCyb.ItemShaderStartsWith) do
        if TLHF.StartsWith(identifier, prefix) then
            ItemFunction(item, usingCharacter, targetCharacter, limb)
            return
        end
    end
end)
--TLCyb_StructuralDamage结构损伤,TLCyb_ServoDamage伺服系统故障
--TLCyb_CircuitDamage电路损坏,TLCyb_SystemDamage神经同步失调
function TLCyb.Fix_TLCyb_StructuralDamage(item, usingCharacter, targetCharacter, limb)
    if not targetCharacter or not limb then return end
    local limbType = TLHF.NormalizeLimbType(limb.type)
    local limb = TLHF.GetLimb(targetCharacter,limbType)
    if not TLHF.HasAfflictionLimb(targetCharacter, "TLCyb_StructuralDamage", limb) then return end

    local num = TLHF.GetAfflictionLimbStrength(targetCharacter, "TLCyb_StructuralDamage", limb)
    if num <= 0.1 then return end
    local baseRepairNum = math.random(5, 10)
    local skillNum = TLHF.GetSkillLevel(usingCharacter, "mechanical")
    local bonusRepairNum = skillNum * 0.1
    local repairNum = -(baseRepairNum + bonusRepairNum)
    TLHF.AddAfflictionLimb(targetCharacter, "TLCyb_StructuralDamage", limb, repairNum)
    TLHF.RemoveItem(item)
end
function TLCyb.Fix_TLCyb_ServoDamage(item, usingCharacter, targetCharacter, limb)
    if not targetCharacter or not limb then return end
    local limbType = TLHF.NormalizeLimbType(limb.type)
    local limb = TLHF.GetLimb(targetCharacter,limbType)
    if not TLHF.HasAfflictionLimb(targetCharacter, "TLCyb_ServoDamage", limb) then return end

    local num = TLHF.GetAfflictionLimbStrength(targetCharacter, "TLCyb_ServoDamage", limb)
    if num <= 0.1 then return end
    local baseRepairNum = math.random(8, 15)
    local skillNum = TLHF.GetSkillLevel(usingCharacter, "mechanical")
    local bonusRepairNum = skillNum * 0.1
    local repairNum = -(baseRepairNum + bonusRepairNum)
    TLHF.AddAfflictionLimb(targetCharacter, "TLCyb_ServoDamage", limb, repairNum)
end
function TLCyb.Fix_TLCyb_CircuitDamage(item, usingCharacter, targetCharacter, limb)
    if not targetCharacter or not limb then return end
    local limbType = TLHF.NormalizeLimbType(limb.type)
    local limb = TLHF.GetLimb(targetCharacter,limbType)
    if not TLHF.HasAfflictionLimb(targetCharacter, "TLCyb_CircuitDamage", limb) then return end

    
    local num = TLHF.GetAfflictionLimbStrength(targetCharacter, "TLCyb_CircuitDamage", limb)
    if num <= 0.1 then return end
    local baseRepairNum = math.random(5, 15)
    local skillNum = TLHF.GetSkillLevel(usingCharacter, "mechanical")
    local bonusRepairNum = skillNum * 0.1
    local repairNum = -(baseRepairNum + bonusRepairNum)
    TLHF.AddAfflictionLimb(targetCharacter, "TLCyb_CircuitDamage", limb, repairNum)
    TLHF.RemoveItem(item)
end
function TLCyb.Fix_TLCyb_SystemDamage(item, usingCharacter, targetCharacter, limb)
    if not targetCharacter or not limb then return end
    local limbType = TLHF.NormalizeLimbType(limb.type)
    local limb = TLHF.GetLimb(targetCharacter,limbType)
    if not TLHF.HasAfflictionLimb(targetCharacter, "TLCyb_SystemDamage", limb) then return end


    local num = TLHF.GetAfflictionLimbStrength(targetCharacter, "TLCyb_SystemDamage", limb)
    if num <= 0.1 then return end

    local mechanical = TLHF.GetSkillLevel(usingCharacter, "mechanical") or 0
    local medical = TLHF.GetSkillLevel(usingCharacter, "medical") or 0
    local baseRepairNum = math.random(3, 8)
    local repairBonus = mechanical * 0.1 + medical * 0.05
    local repairNum = -(baseRepairNum + repairBonus)

    local baseCost = 15
    local saveBonus = mechanical * 0.05 + medical * 0.03
    local durabilityCost = math.max(5, baseCost - saveBonus)

    TLHF.AddAfflictionLimb(targetCharacter, "TLCyb_SystemDamage",limb, repairNum)
    
    TLHF.DamageItem(item, durabilityCost)
end
--兼容映射
TLCyb.ItemShader.steel = TLCyb.Fix_TLCyb_StructuralDamage
TLCyb.ItemShader.screwdriver = TLCyb.Fix_TLCyb_ServoDamage
TLCyb.ItemShader.fpgacircuit = TLCyb.Fix_TLCyb_CircuitDamage
TLCyb.ItemShader.TLCyb_Neuroleptic = TLCyb.Fix_TLCyb_SystemDamage
TLCyb.ItemShaderStartsWith["screwdriver"] = TLCyb.Fix_TLCyb_ServoDamage