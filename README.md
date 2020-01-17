[![Docker pulls](https://img.shields.io/docker/pulls/ludmann/theia-ide.svg?maxAge=3600)](https://hub.docker.com/r/ludmann/theia-ide/) [![Docker Stars](https://img.shields.io/docker/stars/ludmann/theia-ide.svg?maxAge=3600)](https://hub.docker.com/r/ludmann/theia-ide/) [![Docker layers](https://images.microbadger.com/badges/image/ludmann/theia-ide.svg)](https://microbadger.com/images/ludmann/theia-ide) ![License](https://img.shields.io/badge/License-MIT-blue.svg?maxAge=3600)

# Theia IDE Docker Images


## Supported tags and respective `Dockerfile` links

- [`heavy_latest`, `latest`](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/Dockerfile)
- [`heavy_next`, `next`](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/Dockerfile)
- [`light_latest`](https://github.com/corneliusludmann/theia-docker/blob/master/light/Dockerfile)
- [`light_next`](https://github.com/corneliusludmann/theia-docker/blob/master/light/Dockerfile)
- [`YYYYMMDD-HHMMSS_heavy_latest`, `YYYYMMDD-HHMMSS_latest`](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/Dockerfile)
- [`YYYYMMDD-HHMMSS_heavy_next`, `YYYYMMDD-HHMMSS_next`](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/Dockerfile)
- [`YYYYMMDD-HHMMSS_light_latest`](https://github.com/corneliusludmann/theia-docker/blob/master/light/Dockerfile)
- [`YYYYMMDD-HHMMSS_light_next`](https://github.com/corneliusludmann/theia-docker/blob/master/light/Dockerfile)


## What is Theia IDE?

> [Eclipse Theia](https://github.com/eclipse-theia/theia) is an extensible platform to develop full-fledged multi-language Cloud & Desktop IDE-like products with state-of-the-art web technologies.

See also:
- [Theia IDE Website](https://theia-ide.org/)
- [Official Theia IDE Docker Images](https://hub.docker.com/r/theiaide/theia/)

## About these Theia IDE Images

### Image Variants

#### light vs. heavy
The Theia IDE image of this repository comes in 2 flavors:
- [**light**](https://github.com/corneliusludmann/theia-docker/blob/master/light/Dockerfile) – A basic image based on [Alpine](https://alpinelinux.org/) with support for some common file syntaxes as JSON, XML etc.
- [**heavy**](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/Dockerfile) – A feature-rich image based in [Arch Linux](https://www.archlinux.org/) with support for a bunch of languages and up-to-date development tools. See [heavy/archpks/](https://github.com/corneliusludmann/theia-docker/tree/master/heavy/archpks) for a list of supported languages and tools. Want to provide additional languages or tools? PRs are very welcome!

These images are shipped with some [VSCode](https://github.com/microsoft/vscode) compatible plugins. These plugins are listed in [`light/plugins.txt`](https://github.com/corneliusludmann/theia-docker/blob/master/light/plugins.txt) resp. [`heavy/plugins.txt`](https://github.com/corneliusludmann/theia-docker/blob/master/heavy/plugins.txt). Feel free to propose additional plugins by opening a PR!

#### latest vs. next
Theia IDE is shipped in two versions: `lastest` and `next`. `latest` is a stable version that is published occasionally and `next` is built automatically from the Theia `master` branch (which should usually be stable as well). For each flavor of this image there is a `latest` and `next` variant that uses the corresponding Theia version.

#### time-stamped tags
Each build tags the resulting images additionally with a timestamp (`YYYYMMDD-HHMMSS` prefix). This allows to pin your setting to a specific build and revert to a previous image at any time.

### Features

#### fixuid
These images use [fixuid](https://github.com/boxboat/fixuid) to adjust the user and group ID of the container user to match the IDs of the host user. Run Docker with `-u <userid>:<groupid>` (e.g., `-u $(id -u):$(id -g)`) to provide the IDs of your user. Now, the user that runs Theia has the same user and group ID as your host user and all files in `/workspace` are writeable without permission problems.

#### tini
These images use [tini](https://github.com/krallin/tini) as `init` process. That allows to stop the container with `Ctrl + C`. See the [README.md of `tini`](https://github.com/krallin/tini/blob/master/README.md) for more information why you should use a separate `init` process like `tini`.

#### sudo
The `heavy` image provides `root` rights via `sudo` without password. You can remove `sudo` by mounting the [`remove-sudo.sh`](https://github.com/corneliusludmann/theia-docker/blob/master/extensions/entrypoint.d/remove-sudo.sh) extension like this: `-v /path/to/remove-sudo.sh:/entrypoint.d/`


## How to Use these Images

Start the images like this:

```shell
$ docker run -p 3000:3000 -u $(id -u):$(id -g) -v $(pwd):/workspace ludmann/theia-ide
```

* `-u <userid>:<groupid>` sets the user and group ID of the Theia user inside the container.
* `-v <workspace path on host>:/workspace` mounts the workspace directory from the host.

After starting the container open http://localhost:3000 in your browser.

## Extensions for these Images

There are two ways to extend these images just by mounting files into the container. Every shell script that is mounted in the folder `/entrypoint.d/` will be executed by `source` in the `entrypoint.sh` Bash script on container start. The [`extensions`](https://github.com/corneliusludmann/theia-docker/tree/master/extensions/entrypoint.d) folder has some examples. Besides that, every shell script that is mounted in `/home/theia/.bashrc.d/` will be executed by `source` in `bash.rc` each time a new terminal is opened in Theia.


## Automatic Build Pipeline

You'll find the resulting Docker images on Docker Hub at [ludmann/theia-ide](https://hub.docker.com/r/ludmann/theia-ide). They are [automatically build](https://docs.docker.com/docker-hub/builds/) by Docker Hub on every push to this repository. Additionally, a build is automatically triggered on every push to the GitLab project [corneliusludmann/theia](https://gitlab.com/corneliusludmann/theia), which automatically [mirrors](https://gitlab.com/help/user/project/repository/repository_mirroring.md) the official [Theia GitHub repository](https://github.com/eclipse-theia/theia). It [triggers](https://docs.docker.com/docker-hub/webhooks/) the build on Docker Hub with a [GitLab webhook](https://gitlab.com/help/user/project/integrations/webhooks).

For every branch of this repository, a build will be triggered for the Theia versions `latest` and `next`. The images are tagged `<branch>_latest` and `<branch>_next`. This will be achieved with the [Docker Hub hook](https://docs.docker.com/docker-hub/builds/advanced/) `hooks/build`. The master branch will be tagged `latest` and `next` as well (without the branch name). Additionally, the images will be tagged with a timestamp via the hook `hook/post_push` to keep previous versions addressable.


## Examine and Contribute

Fell free to open this repository in Gitpod – the one-click web IDE based on Theia:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/corneliusludmann/theia-docker)

## License
The [repository](https://github.com/corneliusludmann/texlive-docker) is licensed under the [MIT License](https://github.com/corneliusludmann/texlive-docker/blob/master/LICENSE).
