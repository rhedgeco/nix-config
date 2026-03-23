{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  buildFHSEnv,
  dbus,
  dbus-glib,
  glib,
  gpgme,
  libgcc,
  libpcap,
  systemd,
  openssl,
  zlib,
}: let
  version = "3.7.1.74-1";

  # Base package: just extract the deb contents cleanly
  zscaler-unwrapped = stdenv.mkDerivation {
    pname = "zscaler-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://d32a6ru7mhaq0c.cloudfront.net/zscaler-client_${version}_amd64.deb";
      hash = "sha256-hdjj16Io/irMwzp5qyBQPBEIr+9LvsTMydBsZG3lW9U=";
    };

    nativeBuildInputs = [dpkg];

    sourceRoot = ".";
    unpackCmd = "dpkg-deb -x zscaler-client_${version}_amd64.deb .";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Main application files go to /opt/zscaler in the FHS env
      mkdir -p $out/opt/zscaler
      cp -R root/opt/zscaler/* $out/opt/zscaler/

      # D-Bus policy files
      mkdir -p $out/share/dbus-1/system.d
      cp root/usr/share/dbus-1/system.d/* $out/share/dbus-1/system.d/

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.zscaler.com/products-and-solutions/zscaler-client-connector";
      description = "Securely connect users to any destination from any device or location.";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = ["rhedgeco"];
    };
  };

  # Common libraries needed by zscaler daemon binaries
  commonTargetPkgs = _: [
    dbus
    dbus-glib
    glib
    gpgme
    libgcc
    stdenv.cc.cc.lib # libstdc++.so.6
    zlib
    systemd
    openssl
  ];

  # Compat shims: zscaler binaries expect older soname versions
  # gpgme 2.x ships libgpgme.so.45 but zscaler expects libgpgme.so.11
  # libpcap 1.x ships libpcap.so.1 but zscaler expects libpcap.so.0.8
  compat-libs = stdenv.mkDerivation {
    pname = "zscaler-compat-libs";
    version = "1.0";
    dontUnpack = true;
    dontFixup = true;
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/lib
      cp ${gpgme}/lib/libgpgme.so $out/lib/libgpgme.so.11
      cp ${libpcap.lib}/lib/libpcap.so $out/lib/libpcap.so.0.8
      chmod 555 $out/lib/libgpgme.so.11
      chmod 555 $out/lib/libpcap.so.0.8
    '';
  };

  # Set LD_LIBRARY_PATH so the FHS env can find the bundled libpacparser and gpgme compat
  commonProfile = ''
    export LD_LIBRARY_PATH=/opt/zscaler/lib:${compat-libs}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
  '';

  # FHS-wrapped zsaservice (system daemon)
  zsaservice = buildFHSEnv {
    name = "zsaservice";
    targetPkgs = pkgs:
      (commonTargetPkgs pkgs)
      ++ [zscaler-unwrapped compat-libs];
    runScript = "/opt/zscaler/bin/zsaservice";
    profile = commonProfile;
  };

  # FHS-wrapped zstunnel
  zstunnel = buildFHSEnv {
    name = "zstunnel";
    targetPkgs = pkgs:
      (commonTargetPkgs pkgs)
      ++ [zscaler-unwrapped compat-libs];
    runScript = "/opt/zscaler/bin/zstunnel";
    profile = commonProfile;
  };
in {
  inherit zscaler-unwrapped zsaservice zstunnel;
}
