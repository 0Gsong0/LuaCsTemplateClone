using MonoMod.Core.Utils;
using OneOf.Types;
using static Barotrauma.CrossThread;
using static Barotrauma.OutpostModuleInfo;

namespace TeraDeepOcean
{
    public static class TLWallHelper
    {
        private sealed class MoveTask
        {
            public Structure Wall;
            public Vector2 BottomPosition;
            public Vector2 TopPosition;
            public Vector2 TargetPosition;
            public bool IsUp;
            public bool IsMoving;
            public float Speed;
        }
        private static readonly Dictionary<ushort, MoveTask> Tasks = new Dictionary<ushort, MoveTask>();
        public static void ToggleWalls(IEnumerable<Structure> walls, float moveDistance, float speed)
        {
            bool anyMoving = false;

            foreach (Structure wall in walls)
            {
                ushort id = wall.ID;

                if (!Tasks.TryGetValue(id, out MoveTask task))
                {
                    Vector2 bottom = wall.Position;
                    Vector2 top = bottom + new Vector2(0f, -moveDistance);

                    task = new MoveTask
                    {
                        Wall = wall,
                        BottomPosition = bottom,
                        TopPosition = top,
                        TargetPosition = top,
                        IsUp = false,
                        IsMoving = false,
                        Speed = speed
                    };

                    Tasks[id] = task;
                }
                else
                {
                    if (task.Wall == null || task.Wall.Removed)
                    {
                        Vector2 bottom = wall.Position;
                        Vector2 top = bottom + new Vector2(0f, -moveDistance);

                        task.Wall = wall;
                        task.BottomPosition = bottom;
                        task.TopPosition = top;
                        task.TargetPosition = top;
                        task.IsUp = false;
                        task.IsMoving = false;
                    }
                }

                if (task.IsMoving)
                {
                    anyMoving = true;
                }
            }

            if (anyMoving) { return; }

            foreach (Structure wall in walls)
            {
                if (!Tasks.TryGetValue(wall.ID, out MoveTask task)) { continue; }

                task.TargetPosition = task.IsUp ? task.BottomPosition : task.TopPosition;
                task.IsMoving = true;
                task.Speed = speed;
            }
        }
        public static void ToggleWallByTag(string tag, float moveDistance, float speed = 2f)
        {

            var walls = Structure.WallList
                .Where(s => s != null && s.Tags != null && s.Tags.Contains(tag) && !s.Removed)
                .ToList();

            ToggleWalls(walls, moveDistance, speed);
        }
        public static void Reset()
        {
            Tasks.Clear();
        }
        public static void Update(float deltaTime)
        {
            if (Tasks.Count == 0) { return; }

            List<ushort> invalidIds = null;

            foreach (var pair in Tasks)
            {
                MoveTask task = pair.Value;

                if (task == null || task.Wall == null || task.Wall.Removed)
                {
                    invalidIds ??= new List<ushort>();
                    invalidIds.Add(pair.Key);
                    continue;
                }

                if (!task.IsMoving) { continue; }

                Vector2 current = task.Wall.Position;
                Vector2 delta = task.TargetPosition - current;
                float step = task.Speed;

                if (delta.Length() <= step)
                {
                    task.Wall.Move(delta, false);
                    task.IsMoving = false;
                    task.IsUp = !task.IsUp;
                    continue;
                }

                delta.Normalize();
                task.Wall.Move(delta * step, false);
            }

            if (invalidIds != null)
            {
                foreach (ushort id in invalidIds)
                {
                    Tasks.Remove(id);
                }
            }
        }
    }
}