{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  nix-update-script,
  pnpm_9,
  nodejs_22,
}:

rustPlatform.buildRustPackage rec {
  pname = "hslink";
  version = "pre-release";

  src = fetchFromGitHub {
    owner = "HSLink";
    repo = "HSLinkUpper";
    rev = "d22bc42d17a72f0e4c586515c4e5a670bcf78d4c";
    hash = "sha256-drYlb2OgHj430CRkrMvEkBryuONp+M+tE24qBOyLgfI=";
  };

  sourceRoot = "${src.name}/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-yqNvVXER27OIgrZc9b0a/worOFIkEb3/CQpfguA7ltU=";


  nativeBuildInputs = [
    nodejs_22
    pnpm_9.configHook
    pkgs.pkg-config
    pkgs.gobject-introspection
    pkgs.cargo
    pkgs.cargo-tauri
    pkgs.rustc
    pkgs.rustup
    pkgs.openssl
    pkgs.gtk3
    pkgs.pkg-config
  ];

  buildInputs = [ 
    nodejs_22  
    pkgs.gtk3 
    pkgs.at-spi2-atk
    pkgs.atkmm
    pkgs.cairo
    pkgs.gdk-pixbuf
    pkgs.glib
    pkgs.gtk3
    pkgs.harfbuzz
    pkgs.librsvg
    pkgs.libsoup_3
    pkgs.pango
    pkgs.webkitgtk_4_1
    pkgs.openssl
    pkgs.libgudev
    pkgs.systemd
  ];


  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";

  };

  preConfigure = ''
    # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
    # TODO: move frontend into its own drv
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"

    chmod +w -R ..
  '';

  passthru = {
    inherit pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/HSLink/HSLinkUpper";
    description = "HSLinkUpper is a simple tool that allows you to config HSLink.";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "longcat";
    maintainers = with lib.maintainers; [
      bubblepipe
    ];
  };
}
