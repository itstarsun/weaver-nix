{ lib
, buildGoModule
, fetchFromGitHub
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
