{ config, pkgs, ... }:
{
    services.fail2ban = { # puts bad ssh attempts in jail 
    enable = true;
    jails = pkgs.lib.mkForce { # mkForce is needed to override the default jails
  DEFAULT =
''backend = systemd
banaction = iptables-allports
banaction_allports = iptables-allports
mta = msmtp
logtarget = FILE
loglevel = DEBUG
action = %(action_mw)s[from=paperpl88s@gmail.com, sender=paperpl88s@gmail.com, destination=adamciuris@gmail.com, sendername=Fail2Ban]
bantime = 300m
maxretry = 3'';
sshd=''
enabled = true
port = 22
banaction = iptables-allports
maxretry  = 5
findtime  = 1d
bantime   = 2w'';
      };
    };
}