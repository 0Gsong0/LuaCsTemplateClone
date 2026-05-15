using Barotrauma;
using Barotrauma.LuaCs.Data;
namespace TeraDeepOcean
{
    public class TLConfig
    {
        private readonly IConfigService configService;
        private readonly IPluginManagementService pluginService;
        private readonly ILoggerService loggerService;
        private ContentPackage myPackage;

        public ISettingBase<bool> EnableDebugPanelSetting { get; private set; }
        public ISettingBase<float> DebugUpdateIntervalSetting { get; private set; }

        public TLConfig(
            IConfigService configService,
            IPluginManagementService pluginService,
            ILoggerService loggerService)
        {
            this.configService = configService;
            this.pluginService = pluginService;
            this.loggerService = loggerService;
        }

        public void LoadConfig()
        {
            if (pluginService == null)
            {
                loggerService?.Log("TLConfig: PluginService is null.");
                return;
            }

            if (configService == null)
            {
                loggerService?.Log("TLConfig: ConfigService is null.");
                return;
            }
            //获取此模组包
            if (!pluginService.TryGetPackageForPlugin<Plugin>(out myPackage))
            {
                loggerService?.Log("TLConfig: Could not get ContentPackage for Plugin.");
                return;
            }

            configService.TryGetConfig<ISettingBase<bool>>(
                myPackage,
                "EnableDebugPanel",
                out ISettingBase<bool> enableDebugPanelSetting
            );

            configService.TryGetConfig<ISettingBase<float>>(
                myPackage,
                "DebugUpdateInterval",
                out ISettingBase<float> debugUpdateIntervalSetting
            );

            EnableDebugPanelSetting = enableDebugPanelSetting;
            DebugUpdateIntervalSetting = debugUpdateIntervalSetting;

        }
        public bool EnableDebugPanel
        {
            get
            {
                if (EnableDebugPanelSetting == null) return true;
                return EnableDebugPanelSetting.Value;
            }
        }
        public float DebugUpdateInterval
        {
            get
            {
                if (DebugUpdateIntervalSetting == null) return 1.0f;

                float value = DebugUpdateIntervalSetting.Value;
                if (value <= 0f) return 1.0f;

                return value;
            }
        }
        public void SaveEnableDebugPanel(bool value)
        {
            if (EnableDebugPanelSetting == null) return;
            // 写入值
            if (EnableDebugPanelSetting.TrySetValue(value))
            {
                // 保存文件
                configService.SaveConfigValue(EnableDebugPanelSetting);
            }
        }
        public void SaveDebugUpdateInterval(float value)
        {
            if (DebugUpdateIntervalSetting == null) return;

            if (value <= 0f)
            {
                value = 1.0f;
            }

            if (DebugUpdateIntervalSetting.TrySetValue(value))
            {
                configService.SaveConfigValue(DebugUpdateIntervalSetting);
            }
        }
    }
}
