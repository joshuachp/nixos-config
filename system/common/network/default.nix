{ _, ... }: {
  services.resolved = {
    enable = true;
    fallbackDns = [
      "45.90.28.0#John--Blackbox-4ee8d8.dns1.nextdns.io"
      "2a07:a8c0::#John--Blackbox-4ee8d8.dns1.nextdns.io"
      "45.90.30.0#John--Blackbox-4ee8d8.dns2.nextdns.io"
      "2a07:a8c1::#John--Blackbox-4ee8d8.dns2.nextdns.io"
      "2a07:a8c1::#John--Blackbox-4ee8d8.dns2.nextdns.io"
    ];
    dnssec = "allow-downgrade";
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };

  networking.networkmanager.dns = "systemd-resolved";
}
