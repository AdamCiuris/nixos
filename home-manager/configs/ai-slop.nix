{ config, inputs, pkgs, ... }:

{
  programs.antigravity = {
    enable = true;
    # Assuming the derivation is available in your pkgs, otherwise replace with your package reference
    # package = pkgs.antigravity; 
    mutableExtensionsDir = false;
    
    argvSettings = {
      # "enable-crash-reporter" = false;
    };

    profiles.default = {
      enableMcpIntegration = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      
      extensions = with pkgs; [
        # vscode-extensions.jnoortheen.nix-ide
      ];
      
      userSettings = {
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
      };
      
      keybindings = [
        {
          key = "ctrl+shift+j";
          command = "workbench.action.togglePanel";
        }
      ];

      userTasks = {
        version = "2.0.0";
        tasks = [];
      };

      userMcp = {
        # MCP profile specific config
      };

      globalSnippets = {
        # Global snippet definitions
      };

      languageSnippets = {
        nix = {
          # Nix-specific snippets
        };
      };
    };
  };

  # programs.antigravity-cli = {
  #   enable = true;
  #   # package = inputs.antigravity.packages.${pkgs.system}.antigravity-cli;
    
  #   defaultModel = "gemini-1.5-pro";
  #   useLegacyGeminiConfig = false;
  #   enableMcpIntegration = true;
    
  #   settings = {
  #     # CLI-specific settings
  #   };

  #   permissions = {
  #     allow = [ "read-workspace" ];
  #     ask = [ "execute-command" ];
  #     deny = [];
  #   };

  #   policies = {
  #     # Policy configurations
  #   };

  #   context = {
  #     # Context tracking configuration
  #   };

  #   skills = [
  #     # "python-developer"
  #     # "nix-sysadmin"
  #   ];

  #   mcpServers = {
  #     # localServer = {
  #     #   command = "node";
  #     #   args = [ "/path/to/server.js" ];
  #     # };
  #   };

  #   commands = {
  #     explain = {
  #       description = "Explain the given code or concept";
  #       prompt = "Explain this concisely.";
  #     };
  #     refactor = {
  #       description = "Refactor the selected code";
  #       prompt = "Refactor this code to be more idiomatic and performant.";
  #     };
  #   };
  # };
}