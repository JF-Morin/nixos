{ config, pkgs, sysConfig, ... }:
{
    ############################################
    # GPU Driver and OpenGL
    ############################################
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.legacy_580 ];
    boot.kernelParams = [
        "nvidia-drm.fbdev=1"
    ];
    boot.extraModprobeConfig = ''
        options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerLevel=0x1;PowerMizerDefaultAC=0x1"
    '';


    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;

        powerManagement.finegrained = false;

        open = false;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    };

    environment.sessionVariables = {
        # Aquamarine/Hyprland: Specifies the exact GPU device to use for Direct Rendering Manager (DRM).
        # Useful in multi-GPU/laptop setups to force the dedicated NVIDIA card over integrated graphics.
        AQ_DRM_DEVICES = "/dev/dri/card1";

        # Forces the Generic Buffer Management (GBM) API to use the NVIDIA DRM driver.
        # Essential for rendering Wayland compositors smoothly on modern NVIDIA drivers.
        GBM_BACKEND = "nvidia-drm";

        # Forces Video Acceleration API (VA-API) to use NVIDIA hardware acceleration for video decoding.
        LIBVA_DRIVER_NAME = "nvidia";

        # Tells GLX (OpenGL Extension to the X Window System) to use NVIDIA's hardware vendor library.
        # Prevents applications from falling back to software rendering or integrated graphics.
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # Disable G-Sync/VRR at the driver level to prevent black screen flashes on Wayland.
        # VRR is also disabled in hyprland.conf (vrr = 0).
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";

    };

    # The SDDM display-manager service runs BEFORE any user session, so
    # sessionVariables above are not available to Weston (SDDM's Wayland
    # compositor) or the QML greeter. These duplicated NVIDIA vars ensure
    # the NVIDIA DRM/GBM stack is properly initialised at the login screen,
    # which fixes QML theme rendering and cursor plane support.
    systemd.services.display-manager.environment = {
        GBM_BACKEND               = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME         = "nvidia";
    };
}
