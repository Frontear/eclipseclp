{
  lib,

  stdenvNoCC,
  fetchzip,

  makeWrapper,

  jdk8,

  buildFHSEnv,
}:
let
  arch = "x86_64_linux"; # this program is something..
  eclipse = stdenvNoCC.mkDerivation {
    pname = "eclipse";
    version = "6.1";

    src = fetchzip {
      url = "https://eclipseclp.org/Distribution/Builds/6.1_229/${arch}/eclipse_basic.tgz";
      hash = "sha256-fjEvw0ZfTm7d+U4dFe64OLjrJmW4vEYoVsBGfragwgI=";

      stripRoot = false;
    };

    nativeBuildInputs = [ makeWrapper ];

    # do they like out for bins, or bin?
    # do they like dev for libs, or lib?
    # it's all so darn inconsistent
    outputs = [
      "out"
      "dev"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out $dev

      install -D -m 755 lib/${arch}/eclipse.exe $out/bin/eclipse
      cp -R --preserve=mode lib/${arch}/ $dev/lib

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/eclipse \
        --set "ECLIPSEDIR" "$src" \
        --set "JRE_HOME" "${jdk8}/jre"
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

      license = licenses.unfree; # no CMPL
      platforms = [ "x86_64-linux" ];
      mainProgram = "eclipse";

      maintainers = with maintainers; [ frontear ];
    };
  };
in buildFHSEnv {
  name = "eclipse-fhs";

  extraOutputsToInstall = [ "out" "dev" ];

  targetPkgs = _: [ eclipse ];

  runScript = eclipse.meta.mainProgram;
}
