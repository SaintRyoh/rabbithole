{ pkgs ? import <nixpkgs> {} }:

let

in
  pkgs.mkShell rec {

    buildInputs = [
      pkgs.lua5_2
      pkgs.lua52Packages.luarocks
      pkgs.entr
      pkgs.gh
      pkgs.xorg.xorgserver
      pkgs.awesome
    ];

     shellHook = ''
       BASE_DIRECTORY=$(pwd)
       if [[ -f ./hook.sh ]]; then
           source ./hook.sh
       fi
     '';
}
