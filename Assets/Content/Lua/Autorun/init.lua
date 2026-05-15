TL = {}
TL.Name="TaiLa - Deep - Ocean - New Era"
TL.Version = "Dev开发版本-1.0.2"
TL.Path = ...
TLCyb = {}


LuaUserData.RegisterType("TeraDeepOcean.TLLib_Shared")
Lib = LuaUserData.CreateStatic("TeraDeepOcean.TLLib_Shared", false)
if CLIENT then
    LuaUserData.RegisterType("TeraDeepOcean.TLLib_Client")
    Lib_Client = LuaUserData.CreateStatic("TeraDeepOcean.TLLib_Client", false)
end
if TeraDeepOcean == nil then
    print("TeraDeepOcean未找到")
end
dofile(TL.Path .. "/Lua/Scripts/Config/configdata.lua")
if CLIENT then
    dofile(TL.Path .. "/Lua/Scripts/Config/configgui.lua")
end
-- Hook.Add("roundStart", "TLconfig.LoadConfig", function()
--     Timer.Wait(function()
--         TLConfig.LoadConfig()
--     end, 100)
-- end)
--dofile(ST.Path.."/Lua/Autorun/Helperfunctions.lua")
if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then
    dofile(TL.Path.."/Lua/Scripts/Cyb/CybHF.Lua")
    dofile(TL.Path.."/Lua/Scripts/Cyb/CybItemUse.lua")
    dofile(TL.Path.."/Lua/Scripts/Cyb/CybHumanUpdate.Lua")
    dofile(TL.Path.."/Lua/Scripts/Cyb/items.shared.lua")
    dofile(TL.Path.."/Lua/Autorun/HelpFunction.lua")
    dofile(TL.Path.."/Lua/Scripts/Missile/Enemy_Anti-shipMissile.lua")

    Timer.Wait(function() Timer.Wait(function()
        local runstring = "\n/// ____Running TaiLa - Deep - Ocean____  "..TL.Version.." ///  \n Loading TaiLa  Deep  Ocean.... Subject \n 泰拉渊洋主体加载已完成...  \n 即将开始读取附件...  \n"

        -- add dashes
        local linelength = string.len(runstring)+4
        local i = 0
        while i < linelength do runstring=runstring.."-" i=i+1 end

        local hasSurgical, err = pcall(function()
            local Prefab = AfflictionPrefab.Prefabs["Surgicalexpansion"]
        end)
        local hasMusics, err = pcall(function()
            local Prefab = AfflictionPrefab.Prefabs["TLmusicpacks"]
        end)
        local hasSub, err = pcall(function()
            local Prefab = AfflictionPrefab.Prefabs["TLsub"]
        end)
        local hasMissiles, err = pcall(function()
            local Prefab = AfflictionPrefab.Prefabs["TLMissiles"]
        end)
        local HasNT, err = pcall(function()
            local Prefab = AfflictionPrefab.Prefabs["th_amputation"]
        end)

        -- No expansions
        runstring = runstring.."\n"
        if hasSurgical then
            runstring = runstring.."--- Surgical expansion has been added \n     -泰拉渊洋 - 改造手术拓展已添加\n    -Version ：0.0.1 测试版(test) \n"
        end
        if hasMusics then
            runstring = runstring.."--- Attached music packs has been added \n     -泰拉渊洋 - 附属音乐包已添加\n    -Version ：1.0.0 \n"
        end
        if hasSub then
            runstring = runstring.."--- Attached Sub packs has been added \n     -泰拉渊洋 - 附属舰艇包已添加\n    -Version ：1.0.0 \n"
        end
        if not hasSurgical and not hasMusics and not hasSub then
            runstring = runstring.."- Not running any expansions\n 目前未运行任何附件\n  目前发布拓展有：附属舰艇包、附属音乐包"
        end
        runstring = runstring.."\n开始读取测试包...\n"
        if hasMissiles then
            runstring = runstring.."--- Missile test package has been added \n     -泰拉渊洋 - 导弹测试包已添加\n    -Version ：0.0.3 \n"
        end
        if not hasMissiles then
            runstring = runstring.."- Not running any test expansions\n 目前未运行任何测试包\n"
        end
        runstring = runstring.."\n开始读取神经创伤...\n"
        if HasNT then
            runstring = runstring.."--- Neurotrauma has been added \n     - 神经创伤 - 已添加\n    医疗物品将执行对应逻辑 \n\n"
        end
        if not HasNT then
            runstring = runstring.."- Not running Neurotrauma\n 未运行 - 神经创伤 -\n \n"
        end
        runstring = runstring.."QQ群：860432216 \n"
        runstring = runstring.."///——————————泰拉渊洋已全部加载完毕——————————\\\\\\"
        print(package.path)
        print(runstring)
    end,3) end,6)
end

Timer.Wait(function()
    if TLCyb ~= nil and TLCyb.HF ~= nil and TLCyb.HF.ApplyNTCyberCompatPatches ~= nil then
        TLCyb.HF.ApplyNTCyberCompatPatches()
    end
end, 100)

TL.IdentifiersCheckList = {
    "screwdriver",
    "steel",
    "fpgacircuit"
}
TL.OverrideWarnings = {}
TL.OverrideDialogShown = false
local modOverrideChecked = false
Hook.Add("roundStart", "TLCyb.ResetCompatCheck", function()
    modOverrideChecked = false

    Timer.Wait(function()
        TL.RunOverrideChecks()
    end, 1000)
end)
function TL.AddOverrideWarning(modName, itemIdentifier, reason)
    modName = modName or "未知模组"
    itemIdentifier = itemIdentifier or "未知物品"
    reason = reason or "未知原因"

    table.insert(TL.OverrideWarnings, {
        mod = modName,
        item = itemIdentifier,
        reason = reason
    })
end
function TL.TryGetPrefabModName(prefab)
    if prefab == nil then return "未知模组" end

    local ok,  result = pcall(function()
        if prefab.ContentPackage ~= nil and prefab.ContentPackage.Name ~= nil then
            return tostring(prefab.ContentPackage.Name)
        end
        return "未知模组"
    end)

    if ok and result ~= nil then
        return result
    end

    return "未知模组"
end
function TL.CheckItemHealthInterface(identifier)
    local prefab = ItemPrefab.GetItemPrefab(identifier)

    if prefab == nil then
        TL.AddOverrideWarning("未知模组", identifier, "未找到该物品 prefab")
        return
    end

    local modName = TL.TryGetPrefabModName(prefab)

    local ok, useInHealth = pcall(function()
        return prefab.ConfigElement.GetAttributeBool("useinhealthinterface", false)
    end)

    if not ok then
        TL.AddOverrideWarning(modName, identifier, "无法读取 useinhealthinterface 属性")
        return
    end

    if not useInHealth then
        TL.AddOverrideWarning(modName, identifier, "useinhealthinterface 被设为 false")
    end
end
function TL.BuildOverrideWarningText()
    if #TL.OverrideWarnings <= 0 then
        return nil
    end

    local lines = {}
    table.insert(lines, "检测到模组覆盖冲突：")
    table.insert(lines, "")

    for _, warning in ipairs(TL.OverrideWarnings) do
        table.insert(lines,
            _..".\n"..
            "正在发生覆盖的模组: " .. tostring(warning.mod) ..
            "\n被覆盖的物品: " .. tostring(warning.item) ..
            "\n问题: " .. tostring(warning.reason) ..
            "\n"
        )
    end

    return table.concat(lines, "\n")
end
function TL.ShowOverrideDialogToAll()
    if TL.OverrideDialogShown then return end
    TL.OverrideDialogShown = true

    local text = TL.BuildOverrideWarningText()
    if text == nil then return "检查出现错误" end

    text = text.."\n请提升 泰拉渊洋-新时代 排序优先级后再次尝试"
    if SERVER then
        for _, client in pairs(Client.ClientList) do
           TLHF.ShowDialogToAll("警告：模组内容被覆盖", text,client)
        end
    else
        TLHF.ShowDialogToAll("警告：模组内容被覆盖", text)
    end
    
end
function TL.RunOverrideChecks()
    TL.OverrideWarnings = {}
    TL.OverrideDialogShown = false

    for _, identifier in ipairs(TL.IdentifiersCheckList) do
        TL.CheckItemHealthInterface(identifier)
    end

    if #TL.OverrideWarnings > 0 then
        TL.ShowOverrideDialogToAll()
        TLHF.GiveAfflictionToAll("TL_overridWarning")
    end
end
-- function TL.CheckScrewdriverOverrideOnce()
--     if modOverrideChecked then return end
--     modOverrideChecked = true

--     local overridden = false

--     for _, identifier in ipairs(TL.IdentifiersCheckList) do
--         local prefab = ItemPrefab.GetItemPrefab(identifier)

--         if prefab == nil or prefab.ConfigElement == nil then
--             overridden = true
--             break
--         end

--         local useInHealth = prefab.ConfigElement.GetAttributeBool("useinhealthinterface", false)
--         if useInHealth then
--             overridden = true
--             break
--         end
--     end

--     if overridden then
--         TLHF.ShowOverrideDialogToAll("模组覆盖警告","114514")
--         TLHF.GiveAfflictionToAll("TL_overridWarning")
--     end

-- end

--作为服务端
if SERVER then
    Networking.Receive("TL.ConfigRequest", function(msg, sender)
        if not sender then return end
        TLConfig.SendConfig(sender)
    end)

    Networking.Receive("TL.ConfigUpdate", function(msg, sender)
        if not sender then return end
        if Game.IsMultiplayer and not sender.HasPermission(ClientPermissions.ManageSettings) then
            return
        end

        TLConfig.ReceiveConfig(msg)
        TLConfig.SaveConfig()
        TLConfig.SendConfig(nil)
    end)
end