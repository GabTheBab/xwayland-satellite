{ lib
, rustPlatform
, fetchFromGitHub
, clang
, llvmPackages
, xcb-util-cursor
, xorg
, glibc
, libclang
, musl
, xwayland
, makeWrapper
, pkg-config
}:

rustPlatform.buildRustPackage rec {  
  pname = "xwayland-satellite";
  version = "0a5dddacfde337e10943e95b0d5aa5602d3c4e0c";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-bHi+SadroXIH0IksxFXszVmTuw06yMCB3c8Rj4oALVs=";
  };

  cargoSha256 = "sha256-1Zj7Ijy+tR5Iifg/rTu12hwgoU7gAx+100EGFl5ZvPo=";

  doCheck = false;

  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang.lib ];  BINDGEN_EXTRA_CLANG_ARGS =
   (builtins.map (a: ''-I"${a}/include"'') [
    xcb-util-cursor.dev
    xorg.libxcb.dev
    musl.dev
  ])
  ++ [
    ''-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include''
  ];

  buildInputs = [
    xcb-util-cursor
    clang
    makeWrapper
  ];

    nativeBuildInputs = [
        pkg-config
    ];

  postInstall = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = with lib; {
    description = "Xwayland outside your Wayland";
    license = licenses.mpl20;
    homepage = src.meta.homepage;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gabby ];
  };
}