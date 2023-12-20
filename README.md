# docker_tls_observable_gateway
TLS Gateway features:
- Support for bidirectional authentication
- Runs in docker 
- Outlines TLS premaster keys, which can be used by wireshark to decipher TLS
- Compilation of Peter Wu's wireshark-notes project for the shared library libsslkeylog.so, which is used with LD_PRELOAD
- Uses socat for establishing a TLS connection



## Build image
```bash
docker image build -t my_tls_gateway .
``` 

## Run with interactive bash
We instantiate a container and open a bash. Then we pass the target hostport as parameter to the script.
In host:
```bash
mkdir -p /tmp/sslkeys_h && docker container run -ti -v /tmp/sslkeys_h:/tmp/sslkeys_g -p 8080:1234 my_tls_gateway bash 
```
Inside guest, either:
```bash
TARGET_HOSTPORT="yourdomain.com:443" tls_gw_bidirectional
```
or:
```bash
tls_gw_bidirectional "yourdomain.com:443"
```

## Run without bash
In your host:
```bash
mkdir -p /tmp/sslkeys_h && docker container run -v /tmp/sslkeys_h:/tmp/sslkeys_g -p 8080:1234 -e TARGET_HOSTPORT="yourdomain.com::443" my_tls_gateway tls_gw_bidirectional
```


