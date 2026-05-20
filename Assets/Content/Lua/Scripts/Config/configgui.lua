local easySettings = dofile(TL.Path .. "/Lua/Scripts/Config/easysettings.lua")
local GUIComponent = LuaUserData.CreateStatic("Barotrauma.GUIComponent")

TLConfigGUI = TLConfigGUI or {}
TLConfigGUI.Root = nil
TLConfigGUI.Parent = nil
TLConfigGUI.IsLoading = false
TLConfigGUI.LoadingText = nil
TLConfigGUI.HasReceivedConfig = false
TLConfigGUI.LoadRequestId = 0
TLConfigGUI.IsNetworkingConfig = false

function TLConfigGUI.ClearRoot()
    if TLConfigGUI.Root and TLConfigGUI.Root.Frame then
        TLConfigGUI.Root.Frame.RectTransform.Parent = nil
    end
    TLConfigGUI.Root = nil
end
function TLConfigGUI.CanEditConfig()
    if Game.IsSingleplayer then
        return true
    end

    if Game.IsMultiplayer and Game.Client ~= nil then
        return Game.Client.HasPermission(ClientPermissions.ManageSettings)
    end

    return false
end
function TLConfigGUI.DrawLoading(parent)
    TLConfigGUI.Parent = parent
    TLConfigGUI.ClearRoot()

    local ui = easySettings.BasicFrame(parent, "泰拉渊洋配置", Vector2(0.62, 0.72))
    TLConfigGUI.Root = ui
    TLConfigGUI.IsLoading = true

    TLConfigGUI.LoadingText = GUI.TextBlock(
        GUI.RectTransform(Vector2(1, 0.12), ui.List.Content.RectTransform),
        "正在加载配置，请稍候……",
        Color(255, 255, 255),
        nil,
        GUI.Alignment.Center
    )
end
function TLConfigGUI.DrawConfig(parent)
    TLConfigGUI.ClearRoot()

    local ui = easySettings.BasicFrame(parent, "泰拉渊洋配置", Vector2(0.62, 0.72))
    TLConfigGUI.Root = ui
    TLConfigGUI.Parent = parent
    TLConfigGUI.IsLoading = false

    Lib_Client.OpenTLCybConfigMenu(ui.Frame, ui.List, ui.ButtonRow)
end
function TLConfigGUI.AddButtons(ui, parent)
    local canEdit = TLConfigGUI.CanEditConfig()

    local saveButton = GUI.Button(
        GUI.RectTransform(Vector2(0.32, 1), ui.ButtonRow.RectTransform),
        "保存",
        GUI.Alignment.Center,
        "GUIButton"
    )

    local closeButton = GUI.Button(
        GUI.RectTransform(Vector2(0.32, 1), ui.ButtonRow.RectTransform),
        "关闭",
        GUI.Alignment.Center,
        "GUIButton"
    )

    local resetButton = GUI.Button(
        GUI.RectTransform(Vector2(0.32, 1), ui.ButtonRow.RectTransform),
        "恢复默认",
        GUI.Alignment.Center,
        "GUIButton"
    )

    if not canEdit then
        saveButton.Enabled = false
        resetButton.Enabled = false

        saveButton.ToolTip = "你不是服务器的管理员，无权限提交配置"
        resetButton.ToolTip = "你不是服务器的管理员，无权限恢复默认配置"
    end

    saveButton.OnClicked = function()
        if not canEdit then return end

        local box
        if Game.IsSingleplayer then
            TLConfig.SaveConfig()
            box = GUI.MessageBox("保存成功", "配置已保存到本地。", { "确定" })
        else
            --存疑
            TLConfig.SendConfig()
            box = GUI.MessageBox("保存成功", "配置已提交至服务器。", { "确定" })
        end

        box.DrawOnTop = true
        box.Buttons[1].OnClicked = function()
            box.Close()
        end
    end

    closeButton.OnClicked = function()
        GUI.GUI.TogglePauseMenu()
    end

    resetButton.OnClicked = function()
        if not canEdit then return end

        local box = GUI.MessageBox("恢复默认", "确定要恢复默认配置吗？记得手动点击保存哦...", { "确定", "取消" })
        box.DrawOnTop = true

        box.Buttons[1].OnClicked = function()
            TLConfig.ResetToDefaults()
            TLConfigGUI.DrawConfig(parent)
            box.Close()
        end

        box.Buttons[2].OnClicked = function()
            box.Close()
        end
    end
end
function TLConfigGUI.Open(parent)
    TLConfigGUI.Parent = parent
    TLConfigGUI.HasReceivedConfig = false
    TLConfigGUI.LoadRequestId = TLConfigGUI.LoadRequestId + 1
    TLConfigGUI.IsNetworkingConfig = false
    local requestId = TLConfigGUI.LoadRequestId

    TLConfigGUI.DrawLoading(parent)

    if Game.IsSingleplayer then
        TLConfig.LoadConfig()

        Timer.Wait(function()
            if requestId ~= TLConfigGUI.LoadRequestId then return end
            if TLConfigGUI.Parent == nil then return end
            TLConfigGUI.DrawConfig(TLConfigGUI.Parent)
        end, 100)
    else
        local msg = Networking.Start("TL.ConfigRequest")
        Networking.Send(msg)

        Timer.Wait(function()
            if requestId ~= TLConfigGUI.LoadRequestId then return end
            if TLConfigGUI.HasReceivedConfig then return end
            if TLConfigGUI.LoadingText ~= nil then
                TLConfigGUI.LoadingText.Text = "配置同步失败，请关闭后重试。"
                TLConfigGUI.LoadingText.TextColor = Color(255, 120, 120)
            end
        end, 8000)
    end
end
Networking.Receive("TL.ConfigUpdate", function(msg)
    TLConfig.ReceiveConfig(msg)
    TLConfigGUI.HasReceivedConfig = true

    if TLConfigGUI.Parent ~= nil then
        TLConfigGUI.IsNetworkingConfig = true
        TLConfigGUI.DrawConfig(TLConfigGUI.Parent)
    end
end)
easySettings.AddMenu("泰拉渊洋", function(parent)
    TLConfigGUI.Open(parent)
end)
