using Barotrauma;
using Barotrauma.Networking;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace TeraDeepOcean
{
    public static class TLCybConfigMenu
    {
        private enum ConfigTab
        {
            System,
            Cyber
        }
        private static bool isOpen = false;
        private static ConfigTab? currentTab = null;
        private static GUIFrame rootFrame;

        private static GUIFrame leftPanel;
        private static GUIFrame rightPanel;

        private static GUIButton systemTabButton;
        private static GUIButton cyberTabButton;

        private static GUITextBlock rightTitle;
        private static GUIListBox rightList;

        private static GUIButton saveButton;
        private static GUIButton resetButton;
        private static GUIButton closeButton;

        private static bool suppressNumberEvent = false;

        private static GUITextBlock configModel;
        private static GUITextBlock gameModel;
        public static void Open(GUIFrame frame, GUIListBox list, GUIComponent buttonRow)
        {
            isOpen = true;
            currentTab = null;
            DrawConfigUI(frame, list, buttonRow);
            RefreshTabVisuals();
            RefreshRightPanel();
        }
        public static void Close()
        {
            isOpen = false;
            if (rootFrame != null)
            {
                rootFrame.Visible = false;
                rootFrame.Enabled = false;
            }
        }
        public static void DrawConfigUI(GUIFrame frame, GUIListBox list, GUIComponent buttonRow)
        {
            rootFrame = frame;
            // 内容区总容器：左右分栏都放在这里
            GUIFrame contentRoot = new GUIFrame(
                new RectTransform(new Vector2(0.98f, 0.98f), list.Content.RectTransform, Anchor.Center),
                style: null
            );
            // 左侧分类栏
            leftPanel = new GUIFrame(
                new RectTransform(new Vector2(0.24f, 1f), contentRoot.RectTransform, Anchor.CenterLeft),
                style: "InnerFrame"
            );
            // 右侧详情栏
            rightPanel = new GUIFrame(
                new RectTransform(new Vector2(0.75f, 1f), contentRoot.RectTransform, Anchor.CenterRight)
                {
                    RelativeOffset = new Vector2(0.0f, 0)
                },
                style: "InnerFrame"
            );
            // 左侧两个分类按钮
            systemTabButton = new GUIButton(
                new RectTransform(new Vector2(0.88f, 0.10f), leftPanel.RectTransform, Anchor.TopCenter)
                {
                    AbsoluteOffset = new Point(0, 18)
                },
                TLLib_Shared.ReadXmlRichText("config.System"),
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            cyberTabButton = new GUIButton(
                new RectTransform(new Vector2(0.88f, 0.10f), leftPanel.RectTransform, Anchor.TopCenter)
                {
                    AbsoluteOffset = new Point(0, 80)
                },
                TLLib_Shared.ReadXmlRichText("config.Cyb"),
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            systemTabButton.OnClicked = (button, obj) =>
            {
                currentTab = ConfigTab.System;
                RefreshTabVisuals();
                RefreshRightPanel();
                return true;
            };
            cyberTabButton.OnClicked = (button, obj) =>
            {
                currentTab = ConfigTab.Cyber;
                RefreshTabVisuals();
                RefreshRightPanel();
                return true;
            };
            // 右侧标题
            rightTitle = new GUITextBlock(
                new RectTransform(new Vector2(0.92f, 0.05f), rightPanel.RectTransform, Anchor.TopCenter),
                "",
                textAlignment: Alignment.CenterLeft,
                style: "GUITextBlock"
            );
            rightTitle.TextScale = 1.2f;
            // 右侧滚动内容区
            rightList = new GUIListBox(
                new RectTransform(new Vector2(0.92f, 0.85f), rightPanel.RectTransform, Anchor.BottomCenter)
                {
                    AbsoluteOffset = new Point(0, 10)
                },
                style: "GUIListBox"
            );
            // 底部按钮区
            bool canEdit = CanEditConfig();
            saveButton = new GUIButton(
                new RectTransform(new Vector2(0.30f, 1f), buttonRow.RectTransform),
                "保存",
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            saveButton.Enabled = canEdit;
            saveButton.ToolTip = canEdit ? TLLib_Shared.ReadXmlRichText("config.Submit") : TLLib_Shared.ReadXmlRichText("config.CantEdit");
            saveButton.OnClicked = (button, obj) =>
            {
                if (!CanEditConfig()) return true;
                TLCybConfigData.Save();
                return true;
            };

            resetButton = new GUIButton(
                new RectTransform(new Vector2(0.30f, 1f), buttonRow.RectTransform),
                TLLib_Shared.ReadXmlRichText("config.Default"),
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            resetButton.Enabled = canEdit;
            resetButton.ToolTip = canEdit ? TLLib_Shared.ReadXmlRichText("config.des.Default") : TLLib_Shared.ReadXmlRichText("config.CantEdit");
            resetButton.OnClicked = (button, obj) =>
            {
                if (!CanEditConfig()) return true;
                TLCybConfigData.Reset();
                currentTab = null;
                RefreshRightPanel();
                RefreshTabVisuals();
                return true;
            };

            closeButton = new GUIButton(
                new RectTransform(new Vector2(0.30f, 1f), buttonRow.RectTransform)
                {
                    AbsoluteOffset = new Point(50, 0)
                },
                TLLib_Shared.ReadXmlRichText("config.close"),
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            closeButton.OnClicked = (button, obj) =>
            {
                Close();
                return true;
            };
        }
        public static void Update()
        {
            if (!isOpen) return;
        }
        /// <summary>
        /// 刷新右侧内容
        /// </summary>
        private static void RefreshRightPanel()
        {
            if (rightTitle == null || rightList == null) return;
            ClearRightPanel();
            if (currentTab == null)
            {
                rightTitle.Text = TLLib_Shared.ReadXmlRichText("config.TeraDeepOcean");
                if (!CanEditConfig())
                {
                    configModel = new GUITextBlock(
                        new RectTransform(new Vector2(0.92f, 0.06f), rightPanel.RectTransform, Anchor.TopCenter)
                        {
                            AbsoluteOffset = new Point(0, 35)
                        },
                        TLLib_Shared.ReadXmlRichText("config.configModel.CantEdit"),
                        textAlignment: Alignment.CenterLeft,
                        style: "GUITextBlock"
                    );
                }
                else
                {
                    configModel = new GUITextBlock(
                        new RectTransform(new Vector2(0.92f, 0.06f), rightPanel.RectTransform, Anchor.TopCenter)
                        {
                            AbsoluteOffset = new Point(0, 35)
                        },
                        TLLib_Shared.ReadXmlRichText("config.configModel.Edit"),
                        textAlignment: Alignment.CenterLeft,
                        style: "GUITextBlock"
                    );
                }
                if (!GameMain.IsMultiplayer)
                {
                    gameModel = new GUITextBlock(
                        new RectTransform(new Vector2(0.92f, 0.06f), rightPanel.RectTransform, Anchor.TopCenter)
                        {
                            AbsoluteOffset = new Point(0, 55)
                        },
                        TLLib_Shared.ReadXmlRichText("config.gameModel.sing"),
                        textAlignment: Alignment.CenterLeft,
                        style: "GUITextBlock"
                    );
                }
                else
                {
                    gameModel = new GUITextBlock(
                        new RectTransform(new Vector2(0.92f, 0.06f), rightPanel.RectTransform, Anchor.TopCenter)
                        {
                            AbsoluteOffset = new Point(0, 55)
                        },
                        TLLib_Shared.ReadXmlRichText("config.gameModel.server"),
                        textAlignment: Alignment.CenterLeft,
                        style: "GUITextBlock"
                    );
                }
                string spritePath = System.IO.Path.Combine(Plugin.ModDir, "Content", "UI", "泰拉logo.png");
                spritePath = spritePath.Replace('\\', '/');
                Sprite iconSprite = LoadSprite(spritePath);
                GUIImage icon = new GUIImage(
                    new RectTransform(new Vector2(1f, 0.85f), rightList.Content.RectTransform, Anchor.CenterLeft)
                    {
                        AbsoluteOffset = new Point(0, -50)
                    },
                    iconSprite, true
                );
                GUITextBlock welcomeText = new GUITextBlock(
                    new RectTransform(new Vector2(0.9f, 0.12f), rightList.Content.RectTransform, Anchor.BottomCenter)
                    {
                        AbsoluteOffset = new Point(0, -100)
                    },
                    TLLib_Shared.ReadXmlRichText("config.choose"),
                    textAlignment: Alignment.Center,
                    style: "GUITextBlock"
                );
                welcomeText.TextScale = 1.3f;
            }
            else if (currentTab == ConfigTab.System)
            {
                rightTitle.Text = TLLib_Shared.ReadXmlRichText("config.TL_header_System");
                rightTitle.TextScale = 1.5f;

                AddSectionTitle(rightList.Content, "TL_header_System");
                AddIntSetting(rightList.Content, "TL_TLUpdateInterval", 2, 1, 5);
                AddIntSetting(rightList.Content, "TL_TLLateUpdateInterval", 2, 1, 10);
            }
            else if (currentTab == ConfigTab.Cyber)
            {
                rightTitle.Text = TLLib_Shared.ReadXmlRichText("config.TL_header_cyb");
                rightTitle.TextScale = 1.5f;

                AddSectionTitle(rightList.Content, "TL_header_cyb");
                AddFloatSetting(rightList.Content, "TL_cybDamageMultiplier", 1.5f, 0.1f, 5f, 0.1f);
                AddFloatSetting(rightList.Content, "TL_TLCybTripChance", 0.25f, 0f, 1f, 0.1f);
                AddIntSetting(rightList.Content, "TL_TLCybProtectFallNum", 5, 0, 20);
                AddIntSetting(rightList.Content, "TLCyb_LycorisSystemDamage_AutoIncrementThreshold", 80, 10, 100);
                AddIntSetting(rightList.Content, "TLCyb_SystemDamageCrawlThreshold", 60, 10, 100);
                AddIntSetting(rightList.Content, "TLCyb_ServoDamageCrawlThreshold", 80, 10, 100);
                AddIntSetting(rightList.Content, "TLCyb_totalDisableScoreoDamageCrawlThreshold", 150, 10, 300);
            }
        }
        /// <summary>
        /// 添加标签
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        private static GUITextBlock AddLabel(RectTransform parent, string text)
        {
            GUITextBlock label = new GUITextBlock(
                new RectTransform(new Vector2(0.96f, 0.08f), parent),
                text,
                textAlignment: Alignment.CenterLeft,
                style: "GUITextBlock"
            );
            return label;
        }
        /// <summary>
        /// 通用分类标题
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        private static GUITextBlock AddSectionTitle(GUIComponent parent, string key)
        {
            string name = TLCybConfigData.GetName(key);
            string description = TLCybConfigData.GetDescription(key);
            GUITextBlock title = new GUITextBlock(
                new RectTransform(new Vector2(0.96f, 0.08f), parent.RectTransform),
                name,
                textAlignment: Alignment.CenterLeft,
                style: "GUITextBlock"
            );
            title.toolTip = description;
            return title;
        }
        /// <summary>
        /// 通用数字设置
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="key"></param>
        /// <param name="defaultValue"></param>
        /// <param name="minValue"></param>
        /// <param name="maxValue"></param>
        /// <param name="step"></param>
        /// <param name="decimals"></param>
        private static void AddFloatSetting(
            GUIComponent parent,
            string key,
            float defaultValue,
            float minValue,
            float maxValue,
            float step,
            int decimals = 1)
        {
            string name = TLCybConfigData.GetName(key);
            string description = TLCybConfigData.GetDescription(key);
            float currentValue = TLCybConfigData.GetFloat(key, defaultValue);
            bool canEdit = CanEditConfig();

            GUITextBlock label = new GUITextBlock(
                new RectTransform(new Vector2(0.96f, 0.06f), parent.RectTransform),
                name + " : " + currentValue.ToString("F" + decimals),
                textAlignment: Alignment.CenterLeft,
                style: "GUITextBlock"
            );
            label.ToolTip = description;

            GUINumberInput input = new GUINumberInput(
                new RectTransform(new Vector2(0.96f, 0.08f), parent.RectTransform),
                NumberType.Float
            );

            input.MinValueFloat = minValue;
            input.MaxValueFloat = maxValue;
            input.FloatValue = currentValue;
            input.ToolTip = description;
            input.ToolTip = canEdit ? description : GetNoPermissionToolTip(description);
            input.Enabled = canEdit;

            input.OnValueChanged = numberInput =>
            {
                if (!canEdit || suppressNumberEvent) return;

                float snapped = SnapToStep(numberInput.FloatValue, step);
                snapped = (float)Math.Round(snapped, decimals);

                if (Math.Abs(numberInput.FloatValue - snapped) > 0.0001f)
                {
                    suppressNumberEvent = true;
                    numberInput.FloatValue = snapped;
                    suppressNumberEvent = false;
                }

                TLCybConfigData.SetFloat(key, snapped);
                label.Text = name + " : " + snapped.ToString("F" + decimals);
            };
        }
        /// <summary>
        /// 通用整数设置
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="key"></param>
        /// <param name="defaultValue"></param>
        /// <param name="minValue"></param>
        /// <param name="maxValue"></param>
        private static void AddIntSetting(
            GUIComponent parent,
            string key,
            int defaultValue,
            int minValue,
            int maxValue)
        {
            string name = TLCybConfigData.GetName(key);
            string description = TLCybConfigData.GetDescription(key);
            int currentValue = (int)Math.Round(TLCybConfigData.GetFloat(key, defaultValue));
            bool canEdit = CanEditConfig();

            GUITextBlock label = new GUITextBlock(
                new RectTransform(new Vector2(0.96f, 0.06f), parent.RectTransform),
                name + " : " + currentValue,
                textAlignment: Alignment.CenterLeft,
                style: "GUITextBlock"
            );
            label.ToolTip = description;

            GUINumberInput input = new GUINumberInput(
                new RectTransform(new Vector2(0.96f, 0.08f), parent.RectTransform),
                NumberType.Int
            );

            input.MinValueInt = minValue;
            input.MaxValueInt = maxValue;
            input.IntValue = currentValue;
            input.ToolTip = canEdit ? description : GetNoPermissionToolTip(description);
            input.Enabled = canEdit;

            input.OnValueChanged = numberInput =>
            {
                if (!canEdit) return;

                int value = numberInput.IntValue;
                TLCybConfigData.SetFloat(key, value);
                label.Text = name + " : " + value;
            };
        }

        /// <summary>
        /// 通用布尔设置
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="key"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        private static GUITickBox AddBoolSetting(GUIComponent parent, string key, bool defaultValue)
        {
            string name = TLCybConfigData.GetName(key);
            string description = TLCybConfigData.GetDescription(key);
            bool value = TLCybConfigData.GetBool(key, defaultValue);
            bool canEdit = CanEditConfig();

            GUITickBox tick = new GUITickBox(
                new RectTransform(new Vector2(0.96f, 0.08f), parent.RectTransform),
                name
            );

            tick.Selected = value;
            tick.ToolTip = canEdit ? description : GetNoPermissionToolTip(description);
            tick.Enabled = canEdit;

            tick.OnSelected = tickBox =>
            {
                if (!canEdit) return true;

                TLCybConfigData.SetBool(key, tickBox.Selected);
                return true;
            };

            return tick;
        }
        private static string GetNoPermissionToolTip(string original)
        {
            string extra = TLLib_Shared.ReadXmlRichText("config.configModel.CantEdit").ToString();
            if (string.IsNullOrWhiteSpace(original)) return extra;
            return original + "\n" + extra;
        }
        /// <summary>
        /// 清空右侧内容
        /// </summary>
        private static void ClearRightPanel()
        {
            if (rightList == null || rightList.Content == null) return;

            if(configModel != null)
            {
                configModel.RectTransform.Parent = null;
                gameModel.RectTransform.Parent = null;
            }
            var children = new List<RectTransform>(rightList.Content.RectTransform.Children);
            foreach (var child in children)
            {
                child.Parent = null;
            }
        }
        private static void RefreshTabVisuals()
        {
            if (systemTabButton != null)
            {
                systemTabButton.Color = currentTab == ConfigTab.System
                    ? new Color(70, 120, 180, 255)
                    : new Color(255, 255, 255, 200);
            }

            if (cyberTabButton != null)
            {
                cyberTabButton.Color = currentTab == ConfigTab.Cyber
                    ? new Color(70, 120, 180, 255)
                    : new Color(255, 255, 255, 200);
            }
        }
        private static Sprite LoadSprite(string spritePath)
        {
            var texture = Sprite.LoadTexture(spritePath);
            if (texture == null) return null;
            return new Sprite(texture, null, null, 0f, spritePath);
        }
        /// <summary>
        /// 限制步长
        /// </summary>
        /// <param name="value"></param>
        /// <param name="step"></param>
        /// <returns></returns>
        private static float SnapToStep(float value, float step)
        {
            if (step <= 0f) return value;
            return (float)System.Math.Round(value / step) * step;
        }
        private static bool CanEditConfig()
        {
            if (!GameMain.IsMultiplayer) return true;
            if (GameMain.Client == null) return false;

            Client myClient = GameMain.Client.MyClient;
            if (myClient == null) return false;

            return myClient.IsOwner || myClient.HasPermission(ClientPermissions.ManageSettings);
        }
    }
}
