{ config, pkgs, ... }:

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
  nixpkgs.config =  {
    allowUnfreePredicate = _: true;
    # Obsidian uses old insecure version of electron https://github.com/NixOS/nixpkgs/issues/273611.
    permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
  };

  # Enables Gnome integration with Ubuntu
  # https://github.com/nix-community/home-manager/issues/1439#issuecomment-1605851533
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.alacritty
    pkgs.chromium
    pkgs.clipit
    pkgs.cmake
    pkgs.curl
    pkgs.docker
    pkgs.docker-compose
    pkgs.eza
    pkgs.flyctl
    pkgs.firefox
    pkgs.flameshot
    pkgs.git
    pkgs.go
    pkgs.insync
    pkgs.jdk21
    pkgs.jetbrains-toolbox
    pkgs.nodejs_20
    pkgs.obsidian
    pkgs.maven
    pkgs.neovim
    pkgs.spotify
    pkgs.tmux
    pkgs.vscode
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bash_aliases".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.bash_aliases";
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.vimrc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.tmux.conf";
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
    # Setting this to fix issue with man pages locale.
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
