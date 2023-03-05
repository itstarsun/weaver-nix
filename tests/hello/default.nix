{ buildGoModule }:

buildGoModule {
  name = "hello";
  src = ./.;

  vendorSha256 = "sha256-IgnlZyjRW8Ufm/Ugjhcf23eRXdH9C8P7ZONQPsumHns=";
}
