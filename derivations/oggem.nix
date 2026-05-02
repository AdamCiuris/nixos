installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/gemini-cli}

    npm prune --omit=dev

    find node_modules -name "*.py" -delete
    rm -rf node_modules/keytar/build

    cp -r node_modules $out/share/gemini-cli/

    # 1. Remove the symlinks NPM generated for local workspace packages
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-sdk
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-devtools
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    
    # 2. Replace them with the actual physical folders from the source
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    cp -r packages/a2a-server $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server
    cp -r packages/sdk $out/share/gemini-cli/node_modules/@google/gemini-cli-sdk
    cp -r packages/devtools $out/share/gemini-cli/node_modules/@google/gemini-cli-devtools

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core/dist/docs/CONTRIBUTING.md

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini
    chmod +x "$out/bin/gemini"

    find $out/share/gemini-cli/node_modules -name "package-lock.json" -delete
    find $out/share/gemini-cli/node_modules -name ".package-lock.json" -delete
    find $out/share/gemini-cli/node_modules -name "config.gypi" -delete

    runHook postInstall
  '';