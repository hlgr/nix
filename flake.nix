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
      security.pam.services.sudo_local.touchIdAuth = true;
      nix.extraOptions = ''
  extra-platforms = x86_64-darwin aarch64-darwin
'';

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
		"threema@beta"
		"discord"
		"microsoft-auto-update"
		"firefox"
		"microsoft-teams"
		"vlc"
		"google-chrome"
		"nextcloud"
		"whatsapp"
		"horos"
		"rectangle-pro"
		"sabnzbd"
	];

  masApps = {
  	"Pages" = 409201541;
  	"Numbers" = 409203825;
  	"Keynote" = 409183694;
    "Yoink" = 457622435;
    "CotEditor" = 1024640650;
    "MRIEssentials" = 1178665888;
    "DaisyDisk" = 411643860;
    "Hidden Bar" = 1452453066;
    "Moliview" = 6502892357;
    "Nitro Photo" = 1591292532;
    "MS ToDo" = 1274495053;
    "MoneyMoney" = 872698314;
    };

	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
		 };
		 
##### System Settings
	system.primaryUser = "Holger Haubenreisser";
	system.defaults = {
  dock.mru-spaces = false;
  dock.persistent-apps = [
  "/Applications/Firefox.app"
  "/System/Applications/Mail.app"
  "/System/Applications/Calendar.app"
  "/Applications/WhatsApp.app"
  "/System/Applications/Notes.app"
  ];
  finder.FXPreferredViewStyle = "clmv";
  	NSGlobalDomain = {
  AppleMeasurementUnits = "Centimeters";
  AppleInterfaceStyle = "Dark";
  AppleTemperatureUnit = "Celsius";
  AppleShowAllExtensions = true;
  AppleShowAllFiles = true;
  AppleICUForce24HourTime = true;
  AppleMetricUnits = 1;
  AppleScrollerPagingBehavior = true;
  "com.apple.mouse.tapBehavior" = 1;
  "com.apple.swipescrolldirection" = false;
  "com.apple.trackpad.forceClick" = false;
  "com.apple.trackpad.enableSecondaryClick" = true;
  "com.apple.trackpad.scaling" = 0.875;
  };
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
            user = "hlgr";

	    autoMigrate = true;

         		 };
        }
		];
    };
  };
}
