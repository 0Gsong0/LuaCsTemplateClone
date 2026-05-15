namespace TeraDeepOcean
{
    public static class TLLib_Shared
    {
        public static RichString ReadXmlRichText(string tag)
        {
            return RichString.Rich(TextManager.Get(tag));
        }
    }
}
