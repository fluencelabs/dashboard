FROM caddy
WORKDIR /
COPY ./dist /bundle
COPY Caddyfile /Caddyfile

#RUN printf '\n\
#dash.fluence.dev {\n\
#    try_files /bundle/{path} /bundle/index.html?{query}&p={path}\n\
#}\n\
#'\
#>> /tmp/hello

#RUN echo 'try_files /bundle/{path} /bundle/index.html?{query}&p={path}' > Caddyfile

VOLUME /data

#CMD ["caddy", "file-server", "--root", "/bundle", "--browse"]
CMD ["caddy", "run", "--config", "/Caddyfile"]

# DO NOT FORGET TO USE VOLUME OR CERTBOT WILL BAN: -v caddy_data:/data
