{ pkgs ? import <nixpkgs> {} }:

let
  zig-overlay = builtins.fetchTarball "https://github.com/mitchellh/zig-overlay/archive/main.tar.gz";
  zigpkgs = import zig-overlay { inherit pkgs; };
in
pkgs.mkShell {
  name = "gavel-dev-shell"; # This is the "internal" name
  nativeBuildInputs = with pkgs; [
    zigpkgs."0.15.2"
    pkgs.zls
    pkg-config
    python3
    python3Packages.pip
    python3Packages.ply
    linuxPackages.perf
    flamegraph
    hotspot
  ];

  buildInputs = with pkgs; [
    # Raylib dependencies
    glibc.dev
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  # This part is the "secret sauce" for NixOS
  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (with pkgs; [ libGL xorg.libX11 ])}:$LD_LIBRARY_PATH"
    export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"

    # Generate libc config for Zig to use system libraries
    cat > /tmp/zig-libc.txt <<EOF
include_dir=${pkgs.glibc.dev}/include
sys_include_dir=${pkgs.glibc.dev}/include
crt_dir=${pkgs.glibc}/lib
msvc_lib_dir=
kernel32_lib_dir=
gcc_dir=
EOF
    export ZIG_LIBC=/tmp/zig-libc.txt
  '';
}
