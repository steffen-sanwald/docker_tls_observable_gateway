FROM debian:buster
WORKDIR	/opt
RUN	apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential openssl python3 unzip bc wget curl git libssl-dev tcpdump vim socat netcat

ARG ca_cert_path=certs/ca.crt
ARG client_cert_path=certs/client.crt 
ARG client_key_path=keys/client.key
#ENV TARGET_HOSTPORT="yourdomain.com:443"
ARG tls_gw_scripts_path="/usr/local/bin/"


RUN git clone https://git.lekensteyn.nl/peter/wireshark-notes/ && cd wireshark-notes/src && make && mkdir /opt/sslkeylog && cp /opt/wireshark-notes/src/libsslkeylog.so /opt/sslkeylog  && mkdir /tmp/sslkeys_g
RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=0/g' /etc/ssl/openssl.cnf


RUN mkdir -p /opt/certs && mkdir -p /opt/keys

COPY ${ca_cert_path} /opt/certs/
COPY ${client_cert_path} /opt/certs/
COPY ${client_key_path} /opt/keys/

# use socat as proxy
COPY scripts ${tls_gw_scripts_path}
RUN chmod +x ${tls_gw_scripts_path}/*

# docker image build -t my_tls_gateway .
# run with shared folder for keys and to use the socat proxy
# bash approach and pass target as parameter
#mkdir -p /tmp/sslkeys_h && docker container run -ti -v /tmp/sslkeys_h:/tmp/sslkeys_g -p 8080:1234 my_tls_gateway bash 
#inside guest:
#TARGET_HOSTPORT="yourdomain.com:443" tls_gw_bidirectional

#mkdir -p /tmp/sslkeys_h && docker container run -v /tmp/sslkeys_h:/tmp/sslkeys_g -p 8080:1234 -e TARGET_HOSTPORT="yourdomain.com::443" my_tls_gateway tls_gw_bidirectional