{ config, pkgs, ... }:

let
  # All this to get alacritty to work :(
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-pkg-wrapper" { } ''
    # Create a new package that wraps the binaries with nixGL
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*
    do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "#!/bin/sh" > $wrapped_bin
      echo "exec nixGL $bin \"\$@\"" >> $wrapped_bin
      chmod +x $wrapped_bin
    done

    # If .desktop files refer to the old derivation, replace the references
    if [ -d "${pkg}/share/applications" ] && grep "${pkg}" ${pkg}/share/applications/*.desktop > /dev/null
    then
        rm $out/share
        mkdir -p $out/share
        cd $out/share
        ln -s ${pkg}/share/* ./
        rm applications
        mkdir applications
        cd applications
        cp -a ${pkg}/share/applications/* ./
        for dsk in *.desktop
        do
            sed -i "s|${pkg}|$out|g" "$dsk"
        done
    fi
  '';
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
  };

  # Enables Gnome integration with Ubuntu
  # https://github.com/nix-community/home-manager/issues/1439#issuecomment-1605851533
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (nixGLWrap pkgs.alacritty)
    # Programming Languages & Build Tools
    pkgs.cargo
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.cmake
    pkgs.go
    pkgs.jdk21
    pkgs.nodejs_20
    pkgs.maven

    # Programming Tools & CLI
    pkgs.curl
    pkgs.docker
    pkgs.docker-compose
    pkgs.eza
    pkgs.flyctl
    pkgs.git
    pkgs.jetbrains-toolbox
    pkgs.neovim
    pkgs.vscode
    pkgs.zellij

    # Other
    pkgs.chromium
    pkgs.clipit
    pkgs.emote
    pkgs.exercism
    pkgs.firefox
    pkgs.flameshot
    (nixGLWrap pkgs.insync)
    pkgs.obsidian
    (nixGLWrap pkgs.obs-studio)
    pkgs.spotify
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
    TERMINAL = "alacritty";
    # Setting this to fix issue with man pages locale.
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
