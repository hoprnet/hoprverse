{ pkgs ? import <nixpkgs> {}, ... }:
let
  linuxPkgs = with pkgs; lib.optional stdenv.isLinux (
    [
    inotifyTools
    mkpasswd
  ]
  );
  macosPkgs = with pkgs; lib.optional stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      # macOS file watcher support
      CoreFoundation
      CoreServices
    ]
  );
in
with pkgs;
mkShell {
  buildInputs = [
    ## base
    envsubst

    nodejs-16_x # v16.5.0
    (yarn.override { nodejs = nodejs-16_x; }) # v1.22.10

    kubectl
    minikube

    rust-bin.stable.latest.default
    yj
    entr

    # infrastructure
    terraform
    kubernetes-helm
    python310
    python310Packages.black
    python310Packages.ruamel_yaml
    python310Packages.simplejson
    python310Packages.jmespath
    ansible_2_12 # v2.12.x
    haproxy

    # custom pkg groups
    macosPkgs
    linuxPkgs
  ];
}
