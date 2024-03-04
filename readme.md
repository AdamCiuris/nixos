<h1>NixOS config</h1>

My configuration for NixOS. Obtain a NixOS ISO [here.](https://nixos.org/manual/nixos/stable/#sec-obtaining)

Note that you may want to exclude linking my `hardware-configuration.nix` if it causes issues.

---

<h3>How to use (NixOS):</h3>

Clone my repo.

```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos && bash link
```

<h5>link explanation:</h5>


Clear everything in your nixos config and remake.

```bash
sudo rm -rf /etc/nixos/* 
```

Hardlink this repo into there.

```bash
sudo mkdir /etc/nixos/home-manager && sudo mkdir /etc/nixos/home-manager/configs \
sudo ln -fn ./configuration.nix ./nix-alien.nix ./home-manager/home-manager-module.nix \
./home-manager/home.nix /home-manager/configs/xdg.nix /etc/nixos/ && \
sudo nixos-generate-config # to get your hardware config back
```

Rebuild and switch.

```bash
sudo nixos-rebuild switch
```

<h3>How to use just home-manager (you aren't on nixOS):</h3>

run `bash link-home` which clears everything in your nix home-manger config and relinks.

```bash
rm -rf ~/.config/home-manager/* && \
mkdir ~/.config/home-manager/configs && \
ln -fn ./home-manager/home.nix  ~/.config/home-manager && \
ln -fn ./home-manager/configs/xdg.nix ~/.config/home-manager/configs \
&& home-manager switch
```

---

<h3>How to SSH into a machine and build:</h3>



```bash
git clone git@github.com:AdamCiuris/nixos.git && cd nixos
```

```bash
scp ./configuration.nix  \
./nix-alien.nix \
./home-manager-module.nix root@your_vms_internal_ip:/etc/nixos/
```
