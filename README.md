# ngrok reverse proxy
[ngrok](https://ngrok.com) is a globally distributed reverse proxy fronting your web services running in any cloud or private network, or your machine.

## Exposing a local website to internet using ngrok

- Create a shared docker brige network for ngrok and your website to share:
```
docker network create --driver=bridge --subnet=192.168.0.0/16 ngrok-bridge-network.
```
- Build a docker images using `ngrok.dockerfile` to run ngrok inside a container.
```
docker build --build-arg AUTH_TOKEN=<pass-your-token-here> -t ngrok:latest . -f ngrok.dockerfile
```
- Bring up your website in a docker container in the shared bridge network. I'm using `nginx` image to simulate my website.
```
docker run -it -d --name=webserver --network=ngrok-bridge-network --ip=192.168.0.2 nginx
```
- Bring up `ngrok` container to forward traffic received on 80 to the local website.
```
docker run -it --name=ngrok-sidecar --ip=192.168.0.3 --network=ngrok-bridge-network --entrypoint /usr/bin/ngrok ngrok:latest http 192.168.0.2:80
```
