# Explore Docker

###### Just exploring and trying to learn docker.

Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications, whether on laptops, data center VMs, or the cloud.

I heard it is used to deploye a machine. So, I got intersted and started exploring. 👅

## Table of Content

- [Installation](#installation)
  - [Basic Commands](#basic-commands)
    - [run](#run)
    - [ps](#ps)
    - [stop](#stop)
    - [rm](#rm)
    - [images](#images)
    - [rmi](#rmi)
    - [pull](#pull)
    - [exec](#exec)
    - [inspect](#inspect)
    - [log](#log)
  - [Docker Run](#docker-run)
    - [Options](#options)
  - [Docker Image](#docker-image)
  - [CMD, ENTRYPOINT and Passing Command](#cmd--entrypoint-and-passing-command)
  - [Network](#network)
    - [Network Types](#network-types)
      - [Bridge](#bridge)
      - [Host](#host)
      - [None](#none)
      - [User defined networks](#user-defined-networks)
    - [Inspect Network](#inspect-network)
  - [Storage, Volume Mapping](#storage--volume-mapping)
  - [Port Mapping](#port-mapping)

## Installation

I'm using Manjaro right now. So I used pacman to install docker on my system.

```sh
sudo pacman -S docker
```

After installing I started docker daemon by running

```sh
systemctl start docker
```

To check if docker is correctly installed, I started a funny container by running:

```sh
sudo docker run docker/whalesay cowsay Hello-KhanShaheb
```

As the container isn't downloaded it downloaded the container and said:

```
 __________________
< Hello-KhanShaheb >
 ------------------
    \
     \
      \
                    ##        .
              ## ## ##       ==
           ## ## ## ##      ===
       /""""""""""""""""___/ ===
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
       \______ o          __/
        \    \        __/
          \____\______/
```

## Basic Commands

#### run

This command is used to run a docker instance. If the instance isn't locally available, it'll pull it first.
Example:

```sh
docker run nginx
```

#### ps

`docker ps` is used to check currently running instances in docker host.

`docker ps -a` is used to check all instances in docker host either running or not.

#### stop

We can stop a running instance by passing the name or id of the instance to `docker stop name/id`.

#### rm

`docker rm name/id` is used to remove an instance x from docker.

#### images

`docker images` gives the list of all locally available images.

#### rmi

`docker rmi name/id` is used to remove a locally available image. But all dependent container should be removed first.

#### pull

`docker pull name` downloads an image. `docker run` does this too if the image isn't available locally.

#### exec

`docker exec name command` is used to execute a command in the instance.

#### inspect

`docker inspect name` shows full information about an instance.

#### log

`docker log name` shows logs of an instance.

## Docker Run

This command is used to run a docker instance. If the instance isn't locally available, it'll pull it first.
Example:

```sh
docker run nginx
```

By default this command select the latest version of the instance. To run a different version:

```sh
docker run nginx:1.0
```

#### Options

- `-i` is for interactive mode
- `-t` is for terminal (`-it` is used for fully interactive mode)
- `-p local_port:docker_port` is used for port mapping
- `-v /local/path:/doceker/path` is used for volume mapping
- `-e` is used to pass env variable
- `-d` option runs the container in detatched mode.

## Docker Image

To create a docker image, a dockerfile must be created. A dockerfile is a set of instructions that will run in the docker instance. Suppose we want to run a cpp file in a docker instance. We can create the docker file like this:

```dockerfile
# First we have to select an OS or another image to be the base of the instance
FROM ubuntu

# Then we have to specify a set of instructions
RUN apt -y update
RUN apt -y install g++
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN g++ -o test test.cpp
CMD ["./test"]
```

Then we have to build a local docker image by running:

```sh
docker build -t tagname .
```

This will generate the local docker image. Now we can run the image as any other image using:

```sh
docker run tagname
```

## CMD, ENTRYPOINT and Passing Command

We can run a command in a dockerfile by using CMD. Like the example in the previous section, we ran `./test` using the CMD command.

If we want to pass a value to the command, we can use ENTRYPOINT. Entry point allows us to send arguement through run command.

```dockerfile
FROM ubuntu
ENTRYPOINT ["sleep"]
```

Now to pass arguement to the command we can do:

```sh
docker run ubuntu 5
```

We can use a default arguement using CMD.

```dockerfile
FROM ubuntu
ENTRYPOINT ["sleep"]
CMD ["5"]
```

Passed arguement will overwrite the CMD command. Or we can pass the whole command through docker run.

```sh
docker run ubuntu sleep 5
```

To overwrite ENTRYPOINT we can use `-entrypoint` option on `docker run`.

## Network

### Network Types

There are three default network type in docker. They are:

#### Bridge

This is selected as the default network type when we run a docker instance without saying the network type. In this mode, every docker instance gets it's own ip address.

#### Host

If we run `docker run --network=host ubuntu` the instance gets the ip address of the host. And all of the port used by the instance is the ports of the host device. As a result two instances with host network can't use the same address.

It is usally used to run a server in a port.

#### None

If we run `docker run --network=none ubuntu` the instance won't be connected to any network.

#### User defined networks

We can define a network too. To define a network:

```sh
docker network create --driver bridge --subnet 182.168.0.0/16 name_of_network
```

To check available network:

```sh
docker network ls
```

### Inspect Network

We can run `docker inspect instance_name` to check the instance's all information. The network info is available here too.

## Storage, Volume Mapping

When installing docker in a linux system it creates a folder in `/var/lib/docker` and all of the contents of docker stays here.

By default docker removes or resets all of the files during closing which are created in that session. We can mount or map a directory to docker using `--mount` or `-v` so that the files remain intact even after the instance is closed.

## Port Mapping

By default docker creates a bridge network for all of the instances using a internal IP address. We can map a port like `docker run -p 3000:80 server`. This will map the 80 port of the instance to 3000 port of the host.

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>
