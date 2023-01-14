{ ...
}: {
  config = {
    # Grafana for visualization
    services.grafana = {
      enable = true;
      # Listening address and TCP port
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3000;
          domain = "localhost";
          enable_gzip = true;
        };
      };
    };

    # Prometheus for metrics
    services.prometheus = {
      enable = true;
      port = 9090;
    };
  };
}
