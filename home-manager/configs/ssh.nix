{ config, pkgs, ... }: {
  	programs.ssh = { 
		enable = true;
		enableDefaultConfig = false;
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
		matchBlocks."gce-builder" = {
  hostname = "instance-20260818-184352";
  # hostname = "nixos";
  user = "adamciuris_gmail_com";
  identityFile = "~/.ssh/google_compute_engine";
  proxyCommand = "gcloud compute start-iap-tunnel %h %p --listen-on-stdin --zone=us-central1-c --project=home-lab-in-quotes";
  extraOptions = {
    StrictHostKeyChecking = "no";
  };
};
	};
}


# Host gce-builder
#     HostName instance-20260818-184352
#     User gcloud
#     IdentityFile ~/.ssh/google_compute_engine
#     ProxyCommand gcloud compute start-iap-tunnel %h %p --listen-on-stdin --zone=YOUR_ZONE --project=YOUR_PROJECT
#     StrictHostKeyChecking no