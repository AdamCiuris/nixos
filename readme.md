<h1>NixOS config</h1>

My configuration for NixOS. Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

Note that you may want to exclude linking my `hardware-configuration.nix` if it causes issues.

---

<h3>How to use (NixOS):</h3>

Clone my repo.

```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos && bash link
```

`bash link` clears everything in your /etc/nixos and remakes. It will default to the last nixos system built.

`link` also accepts nixpkgs.lib.nixosSystem names from flake.nix as an argument. Different options are nixos, lock, and compclub.


<h3>How to use (home-manager standalone):</h3>

Download the [multi-user nix](https://nixos.org/download/) if it doesn't already exist the grab home-manager. Match your nixpkgs version (using tag since anything else breaks mint) with the home-manager version:

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-{VERSION}.tar.gz home-manager && \
nix-channel --add https://github.com/NixOS/nixpkgs/archive/refs/tags/{VERSION}.tar.gz nixpkgs && \
nix-channel --update && \
nix-shell '<home-manager>' -A install
```

Run `bash link-standalone` which clears everything in your nix home-manger config and relinks.

