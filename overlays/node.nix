# An overlay allows for a package set to be extended with new or modified packages

# `final` refers to the package set with all overlays applied.
# This allows for added or modified packages to be referenced with
# all relevant changes
final:

# `prev` refers to the previous package set before this current overlay is applied.
# This is cheaper for nix to evaluate, thus should be prefered over final when possible.
prev:

{

  # https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V18.md
  nodejs-18_x = prev.nodejs-18_x.overrideAttrs (oldAttrs: rec {
    version = "18.15.0";
    name = "nodejs-${version}";

    src = prev.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "sha256-jkTWUBj/lzKEGVwjGGRpoOpAgul+xCAOX1cG1VhNqjc=";
    };

    patches = [
      (prev.lib.head oldAttrs.patches)
    ]; # TODO investigate if this is necessary
  });

  # yarn node -v == node -v
  yarn = prev.yarn.override (_: {
    nodejs = final.nodejs-18_x;
  });
}