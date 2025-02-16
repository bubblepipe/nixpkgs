{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pnpm_9,
  nodejs_22,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hslink";
  version = "pre-release";

  src = fetchFromGitHub {
    owner = "HSLink";
    repo = "HSLinkUpper";
    rev = "d22bc42d17a72f0e4c586515c4e5a670bcf78d4c";
    hash = "sha256-drYlb2OgHj430CRkrMvEkBryuONp+M+tE24qBOyLgfI=";
  };



  nativeBuildInputs = [
    nodejs_22
    pnpm_9.configHook
    pkgs.pkg-config
    pkgs.gobject-introspection
    pkgs.cargo
    pkgs.cargo-tauri
    pkgs.rustc
    pkgs.openssl
  ];

  buildInputs = [ nodejs_22 ];

prePnpmInstall = ''
  pnpm config set dedupe-peer-dependants false
'';

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src prePnpmInstall;
    hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";

  };

  buildPhase = ''
      runHook preBuild

    pnpm install
    pnpm tauri build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ls 
    runHook postInstall
  '';

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
})
