{
  inputs,
  ...
}:
{
  perSystem = { self', system, ... }:
  let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells.default = pkgs.callPackage ./shell.nix { };
    packages.default = pkgs.callPackage ./package.nix { };
  };
}
