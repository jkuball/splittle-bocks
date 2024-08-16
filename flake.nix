{
  description = "godot 4";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/master";
    };
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      default = pkgs.godot_4;
    };
  };
}
