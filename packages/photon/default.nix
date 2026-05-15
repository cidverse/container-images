{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk21_headless,
}:

let
  pname = "photon";
  version = "1.1.0";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/komoot/photon/releases/download/${version}/photon-${version}.jar";
    hash = "sha256-WS4wRQC/d/RtQwfEN0ig2Gwgwk3x3Udxxa1kgDkG2Yk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp "$src" $out/libexec/photon.jar

    makeWrapper ${jdk21_headless}/bin/java $out/bin/photon \
      --set JAVA_HOME ${jdk21_headless}/lib/openjdk \
      --add-flags "--add-modules jdk.incubator.vector" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-Des.gateway.auto_import_dangling_indices=true" \
      --add-flags "-Des.cluster.routing.allocation.batch_mode=true" \
      --add-flags "-Dlog4j2.disable.jmx=true" \
      --add-flags "-jar $out/libexec/photon.jar"

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/komoot/photon";
    description = "OpenStreetMap geocoder built for search-as-you-type and reverse geocoding";
    license = licenses.asl20;
    platforms = jdk21_headless.meta.platforms;
    maintainers = with maintainers; [ ];
    mainProgram = "photon";
  };
}
