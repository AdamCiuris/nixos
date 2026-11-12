{ config, lib, pkgs, ... }:

let
  cfg = config.services.cameraCapture;

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    flask
    werkzeug
  ]);

  appScript = pkgs.writeText "app.py" ''
    import os
    from flask import Flask, request, render_template_string
    from werkzeug.utils import secure_filename

    app = Flask(__name__)
    UPLOAD_FOLDER = 'uploads'
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)

    HTML_HUB = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Workspace Hub</title>
        <style>
            body { margin: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; background: #111; color: white; font-family: sans-serif; }
            h1 { margin-bottom: 40px; font-weight: 300; letter-spacing: 3px; }
            .grid { display: flex; gap: 20px; flex-wrap: wrap; justify-content: center; padding: 20px; }
            a.card { display: flex; flex-direction: column; align-items: center; justify-content: center; width: 180px; height: 150px; background: #222; color: white; text-decoration: none; border-radius: 12px; transition: all 0.2s ease; border: 1px solid #333; }
            a.card:hover { background: #333; transform: translateY(-5px); border-color: #555; }
            .icon { font-size: 3rem; margin-bottom: 15px; }
        </style>
    </head>
    <body>
        <h1>WORKSPACE</h1>
        <div class="grid">
            <a href="/camera" class="card" style="color: #0ea5e9;">
                <div class="icon">📷</div>
                <div style="color: white; font-weight: bold;">Capture Node</div>
            </a>
            <a id="fireflyLink" href="#" class="card" style="color: #4ade80;">
                <div class="icon">💸</div>
                <div style="color: white; font-weight: bold;">Firefly III</div>
            </a>
        </div>

        <script>
            const hostname = window.location.hostname;
            document.getElementById('fireflyLink').href = "http://" + hostname + ":5050";
        </script>
    </body>
    </html>
    """

    HTML_FRONTEND = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Capture Node</title>
        <style>
            body { margin: 0; display: flex; flex-direction: column; align-items: center; background: #111; color: white; font-family: sans-serif; }
            .top-bar { width: 100%; padding: 15px; box-sizing: border-box; }
            .back-btn { color: white; text-decoration: none; background: #333; padding: 8px 15px; border-radius: 5px; font-weight: bold; }
            video { width: 100%; max-width: 600px; background: #000; }
            .controls { display: flex; flex-wrap: wrap; justify-content: center; gap: 15px; margin: 20px; padding: 0 10px; max-width: 600px; }
            button { padding: 15px 25px; font-size: 1.1rem; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; transition: background 0.3s, opacity 0.3s; flex: 1 1 auto; }
            button:disabled { opacity: 0.5; cursor: not-allowed; }
            button.recording { background: #ef4444; }
            #uploadBtn { background: #8b5cf6; }
            #photoNonNativeBtn { background: #0ea5e9; }
            #status { margin-top: 10px; color: #4ade80; font-weight: bold; text-align: center; word-break: break-all; padding: 0 20px; }
        </style>
    </head>
    <body>
        <div class="top-bar">
            <a href="/" class="back-btn">← Hub</a>
        </div>
        
        <video id="video" autoplay playsinline muted></video>
        
        <div class="controls">
            <button id="photoNonNativeBtn">Take Photo (Fast/Canvas)</button>
            <button id="photoBtn">Take Photo (Native/EXIF)</button>
            <button id="recordBtn">Start Recording</button>
            <button id="uploadBtn">Upload File</button>
        </div>
        
        <input type="file" id="cameraInput" accept="image/*" capture="environment" style="display: none;">
        <input type="file" id="fileInput" style="display: none;">
        
        <div id="status"></div>

        <script>
            const video = document.getElementById('video');
            const photoBtn = document.getElementById('photoBtn');
            const photoNonNativeBtn = document.getElementById('photoNonNativeBtn');
            const recordBtn = document.getElementById('recordBtn');
            const uploadBtn = document.getElementById('uploadBtn');
            const cameraInput = document.getElementById('cameraInput');
            const fileInput = document.getElementById('fileInput');
            const statusDiv = document.getElementById('status');
            
            let mediaRecorder;
            let recordedChunks = [];
            let isRecording = false;

            navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' }, audio: true })
                .then(stream => {
                    video.srcObject = stream;
                    
                    mediaRecorder = new MediaRecorder(stream);
                    
                    mediaRecorder.ondataavailable = function(event) {
                        if (event.data.size > 0) {
                            recordedChunks.push(event.data);
                        }
                    };
                    
                    mediaRecorder.onstop = function() {
                        const mimeType = mediaRecorder.mimeType || "";
                        const ext = mimeType.includes('mp4') ? 'mp4' : 'webm';
                        const blob = new Blob(recordedChunks, { type: mimeType });
                        recordedChunks = [];
                        
                        uploadData(blob, `video_''${Date.now()}.''${ext}`);
                    };
                })
                .catch(err => {
                    statusDiv.innerText = "Live feed access denied.";
                    statusDiv.style.color = "#f87171";
                });

            function uploadData(blob, filename) {
                const formData = new FormData();
                formData.append('file', blob, filename);

                fetch('/upload', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        statusDiv.innerText = `Successfully uploaded: ''${filename}`;
                        statusDiv.style.color = "#4ade80"; 
                    } else {
                        statusDiv.innerText = "Upload failed.";
                        statusDiv.style.color = "#f87171"; 
                    }
                })
                .catch(err => {
                    statusDiv.innerText = "Network error.";
                    statusDiv.style.color = "#f87171";
                });
            }

            photoNonNativeBtn.addEventListener('click', () => {
                if (!video.srcObject || isRecording) return;
                statusDiv.innerText = "Capturing frame...";
                statusDiv.style.color = "#4ade80";
                
                const canvas = document.createElement('canvas');
                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;
                canvas.getContext('2d').drawImage(video, 0, 0);

                canvas.toBlob(blob => {
                    uploadData(blob, `canvas_''${Date.now()}.jpg`);
                }, 'image/jpeg', 0.9);
            });

            photoBtn.addEventListener('click', () => {
                if (isRecording) return;
                cameraInput.click();
            });

            cameraInput.addEventListener('change', (event) => {
                const file = event.target.files[0];
                if (!file) return;
                statusDiv.innerText = `Uploading original photo with metadata...`;
                statusDiv.style.color = "#eab308";
                uploadData(file, file.name);
                event.target.value = ""; 
            });

            recordBtn.addEventListener('click', () => {
                if (!mediaRecorder) return;
                if (!isRecording) {
                    mediaRecorder.start();
                    isRecording = true;
                    recordBtn.innerText = "Stop Recording";
                    recordBtn.classList.add("recording");
                    photoBtn.disabled = true;
                    photoNonNativeBtn.disabled = true;
                    uploadBtn.disabled = true;
                    statusDiv.innerText = "Recording...";
                    statusDiv.style.color = "#ef4444";
                } else {
                    mediaRecorder.stop();
                    isRecording = false;
                    recordBtn.innerText = "Start Recording";
                    recordBtn.classList.remove("recording");
                    photoBtn.disabled = false;
                    photoNonNativeBtn.disabled = false;
                    uploadBtn.disabled = false;
                    statusDiv.innerText = "Processing and uploading...";
                    statusDiv.style.color = "#eab308";
                }
            });

            uploadBtn.addEventListener('click', () => {
                if (isRecording) return;
                fileInput.click();
            });

            fileInput.addEventListener('change', (event) => {
                const file = event.target.files[0];
                if (!file) return;
                statusDiv.innerText = `Uploading ''${file.name}...`;
                statusDiv.style.color = "#eab308";
                uploadData(file, file.name);
                event.target.value = "";
            });
        </script>
    </body>
    </html>
    """

    @app.route('/')
    def index():
        return render_template_string(HTML_HUB)

    @app.route('/camera')
    def camera():
        return render_template_string(HTML_FRONTEND)

    @app.route('/upload', methods=['POST'])
    def upload():
        if 'file' not in request.files:
            return "No file provided", 400
        
        file = request.files['file']
        if file.filename == "":
            return "Empty filename", 400
            
        original_filename = secure_filename(file.filename)
        name, ext = os.path.splitext(original_filename)
        filepath = os.path.join(UPLOAD_FOLDER, original_filename)
        
        counter = 0
        while os.path.exists(filepath):
            new_filename = f"{name}_{counter}{ext}"
            filepath = os.path.join(UPLOAD_FOLDER, new_filename)
            counter += 1
            
        file.save(filepath)
        print(f"[*] Saved file to {filepath}")
        return "OK", 200

    if __name__ == '__main__':
        app.run(host='127.0.0.1', port=9777)
  '';

in
{
  options.services.cameraCapture = {
    enable = lib.mkEnableOption "Camera Capture Web App";
    
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "cameraslop";
      description = "Directory under /home/nyx/ to store media uploads";
    };
  };

  config = lib.mkIf cfg.enable {
    # This natively creates the directory with correct permissions before the service starts
    systemd.tmpfiles.rules = [
      "d /home/nyx/${cfg.dataDir} 0755 nyx users -"
    ];

    systemd.services.cameraCapture = {
      description = "Camera Capture Web App";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      script = ''
        ${pythonEnv}/bin/python ${appScript}
      '';

      serviceConfig = {
        User = "nyx";
        Group = "users";
        WorkingDirectory = "/home/nyx/${cfg.dataDir}";
        Restart = "always";
        RestartSec = "3";
      };
    };
  };
}