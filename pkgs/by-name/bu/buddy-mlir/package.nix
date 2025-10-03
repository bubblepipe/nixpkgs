{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  cmake,
  ninja,
  python3,
  git,
  clang,
  lld,
}:

stdenv.mkDerivation rec {
  pname = "buddy-mlir";
  version = "0-unstable-2025-09-29";

  src = fetchFromGitHub {
    owner = "buddy-compiler";
    repo = "buddy-mlir";
    rev = "830d628819c293798b00f1ef650a9e7f3341b191";
    hash = "sha256-rFc+EWz7ode1tz82fM8GSGaq8iyvnb3CNUkuMQdaNRc=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
    git
  ];

  buildInputs = [
    clang
    lld
  ];

  postUnpack = ''
    cd $sourceRoot
    git init
    git remote add origin https://github.com/buddy-compiler/buddy-mlir.git
    git fetch origin
    git checkout -f ${src.rev}
    git submodule init
    git submodule update --recursive 
  '';

  preConfigure = ''
    # buddy-mlir expects to build LLVM from source as a submodule
    # The one-step build approach builds LLVM and buddy-mlir together
    mkdir -p build
  '';

  cmakeDir = "../";
  
  cmakeBuildDir = "build";

  cmakeFlags = [
    "-DLLVM_ENABLE_PROJECTS=mlir;clang"
    "-DLLVM_TARGETS_TO_BUILD=host"
    "-DLLVM_ENABLE_ASSERTIONS=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_BUILD_TOOLS=ON"
    "-DLLVM_INCLUDE_TOOLS=ON"
  ];

  # This is a large build, mark it as such
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "MLIR-based compiler framework for co-design ecosystem from DSL to DSA";
    homepage = "https://github.com/buddy-compiler/buddy-mlir";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}