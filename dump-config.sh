#!/bin/bash

function dump_config() {
    local NS=$1

    kubectl config set-context --current --namespace=${NS}

    mkdir -p ./${NS} && pushd ./${NS}

    local CONFIG_TYPES=(bootstrap cluster endpoint listener route)
    local DELIMITED_POD_NAMES=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{","}}{{end}}')
    IFS=',' read -ra POD_NAMES <<< "${DELIMITED_POD_NAMES}"

    for TYPE in "${CONFIG_TYPES[@]}"; do
        rm -rf ./${TYPE}
        mkdir -pv ${TYPE}

        for POD in "${POD_NAMES[@]}"; do
            local FILE_NAME=$(echo ${POD} | sed 's/v\([0-9]\).*/v\1/g').json
            echo "=== Dumping proxy config ${TYPE} for ${POD} to ${FILE_NAME}"
            istioctl proxy-config ${TYPE} ${POD} > ./${TYPE}/${FILE_NAME} -o json
        done
    done

    popd
}

pushd ./envoy-configs

dump_config foo
dump_config bar

popd
