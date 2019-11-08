ARG NODE_VERSION=10

FROM node:${NODE_VERSION}-alpine
RUN apk add --no-cache make gcc g++ python
ARG THEIA_VERSION=latest
WORKDIR /opt/theia
COPY package.json ./package.json
RUN sed -i "s/THEIA_VERSION/$THEIA_VERSION/g" ./package.json
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

FROM node:${NODE_VERSION}-alpine
RUN apk add --no-cache git openssh bash tini
WORKDIR /opt/theia
RUN mkdir /workspace && \
    chown -R node:node /workspace && \
    chown -R node:node /opt/theia
COPY --from=0 --chown=node:node /opt/theia /opt/theia
EXPOSE 3000
ENV HOME /home/node
ENV SHELL /bin/bash
ENV USE_LOCAL_GIT true
USER node
ENTRYPOINT [ "/sbin/tini", "--", "node", "/opt/theia/src-gen/backend/main.js", "/workspace", "--hostname=0.0.0.0" ]

