using Barotrauma;
namespace TeraDeepOcean
{
    public static class TLHelper
    {
        public static Limb FindLimb(Character character, LimbType limbType)
        {
            if (character == null || character.AnimController == null) return null;
            return character.AnimController.GetLimb(limbType);
        }

        public static float GetLimbAfflictionStrength(Character character, string afflictionIdentifier, LimbType limbType)
        {
            if (character == null || character.CharacterHealth == null) return 0f;

            Limb limb = FindLimb(character, limbType);
            if (limb == null) return 0f;

            Identifier id = new Identifier(afflictionIdentifier);
            Affliction aff = character.CharacterHealth.GetAffliction(id, limb);
            if (aff == null) return 0f;

            return aff.Strength;
        }

        public static bool HasLimbAffliction(Character character, string afflictionIdentifier, LimbType limbType, float minStrength = 0.1f)
        {
            return GetLimbAfflictionStrength(character, afflictionIdentifier, limbType) >= minStrength;
        }
        public static bool HasAffliction(Character character, string afflictionIdentifier, float minStrength = 0.1f)
        {
            if(character == null || character.CharacterHealth == null) return false;
            Affliction aff = character.CharacterHealth.GetAffliction(afflictionIdentifier);
            if (aff == null) return false;
            return aff.Strength >= minStrength;
        }
        public static float HasAfflictionStrength(Character character, string afflictionIdentifier)
        {
            if (character == null || character.CharacterHealth == null) return -2;
            Affliction aff = character.CharacterHealth.GetAffliction(afflictionIdentifier);
            if (aff == null) return -1;
            return aff.Strength;
        }
        public static bool IsHumanAlive(Character character)
        {
            return character != null
                && !character.Removed
                && !character.IsDead
                && character.IsHuman;
        }

        public static float GetVitalityPercent(Character character)
        {
            if (character == null) return 0f;
            if (character.MaxVitality <= 0f) return 0f;

            return character.Vitality / character.MaxVitality;
        }
        public static void PlaySound(string id, Character character)
        {
            GiveItem(id, character, true);
        }
        public static void GiveItem(string id,Character character,bool drop = false)
        {
            ItemPrefab item = ItemPrefab.Prefabs[new Identifier(id)];
            if (drop)
            {
                Entity.Spawner.AddItemToSpawnQueue(item, character.WorldPosition);
            }
            else
            {
                Entity.Spawner.AddItemToSpawnQueue(item, character.Inventory);
            }
        }
        public static void TeleportCharacterToMainSub(Character character)
        {
            if (character == null) return;
            if (Submarine.MainSub == null) return;

            Submarine mainSub = Submarine.MainSub;
            if (mainSub == null) return;
            if (character.Submarine == Submarine.MainSub)
            {
                return;
            }

            character.TeleportTo(Submarine.MainSub.WorldPosition);
        }
        public static bool IsSinglePlayer()
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
            return false;
        }
    }
}
