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

check "script-src" grep '. ${HOME}/.patissuer/devops-auth.sh ${GOGET_PAT_TOKEN}' $HOME/.patissuer/entrypoint.sh

check "aad-tentant-id" grep "export PATISSUER_AAD_TENANT_ID=uuid1" $HOME/.patissuer/patissuer.env
check "aad-client-id" grep "export PATISSUER_AAD_CLIENT_ID=" $HOME/.patissuer/patissuer.env
check "org-url" grep "PATISSUER_ORG_URL=https://dev.azure.com/rickardgranberg" $HOME/.patissuer/patissuer.env
check "token-scope" grep "export PATISSUER_TOKEN_SCOPE=vso.code,vso.other" $HOME/.patissuer/patissuer.env

check "azdo-fqdn" grep "export AZDO_FQDN=dev.azure.com" $HOME/.patissuer/patissuer.env
check "azdo-org" grep "export AZDO_ORG_NAME=rickardgranberg" $HOME/.patissuer/patissuer.env
check "azdo-proj" grep "export AZDO_PROJECT_NAME=patissuer" $HOME/.patissuer/patissuer.env
check "azdo-org-proj" grep "export AZDO_ORG_PROJECT_NAME=rickardgranberg/patissuer" $HOME/.patissuer/patissuer.env
check "token-var" grep "export TOKEN_VAR=GOGET_PAT_TOKEN" $HOME/.patissuer/patissuer.env
check "git-alias" grep "export GIT_ALIAS=rgr.com" $HOME/.patissuer/patissuer.env
check "npm-feed" grep "export AZDO_NPM_ARTIFACT_FEED=rgr_feed" $HOME/.patissuer/patissuer.env

check "git-alias-config1" grep "[url "https://pat@dev.azure.com/rickardgranberg/patissuer/_git"]" $HOME/.gitconfig
check "git-alias-config2" grep "insteadOf = https://rgr.com" $HOME/.gitconfig
        
# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults