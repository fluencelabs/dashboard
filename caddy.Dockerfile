FROM caddy
WORKDIR /
COPY ./dist /dist
COPY Caddyfile /Caddyfile

VOLUME /data

#CMD ["caddy", "file-server", "--root", "/bundle", "--browse"]
CMD ["caddy", "run", "--config", "/Caddyfile"]

# DO NOT FORGET TO USE VOLUME OR CERTBOT WILL BAN: -v caddy_data:/data
