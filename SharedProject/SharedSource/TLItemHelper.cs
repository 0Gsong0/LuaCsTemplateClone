namespace TeraDeepOcean
{
    public static class TLItemHelper
    {
        private sealed class MoveTask
        {
            public Item Item;
            public Vector2 StartPosition;
            public Vector2 EndPosition;
            public Vector2 TargetPosition;
            public bool IsMoved;
            public bool IsMoving;
            public float Speed;
        }
        private static readonly Dictionary<ushort, MoveTask> Tasks = new Dictionary<ushort, MoveTask>();
        private static Vector2 GetMoveOffset(float moveDistance, int moveDirection)
        {
            return moveDirection == 1
                ? new Vector2(moveDistance, 0f)
                : new Vector2(0f, -moveDistance);
        }
        public static void ToggleItems(IEnumerable<Item> items, float moveDistance, float speed, int moveDirection = 0)
        {
            var itemList = items
                .Where(i => i != null && !i.Removed)
                .ToList();

            if (itemList.Count == 0) { return; }

            bool anyMoving = false;

            foreach (Item targetItem in itemList)
            {
                ushort id = targetItem.ID;

                if (!Tasks.TryGetValue(id, out MoveTask task))
                {
                    Vector2 start = targetItem.Position;
                    Vector2 end = start + GetMoveOffset(moveDistance, moveDirection);

                    task = new MoveTask
                    {
                        Item = targetItem,
                        StartPosition = start,
                        EndPosition = end,
                        TargetPosition = end,
                        IsMoved = false,
                        IsMoving = false,
                        Speed = speed
                    };

                    Tasks[id] = task;
                }
                else if (task.Item == null || task.Item.Removed)
                {
                    Vector2 start = targetItem.Position;
                    Vector2 end = start + GetMoveOffset(moveDistance, moveDirection);

                    task.Item = targetItem;
                    task.StartPosition = start;
                    task.EndPosition = end;
                    task.TargetPosition = end;
                    task.IsMoved = false;
                    task.IsMoving = false;
                    task.Speed = speed;
                }

                if (task.IsMoving)
                {
                    anyMoving = true;
                }
            }

            if (anyMoving) { return; }

            foreach (Item targetItem in itemList)
            {
                if (!Tasks.TryGetValue(targetItem.ID, out MoveTask task)) { continue; }

                task.TargetPosition = task.IsMoved ? task.StartPosition : task.EndPosition;
                task.IsMoving = true;
                task.Speed = speed;
            }
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

                if (task == null || task.Item == null || task.Item.Removed)
                {
                    invalidIds ??= new List<ushort>();
                    invalidIds.Add(pair.Key);
                    continue;
                }

                if (!task.IsMoving) { continue; }

                Vector2 delta = task.TargetPosition - task.Item.Position;
                float step = task.Speed;

                if (delta.Length() <= step)
                {
                    task.Item.Move(delta);
                    task.IsMoving = false;
                    task.IsMoved = !task.IsMoved;
                    continue;
                }

                delta.Normalize();
                task.Item.Move(delta * step);
            }

            if (invalidIds == null) { return; }

            foreach (ushort id in invalidIds)
            {
                Tasks.Remove(id);
            }
        }
    }
}