{
  description = "hlgr macbook flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

##### Nix Packages

      environment.systemPackages =
        [ 
		pkgs.neovim
		pkgs.ffmpeg-full
 		pkgs.topgrade
        ];

##### Homebrew Packages

homebrew = {
	enable = true;
  brews = [
    "mas"
  ];
	casks = [ 
		"alfred"
		"iina"
		"spotify"
		"appcleaner"
		"the-unarchiver"
		"jdownloader"
		"threema"
		"discord"
		"microsoft-auto-update"
		"vanilla"
		"firefox"
		"microsoft-teams"
		"vlc"
		"google-chrome"
		"nextcloud"
		"whatsapp"
	];

  masApps = {
    "Yoink" = 457622435;
    "CotEditor" = 1024640650;
    "MRIEssentials" = 1178665888;
    };

	onActivation.cleanup = "zap";
		 };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
		configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "holgerhaubenreisser";

	    autoMigrate = true;

         		 };
        }
		];
    };
  };
}