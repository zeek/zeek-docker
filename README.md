# Zeek Docker

## Overview

The automation in this repo provides a convenient and reproducible way for
to standup a clean Zeek environment in a docker container.

The automation compiles Zeek from source code and installs it within a
Docker container.

## Install pre-requisites

If installing on Mac OSX, you will require the following.

* [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/) ([install](https://docs.docker.com/docker-for-mac/install/))
* [Homebrew](https://brew.sh/) ([install](https://brew.sh/))

Important! Docker Desktop for Mac uses a VM behind the scenes to host the
Docker runtime environment. By default it allocates 2 GB of RAM to the
VM. This is not enough to compile Zeek! If you try with the default RAM
allocation, you will hit a compile error that looks something like this:

    c++: internal compiler error: Killed (program cc1plus)
    Please submit a full bug report,
    with preprocessed source if appropriate.
    See <file:///usr/share/doc/gcc-7/README.Bugs> for instructions.

This is due to the VM hitting an Out Of Memory condition. To avoid this
you will need to allocate more RAM to the VM. Click on the Docker Icon in
your menubar and select "Preferences". Click on the "Advanced" tab and then
use the slider to select 8 GB of RAM (6 also works, but use 8 just in case).
Docker Desktop will restart and then you will be ready to go.

Due to recent changes in the way Maxmind supplies their
GeoLite2 Databases a (free) license is required to download them.
The steps to obtain the license are described in the blog post
[here](https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/):

1. [Sign up for a MaxMind account](https://www.maxmind.com/en/geolite2/signup) (no purchase required)
2. Set your password and create a [license key](https://www.maxmind.com/en/accounts/current/license-key)
3. Setup your download mechanism by using our GeoIP Update program or
   creating a [direct download script](https://dev.maxmind.com/geoip/geoipupdate/#Direct_Downloads)

Once you have gone through all of these steps, set the MAXMIND\_LICENSE\_KEY
variable in your environment to enable direct download of the databases:

    $ export MAXMIND_LICENSE_KEY=<value of your license key>
    
## Check out the code

Use the following command to clone this repo:

    git clone git@github.com:zeek/zeek-docker.git

## Build your Zeek container

To build your Zeek container, type in the commands below:

    $ cd zeek-docker
    $ make build-stamp_3.0.0

Note: If you want to build a Debug build, you can specify BUILD_TYPE=Debug (default is Release)

That's it! Now watch as the wonders of automation unfold, and your
Zeek container is built. You should see something like this on your
terminal console:

    ...
    Step 24/24 : CMD /bin/bash -l
    ---> Running in c1263b7d2ea3
    Removing intermediate container c1263b7d2ea3
    ---> 5bc774250a9a
    Successfully built 5bc774250a9a
    Successfully tagged broplatform/bro:3.0.0
    touch build-stamp_3.0.0
    $

Once the container has been built, check to make sure the container image
is available in your local docker registry:

    $ docker images  | grep -e broplatform -e REPO
    REPOSITORY       TAG   IMAGE ID     CREATED        SIZE
    broplatform/bro  3.0.0 5bc774250a9a 8 minutes ago  215MB

Great! Let's fire it up!

## Use your container

Run the following command to start your container and access it via an
interactive bash shell:

    $ docker run -it -v `pwd`:/pcap broplatform/bro:3.0.0 /bin/bash
    root@3535953ccd99:/# which zeek
    /zeek/bin//zeek

Congratulations! You are up and running with Zeek!
