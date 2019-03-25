**Note:** Docker configuration from this repo is experimental. You can use it at your own risk in accordance with the [GPLv3 license][1].

# LizardFS Docker Cluster

This is a sample configuration of a multiple node [`LizardFS`][2] cluster on [`Docker`][3] using [`Ubuntu 19.04`][4] (codename: [`Disco Dingo`][5]). It consists of a *master server* ([`lizardfs-master`][6]) with a management GUI, a *shadow server*, 3 *chunkservers* ([`lizardfs-chunkserver`][7]) and one *client* machine ([`lizardfs-client`][8]).

After a successful installation you have a fully working LizardFS cluster to play with its features.

## Cluster configurations

**File docker-compose.yml**

- **`172.20.0.2`**: `lizardfs-master`
- **`172.20.0.3`**: `shadow`
- **`172.20.0.11`**: `lizardfs-chunkserver-01`
- **`172.20.0.12`**: `lizardfs-chunkserver-02`
- **`172.20.0.13`**: `lizardfs-chunkserver-03`
- **`172.168.20.0.5`**: `lizardfs-client`
- **`http://172.20.0.2:9425`**: management web interface

## Setup

Install Docker with Docker Composer:

    sudo apt install docker docker-compose

Alternatively you can install it as described on [`docs.docker.com`][9].

### Start LizardFS cluster

Go to repo directory:

    cd lizardfs-docker

Build and run in background:

    docker-compose up

You can also append `-d` flag to run Docker nodes in background, so Docker console output is invisible.

To list all running containers run:

    docker ps

To list all of the containers, not only those that are running, append `--all` flag.

You should have *1 master*, *3 chunkservers* and *1 client* running.

To list Docker images run:

    docker images

If you want to see also intermediate images append `--all` flag.

### Stop the cluster

To stop running containers without removing them run:

    docker-compose stop

They can be started again with `docker-compose start`.

### Restart the stopped cluster

To start existing container run:

    docker-compose start CONTAINER

### Remove containers

To remove stopped service containers run:

    docker-compose rm

You must be in directory with `docker-compose.yml` or `docker-compose.yaml` when running this command.

If you don't want to be asked for removal append `-f` flag. By default, anonymous volumes attached to containers will not be removed. You can override this with `-v`. To list all volumes, use `docker volume ls`.

To remove all unused images, not just dangling ones, run:

    docker image prune --all

This will remove all images without at least one container associated to them.

### Get bash into a running container

    docker exec -i -t container-name /bin/bash

`-i` stands for `--interactive` and keeps `STDIN` open even if not attached. `-t` stands for `--tty` and allocates a pseudo-TTY.

## TODO

- Remove SSH server ([rationale][14])
- Remove copy-paste configuration
- [Make][15] `lizardfs-client` wait for `lizardfs-master` successful start

---

*This repo is fork of the [`psarna`][10]`/`[`lizardfs-docker`][11] which is based on [`moosefs`][12]`/`[`moosefs-docker-cluster`][13].*

[1]: https://github.com/pbeza/lizardfs-docker/blob/master/LICENSE
[2]: https://lizardfs.com/
[3]: https://www.docker.com/
[4]: https://www.ubuntu.com/about/release-cycle
[5]: https://wiki.ubuntu.com/Releases
[6]: https://packages.ubuntu.com/disco/admin/lizardfs-master
[7]: https://packages.ubuntu.com/disco/admin/lizardfs-chunkserver
[8]: https://packages.ubuntu.com/disco/admin/lizardfs-client
[9]: https://docs.docker.com/compose/install/
[10]: https://github.com/psarna
[11]: https://github.com/psarna/lizardfs-docker
[12]: https://github.com/moosefs
[13]: https://github.com/moosefs/moosefs-docker-cluster/
[14]: https://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
[15]: https://stackoverflow.com/questions/31746182/docker-compose-wait-for-container-x-before-starting-y
