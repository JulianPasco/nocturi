# Personal user configuration
# Edit this file with your personal settings before deploying

{
  # User account settings
  username = "julian";
  fullName = "Julian";
  email = "julian@hotstuff.co.za";  # Change to your email
  
  # System settings
  timezone = "Africa/Johannesburg";  # Change to your timezone (e.g., "America/New_York", "Europe/London")
  locale = "en_ZA.UTF-8";            # Change to your locale (e.g., "en_US.UTF-8", "en_GB.UTF-8")
  
  # Host-specific settings
  hostnames = {
    home = "nixos-home";  # Laptop hostname
    work = "nixos-work";  # Work PC hostname
  };
  
  # Location (for weather/geolocation)
  location = {
    latitude = -26.2041;   # Johannesburg coordinates - change to your location
    longitude = 28.0473;
    city = "Johannesburg";
  };
}
