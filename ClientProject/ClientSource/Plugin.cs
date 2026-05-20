using Barotrauma;
using Barotrauma.LuaCs.Data;
using Microsoft.Xna.Framework;
using System;
using static Barotrauma.Media.Video;

namespace TeraDeepOcean
{
    public partial class Plugin : IAssemblyPlugin
    {
        private GUIFrame debugButtonFrame;
        private GUIButton openWorkbenchButton;

        private GUIFrame workbenchFrame;

        private GUITextBlock summaryText;

        private GUIFrame leftLegPanel;
        private GUIFrame rightLegPanel;
        private GUIFrame leftArmPanel;
        private GUIFrame rightArmPanel;

        private GUITextBlock leftLegText;
        private GUITextBlock rightLegText;
        private GUITextBlock leftArmText;
        private GUITextBlock rightArmText;


        private bool buttonCreated = false;
        private bool workbenchCreated = false;
        private bool workbenchOpen = false;

        bool enableDebugPanel;

        private GUIFrame actionBarFrame;
        private GUIButton spawnButton;
        private GUIButton clearButton;
        private GUIButton giveWeaponButton;
        private GUITickBox torsoNoDamageTickBox;
        private bool debugNoTorsoDamage = false;

        private double accumulatedTime = 0.0;
        private double lastGuiRefreshTime = 0.0;
        private double lastWorkbenchUpdateTime = 0.0;
        public TLConfig Config { get; private set; }
        public GUIButton testWall;
        partial void InitProjSpecific()
        {
            Config = new TLConfig(
                ConfigService,
                PluginService,
                LoggerService
            );
            LuaCsSetup.Instance.Hook.Add("roundStart", "TeraDeepOcean.WallMoverReset", args =>
            {
                TLWallHelper.Reset();
                LuaCsLogger.Log("TLWallMoverSystem reset on roundStart.");
                return null;
            });
            LuaCsSetup.Instance.Hook.Add("think", "TeraDeepOcean.CyberDiagnoserV1", (object[] args) =>
            {
                CreateDebugButton();
                if (debugButtonFrame != null && enableDebugPanel)
                {
                    debugButtonFrame.Visible = true;
                    debugButtonFrame.Enabled = true;
                    debugButtonFrame.AddToGUIUpdateList();
                }
                if (workbenchOpen && workbenchFrame != null && enableDebugPanel)
                {
                    workbenchFrame.Visible = true;
                    workbenchFrame.Enabled = true;
                    workbenchFrame.AddToGUIUpdateList();
                }
                TLCybConfigMenu.Update();
                double deltaTime = Convert.ToDouble(args[0]);
                accumulatedTime += deltaTime;
                if (accumulatedTime - lastGuiRefreshTime >= 2 )
                {
                    lastGuiRefreshTime = accumulatedTime;
                    UpdateWorkbenchUI(accumulatedTime);
                }
                TLWallHelper.Update((float)deltaTime);
                return null;
            });
            LuaCsSetup.Instance.Hook.Patch("Barotrauma.CharacterHealth", "ApplyDamage", (instance, ptable) =>
            {
                if (!debugNoTorsoDamage) return null;
                CharacterHealth characterHealth = instance as CharacterHealth;
                Limb hitLimb = ptable["hitLimb"] as Limb;

                Character character = characterHealth.Character;
                if (character == null) return null;
                LimbType limbType = hitLimb.type;
                if (limbType != LimbType.Torso && limbType != LimbType.Waist) return null;

                ptable["damageMultiplier"] = 0f;
                ptable.PreventExecution = true;

                return null;
            });
        }
        void CreateDebugButton()
        {
            Config.LoadConfig();
            enableDebugPanel = Config == null || Config.EnableDebugPanel;
            if (buttonCreated)
            {
                debugButtonFrame.Visible = enableDebugPanel;
            }
            if (buttonCreated) return;
            if (GUI.Canvas == null) return;

            debugButtonFrame = new GUIFrame(
                new RectTransform(
                    new Vector2(0.10f, 0.05f),
                    GUI.Canvas,
                    Anchor.TopRight
                ),
                style: "GUIFrame"
            );
            debugButtonFrame.RectTransform.AbsoluteOffset = new Point(0, 80);

            //openWorkbenchButton = new GUIButton(
            //    new RectTransform(Microsoft.Xna.Framework.Vector2.One, debugButtonFrame.RectTransform),
            //    "义体调试终端",
            //    textAlignment: Alignment.Center,
            //    style: "GUIButton"
            //);

            //openWorkbenchButton.OnClicked = (button, obj) =>
            //{
            //    ToggleWorkbench();
            //    return true;
            //};
            buttonCreated = true;

        }
        private void ToggleWorkbench()
        {
            CreateWorkbenchUI();

            workbenchOpen = !workbenchOpen;

            if (workbenchFrame != null)
            {
                workbenchFrame.Visible = workbenchOpen;
            }
        }
        void CreateWorkbenchUI()
        {
            if (workbenchCreated) return;
            if (GUI.Canvas == null) return;

            workbenchFrame = new GUIFrame(
                new RectTransform(
                    new Vector2(0.6f, 0.65f),
                    GUI.Canvas,
                    Anchor.Center
                ),
                style: "GUIFrame"
            );

            GUITextBlock titleText = new GUITextBlock(
                new RectTransform(
                    new Microsoft.Xna.Framework.Vector2(0.92f, 0.82f),
                    workbenchFrame.RectTransform,
                    Anchor.TopCenter
                ),
                "义体工作台 / 检测终端",
                textAlignment: Alignment.TopLeft,
                style: "GUITextBlock"
            );
            titleText.TextScale = 1.4f;
            summaryText = new GUITextBlock(
                new RectTransform(
                    new Vector2(0.92f, 0.16f),
                    workbenchFrame.RectTransform,
                    Anchor.TopCenter
                )
                {
                    AbsoluteOffset = new Point(0, 40)
                },
                "总览区域",
                textAlignment: Alignment.TopLeft,
                style: "GUITextBlock"
            );
            actionBarFrame = new GUIFrame(
                new RectTransform(
                    new Vector2(0.92f, 0.10f),
                    workbenchFrame.RectTransform,
                    Anchor.TopCenter
                )
                {
                    AbsoluteOffset = new Point(0, 110)
                },
                style: "InnerFrame"
            );
            spawnButton = new GUIButton(
                new RectTransform(
                    new Vector2(0.22f, 0.72f),
                    actionBarFrame.RectTransform,
                    Anchor.CenterLeft
                )
                {
                    AbsoluteOffset = new Point(10, 0)
                },
                "获得义体",
                textAlignment: Alignment.Center,
                style: "GUIButtonSmall"
            );
            spawnButton.OnClicked = (button, obj) =>
            {
                if (Character.controlled == null) return true;
                TLCybHelper.SpawnCyberItemsToControlledCharacter(Character.controlled);
                return true;
            };
            clearButton = new GUIButton(
                new RectTransform(
                    new Vector2(0.22f, 0.72f),
                    actionBarFrame.RectTransform,
                    Anchor.Center
                )
                {
                    AbsoluteOffset = new Point(0, 0)
                },
                "清除Aff",
                textAlignment: Alignment.Center,
                style: "GUIButtonSmall"
            );
            giveWeaponButton = new GUIButton(
                new RectTransform(
                    new Vector2(0.22f, 0.72f),
                    actionBarFrame.RectTransform,
                    Anchor.CenterRight
                )
                {
                    AbsoluteOffset = new Point(10, 0)
                },
                "武器调试",
                textAlignment: Alignment.Center,
                style: "GUIButtonSmall"
            );
            giveWeaponButton.OnClicked = (button, obj) =>
            {
                DebugGiveWeaponAndMaxSkill();
                return true;
            };
            torsoNoDamageTickBox = new GUITickBox(
                new RectTransform(
                    new Vector2(0.30f, 0.06f),
                    workbenchFrame.RectTransform,
                    Anchor.Center
                )
                {
                    AbsoluteOffset = new Point(60, 0)
                },
                "Torso 无伤调试"
            );
            torsoNoDamageTickBox.Selected = debugNoTorsoDamage;
            torsoNoDamageTickBox.OnSelected = tickBox =>
            {
                debugNoTorsoDamage = tickBox.Selected;
                return true;
            };

            clearButton.OnClicked = (button, obj) =>
            {
                TLCybHelper.ClearAllAfflictionsFromControlledCharacter();
                return true;
            };
            leftLegPanel = CreateLimbPanel(
               workbenchFrame.RectTransform,
               new Vector2(0.35f, 0.26f),
               Anchor.CenterLeft,
               new Point(20, -20),
               "左腿"
            );
            rightLegPanel = CreateLimbPanel(
                workbenchFrame.RectTransform,
                new Vector2(0.35f, 0.26f),
                Anchor.CenterRight,
                new Point(20, -20),
                "右腿"
            );
            leftArmPanel = CreateLimbPanel(
                workbenchFrame.RectTransform,
                new Vector2(0.35f, 0.26f),
                Anchor.BottomLeft,
                new Point(20, 0),
                "左手（预留1）"
            );
            rightArmPanel = CreateLimbPanel(
                workbenchFrame.RectTransform,
                new Vector2(0.35f, 0.26f),
                Anchor.BottomRight,
                new Point(20, 0),
                "右手（预留）"
            );
            leftLegText = CreatePanelContent(leftLegPanel.RectTransform);
            rightLegText = CreatePanelContent(rightLegPanel.RectTransform);
            leftArmText = CreatePanelContent(leftArmPanel.RectTransform);
            rightArmText = CreatePanelContent(rightArmPanel.RectTransform);

            leftArmText.Text = "暂未接入手臂诊断数据";
            rightArmText.Text = "暂未接入手臂诊断数据";

            GUIButton closeButton = new GUIButton(
                new RectTransform(
                    new Vector2(0.18f, 0.10f),
                    workbenchFrame.RectTransform,
                    Anchor.BottomCenter
                ),
                "关闭",
                textAlignment: Alignment.Center,
                style: "GUIButton"
            );
            closeButton.OnClicked = (button, obj) =>
            {
                ToggleWorkbench();
                return true;
            };

            workbenchCreated = true;
            workbenchOpen = false;
            workbenchFrame.Visible = false;
        }
        private void UpdateWorkbenchUI(double currentTime)
        {
            if (!workbenchOpen) return;
            if (workbenchFrame == null) return;
            double interval = Config == null ? 1.0 : Config.DebugUpdateInterval;

            if (Config != null)
            {
                interval = Config.DebugUpdateInterval;
                if (interval <= 0) interval = 1.0;
            }
            if (currentTime - lastWorkbenchUpdateTime < interval)
            {
                return;
            }
            lastWorkbenchUpdateTime = currentTime;
            Character character = Character.controlled;
            if (character == null)
            {
                summaryText.Text = "义体工作台 / 检测终端\nNo controlled character.";
                return;
            }
            ;
            CharacterHealth health = character.CharacterHealth;
            if (health == null)
            {
                summaryText.Text = "义体工作台 / 检测终端\nNo CharacterHealth.";
                return;
            }

            Limb leftLeg = TLCybHelper.FindLimb(character, LimbType.LeftLeg);
            Limb rightLeg = TLCybHelper.FindLimb(character, LimbType.RightLeg);
            if (leftLeg == null || rightLeg == null)
            {
                summaryText.Text = "义体工作台 / 检测终端\nCould not find both leg limbs.";
                return;
            }

            bool leftInstalled = TLCybHelper.HasLimbAffliction(health, "TLCyb_CivilianLeg_Init", leftLeg);
            bool rightInstalled = TLCybHelper.HasLimbAffliction(health, "TLCyb_CivilianLeg_Init", rightLeg);
            bool hasAnyCyberLeg = leftInstalled || rightInstalled;

            float leftServo = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_ServoDamage", leftLeg);
            float rightServo = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_ServoDamage", rightLeg);

            float leftCircuit = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_CircuitDamage", leftLeg);
            float rightCircuit = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_CircuitDamage", rightLeg);

            float leftSystem = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_SystemDamage", leftLeg);
            float rightSystem = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_SystemDamage", rightLeg);

            float leftStructural = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_StructuralDamage", leftLeg);
            float rightStructural = TLCybHelper.GetLimbAfflictionStrength(health, "TLCyb_StructuralDamage", rightLeg);

            summaryText.Text =
            "角色: " + character.Name + "\n" +
            "生命: " + character.Vitality.ToString("0.0") + "\n";
            leftLegText.Text =
            "左腿\n" +
            "已安装义体: " + (leftInstalled ? "是" : "否") + "\n" +
            "伺服损伤: " + leftServo.ToString("0.0") + "\n" +
            "电路损伤: " + leftCircuit.ToString("0.0") + "\n" +
            "系统损伤: " + leftSystem.ToString("0.0") + "\n" +
            "结构损伤: " + leftStructural.ToString("0.0");
            rightLegText.Text =
            "右腿\n" +
            "已安装义体: " + (rightInstalled ? "是" : "否") + "\n" +
            "伺服损伤: " + rightServo.ToString("0.0") + "\n" +
            "电路损伤: " + rightCircuit.ToString("0.0") + "\n" +
            "系统损伤: " + rightSystem.ToString("0.0") + "\n" +
            "结构损伤: " + rightStructural.ToString("0.0");
            leftArmText.Text = "暂未接入手臂诊断数据";
            rightArmText.Text = "暂未接入手臂诊断数据";
        }
        private GUIFrame CreateLimbPanel(
            RectTransform parent,
            Vector2 size,
            Anchor anchor,
            Point offset,
            string title)
        {
            GUIFrame panel = new GUIFrame(
                new RectTransform(size, parent, anchor)
                {
                    AbsoluteOffset = offset
                },
                style: "InnerFrame"
            );

            GUITextBlock titleText = new GUITextBlock(
                new RectTransform(
                    new Vector2(0.94f, 0.18f),
                    panel.RectTransform,
                    Anchor.TopCenter
                ),
                title,
                textAlignment: Alignment.Center,
                style: "GUITextBlock"
            );
            titleText.TextScale = 1.5f;

            return panel;
        }
        private GUITextBlock CreatePanelContent(RectTransform parent)
        {
            GUITextBlock textBlock = new GUITextBlock(
                new RectTransform(
                    new Vector2(0.92f, 0.72f),
                    parent,
                    Anchor.Center
                )
                {
                    AbsoluteOffset = new Point(0, 12)
                },
                "",
                textAlignment: Alignment.TopLeft,
                style: "GUITextBlock"
            );

            textBlock.TextScale = 1.0f;
            return textBlock;
        }
        private void DebugGiveWeaponAndMaxSkill()
        {
            Character character = Character.Controlled;
            if (character == null) return;
            if (character.Info == null) return;
            if (character.Inventory == null) return;

            TLCybHelper.SetSkillTo(character, "weapons", 100f);

            TLCybHelper.SpawnItemToInventory(character, "Gatlingun_TL");

            LuaCsLogger.Log("已加满武器技能，并发放一把武器。");
        }
    }
}
