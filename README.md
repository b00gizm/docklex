# Docklex

A minimalistic development environment for [Silex](http://silex.sensiolabs.org) apps using
[Docker](http://www.docker.io).

## Wat?!

The goal of this little experiment is to provide an isolated and self- contained
development environment for Silex applications. It uses Docker to build a
lightweight Linux container installed and preconfigured with everything you need
to get going:

* PHP
* [Nginx](http://nginx.com)
* [Composer](http://getcomposer.org)

## Why?

* Setting up a new development machine is a tedious and error prone process
* You don't want to pollute the file system of your shiny new Mac or PC
* It streamlines your and your team's development process
* No more, "Well, it worked on my machine!"
* You can create your own PaaS
* Docker is awesome!
* And Silex, too.

## Requirements

You need to install [Docker](http://www.docker.io) on your system. If your
development machine runs Linux, you're good to go. If you're running OSX or
Windows, you have to install [Vagrant](http://www.vagrantup.com) first, since
Docker only runs natively on Linux hosts (see below).

* [Vagrant installation guide](http://docs.vagrantup.com/v2/installation/index.html)
* [Docker installation guides](https://www.docker.io/gettingstarted/#h_installation)

## Usage

Clone this repository and `cd` into it.

    git clone https://github.com/b00giZm/docklex.git
    cd docklex

### Spin up Vagrant (optional)

If you're on OSX or Windows, spin up Vagrant via `vagrant up`. A basic Vagrant file is included with this repo.

    Vagrant::Config.run do |config|
      config.vm.box = "raring"
      config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"
      config.vm.forward_port 8880, 8880
      config.vm.share_folder("vagrant-root", "/vagrant", ".")
      Vagrant::Config.run do |config|
        config.vm.customize ["modifyvm", :id, "--memory", 512]
      end
    end

This should create a VM running [Ubuntu](http://www.ubuntu.com) 13.04. After
booting, you can `ssh` into it via `vagrant ssh`. You can then follow the
[detailed installation
guides](http://docs.docker.io/en/latest/installation/ubuntulinux/) for
installing Docker on a Ubuntu host system.

### Build the Docker container

The following will build the Docker container for you. This might take some
while depending on your system.

    sudo docker build -t docklex .

Don't forget the `.` at the end of the line. The output looks similar to this:

    vagrant@vagrant-ubuntu-raring-64:/vagrant$ sudo docker build -t docklex .
    Uploading context 2867200 bytes
    Step 1 : FROM ubuntu
     ---> 8dbd9e392a96
    Step 2 : RUN echo "deb http://archive.ubuntu.com/ubuntu raring main restricted universe multiverse" > /etc/apt/sources.list
     ---> b4bbb2fa389e
    ...
    Step 11 : CMD ["sh", "-c", "cd /var/www/docklex && composer update && service php5-fpm start && nginx"]
     ---> Running in 99898882ef82
     ---> 6c5964f10528
    Successfully built 6c5964f10528

What this does:

* It pulls a Ubuntu base image for the container
* It installs PHP, Nginx, Composer and some other tools inside the container
* It copies the app's Nginx configuration to the container
* It exposes port 80 (Nginx) to the host system

### Starting the container

To start the container, use the following command:

    sudo docker run -v <local_path>:/var/www/docklex -p <port>:80 docklex

`local_path` is the path to the project root and `port` is the (external) port
you want to use on your host system for forwarding the requests to the
container's (internal) port 80. Since I'm on OSX and Vagrant, I'd use the
following:

    sudo docker run -v /vagrant:/var/www/docklex -p 8880:80 docklex

If you want to run the container as daemon, add the `-d` flag.

    sudo docker run -d -v /vagrant:/var/www/docklex -p 8880:80 docklex

What this does:

* It creates a [volume](http://blog.docker.io/2013/07/docker-0-5-0-external-volumes-advanced-networking-self-hosted-registry/#external_volumes) (think: symlink) with the project root as source so that you can edit code without needing to rebuild or restart the container in order to see your changes.
* It forwards all requests from `port` to port 80 of the container
* It installs/updates Composer dependecies
* It starts Nginx and PHP-FPM

Now start up a browser of your choice and navigate to `http://localhost:8880`

![Docklex running in the browser](http://i.imgur.com/ak23aUA.png)

**BOOM!** Silex running inside a Docker container.

### Stopping the container

You can stop the container via `CTRL-C`. If you're running the container as
daemon, check out the output of `sudo docker ps`.

    vagrant@vagrant-ubuntu-raring-64:/vagrant$ sudo docker ps
    ID                  IMAGE            COMMAND                CREATED             STATUS              PORTS
    d2925096172e        docklex:latest   sh -c cd /var/www/do   10 seconds ago      Up 9 seconds        8880->80

and use `sudo docker stop <ID>` to stop the container.

## License

Docklex is licensed under the [MIT license](http://opensource.org/licenses/MIT).

Created by [@b00gizm](https://twitter.com/b00gizm).
