{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ytdlp-web;

  pythonEnv = pkgs.python3.withPackages (p: with p; [ flask ]);

  appScript = pkgs.writeScript "app.py" ''
    import subprocess
    import threading
    import sys
    import json
    import os
    import uuid
    from datetime import datetime
    from flask import Flask, request, render_template_string, redirect

    app = Flask(__name__)

    # --- History Configuration ---
    HISTORY_FILE = "${cfg.downloadDir}/ytdlp_history.json"
    history_lock = threading.Lock()

    def update_history(job_id, url, status, details=""):
        with history_lock:
            history = []
            if os.path.exists(HISTORY_FILE):
                try:
                    with open(HISTORY_FILE, 'r') as f:
                        history = json.load(f)
                except Exception:
                    pass
            
            # Update existing job if found
            found = False
            for item in history:
                if item.get('id') == job_id:
                    item['status'] = status
                    item['details'] = details
                    found = True
                    break
            
            # Create new job entry if it doesn't exist
            if not found:
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                history.insert(0, {
                    "id": job_id, 
                    "timestamp": timestamp, 
                    "url": url, 
                    "status": status, 
                    "details": details
                })
                # Keep only the 50 most recent downloads
                history = history[:50] 
                
            try:
                with open(HISTORY_FILE, 'w') as f:
                    json.dump(history, f, indent=2)
            except Exception as e:
                print(f"Failed to write history: {e}", flush=True)

    def get_history():
        with history_lock:
            if os.path.exists(HISTORY_FILE):
                try:
                    with open(HISTORY_FILE, 'r') as f:
                        return json.load(f)
                except Exception:
                    return []
            return []

    HTML = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>yt-dlp Server</title>
        <style>
            body { font-family: system-ui; max-width: 700px; margin: 40px auto; padding: 0 20px; color: #333; }
            .form-group { margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
            label.bold { font-weight: bold; display: block; margin-bottom: 5px; }
            input[type="url"], input[type="text"], select { width: 100%; padding: 10px; margin-bottom: 10px; box-sizing: border-box; }
            .split-group { display: flex; gap: 10px; }
            .split-group > div { flex: 1; }
            button { width: 100%; padding: 15px; background: #007bff; color: white; border: none; cursor: pointer; font-size: 16px; border-radius: 5px; }
            button:hover { background: #0056b3; }
            .checkbox-group label { display: block; margin-bottom: 5px; cursor: pointer; }
            .msg { margin-bottom: 20px; padding: 15px; background: #e8f5e9; border-left: 4px solid #4caf50; border-radius: 5px; }
            
            /* History Table Styles */
            .history-header { display: flex; justify-content: space-between; align-items: center; margin-top: 40px; }
            .refresh-btn { width: auto; padding: 8px 15px; font-size: 14px; background: #6c757d; }
            .refresh-btn:hover { background: #5a6268; }
            table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
            th, td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #f8f9fa; font-weight: bold; }
            .status-Success { color: #28a745; font-weight: bold; }
            .status-Failed { color: #dc3545; font-weight: bold; }
            .status-Downloading { color: #17a2b8; font-weight: bold; font-style: italic; }
            .details-col { font-size: 12px; color: #666; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: help; }
        </style>
        <script>
            function toggleOptions() {
                const dlType = document.getElementById('dl_type').value;
                document.getElementById('audio_opts').style.display = dlType === 'audio' ? 'block' : 'none';
                document.getElementById('video_opts').style.display = dlType === 'video' ? 'block' : 'none';
            }
            window.onload = toggleOptions;
        </script>
    </head>
    <body>
        <h2>yt-dlp Downloader</h2>
        {% if message %}<div class="msg">{{ message }}</div>{% endif %}
        <form method="POST">
            <div class="form-group">
                <label class="bold">URL:</label>
                <input type="url" name="url" placeholder="https://www.youtube.com/watch?v=..." required>
            </div>

            <div class="form-group">
                <label class="bold">Download Type:</label>
                <select name="dl_type" id="dl_type" onchange="toggleOptions()">
                    <option value="audio" selected>Audio Only</option>
                    <option value="video">Video + Audio</option>
                </select>
            </div>

            <div class="form-group" id="audio_opts">
                <label class="bold">Audio Format:</label>
                <select name="audio_format">
                    <option value="m4a" selected>m4a (Highest Quality Native / Converted)</option>
                    <option value="best">Best Native Audio (No Conversion)</option>
                    <option value="mp3">mp3</option>
                    <option value="flac">flac (Lossless)</option>
                    <option value="wav">wav</option>
                </select>
            </div>

            <div class="form-group" id="video_opts">
                <label class="bold">Video Options:</label>
                <select name="video_format" style="margin-bottom: 10px;">
                    <option value="mp4" selected>mp4</option>
                    <option value="mkv">mkv</option>
                    <option value="webm">webm</option>
                </select>
                <select name="quality">
                    <option value="best" selected>Best Available Resolution</option>
                    <option value="2160">4K (2160p)</option>
                    <option value="1440">1440p</option>
                    <option value="1080">1080p</option>
                    <option value="720">720p</option>
                </select>
            </div>

            <div class="form-group">
                <label class="bold">Slice / Trim (Optional):</label>
                <div class="split-group">
                    <div>
                        <label>Start Time (e.g. 00:15, 1:20:00)</label>
                        <input type="text" name="start_time" placeholder="0 (Start)">
                    </div>
                    <div>
                        <label>End Time (e.g. 01:30, 2:05:00)</label>
                        <input type="text" name="end_time" placeholder="inf (End)">
                    </div>
                </div>
            </div>

            <div class="form-group checkbox-group">
                <label class="bold">Extra Options:</label>
                <label><input type="checkbox" name="metadata" checked> Embed Metadata (Tags, Artist, etc.)</label>
                <label><input type="checkbox" name="thumbnail" checked> Embed Thumbnail Art</label>
                <label><input type="checkbox" name="subs"> Download & Embed Subtitles</label>
                <label><input type="checkbox" name="playlist"> Download Full Playlist</label>
            </div>

            <button type="submit">Download</button>
        </form>

        <div class="history-header">
            <h3>Download History</h3>
            <button class="refresh-btn" onclick="window.location.href='/';">Refresh Status</button>
        </div>
        <table>
            <tr>
                <th>Time</th>
                <th>URL</th>
                <th>Status</th>
                <th>Details</th>
            </tr>
            {% for item in history %}
            <tr>
                <td>{{ item.timestamp }}</td>
                <td><a href="{{ item.url }}" target="_blank" style="text-decoration:none; color:#007bff;">Link</a></td>
                <!-- FIX: Changed replace to strip to avoid breaking Nix string interpolation -->
                <td class="status-{{ item.status.split(' ')[0].strip('.') }}">{{ item.status }}</td>
                <td class="details-col" title="{{ item.details }}">{{ item.details }}</td>
            </tr>
            {% else %}
            <tr><td colspan="4" style="text-align:center; color:#999;">No download history yet.</td></tr>
            {% endfor %}
        </table>
    </body>
    </html>
    """

    def build_ytdlp_command(form_data):
        cmd = [
            '${pkgs.yt-dlp}/bin/yt-dlp', 
            '-P', '${cfg.downloadDir}',
            '--ffmpeg-location', '${pkgs.ffmpeg-headless}/bin',
            '--ignore-errors',
            '--force-ipv4'
        ]
        
        dl_type = form_data.get('dl_type', 'audio')
        
        if dl_type == 'audio':
            audio_fmt = form_data.get('audio_format', 'm4a')
            cmd.append('-x')
            if audio_fmt == 'm4a':
                cmd.extend(['-f', 'bestaudio[ext=m4a]/bestaudio', '--audio-format', 'm4a'])
            elif audio_fmt == 'best':
                cmd.extend(['-f', 'bestaudio'])
            else:
                cmd.extend(['-f', 'bestaudio', '--audio-format', audio_fmt])
        else:
            video_fmt = form_data.get('video_format', 'mp4')
            quality = form_data.get('quality', 'best')
            
            if quality == 'best':
                cmd.extend(['-f', 'bestvideo+bestaudio/best'])
            else:
                cmd.extend(['-f', f'bestvideo[height<={quality}]+bestaudio/best[height<={quality}]'])
            
            cmd.extend(['--merge-output-format', video_fmt])

        if form_data.get('metadata'):
            cmd.append('--embed-metadata')
        if form_data.get('thumbnail'):
            cmd.extend(['--embed-thumbnail', '--convert-thumbnails', 'jpg'])
        if form_data.get('subs'):
            cmd.extend(['--write-subs', '--embed-subs', '--sub-langs', 'all'])
        
        is_playlist = form_data.get('playlist')
        if not is_playlist:
            cmd.append('--no-playlist')
        else:
            cmd.extend([
                '--yes-playlist',
                '-o', '%(playlist_title)s/%(title)s [%(id)s].%(ext)s'
            ])
            
        start_time = form_data.get('start_time', "").strip()
        end_time = form_data.get('end_time', "").strip()
        
        if (start_time or end_time) and not is_playlist:
            s = start_time if start_time else '0'
            e = end_time if end_time else 'inf'
            cmd.extend(['--download-sections', f'*{s}-{e}'])

        cmd.append(form_data.get('url'))
        return cmd

    def run_ytdlp(form_data, job_id, url):
        # 1. Update history to Downloading
        update_history(job_id, url, "Downloading...", "Started")
        
        cmd = build_ytdlp_command(form_data)
        print(f"Starting download: {' '.join(cmd)}", flush=True)
        
        # 2. Run the command and wait for it to finish
        process = subprocess.run(cmd, capture_output=True, text=True)
        
        # 3. Handle Success / Failure and update history file
        if process.returncode != 0:
            print(f"--- yt-dlp ERROR ---", flush=True)
            print(process.stderr, flush=True)
            
            # Grab the last relevant line of the error log for the UI details column
            error_lines = [line.strip() for line in process.stderr.split('\n') if line.strip() and 'ERROR' in line]
            err_msg = error_lines[-1] if error_lines else "Unknown error. Check 'journalctl -eu ytdlp-web'"
            
            update_history(job_id, url, "Failed", err_msg)
        else:
            print(f"--- yt-dlp SUCCESS ---", flush=True)
            update_history(job_id, url, "Success", "Download completed successfully")

    @app.route('/', methods=['GET', 'POST'])
    def index():
        message = None
        if request.method == 'POST':
            url = request.form.get('url')
            if url:
                # Generate a unique ID for this download task
                job_id = str(uuid.uuid4())
                
                # Convert ImmutableMultiDict to a standard dict before passing it to thread
                form_data = dict(request.form)
                
                threading.Thread(target=run_ytdlp, args=(form_data, job_id, url)).start()
                
                # Post/Redirect/Get pattern
                return redirect('/?queued=true')
                
        # Check if we were just redirected from a successful POST
        if request.args.get('queued') == 'true':
            message = "Download queued successfully!"
            
        # Load the latest history every time the page is rendered
        history_data = get_history()
        return render_template_string(HTML, message=message, history=history_data)

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=${toString cfg.port})
  '';

in {
  options.services.ytdlp-web = {
    enable = mkEnableOption "yt-dlp web UI service";

    port = mkOption {
      type = types.port;
      default = 8097;
      description = "Port for the web interface to listen on.";
    };

    downloadDir = mkOption {
      type = types.str;
      default = "/home/nyx/jellyfin/music/tmp";
      description = "Directory where yt-dlp will save downloads.";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.downloadDir} 0777 root root -"
    ];

    systemd.services.ytdlp-web = {
      description = "yt-dlp Web Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ffmpeg-headless ];
      serviceConfig = {
        ExecStart = "${pythonEnv}/bin/python ${appScript}";
        Restart = "always";
        WorkingDirectory = cfg.downloadDir;
      };
    };
  };
}