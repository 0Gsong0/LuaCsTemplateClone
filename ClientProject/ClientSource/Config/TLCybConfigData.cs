using MoonSharp.Interpreter;

namespace TeraDeepOcean
{
    public static class TLCybConfigData
    {
        private static Table GetBridge()
        {
            return LuaCsSetup.Instance.Lua.Globals.Get("TLConfigBridge").Table;
        }
        public static float GetFloat(string key, float defaultValue)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("GetFloat");
            DynValue result = LuaCsSetup.Instance.Lua.Call(fn, key, defaultValue);
            return (float)result.Number;
        }

        public static void SetFloat(string key, float value)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("SetFloat");
            LuaCsSetup.Instance.Lua.Call(fn, key, value);
        }

        public static bool GetBool(string key, bool defaultValue)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("GetBool");
            DynValue result = LuaCsSetup.Instance.Lua.Call(fn, key, defaultValue);
            return result.Boolean;
        }

        public static void SetBool(string key, bool value)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("SetBool");
            LuaCsSetup.Instance.Lua.Call(fn, key, value);
        }
        public static string GetDescription(string key)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("GetDescription");
            DynValue result = LuaCsSetup.Instance.Lua.Call(fn, key);
            return result.CastToString() ?? "";
        }

        public static string GetName(string key)
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("GetName");
            DynValue result = LuaCsSetup.Instance.Lua.Call(fn, key);
            return result.CastToString() ?? key;
        }
        public static void Save()
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("Save");
            LuaCsSetup.Instance.Lua.Call(fn);
        }

        public static void Reset()
        {
            Table bridge = GetBridge();
            DynValue fn = bridge.Get("Reset");
            LuaCsSetup.Instance.Lua.Call(fn);
        }
    }
}