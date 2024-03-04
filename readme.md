<h1>NixOS config</h1>

My configuration for NixOS. Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

Note that you may want to exclude linking my `hardware-configuration.nix` if it causes issues.

---

<h3>How to use (NixOS):</h3>

Clone my repo.

```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos && bash link
```

`bash link` clears everything in your /etc/nixos and remakes.


<h3>How to use (home-manager standalone):</h3>

run `bash link-home` which clears everything in your nix home-manger config and relinks.

