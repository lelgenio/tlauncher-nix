{ lib
, stdenv
, makeWrapper
, jre
, gnome
, writeShellScript
}:
let
  warnScript = writeShellScript "warn-tlauncher-jre-version" ''
    if ! test -d "$HOME/.tlauncher"; then
      ${gnome.zenity}/bin/zenity --warning \
        --text="On Tlauncher settings, set Java/JRE to 'Current only', otherwise minecraft will fail to launch."
    fi
  '';
in
stdenv.mkDerivation rec {
  name = "tlauncher";

  src = ./TL_mcl.jar;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  runtimeDeps = [ jre ];

  installPhase = ''
    install -Dm555 $src $out/share/tlauncher/tlauncher.jar
    makeWrapper "${jre}/bin/java" "$out/bin/tlauncher" \
      --run ${warnScript} \
      --add-flags "-jar $out/share/tlauncher/tlauncher.jar" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';
}
