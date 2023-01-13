{ ...
}: {
  config = {
    # Grafana for visualization
    services.grafana = {
      enable = true;
      # Listening address and TCP port
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          domain = "localhost";
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
