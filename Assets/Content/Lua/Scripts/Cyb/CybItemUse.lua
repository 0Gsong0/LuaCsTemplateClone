TLCyb.Item = {}

Hook.Add("item.applyTreatment", "TLCyber.applyInstall", function(item, usingCharacter, targetCharacter, limb)
    if
        not item or
        not targetCharacter or
        not usingCharacter or
        not limb
    then
        return
    end

    local identifier = item.Prefab.Identifier.Value
    --匹配ID并执行
    local methodtorun = TLCyb.Item[identifier]
    if (methodtorun ~= nil) then
        -- run said function
        methodtorun(item, usingCharacter, targetCharacter, limb)
        if TLConfig.Get("TL_TLDebugModel",false) then
             print("TLCyb.Item执行完成：" .. identifier.." usingCharacter" .. usingCharacter.Name.." targetCharacter"..targetCharacter.Name.." limb："..limb.type)
        end
        return
    end

    -- if not item or not targetCharacter or not limb then return end
    -- if item.prefab.Identifier.Value == "cyberlimb" then
    --     TLCyb.HF.InstallCybLimb(targetCharacter, limb)
    --     TLHF.RemoveItem(item)
    -- end
end)
--Lycoris   
TLCyb.Item.TLCyb_LycorisChip = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if not TLCyb.HF.IsInstallLycoris(targetCharacter) then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Init")
        TLHF.PlaySound("TLCyb_LycorisChip_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠·[加速学习协议]
TLCyb.Item.TLCyb_LycorisChip_Learning = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChip_Learning_Init") then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Learning_Init")
        TLHF.PlaySound("TLCyb_NewModel_Init_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_Learning_Init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠·[执行强化模块]
TLCyb.Item.TLCyb_LycorisChip_Skill = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChip_Skill_Init") then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Skill_Init")
        TLHF.PlaySound("TLCyb_NewModel_Init_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_Skill_Init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠·[应激缓冲模块]
TLCyb.Item.TLCyb_LycorisChip_Stress = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChip_Stress_Init") then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Stress_Init")
        TLHF.PlaySound("TLCyb_NewModel_Init_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_Stress_Init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠·[代谢调节模块]
TLCyb.Item.TLCyb_LycorisChip_Metabolic = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChip_Metabolic_Init") then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Metabolic_Init")
        TLHF.PlaySound("TLCyb_NewModel_Init_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_Metabolic_Init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠·终止-[回收协议]
TLCyb.Item.TLCyb_LycorisChip_Recovery = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChip_Recovery_Init") then
        TLCyb.HF.InstallCybLimb(targetCharacter, limb, "TLCyb_LycorisChip_Recovery_Init")
        TLHF.PlaySound("TLCyb_NewModel_Init_Sound", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChip_Recovery_Init"), "GUITLCyb_LycorisChip")
        end
        TLHF.RemoveItem(item)
    end
end
--曼珠重启
TLCyb.Item.TLCyb_LycorisChipRestart = function(item, usingCharacter, targetCharacter, limb)
    if limb.type ~= LimbType.Head then return end
    if TLCyb.HF.IsInstallLycoris(targetCharacter) and not TLHF.HasAffliction(targetCharacter, "TLCyb_LycorisChipRestart_Init") then
        TLHF.SetAffliction(targetCharacter, "TL_StunState", 5)
        TLHF.SetAffliction(targetCharacter,"TLCyb_LycorisSystemDamage",0)
        TLHF.PlaySound("TLCyb_LycorisChipRestart", targetCharacter)
        if targetCharacter == Character.Controlled then
            Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                Lib.ReadXmlRichText("TLCyb_LycorisChipRestart"), "GUITLCyb_LycorisChip")
        end
    end
end
--民用腿
local CivilianLegInstalled = {}
TLCyb.Item.TLCyb_CivilianLeg = function(item, usingCharacter, targetCharacter, limb)
    local limb = TLHF.NormalizeLimbType(limb.type)
    if limb ~= LimbType.LeftLeg and limb ~= LimbType.RightLeg then return end
    -- 已经有你的义体或 NT赛博义体，就不允许再装
    if TLCyb.HF.HasOtherCyberInstalled(targetCharacter, limb) then return end
    if not TLCyb.HF.IsCybLimb(targetCharacter, limb) then
        TLCyb.HF.InstallCybLimb(targetCharacter, TLHF.GetLimb(targetCharacter, limb), "TLCyb_CivilianLeg_Init")
        local charId = targetCharacter.ID
        CivilianLegInstalled[charId] = CivilianLegInstalled[charId] or false
        if not CivilianLegInstalled[charId] then
            TLHF.PlaySound("TLCyb_CivilianLeg_Sound", targetCharacter)
            if targetCharacter == Character.Controlled then
                Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                    Lib.ReadXmlRichText("TLCyb_CivilianLeg_Init"), "GUITLCyb_LycorisChip")
            end
            CivilianLegInstalled[charId] = true
        end
        TLHF.RemoveItem(item)
    end
end
--民用胳膊
local CivilianArmInstalled = {}
TLCyb.Item.TLCyb_CivilianArm = function(item, usingCharacter, targetCharacter, limb)
    local limb = TLHF.NormalizeLimbType(limb.type)
    if limb ~= LimbType.LeftArm and limb ~= LimbType.RightArm then return end
    -- 已经有你的义体或 NT赛博义体，就不允许再装
    if TLCyb.HF.HasOtherCyberInstalled(targetCharacter, limb) then return end
    if not TLCyb.HF.IsCybLimb(targetCharacter, limb) then
        TLCyb.HF.InstallCybLimb(targetCharacter, TLHF.GetLimb(targetCharacter, limb), "TLCyb_CivilianArm_Init")
        local charId = targetCharacter.ID
        CivilianArmInstalled[charId] = CivilianArmInstalled[charId] or false
        if not CivilianArmInstalled[charId] then
            TLHF.PlaySound("TLCyb_CivilianLeg_Sound", targetCharacter)
            if targetCharacter == Character.Controlled then
                Lib.CreatBottomMessageBox(Lib.ReadXmlRichText("entityname.TLCyb_LycorisChip"),
                    Lib.ReadXmlRichText("TLCyb_CivilianArm_Init"), "GUITLCyb_LycorisChip")
            end
            CivilianArmInstalled[charId] = true
        end
        TLHF.RemoveItem(item)
    end
end