{  config, pkgs, ...}:
let
  gcloudOrNot = false; # TODO figure out condition for this
  bashExtra = ''
	eval "$(direnv hook bash)"
	'';
	zshExtra = ''
	eval "$(direnv hook zsh)" # makes direnv work
	# scan local network for open ports
	# nmap -p 1-65535 localhost
	# echo "\"nix-shell -p 'lsof -i :<port> -S'\" to see what's using it"
	'';
	shellExtra =  ''

		# BEGIN XDG_DATA_DIRS CHECK
		# used to add .desktop files to xdg-mime from nix profile if dne
		# TODO figure out why this gets entered every home-manager switch
		xdgCheck="$HOME/.nix_profile/share/applications"
		if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
			export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
		fi	
		# ENd XDG_DATA_DIRS CHECK
		# BEGIN FUNCTIONS
		opts() {
			# opens a new firefox in a nix-shell on the nixos options page, pipes to nohup's thing and detaches from shell with &
			nohup nix-shell --pure -p mullvad-browser --run "mullvad-browser https://search.nixos.org/options" -- 2>&1 &
		}
		discord() {
			local NIXPKGS_ALLOW_UNFREE=1 nohup nix-shell --pure -p discord  --command discord -- 2>&1 & 
		}
		pvenv() {
			# starts a python virtual environment named after first arg and if a path to a requirements file is provided as second arg it installs it
			# "deactivate" leaves the venv
			local firstArg="$1"
			local activate="./$firstArg/bin/activate"
			python -m venv $firstArg 
			if [ ! -z "$2" ]; then
				source $activate && pip install -r $2 && echo "deactivate to leave"
			else
				source $activate && echo "deactivate to leave"
			fi
		}
		# opts() {
		# 	opens a new firefox in a nix-shell on the nixos options page, pipes to nohup's thing and detaches from shell with &
		# 	nohup nix-shell --pure -p firefox --run "firefox https://search.nixos.org/options" -- &
		# }
		apt-remove() {
			# removes a package from apt and nix
			local firstArg="$1"
			sudo apt-get remove $(apt list --installed "$firstArg" 2>/dev/null | awk -F'/' 'NR>1{print $1}')
		}
		desktopFiles() {
			local firstArg="$1"
			echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
			ls ~/.nix-profile/share/applications | grep "$firstArg"
			echo "searching for $firstArg in /usr/share/applications/..."
			ls /usr/share/applications | grep "$firstArg"
		} 
		countFiles() {
			local firstArg="$1"
			local A=$(ls -a |  wc -l)
			local B=$($A-2)
			echo $B
		}
		pathappend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="${"$PATH:"}$ARG"
				fi
			done
		}
		pathprepend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="$ARG${":$PATH"}"
				fi
			done
		}	# END FUNCTIONS


		# BEGIN ALIASES
		alias src="source"; 
		alias resrc="source ~/.zshrc";
		alias ...="../../"; 
		alias nrs="sudo nixos-rebuild switch"; 
		
		alias "g*"="git add *"; 
		alias gcm="git commit -m";
		alias gp="git push"; # conflicts with global-platform-pro, pari
		alias gpl="git pull";
		alias gco="git checkout";
		alias gbr="git branch";
		alias gcl="git clone";
		alias glog="git log";
		alias gdiff="git diff";
		alias gstat="git status";
		
		alias hms="rm -f ~/.config/mimeapps.list && home-manager switch";
		alias LS="ls -lAh";
		alias CD="cd";
		alias "cd.."="cd ..";
		alias "cd..."="cd ../..";

		alias "SUDO"="sudo";
		alias "SUDO!"="sudo !!";

		alias shutr="shutdown -r now ; systemd-inhibit --list"
		alias shut="shutdown now ; systemd-inhibit --list"

		alias ipy="type ipy && \
		nix-shell -p 'python3.withPackages (python-pkgs: with python-pkgs; [
						ipython
						matplotlib
						scipy
						scikit-learn
            pandas
            numpy
						requests
						pysocks
        ])' --run ipython"



		alias crontab-reboot-test="sudo rm /var/run/crond.reboot && sudo service cron restart"
		alias code=codium
		# click kill thing
		alias xkill="nix-shell -p xorg.xkill --run xkill"
		alias mkill="nix-shell -p xorg.xkill --run xkill"
		alias mousekill="nix-shell -p xorg.xkill --run xkill"
		
		# END ALIASES
		'';
		

in
{
	# BEGIN BASH
	programs.bash ={
		enable=true;
		historyControl = ["ignoredups"];
		initExtra =  if !gcloudOrNot then shellExtra 
			# add this email thing for gcloud only
			else shellExtra + ''
			# BEGIN LOGIN NOTIF
			echo "To: adamciuris@gmail.com    \n   
			Hi,\n
			$USER logging in at $(date) from $(who | awk '{print $5}')\n
			Hopefully it's you!\n
			" | msmtp -t

			# END LOGIN NOTIF
		'';
	}; # END BASH
	# BEGIN ZSH
	programs.zsh = {
		enable = true;
		enableAutosuggestions = true;
		syntaxHighlighting.enable = true;
		oh-my-zsh={
			enable = true;
			# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
			# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
			# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
			# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
			plugins = [ "git" "sudo" "systemd" "python"];  # a bunch of aliases and a few functions
			theme = "agnoster";  # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
			};
		initExtra = zshExtra + shellExtra;
	}; # END ZSH
}