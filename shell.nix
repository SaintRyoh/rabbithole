{ pkgs ? import <nixpkgs> {} }:

let

in
  pkgs.mkShell rec {

    # might also need awesome and Xephyr
    buildInputs = [
      pkgs.lua5_2
      pkgs.lua52Packages.luarocks
      pkgs.entr
      pkgs.gh
    ];

     shellHook = ''
       BASE_DIRECTORY=$(pwd)
       if [[ -f ./hook.sh ]]; then
           source ./hook.sh
       fi
     '';
}
