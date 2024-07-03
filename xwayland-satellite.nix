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
  version = "3794c4b94569b0623448dbd2625534406b8d1ad6";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-nGozfApetEctJGvTz24P5muBwbKfhVRzO4lSrymkEgo=";
  };

  cargoSha256 = "sha256-0zYWZV2bntmCq7UWugUYzUrA009wg+gt1DwZV1++2Oc=";

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