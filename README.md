# Istio Security Envoy Config

Envoy configs dumped from Istio when going through security features of Istio

## To dump configs

```
./dump-config.sh
```

## Test connections between services

```
./test-services.sh # only services with sidecars
./test-services.sh all # include legacy services
```
