{ config, pkgs, lib, inputs, nixgl, ... }:

let
  nixGLwrap = pkg: config.lib.nixGL.wrap pkg;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "anthony";
  home.homeDirectory = "/home/anthony";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow unfree software https://nixos.wiki/wiki/Unfree_Software
  nixpkgs.config = {
    allowUnfreePredicate = _: true;
    allowUnfree = true;
  };

  # Enables Gnome integration with Ubuntu
  # https://github.com/nix-community/home-manager/issues/1439#issuecomment-1605851533
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "nvidia";
  nixGL.installScripts = [ "nvidia" ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Programming Languages & Build Tools
    pkgs.cargo
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.clj-kondo
    pkgs.cmake
    pkgs.deno
    pkgs.libclang
    pkgs.gcc
    pkgs.go
    pkgs.sqlite
    pkgs.maven
    pkgs.nodejs_20
    pkgs.uv
    pkgs.yarn

    # CLI
    (nixGLwrap pkgs.ghostty)
    pkgs.curl
    pkgs.eza
    pkgs.fd
    pkgs.flyctl
    pkgs.git
    pkgs.openssh
    pkgs.xclip
    pkgs.zellij

    # AI
    pkgs.code-cursor
    pkgs.claude-code
    pkgs.cursor-cli
    pkgs.llm

    # WM
    pkgs.i3
    pkgs.j4-dmenu-desktop

    # Editors
    pkgs.jetbrains-toolbox
    pkgs.neovim
    pkgs.vscode

    # Other
    pkgs._1password-cli
    pkgs._1password-gui
    (nixGLwrap pkgs.anki)
    pkgs.bubblewrap
    pkgs.chromium
    pkgs.copyq
    pkgs.discord
    pkgs.emote
    pkgs.firefox
    pkgs.flameshot
    pkgs.obsidian
    (nixGLwrap pkgs.obs-studio)
    pkgs.spotify
    pkgs.vlc

    # Archive
    # (nixGLwrap pkgs.insync) # Have problems with nix insync. Install via https://www.insynchq.com/downloads/linux
    # pkgs.docker # A lot of manual config to get this running as a service.
    # pkgs.docker-compose # Same as above.
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bash_aliases".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.bash_aliases";
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vimrc";
    ".npmrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.npmrc";
    ".config/nvim/init.vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nvim/init.vim";
    ".config/alacritty.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/alacritty.yml";
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

  programs = {
    bash = {
      enable = true;
      # Enabling generic linux target above seems to set an invalid NIX_PATH.
      # Unsetting seems to fix the problem \_(._.)_/
      initExtra = "
        export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH
        . ~/.bash_aliases
        unset NIX_PATH
      ";
    };
    java = {
      enable = true;
      package = pkgs.jdk25;
    };
    fzf = {
      enable = true;
    };
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/anthony/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "ghostty";
    # Setting this to fix issue with man pages locale.
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
