{ config, pkgs, ... }: {

    # 1. Hardware Video Acceleration (Intel VA-API)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            intel-media-driver # For Broadwell (5th gen) and newer CPUs
            intel-vaapi-driver # For older Intel CPUs (can be kept as fallback)
            vpl-gpu-rt         # Necessary for Quick Sync video on newer Intel chips
        ];
    };

    # 2. Optimized Environment Variables for Intel + Wayland
    environment.sessionVariables = {
        # Forces Video Acceleration API (VA-API) to use the Intel Media Driver
        LIBVA_DRIVER_NAME = "iHD";

        # Tells hardware acceleration frameworks to prefer Intel integrated graphics
        VDPAU_DRIVER = "va_gl";
    };

    # 3. Laptop Power Management (Crucial for battery life!)
    services.tlp = {
        enable = true;
        settings = {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

            # Optional: Helps prevent battery degradation if plugged in often
            # START_CHARGE_THRESH_BAT0 = 75;
            # STOP_CHARGE_THRESH_BAT0 = 80;
        };
    };

    # Disable conflicting power management daemons if using TLP
    services.power-profiles-daemon.enable = false;
}
