using Barotrauma;
namespace TeraDeepOcean
{
    public static class TLLib_Client
    {
        public static void CreatBottomMessageBox(RichString title, RichString content,string iconstyle)
        {
            GUIMessageBox messageBox = new GUIMessageBox(
                title,
                content, 
                null, null, null,Alignment.TopLeft, GUIMessageBox.Type.InGame,null,null, iconstyle, null,null,false);
        }
        public static RichString ReadXmlRichText(string tag)
        {
            return RichString.Rich(TextManager.Get(tag));
        }
        public static void OpenTLCybConfigMenu(GUIFrame frame, GUIListBox list, GUILayoutGroup buttonRow)
        {
            TLCybConfigMenu.Open(frame, list, buttonRow);
        }


        public static void CloseTLCybConfigMenu()
        {
            TLCybConfigMenu.Close();
        }
    }
}