{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # macbook camera
  hardware.facetimehd.enable = true;

  # macbook wifi drivers 
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "wl" "kvm-intel" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  nixpkgs.config.permittedInsecurePackages = ["broadcom-sta-6.30.223.271-59-6.12.77"];
  boot.blacklistedKernelModules = [ "b43" "bcma" ];
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=1
  '';
  networking.networkmanager.enable = true;

  networking.hostName = "theseus";

  time.timeZone = "Europe/London";

  services.xserver = {
    enable = true;
  };

  services.xserver.desktopManager.wallpaper.mode = "fill";

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.games.enable = false;
  services.libinput.touchpad.tapping = false;

  users.users.thomas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      bitwarden-desktop
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    tree
    emacs
    htop
    helix
    tmux

    alacritty
    sioyek
    libreoffice-still
    hunspell
    hunspellDicts.en-us
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

