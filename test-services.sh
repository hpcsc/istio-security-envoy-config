#!/bin/bash

TYPE=${1:-istio}

SERVICES=("foo" "bar")
if [ "${TYPE}" = "all" ]; then
    SERVICES=("foo" "bar" "legacy")
fi

for from in ${SERVICES[@]}; do
    for to in ${SERVICES[@]}; do
        kubectl exec \
            $(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name}) \
            -c sleep \
            -n ${from} -- \
            curl "http://httpbin.${to}:8000/ip" -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n";
    done;
done
