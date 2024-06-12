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
  version = "b6d281967cb0b7bf1dfdb8d0f597b517dc4aa5c5";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-dwF9nI54a6Fo9XU5s4qmvMXSgCid3YQVGxch00qEMvI=";
  };

  cargoSha256 = "sha256-YuDCMPAuzHfGgFoobA7VAnq8SqzLfDqqq0q+avIskNg=";

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