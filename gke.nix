{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "weaver-gke";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ServiceWeaver";
    repo = "weaver-gke";
    rev = "v${version}";
    sha256 = "sha256-16TDuLHmRENDEKZ/sNatBWJCDL1IWor04S+BbqESwok=";
  };

  subPackages = [ "cmd/*" ];

  vendorSha256 = "sha256-gYViO9BQYrbyvcWbuT4b5aXKyZzyz2VJLgBiMIPykTw=";

  proxyVendor = true;

  doCheck = false;

  meta = with lib; {
    description = "Run Weaver applications on GKE";
    homepage = "https://serviceweaver.dev/";
    license = licenses.asl20;
  };
}
