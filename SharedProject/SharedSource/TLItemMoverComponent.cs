using Barotrauma.Items.Components;

namespace TeraDeepOcean
{
    class TLItemMoverComponent : ItemComponent
    {
        [Serialize(0, IsPropertySaveable.Yes, description: "移动方向：0=垂直，1=水平")]
        [Editable(MinValueInt = 0, MaxValueInt = 1)]
        public int MoveDirection { get; set; } = 0;

        [Serialize(64.0f, IsPropertySaveable.Yes, description: "移动距离，单位像素")]
        [Editable(MinValueFloat = -4096f, MaxValueFloat = 4096f, DecimalCount = 1)]
        public float MoveDistance { get; set; } = 64f;

        [Serialize(2.0f, IsPropertySaveable.Yes, description: "移动速度")]
        [Editable(MinValueFloat = 0.1f, MaxValueFloat = 128f, DecimalCount = 1)]
        public float Speed { get; set; } = 2f;

        public TLItemMoverComponent(Item item, ContentXElement element) : base(item, element)
        {
        }
        private List<Item> GetLinkedItems()
        {
            List<Item> items = new List<Item>();

            foreach (MapEntity linked in item.linkedTo)
            {
                if (linked is Item linkedItem && linkedItem != item && !linkedItem.Removed)
                {
                    items.Add(linkedItem);
                }
            }

            return items;
        }
        public override void ReceiveSignal(Signal signal, Connection connection)
        {
            base.ReceiveSignal(signal, connection);

            if (connection == null) { return; }
            if (connection.Name != "trigger_in") { return; }

            List<Item> items = GetLinkedItems();
            TLItemHelper.ToggleItems(items, MoveDistance, Speed, MoveDirection);
        }
    }
}