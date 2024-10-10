{ ... }:
{
  environment.etc =
    let
      dir = "/persist/etc";
    in
    {
      machine-id.source = "${dir}/machine-id";
    };
}
