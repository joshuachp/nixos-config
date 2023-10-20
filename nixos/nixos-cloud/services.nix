{ config
, lib
, ...
}: {
  config =
    let
      hostname = config.privateConfig.nixos-cloud.address;
      acmeEmail = config.privateConfig.acme.email;
      grafanaPort = 3000;
    in
    {
      # Open HTTP ports
      networking.firewall = {
        allowedTCPPorts = [ 80 443 ];
        allowedUDPPorts = [ 80 443 ];
      };

      # Automated renewal and expiration reminders
      security.acme = {
        acceptTerms = true;
        certs = {
          ${hostname}.email = acmeEmail;
        };
      };

      services = {
        # Reverse proxy to other services
        nginx = {
          enable = true;
          recommendedTlsSettings = true;
          recommendedOptimisation = true;
          recommendedGzipSettings = true;
          recommendedProxySettings = true;
          # Sites
          virtualHosts.${hostname} = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              root = "/var/www";
            };
            # Proxy to graphana server
            locations."/grafana/" = {
              proxyPass = "http://127.0.0.1:${toString grafanaPort}/";
              proxyWebsockets = true;
              extraConfig = ''
                allow 127.0.0.1;
                allow 10.0.0.0/24;
                deny all;
              '';
            };
          };
        };

        # Grafana for visualization
        grafana = {
          enable = true;
          # Listening address and TCP port
          settings = {
            server = {
              http_addr = "127.0.0.1";
              http_port = grafanaPort;
              root_url = "https://${hostname}/grafana/";
              domain = hostname;
              enable_gzip = true;
            };
          };
        };

        # Loki for logs and traces
        loki = {
          enable = true;
          configFile = ./config/loki.yaml;
        };
        # The agent to gather the Loki logs
        promtail = {
          enable = true;
          configuration = lib.importJSON ./config/promtail.json;
        };

        # Prometheus for metrics
        prometheus =
          let
            nodePort = 9002;
          in
          {
            enable = true;
            port = 9090;
            exporters = {
              node = {
                enable = true;
                port = nodePort;
              };
            };
            scrapeConfigs = [
              {
                job_name = "node";
                static_configs = [{
                  targets = [ "localhost:${toString nodePort}" ];
                }];
              }
            ];
          };
      };

      systemd.services.promtail.serviceConfig.SupplementaryGroups = [ "nginx" ];
    };
}
