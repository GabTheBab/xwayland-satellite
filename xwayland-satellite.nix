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
}:

rustPlatform.buildRustPackage rec {  
  pname = "xwayland-satellite";
  version = "016cef6f72b0bf960218b8b487915c2a8b991ba4";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-/ozAYc+hkCugIBw5w9u/A+4rVgOhpO2V2u1eaMXsa9U=";
  };

  cargoSha256 = "sha256-NfIanS7IMXC+Cc2pk8zeWHz418hmamUnQVXvlwY6ijY=";

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