using System;
using System.Collections.Generic;
using Barotrauma;

namespace TeraDeepOcean
{
    public partial class Plugin : IAssemblyPlugin
    {
        List<Hull> mainSubHulls = new List<Hull>();
        private readonly Dictionary<ushort, double> recoveryPending = new Dictionary<ushort, double>();
        double timer = 0;
        double accumulatedTimeShared = 0.0;
        double lastUpdateTimeShared = 0.0;
        private void InitializeRecoveryProtocol()
        {
            LuaCsSetup.Instance.Hook.Add("roundStart", "TL.roundStart.GetMainSubHulls", (object[] args) =>
            {
                mainSubHulls.Clear();
                foreach (Hull hull in Hull.HullList)
                {
                    if (hull == null) continue;
                    Submarine mainSub = Submarine.MainSub;
                    if (mainSub == null) return null;
                    if (hull.Submarine != mainSub) continue;

                    mainSubHulls.Add(hull);
                }
                return null;
            });
            LuaCsSetup.Instance.Hook.Add("think", "TeraDeepOcean.RecoveryProtocol", (object[] args) =>
            {
                double deltaTime = Convert.ToDouble(args[0]);
                accumulatedTimeShared += deltaTime;
                if (accumulatedTimeShared - lastUpdateTimeShared >= 2)
                {
                    timer = Convert.ToDouble(args[0]);

                    if (!ShouldRun()) return null;
                    if (args == null || args.Length == 0 || args[0] == null) return null;

                    UpdateLycorisChip_RecoveryChip(accumulatedTimeShared);
                }
                return null;
            });
        }
        private bool HasLycorisChip_RecoveryChip(Character character)
        {
            if (character == null) return false;
            if (character.CharacterHealth == null) return false;
            Limb limb = TLHelper.FindLimb(character, LimbType.Head);
            if (limb == null) return false;
            return TLHelper.HasAffliction(
                character,
                "TLCyb_LycorisChip_Recovery_Init"
            );
        }
        private void UpdateLycorisChip_RecoveryChip(double currentTime)
        {
            if (Character.CharacterList == null) return;
            foreach (Character character in Character.CharacterList)
            {
                if (!TLHelper.IsHumanAlive(character)) continue;
                if (!HasLycorisChip_RecoveryChip(character)) continue;
                
                ushort charId = character.ID;
                if (character.Submarine != null && Submarine.MainSub != null && character.Submarine == Submarine.MainSub)
                {
                    if (recoveryPending.ContainsKey(charId))
                    {
                        recoveryPending.Remove(charId);
                    }
                    continue;
                }
                float vitalityPercent = TLHelper.GetVitalityPercent(character);
                if (vitalityPercent <= 0.10f)
                {
                    if (!recoveryPending.ContainsKey(charId))
                    {
                        recoveryPending[charId] = currentTime;

                        character.Stun = System.Math.Max(character.Stun, 10f);
                        TLHelper.PlaySound("TLCyb_LycorisChip_Recovery_ues_Sound", character);
                        TLHelper.GiveItem("TLCyb_LycorisChip_Recovery_ues", character);
                    }
                    else
                    {
                        double startTime = recoveryPending[charId];
                        character.Stun = System.Math.Max(character.Stun, 1f);
                        if (currentTime - startTime >= 17.0)
                        {
                            TeleportCharacterToRandomHull(character);
                            recoveryPending.Remove(charId);
                        }
                    }
                }
                else
                {
                    if (recoveryPending.ContainsKey(charId))
                    {
                        recoveryPending.Remove(charId);
                    }
                }
            }
        }
        public void TeleportCharacterToRandomHull(Character character)
        {
            if (character == null) return;
            if (mainSubHulls.Count == 0) return;

            int index = Rand.Range(0, mainSubHulls.Count);
            Hull targetHull = mainSubHulls[index];
            if (targetHull == null) return;
            var rect = targetHull.Rect;
            character.TeleportTo(targetHull.WorldPosition);
        }
        //判断代码该在哪里运行，单人游戏客户端，多人游戏服务器
        private bool ShouldRun()
        {
            var session = GameMain.GameSession;
            if (session == null || session.GameMode == null)
            {
                return false;
            }
            if (session.GameMode.IsSinglePlayer)
            {
                return true;
            }

#if SERVER
                return true;
#else
                return false;
#endif
        }
    }
}