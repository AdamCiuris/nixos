{  config, pkgs, ...}:
{
	programs.git = {
		enable = true;
		settings.user.name = "Adam Ciuris";
		settings.user.email = "adamciuris@gmail.com";
	};
}