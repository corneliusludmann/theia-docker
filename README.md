# Theia IDE Docker

> This is a repository for building Docker images for the [Theia IDE](https://theia-ide.org/). This is mainly for testing purposes. You'll find the official ones in the GitHub repository [theia-ide/theia-apps](https://github.com/theia-ide/theia-apps/) and on Docker Hub at [theiaide](https://hub.docker.com/u/theiaide).

You'll find the resulting Docker images on Docker Hub at [ludmann/theia-ide](https://hub.docker.com/r/ludmann/theia-ide). They are [automatically build](https://docs.docker.com/docker-hub/builds/) by Docker Hub on every push to this repository. Additionally, a build is automatically triggered on every push to the GitLab project [corneliusludmann/theia](https://gitlab.com/corneliusludmann/theia), which automatically [mirrors](https://gitlab.com/help/user/project/repository/repository_mirroring.md) the official [Theia GitHub repository](https://github.com/eclipse-theia/theia). It [triggers](https://docs.docker.com/docker-hub/webhooks/) the build on Docker Hub with a [GitLab webhook](https://gitlab.com/help/user/project/integrations/webhooks).

For every branch of this repository, a build will be triggered for the Theia versions `latest` and `next`. The images are tagged `<branch>_latest` and `<branch>_next`. This will be achieved with the [Docker Hub hook](https://docs.docker.com/docker-hub/builds/advanced/) `hooks/build`. The master branch will be tagged `latest` and `next` as well (without the branch name). Additionally, the images will be tagged with a timestamp via the hook `hook/post_push` to keep previous versions addressable.


## Examine and Contribute

Fell free to open this repository in Gitpod (which is powered by Theia as well):

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/corneliusludmann/theia-docker)
