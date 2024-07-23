{ config, pkgs, ... }: {
  	programs.ssh = { 
		enable = true;
		matchBlocks."github.com" = {
				hostname = "github.com";
				identityFile = "~/.ssh/id_ed25519_github";
		};
		matchBlocks."gcloud_local" = {
				hostname = "10.0.0.187"; # subject to change TODO find out some way to imperatively set this or change accordingly
				user = "nyx";
				# localForwards = [
				# 	{
				# 	# bind.port = 22;
				# 	host.address = "10.0.0.187";
				# 	# bind.port = 22;
				# 	}
				# ];
				identityFile = "~/.ssh/server_ided ";		
		};
	};
}