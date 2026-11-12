{ config, lib, pkgs, ... }:

let
  cfg = config.services.siteMonitor;

  webroot = pkgs.writeTextDir "index.html" ''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Site Monitor</title>
        <style>
            body { font-family: sans-serif; margin: 10px; }
            table { width: 100%; border-collapse: collapse; max-width: 800px; }
            th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
            @media (max-width: 400px) { th, td { padding: 4px; font-size: 14px; } }
            .up { color: green; font-weight: bold; }
            .down { color: red; font-weight: bold; }
            
            /* Button styling */
            .open-btn {
                margin-left: 15px;
                padding: 4px 12px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: normal;
                display: inline-block;
                transition: background-color 0.2s;
            }
            .open-btn:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Site</th>
                <th>Ping Status</th>
            </tr>
        </thead>
        <tbody id="siteList">
        </tbody>
    </table>

    <script>
        const sites = [
            { name: "Jellyfin", url: "https://nixos-2.tail113143.ts.net:4096" },
            { name: "yt-dlp", url: "https://nixos-2.tail113143.ts.net:4097" },
            { name: "Motion Detection", url: "https://nixos-2.tail113143.ts.net:4081" },
            { name: "Photos", url: "https://nixos-2.tail113143.ts.net:4777" },
            { name: "Kavita", url: "https://nixos-2.tail113143.ts.net:50000" },
            { name: "PDF Tools (Stirling)", url: "https://nixos-2.tail113143.ts.net:3001" }
        ];

        const tbody = document.getElementById('siteList');

        sites.forEach((site, i) => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>''${i + 1}</td>
                <td><a href="''${site.url}" target="_blank">''${site.name}</a></td>
                <td id="status-''${i}">Pinging...</td>
            `;
            tbody.appendChild(row);

            const statusCell = document.getElementById(`status-''${i}`);
            
            fetch(site.url, { mode: 'no-cors', cache: 'no-store' })
                .then(() => {
                    statusCell.innerHTML = '<span class="up">UP</span>';
                    
                    const btn = document.createElement('a');
                    btn.href = site.url;
                    btn.target = "_blank";
                    btn.className = "open-btn";
                    btn.textContent = "Open";
                    
                    statusCell.appendChild(btn);
                })
                .catch(() => {
                    statusCell.innerHTML = '<span class="down">DOWN</span>';
                });
        });
    </script>

    </body>
    </html>
  '';

in {
  options.services.siteMonitor = {
    enable = lib.mkEnableOption "site monitor dashboard";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Port to serve the site monitor on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.siteMonitor = {
      description = "Site Monitor Dashboard";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.python3}/bin/python3 -m http.server ${toString cfg.port} --bind 127.0.0.1 --directory ${webroot}";
        DynamicUser = true;
        Restart = "always";
      };
    };
  };
}