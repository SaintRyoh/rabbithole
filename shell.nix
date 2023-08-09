let
  overlay = self: super: {
    awesome = super.awesome.override {
      gtk3Support = true;
    };
  };

  customPkgs = import <nixpkgs> {
    overlays = [ overlay ];
  };

in
  customPkgs.mkShell rec {
    buildInputs = [
      customPkgs.lua5_2
      customPkgs.lua52Packages.luarocks
      customPkgs.entr
      customPkgs.gh
      customPkgs.xorg.xorgserver
      customPkgs.awesome
    ];

    shellHook = ''
      BASE_DIRECTORY=$(pwd)
      AWM_DEBUG=1
      if [[ -f ./scripts/hook.sh ]]; then
          source ./scripts/hook.sh
      fi
    '';
  }
