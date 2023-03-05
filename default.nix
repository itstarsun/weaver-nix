{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "weaver";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ServiceWeaver";
    repo = "weaver";
    rev = "v${version}";
    sha256 = "sha256-dO4L2GP3KI4Y4OOOXXu/bnzJ1GEfZ7Z8cHTiE4HLEBo=";
  };

  patches = [
    # TODO: remove once the next release is out.
    (fetchpatch {
      url = "https://github.com/ServiceWeaver/weaver/commit/35727ae307c392d27cadfbf5302d56a3e76977ab.patch";
      sha256 = "sha256-++gFFDHBxwegpiNxC2YmiDVrKXNIXotFxcTGndOIlEs=";
    })
  ];

  subPackages = [ "cmd/*" ];

  vendorSha256 = "sha256-aoV+/5brHOPdgi3zaos6jWUs1sVLiECTH9vL9IC1o24=";

  proxyVendor = true;

  doCheck = false;

  meta = with lib; {
    description = "Programming framework for writing and deploying cloud applications";
    homepage = "https://serviceweaver.dev/";
    license = licenses.asl20;
  };
}
