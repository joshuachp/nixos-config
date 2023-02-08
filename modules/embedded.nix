{ _, ... }: {
  config = {
    # Permission for the ESP32 device
    services.udev.extraRules = ''
      ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", TAG+="uaccess"
    '';

    users.users.joshuachp.extraGroups = [ "dialout" ];
  };
}
