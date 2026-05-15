using Barotrauma;
namespace TeraDeepOcean
{
    public static class TLCybHelper
    {
        private static readonly string[] CyberItemIdentifiers =
        {
            "TLCyb_CivilianLeg",
            "TLCyb_CivilianArm",
        };
        public static Limb FindLimb(Character character, LimbType targetType)
        {
            if (character == null || character.AnimController == null) return null;

            foreach (Limb limb in character.AnimController.Limbs)
            {
                if (limb != null && limb.type == targetType)
                {
                    return limb;
                }
            }

            return null;
        }
        public static bool HasLimbAffliction(CharacterHealth health, string afflictionIdentifier, Limb limb)
        {
            if (health == null || limb == null) return false;

            Identifier id = new Identifier(afflictionIdentifier);
            Affliction aff = health.GetAffliction(id, limb);
            return aff != null && aff.Strength > 0f;
        }
        public static float GetLimbAfflictionStrength(CharacterHealth health, string afflictionIdentifier, Limb limb)
        {
            if (health == null || limb == null) return 0f;

            Identifier id = new Identifier(afflictionIdentifier);
            Affliction aff = health.GetAffliction(id, limb);
            if (aff == null) return 0f;

            return aff.Strength;
        }
        public static bool HasAnyCyberLeg(CharacterHealth health, Limb leftLeg, Limb rightLeg)
        {
            bool leftInstalled = HasLimbAffliction(health, "TLCyb_CivilianLeg_Init", leftLeg);
            bool rightInstalled = HasLimbAffliction(health, "TLCyb_CivilianLeg_Init", rightLeg);
            return leftInstalled || rightInstalled;
        }
        public static void SpawnCyberItemsToControlledCharacter(Character character)
        {
            if(character == null)return;
            if (character.Inventory == null) return;

            foreach (string identifier in CyberItemIdentifiers)
            {
                ItemPrefab prefab = ItemPrefab.Prefabs[new Identifier(identifier)];
                if (prefab == null) continue;

                Item item = new Item(prefab, character.WorldPosition, null);

                if (!character.TryPutItemInAnySlot(item))
                {
                    LuaCsLogger.Log(item.ToString()+" "+ character.Name);
                    item.Drop(character);
                }
            }

            LuaCsLogger.Log("已向当前玩家发放赛博物品。");
        }
        public static void ClearAllAfflictionsFromControlledCharacter()
        {
            Character character = Character.Controlled;
            if (character == null) return;
            if (character.CharacterHealth == null) return;

            var health = character.CharacterHealth;

            foreach (Limb limb in character.AnimController.Limbs)
            {
                var afflictions = health.GetAllAfflictions();
                if (afflictions == null) continue;

                foreach (Affliction aff in afflictions)
                {
                    if (aff == null) continue;
                    aff.Strength = 0f;
                }
            }

            var globalAfflictions = health.GetAllAfflictions();
            if (globalAfflictions != null)
            {
                foreach (Affliction aff in globalAfflictions)
                {
                    if (aff == null) continue;
                    aff.Strength = 0f;
                }
            }

            LuaCsLogger.Log("已清除当前玩家 affliction。");
        }
        public static void SetSkillTo(Character character, string skillIdentifier, float value)
        {
            if (character == null || character.Info == null) return;
            Identifier id = new Identifier(skillIdentifier);
            character.Info.SetSkillLevel(id, value);
        }
        public static void SpawnItemToInventory(Character character, string itemIdentifier)
        {
            if (character == null || character.Inventory == null) return;

            ItemPrefab prefab = ItemPrefab.Prefabs[new Identifier(itemIdentifier)];
            if (prefab == null) return;
            Item item = new Item(prefab, character.WorldPosition, null);
            if (!character.TryPutItemInAnySlot(item))
            {
                item.Drop(character);
            }
        }
    }
}
