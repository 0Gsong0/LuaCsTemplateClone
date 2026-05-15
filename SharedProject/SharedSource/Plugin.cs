using Barotrauma;
namespace TeraDeepOcean
{
    public partial class Plugin : IAssemblyPlugin
    {
        // These are automatically assigned by the plugin service after the Constructor is called
        public IConfigService ConfigService { get; set; }
        public IPluginManagementService PluginService { get; set; }
        public ILoggerService LoggerService { get; set; }
        public static string ModDir { get; private set; }
        public void PreInitPatching()
        {
            if (PluginService.TryGetPackageForPlugin<Plugin>(out var package))
            {
                ModDir = package.Dir;
            }
        }
        partial void InitProjSpecific();
        public void Initialize()
        {
            // When your plugin is loading, use this instead of the constructor for code relying on
            // the services above.

            // Put any code here that does not rely on other plugins.
            LoggerService.Log($"TeraDeepOcean  Plugin Initialized. Welcome to modding!");
            InitProjSpecific();
            InitializeRecoveryProtocol();
        }

        public void OnLoadCompleted()
        {
            // After all plugins have loaded
            // Put code that interacts with other plugins here.
        }

        public void Dispose()
        {
            // Cleanup your plugin!
        }
    }
}
