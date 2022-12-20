#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" oh-my-posh --version
check "theme" test -e $HOME/.poshthemes/agnoster.omp.json
check "zsh install" grep "eval \"\$(oh-my-posh init zsh --config '$HOME/.poshthemes/agnoster.omp.json')\"" $HOME/.zshrc
check "bash install" grep "eval \"\$(oh-my-posh init bash --config '$HOME/.poshthemes/agnoster.omp.json')\"" $HOME/.bashrc

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults