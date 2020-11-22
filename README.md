# Nginx container with Git

![Travis (.com) branch](https://img.shields.io/github/workflow/status/baskraai/docker-nginx-git/CI?label=Build%20Main&style=flat-square)

This is a container with NGINX and a Git client for pulling the config.
The purpose of this host is a running a port-redirect NGINX instaces with auto-git pulling of config.
This image is not based on the official NGINX Docker container, but on the ubuntu install of nginx.

## Repo's

This images can use two repo's:

 - NGINX config

These can be the same repo, but you need to put the files in the right path:

 - nginx config : <git_repo>/nginx

## Ports

This container exposes no default ports.

## Usage

You can use this image with docker run and docker-compose.
Below are examples for both.

### Docker run

The most basic docker run config is:

```bash

docker run --name "nginx-git" -e CONFIG_MOUNT="/config" -e SSH_KEY_MOUNT="/keys" -v "$(pwd)/keys":/keys -v "$(pwd)/config":/config baskraai/nginx-git

```

 1. Create the following directories: `config` and `keys`
 2. You need to create a id\_ecdsa ssh key in de keys directory, for now the only supported type is ecdsa.
 3. run the `docker run` command above.

### Parameters

You can use the following parameters with this container:

| Parameter | meaning |
| :---: | --- |
| --hostname | Used to set the NGINX servername |

### Environment variables

You can use the following environment variables with this container:

| Variable | Required | meaning | values |
| :---: | --- | --- | --- |
| NAME | Required | Name of the user | string |
| SSH\_KEY\_MOUNT | Optional | The directory with the ssh keys used for git clone | linux path |
| SSH\_PRIVKEY | Optional |Give the private ssh key directly | SSH private key |
| SSH\_PUBKEY | Optional | Give the public ssh key directly | SSH public key |
| CONFIG\_REPO | Required | The repo url for the NGINX configuration | git ssh link |
| CONFIG\_MOUNT | Required | The location of the directory mounted NGINX config | linux path |

## Extend image

```Dockerfile
FROM baskraai/nginx-git:latest
RUN apt-get update \
    && apt-get install -y <packages> \
    && rm -rf /var/lib/apt/lists/
```

With this Dockerfile the rest of the container keeps working as expected.

### Todo
