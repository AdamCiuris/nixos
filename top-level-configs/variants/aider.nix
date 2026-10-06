{ config, lib, pkgs, ... }:

let
  cfg = config.programs.local-aider;

  # writeShellApplication automatically adds the runtimeInputs to the script's PATH
  # and ensures it runs from the current working directory ($PWD).
  startAider = pkgs.writeShellApplication {
    name = "start-aider";
    runtimeInputs = with pkgs; [ aider-chat tree bash ];
    text = ''
      # Local OpenAI-compatible APIs usually still require a dummy key to bypass client-side checks
      export OPENAI_API_KEY="''${OPENAI_API_KEY:-dummy-local-key}"

      echo "Connecting Aider to LLM at ${cfg.apiBase} from $PWD..."

      # - 'openai/' prefix tells Aider to use standard OpenAI API formatting for your local server.
      # - We pass "$@" to allow appending extra flags on the fly (e.g., start-aider --no-auto-commits)
      exec aider \
        --openai-api-base "${cfg.apiBase}" \
        --model "${cfg.model}" \
        "$@"
    '';
  };

in
{
  options.programs.local-aider = {
    enable = lib.mkEnableOption "Local Aider integration";

    apiBase = lib.mkOption {
      type = lib.types.str;
      default = "http://10.99.99.2:8080/v1";
      description = "Base URL for the local LLM. Most local servers (llama.cpp, vLLM) require the /v1 suffix.";
    };

    model = lib.mkOption {
      type = lib.types.str;
      default = "openai/local-model"; 
      description = ''
        Model name to pass to Aider. Prefix with 'openai/' to force API compatibility.
        If your server is strict, replace 'local-model' with the exact model name you have loaded.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ startAider ];
  };
}