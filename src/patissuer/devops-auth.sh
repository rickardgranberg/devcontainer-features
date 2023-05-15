#!/usr/bin/env bash

function issue_token() {
    local token_file=${HOME}/.patissuer/${TOKEN_VAR,,}.json
    if [[ -n "${1}" ]]; then  
        export "${TOKEN_VAR}"=${1}
        return
    fi

    # This is mostly for when unit testing this script:
    if [[ -z "${PATISSUER_AAD_CLIENT_ID}" ]]; then
        echo "Incomplete config, skipping token issue"
        return
    fi

    # This is for scenarios where xdg-open has not yet been configured, such as during feature install:
    if [[ -z "\${BROWSER}" ]]; then
        echo "No known default browser, exiting"
        return
    fi

    if [[ -f "${token_file}" ]]; then
        local token=$(cat ${token_file} | jq -r .token)
        local expiry=$(cat ${token_file} | jq -r .validTo)
    fi

    local now=$(date --utc +"%Y-%m-%dT%H:%M:%SZ")

    if [[ ! -f "${token_file}" || ${now} > ${expiry}  ]]; then

        local tmp_file=/tmp/.gogettoken.json
        rm -rf $tmp_file
        echo "Logging in to issue new Personal Access Token for access to ${AZDO_ORG_PROJECT_NAME} AzDO Private Resources..."
        # Issue new token...
        patissuer --output json --output-file ${tmp_file} issue "PatIssuer Access Token (${PATISSUER_TOKEN_SCOPE})"
        if [[ ${?} -ne 0 ]]; then
            echo "Failed to issue PAT, exiting..."
            sleep 5
            exit 1
        fi
        echo "Token issued"
        mv -f $tmp_file $token_file 2>&1 > /dev/null
        local token=$(cat ${token_file} | jq -r .token)
        local expiry=$(cat ${token_file} | jq -r .validTo)
    fi

    export "${TOKEN_VAR}"=${token}
}

function update_gitconfig() {
    if [[ -z "${GIT_ALIAS}" || -z "${AZDO_FQDN}" ]]; then
        return
    fi
    git config --global "url.https://pat@${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_git.insteadOf" "https://${GIT_ALIAS}"
}

function create_netrc() {
     if [[ -z "${AZDO_FQDN}" || -z "$1" ]]; then
        return
    fi
    local token=$1
    local netrc=${HOME}/.netrc
    if [[ -f ${netrc} ]]; then
        rm -rf ${netrc}
    fi
    cat <<-EOF > ${netrc}
machine ${AZDO_FQDN}
login pat
password ${token}

EOF
}

function create_npmrc() {
    if [[ -z "${AZDO_NPM_ARTIFACT_FEED}" || -z "$1" ]]; then
        return
    fi

    local token=$(echo -n "$1" | base64)
    local npmrc=${HOME}/.npmrc
    if [[ -f ${npmrc} ]]; then
        rm -rf ${npmrc}
    fi
    cat <<-EOF > ${npmrc}
; begin auth token
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/registry/:username=${AZDO_ORG_NAME}
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/registry/:_password=${token}
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/registry/:email=npm requires email to be set but doesn't use the value
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/:username=${AZDO_ORG_NAME}
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/:_password=${token}
//pkgs.${AZDO_FQDN}/${AZDO_ORG_PROJECT_NAME}/_packaging/${AZDO_NPM_ARTIFACT_FEED}/npm/:email=npm requires email to be set but doesn't use the value
; end auth token
EOF
}

function main() {
    if [ -f ${HOME}/.patissuer/patissuer.env ]; then
        . ${HOME}/.patissuer/patissuer.env
    fi
    issue_token $1
    update_gitconfig
    create_netrc ${!TOKEN_VAR}
    create_npmrc ${!TOKEN_VAR}
}

main $@