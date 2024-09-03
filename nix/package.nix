{
  lib,

  stdenv,
  fetchzip,

  makeWrapper,

  buildFHSEnv,
}:
let
  eclipse = stdenv.mkDerivation (finalAttrs: {
    pname = "eclipse";
    version = "6.1_229";

    src = fetchzip {
      url = "https://eclipseclp.org/Distribution/Builds/6.1_229/x86_64_linux/eclipse_basic.tgz";
      hash = "sha256-fjEvw0ZfTm7d+U4dFe64OLjrJmW4vEYoVsBGfragwgI=";

      stripRoot = false;
    };

    nativeBuildInputs = [ makeWrapper ];

    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib}

      cp -R lib/x86_64_linux/* $out/lib
      install -Dm755 lib/x86_64_linux/eclipse.exe $out/bin/eclipse

      runHook postInstall
    '';

    # Apparently this is necessary?
    postInstall = ''
      wrapProgram $out/bin/eclipse \
        --set "ECLIPSEDIR" "$src"
    '';

    meta = with lib; {
      description = "ECLiPSe Constraint Logic Programming System";
      longDescription = ''
        The ECLiPSe Constraint Logic Programming System is designed for solving
        combinatorial optimization problems, for the development of new constraint
        solver technology and their hybrids, and for the teaching of modelling,
        solving and search techniques.
      '';
      homepage = "https://eclipseclp.org/";

      license = licenses.unfree; # CMPL
      platforms = [ "x86_64-linux" ];
      mainProgram = finalAttrs.pname;
    };
  });
in buildFHSEnv {
  name = "eclipse-fhs";

  targetPkgs = _: [
    eclipse
  ];
}
