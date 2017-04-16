{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation {
  name = "hidapplepatched-${kernel.version}";

  src = fetchurl {
    url = "https://github.com/free5lot/hid-apple-patched/archive/61dce7daffcc2a4bb2bfa633cd93918383d5de5e.tar.gz";
    sha256 = "afc9646ecee5140683461d8284c3839c0234db467a438252c8913e0058e7e309";
  };

  hardeningDisable = [
    "pic"
  ];

  makeFlags = [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  preBuild = "makeFlagsArray+=(\"M=$(pwd)\")";

  buildFlags = [ "modules" ];

  installTargets = [ "modules_install" ];

  meta = {
    homepage = "https://github.com/free5lot/hid-apple-patched";
    description = "An enhanced hid-apple module to customize apple keyboard bindings";
    longDescription = ''
      A patched version of hid-apple allows GNU/Linux user to swap the FN and left Control keys on Macbook Pro, external Apple keyboards and probably other Apple devices.
    '';
    license = stdenv.lib.licenses.gpl2;
  };
}
