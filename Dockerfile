FROM ubuntu:bionic
LABEL Maintainer Bas Kraai <bas@kraai.email>

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update \
    && apt-get install --no-install-recommends -y git rsync \
    openssh-client nginx ca-certificates wget nmap \
    && rm -rf /var/lib/apt/lists/*

# Fix for Let's encrypt CA
## https://www.codingmerc.com/blog/add-lets-encrypt-root-certificate-linux/
RUN cd /usr/local/share/ca-certificates/ \
    && wget "https://letsencrypt.org/certs/isrgrootx1.pem" -O isrgrootx1.crt && chmod 644 isrgrootx1.crt \
    && wget "https://letsencrypt.org/certs/isrg-root-x2-cross-signed.pem" -O isrg-root-x2-cross-signed.crt && chmod 644 isrg-root-x2-cross-signed.crt \
    && update-ca-certificates

COPY ./.scripts/helpfunctions.sh /
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
