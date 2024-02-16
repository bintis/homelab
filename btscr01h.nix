# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Network settings
  networking = {
    hostName = "btscr01h";
    networkmanager.enable = true;
    useDHCP = false; # Disable DHCP
    interfaces.enX0 = {
      useDHCP = false; # Ensure DHCP is disabled for enX0
      ipv4.addresses = [ {
        address = "10.1.1.10"; # Your desired IP address
        prefixLength = 24; # Netmask as a prefix length, for a 255.255.255.0 netmask use 24
      } ];
    };
    defaultGateway = "10.1.1.1"; # Your gateway IP
    nameservers = [ "8.8.8.8" "8.8.4.4" ]; # Google DNS, replace with your DNS if needed
  };



  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "jp";
    xkbVariant = "OADG109A";
  };

  # Configure console keymap
  console.keyMap = "jp106";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bintis = {
    isNormalUser = true;
    description = "bintis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     nfs-utils
     kubernetes-helm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
    services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
    networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  services.k3s = {
        enable = true;
        role = "server";
        extraFlags = "--disable=servicelb --disable=traefik --bind-address 10.1.1.10 --tls-san 10.1.1.10 --node-ip=10.1.1.10 --node-external-ip=10.1.1.10 --write-kubeconfig-mode 644";
    };


}
