#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'hello' feature with no options.
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "hello": {}
#    }
# }
#
# Thus, the value of all options will fall back to the default value in 
# the feature's 'devcontainer-feature.json'.
# For the 'hello' feature, that means the default favorite greeting is 'hey'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the --remote-user flag.
# 
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \ 
#                   --features hello \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" patissuer --version
check "entryscript" test -e $HOME/.patissuer/entrypoint.sh
check "authscript" test -e $HOME/.patissuer/devops-auth.sh
check "env" test -e $HOME/.patissuer/patissuer.env

check "git-alias-config1" grep "[url "https://pat@dev.azure.com/rickardgranberg/patissuer/_git"]" $HOME/.gitconfig
check "git-alias-config2" grep "insteadOf = https://rgr.com" $HOME/.gitconfig

check "netrc" test -e $HOME/.netrc
check "netrc-machine" grep "machine dev.azure.com" $HOME/.netrc
check "netrc-login" grep "login pat" $HOME/.netrc
check "netrc-password" grep "password abc123" $HOME/.netrc

check "npmrc" test -e $HOME/.npmrc
check "npmrc-reg-user" grep "//pkgs.dev.azure.com/rickardgranberg/patissuer/_packaging/rgr_feed/npm/registry/:username=rickardgranberg" $HOME/.npmrc
check "npmrc-reg-password" grep "//pkgs.dev.azure.com/rickardgranberg/patissuer/_packaging/rgr_feed/npm/registry/:_password=YWJjMTIz" $HOME/.npmrc
check "npmrc-user" grep "//pkgs.dev.azure.com/rickardgranberg/patissuer/_packaging/rgr_feed/npm/:username=rickardgranberg" $HOME/.npmrc
check "npmrc-password" grep "//pkgs.dev.azure.com/rickardgranberg/patissuer/_packaging/rgr_feed/npm/:_password=YWJjMTIz" $HOME/.npmrc

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults