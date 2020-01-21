ARG NODE_VERSION=10

FROM node:${NODE_VERSION}-stretch as builder
ARG THEIA_VERSION=latest
WORKDIR /opt/theia
COPY package.json ./
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


FROM archlinux
COPY archpkgs /archpkgs

RUN pacman -Sy --noconfirm archlinux-keyring && pacman -Syyu --noconfirm && \
	egrep -hv '^[[:blank:]]*#|^[[:blank:]]*$' archpkgs/*.txt | pacman -S --noconfirm - && \
	rm -r /archpkgs
RUN useradd --create-home --user-group -G wheel,docker --shell /bin/bash theia && \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo

USER theia
COPY --chown=theia:theia setup /home/theia/setup
RUN mkdir /home/theia/.theia && \
	mkdir /home/theia/.bashrc.d && \
	(echo; echo 'for file in /home/theia/.bashrc.d/*.sh; do source "$file"; done'; echo) >> /home/theia/.bashrc
RUN mkdir -p /tmp/nvm && cd /tmp/nvm && \
	git clone https://aur.archlinux.org/nvm.git && cd nvm && \
	makepkg -si --clean --noconfirm && cd ~ && rm -r /tmp/nvm && \
	ln -s /usr/share/nvm/init-nvm.sh /home/theia/.bashrc.d/ && \
	source /usr/share/nvm/init-nvm.sh && \
	nvm install 10
RUN for file in /home/theia/setup/*.sh; do sh "$file" || exit 1; done && \
	rm -r /home/theia/setup
USER root

RUN rm -r /var/cache/pacman/pkg

WORKDIR /opt/theia
RUN mkdir /workspace && \
	chown -R theia:theia /workspace && \
	chown -R theia:theia /opt/theia
COPY --from=0 --chown=theia:theia /opt/theia /opt/theia
COPY plugins.txt /opt/theia/plugins/
RUN mkdir -p /opt/theia/plugins && cd /opt/theia/plugins && \
	egrep -v '^[[:blank:]]*#|^[[:blank:]]*$' plugins.txt | while read url; do echo "downloading: $url" && curl -sSLO "$url"; done && \
	rm /opt/theia/plugins/plugins.txt

ENV HOME=/home/theia \
	SHELL=/bin/bash \
	USE_LOCAL_GIT=true \
	THEIA_DEFAULT_PLUGINS=local-dir:/opt/theia/plugins \
	WORKSPACE=/workspace
EXPOSE 3000
RUN USER=theia && \
	GROUP=theia && \
	curl -sSL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
	chown root:root /usr/local/bin/fixuid && \
	chmod 4755 /usr/local/bin/fixuid && \
	mkdir -p /etc/fixuid && \
	printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml
COPY entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /sbin/tini
RUN chmod +x /sbin/tini

USER theia
ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint" ]
