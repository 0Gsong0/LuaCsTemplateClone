using Barotrauma.Items.Components;
using Barotrauma;
using Microsoft.Xna.Framework;
namespace TeraDeepOcean
{
    class TLWallMoverComponent : ItemComponent
    {
        [Serialize(64.0f, IsPropertySaveable.Yes, description: "移动距离，单位像素")]
        [Editable(MinValueFloat = -4096f, MaxValueFloat = 4096f, DecimalCount = 1)]
        public float MoveDistance { get; set; } = 64f;

        [Serialize(2.0f, IsPropertySaveable.Yes, description: "移动速度")]
        [Editable(MinValueFloat = 0.1f, MaxValueFloat = 128f, DecimalCount = 1)]
        public float Speed { get; set; } = 2f;
        public TLWallMoverComponent(Item item, ContentXElement element) : base(item, element)
        {
        }
        private List<Structure> GetLinkedWalls()
        {
            List<Structure> walls = new List<Structure>();

            foreach (MapEntity linked in item.linkedTo)
            {
                if (linked is Structure structure && !structure.Removed)
                {
                    walls.Add(structure);
                }
            }

            return walls;
        }
        public override void ReceiveSignal(Signal signal, Connection connection)
        {
            base.ReceiveSignal(signal, connection);

            if (connection == null) { return; }
            if (connection.Name != "trigger_in") { return; }

            if (connection.Name == "trigger_in")
            {
                List<Structure> walls = GetLinkedWalls();
                TLWallHelper.ToggleWalls(walls, MoveDistance, Speed);
            }
        }
    }
}