<h1>NixOS config</h1>

My configuration for NixOS. Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

Note that you may want to exclude linking my `hardware-configuration.nix` if it causes issues.

---

<h3>How to use:</h3>

Clone my repo.

```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos
```

Clear everything in your nixos config and remake.

```bash
sudo rm -r /etc/nixos/ && sudo mkdir /etc/nixos 
```

Hardlink this repo into there.

```bash
sudo ln ./configuration.nix /etc/nixos/ \
&& sudo ln ./hardware-configuration.nix /etc/nixos/ && \
sudo ln ./nix-alien.nix /etc/nixos/
```

Rebuild and switch.

```bash
sudo nixos-rebuild switch
```

---

<h3>How to SSH into a machine and build:</h3>



```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos
```

```bash
scp ./configuration.nix  \
./hardware-configuration.nix \
./nix-alien.nix \
./home-manager-module.nix root@your_vms_internal_ip:/etc/nixos/```
