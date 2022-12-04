FROM alpine:latest as builder
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -P /tmp/
RUN mkdir /ngrok
RUN tar -xvf /tmp/ngrok-v3-stable-linux-amd64.tgz -C /ngrok

FROM alpine:latest
# Pass auth token to use
ARG AUTH_TOKEN
COPY --from=builder /ngrok/ngrok /usr/bin/ngrok
RUN ngrok config add-authtoken $AUTH_TOKEN
ENTRYPOINT ["ngrok", "http", "80"]

