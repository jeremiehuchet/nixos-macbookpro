# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPatches = [
    { name = "poweroff-fix"; patch = ./patches/kernel/poweroff-fix.patch; }
    { name = "hid-apple-keyboard"; patch = ./patches/kernel/hid-apple-keyboard.patch; }
  ];
  boot.initrd.luks.devices = [ {
    name = "pv-enc";
    device = "/dev/sda2";
    preLVM = true;
    allowDiscards = true;
  } ];
  boot.initrd.kernelModules = [
    "dm_snapshot"
  ];
  boot.cleanTmpDir = true;
  boot.kernelParams = [
    "hid_apple.fnmode=2"
    "hid_apple.swap_fn_leftctrl=1"
  ];
  boot.extraModprobeConfig = ''
    options snd_hda_intel index=0 model=intel-mac-auto id=PCM
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd_hda_intel model=mbp101
  '';

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  fileSystems."/home".options = [ "noatime" "nodiratime" "discard" ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  fonts.enableFontDir = true;
  fonts.enableDefaultFonts = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts
    dejavu_fonts
    font-awesome-ttf
    inconsolata
    liberation_ttf
    terminus_font
    ubuntu_font_family
    unifont
  ];

  nix.useSandbox = true;
  nix.binaryCaches = [
    http://cache.nixos.org
  ];

  networking.hostName = "nixbook";
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = false;
  hardware.facetimehd.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  environment.variables = {
    #MY_ENV_VAR = "\${HOME}/bla";
  };

  environment.systemPackages = with pkgs; [
    acpi
    bash
    curl
    customGit
    htop
    idea.idea-ultimate
    lm_sensors
    oh-my-zsh
    terminator
    vim
    vscode
    wget
    zip unzip
    # i3
    i3status
    dmenu
    networkmanagerapplet
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      customGit = pkgs.git.override {
        guiSupport = true;
        svnSupport = true;
      };
    };
  };

  powerManagement.enable = true;

  programs.vim.defaultEditor = true;

  programs.light.enable = true;

  services.mbpfan = {
    enable = true;
    lowTemp = 61;
    highTemp = 64;
    maxTemp = 84;
  };

  services.openssh.enable = true;

  services.locate.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xserver.enable = true;
  services.xserver.enableTCP = false;
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e, terminate:ctrl_alt_bksp, ctrl:nocaps";
  services.xserver.dpi = 150;

  services.xserver.multitouch.enable = true;

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.dev = "/dev/input/event7";
  services.xserver.synaptics.tapButtons = false;
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.synaptics.palmDetect = false;
  services.xserver.synaptics.accelFactor = "0.001";
  services.xserver.synaptics.additionalOptions = ''
    Option "SHMConfig" "on"
    Option "VertScrollDelta" "-100"
    Option "HorizScrollDelta" "-100"
    Option "Resolution" "370"
  '';
  services.xserver.windowManager.i3.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.jeremie = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "messagebus"
      "systemd-journal"
      "disk"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/jeremie";
  };

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableSyntaxHighlighting = true;    
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize your oh-my-zsh options here
    ZSH_THEME="agnoster"
    plugins=(git)

    source $ZSH/oh-my-zsh.sh
  '';

  system.stateVersion = "17.03";

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
}
