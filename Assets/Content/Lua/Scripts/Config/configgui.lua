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

    local ui = easySettings.BasicFrame(parent, "泰拉渊洋配置", Vector2(0.45, 0.75))
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

    local ui = easySettings.BasicFrame(parent, "泰拉渊洋配置", Vector2(0.45, 0.75))
    TLConfigGUI.Root = ui
    TLConfigGUI.Parent = parent
    TLConfigGUI.IsLoading = false

    local canEdit = TLConfigGUI.CanEditConfig()

    local fromText = ""
    if TLConfigGUI.IsNetworkingConfig then 
        fromText = "当前配置来自服务器，保存时将提交到服务器"
    else
        fromText = "当前配置来自本地，保存时将写入本地配置文件"
    end
    GUI.TextBlock(
        GUI.RectTransform(Vector2(1, 0.08), ui.List.Content.RectTransform),
        fromText,
        Color(255, 230, 150),
        GUI.GUIStyle.SubHeadingFont,
        GUI.Alignment.Center
    )

    for key, entry in pairs(TLConfig.Entries) do
        if entry.type == "category" then
            local tick = GUI.TextBlock(
                GUI.RectTransform(Vector2(1, 0.08), ui.List.Content.RectTransform),
                entry.name,
                Color(255, 230, 150),
                GUI.GUIStyle.SubHeadingFont,
                GUI.Alignment.Center
            )
            tick.ToolTip = entry.description or ""
        elseif entry.type == "bool" then
            local currentValue = TLConfig.Get(key, entry.default or false)

            local tick = GUI.TickBox(
                GUI.RectTransform(Vector2(1, 0.1), ui.List.Content.RectTransform),
                entry.name
            )

            tick.Selected = currentValue
            tick.ToolTip = entry.description or ""

            if not canEdit then
                tick.Enabled = false
                tick.ToolTip = (entry.description or "").."\n你不是此服务器的管理员，你无权修改此项内容"
            end

            tick.OnSelected = function()
                if not canEdit then return end
                local isSelected = tick.State == GUIComponent.ComponentState.Selected
                TLConfig.Set(key, isSelected)
            end

        elseif entry.type == "float" then
            local currentValue = TLConfig.Get(key, entry.default or 1)

            local label = GUI.TextBlock(
                GUI.RectTransform(Vector2(1, 0.06), ui.List.Content.RectTransform),
                entry.name .. " : " .. string.format("%.2f", currentValue),
                Color(255, 255, 255),
                nil,
                GUI.Alignment.CenterLeft
            )

            label.ToolTip = entry.description or ""

            local input = GUI.NumberInput(
                GUI.RectTransform(Vector2(1, 0.08), ui.List.Content.RectTransform),
                NumberType.Float
            )

            if entry.range ~= nil then
                input.MinValueFloat = entry.range[1]
                input.MaxValueFloat = entry.range[2]
            end

            input.FloatValue = currentValue

            if not canEdit then
                input.Enabled = false
                input.ToolTip = "你不是此服务器的管理员，你无权修改此项内容"
            end

            input.OnValueChanged = function()
                if not canEdit then return end

                local rounded = tonumber(string.format("%.2f", input.FloatValue))
                TLConfig.Set(key, rounded)
                label.Text = entry.name .. " : " .. string.format("%.2f", rounded)
            end
        elseif entry.type == "int" then
            local currentValue = TLConfig.Get(key, entry.default or 1)
            local label = GUI.TextBlock(
                GUI.RectTransform(Vector2(1, 0.06), ui.List.Content.RectTransform),
                entry.name .. " : " .. tostring(currentValue),
                Color(255, 255, 255),
                nil,
                GUI.Alignment.CenterLeft
            )
            label.ToolTip = entry.description or ""
            local input = GUI.NumberInput(
                GUI.RectTransform(Vector2(1, 0.08), ui.List.Content.RectTransform),
                NumberType.Int
            )
            if entry.range ~= nil then
                input.MinValueInt = entry.range[1]
                input.MaxValueInt = entry.range[2]
            end
            input.IntValue = currentValue
            if not canEdit then
                input.Enabled = false
                input.ToolTip = "你不是此服务器的管理员，你无权修改此项内容"
            end
            input.OnValueChanged = function()
                if not canEdit then return end

                local value = input.IntValue
                TLConfig.Set(key, value)
                label.Text = entry.name .. " : " .. tostring(value)
            end
        elseif entry.type == "show" then
            local currentValue = TLConfig.Get(key, entry.default or 1)
            local label = GUI.TextBlock(
                GUI.RectTransform(Vector2(1, 0.06), ui.List.Content.RectTransform),
                entry.name .. " : " .. tostring(currentValue),
                Color(255, 255, 255),
                nil,
                GUI.Alignment.CenterLeft
            )
            label.ToolTip = entry.description or ""
        end
    end

    TLConfigGUI.AddButtons(ui, parent)
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
        end, 1000)
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
    local ui = easySettings.BasicFrame(parent, "泰拉渊洋配置", Vector2(0.62, 0.72))
    Lib_Client.OpenTLCybConfigMenu(ui.Frame, ui.List, ui.ButtonRow)
end)
