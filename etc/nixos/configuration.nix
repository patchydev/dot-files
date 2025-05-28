{ config, pkgs, ... }:
let
  nixvimFlake = builtins.getFlake "github:patchydev/nixvim?ref=main";
in
let
  aurpkgs = import (pkgs.fetchFromGitHub {
    owner = "aurakle";
    repo = "nurpkgs";
    rev = "99b25246a4aac105060c2e29b2d798a927c0841a";
    hash = "sha256-5dCnMkp3G4Uol2IKWvlB8vc2YAA09siSRzBAWW+Xkfk=";
  }) { inherit pkgs; };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    #variant = "qwerty";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "patchy" ];

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "patchy" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.patchy = {
    isNormalUser = true;
    description = "Isa";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      wl-clipboard
      spotify
      fastfetch
      prismlauncher
      fzf
      proton-pass
      protonvpn-gui
      protonvpn-cli
      tmux
      libisoburn
      grub2
      qemu
      btop
      libllvm
      gcc
      raylib
      protonmail-desktop
      zig
      appimage-run
      github-desktop
      gay
      blahaj
      chromium
      vscodium
      badlion-client
      lunarvim
      lazygit
      krita
      openvpn
      zed-editor
      obsidian
      libreoffice-qt6-fresh
      gnome-disk-utility
      nomacs
      lunar-client
      vesktop
      jetbrains.rust-rover
      aurpkgs.element-desktop
      gimp
      hyfetch
      mpv
    ];
  };

  services.ollama = {
    enable = true;
  };

  services.teamviewer.enable = true;

  environment.variables = {
    XCURSOR_THEME = "capitaine-cursors";
    XCURSOR_SIZE = "24";
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "copyfile"
        "copybuffer"
      ];
      theme = "eastwood";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    light
    swaybg
    swayidle
    swayimg
    swaylock
    grim
    slurp
    waybar
    wofi
    pavucontrol
    pamixer
    dunst
    banana-cursor
    nixvimFlake.packages.${pkgs.system}.default
    bluez
    capitaine-cursors
    git
    sway-contrib.grimshot
    bluez-tools
    unzip
    font-awesome
  ];

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    font-awesome
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "patchy"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
