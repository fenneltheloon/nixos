{ config, lib, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fennel";
  home.homeDirectory = "/home/fennel";

  home.shellAliases = {
    g = "lazygit";
    cd = "z";
    rebuild = "sudo nixos-rebuild switch --upgrade --flake ~/nixos#default";
  };
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Sway support
    sway-contrib.grimshot
    wl-clipboard
    mako
    autotiling
    pamixer
    pavucontrol

    # Dev stuff
    gcc
    fastfetch
    ghidra-bin
    racket-minimal

    # Internet things
    firefox
    discord
    betterdiscordctl
    spotify
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [
        { statusCommand = "while date +'%Y-%m-%d %H:%M'; do sleep 60; done"; }
      ];
      keybindings = let
	mod = config.wayland.windowManager.sway.config.modifier;
        menu = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      in lib.mkOptionDefault {
	"${mod}+x" = "kill";
	"${mod}+space" = menu;
	"${mod}+p" = "exec grimshot savecopy active";
	"${mod}+shift+p" = "exec grimshot savecopy area";
	"${mod}+Mod1+p" = "exec grimshot savecopy output";
	"${mod}+ctrl+p" = "exec grimshot savecopy window";
	"XF86AudioRaiseVolume" = "exec pamixer -i 5";
	"XF86AudioLowerVolume" = "exec pamixer -d 5";
	"XF86AudioMute" = "exec pamixer -t";
      };
      modifier = "Mod4";
      startup = [
        { command = "autotiling"; always = true; }
      ];
      terminal = "alacritty";
      window = {
        border = 1;
	hideEdgeBorders = "smart";
	titlebar = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = { family = "NotoSansM Nerd Font Propo"; };
	size = 10.0;
      };
    };
  };
  
  programs.bash = {
    enable = true;
    initExtra = ''
      ${builtins.readFile ./.bashrc}
    '';
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      character = {
        success_symbol = ''[\([ᴖ](bold red) ᵥ [ᴖ](bold red)\)](bold bg:black)'';
	error_symbol = ''[\([ᴗ](bold red) ᵥ [ᴗ](bold red)\)](bold bg:black)'';
      };
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.git = {
    enable = true;
    userName = "Fennel";
    userEmail = "fennel@everwild.dev";
    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
  
  programs.lazygit = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/init.lua}
    '';
  };

#  programs.hyfetch = {
#    enable = true;
#    settings = {
#      preset = "nonbinary";
#      mode = "rgb";
#      light_dark = "dark";
#      lightness = 0.5;
#      color_align = {
#        mode = "horizontal";
#      };
#    };
#  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fennel/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
