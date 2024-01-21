<h1>NixOS config</h1>

---

<h3>How to Use</h3>

Clone my repo.

```bash
git clone git@github.com:AdamCiuris/nixos.git
```

Clear everything in your nixos config and remake.

```bash
sudo rm -r /etc/nixos/ && sudo mkdir /etc/nixos
```

Hardlink this repo into there.

```bash
sudo ln ./configuration.nix /etc/nixos/ \
sudo ln ./hardware-configuration.nix /etc/nixos/
```

Rebuild and switch.

```bash
sudo nixos-rebuild switch
```