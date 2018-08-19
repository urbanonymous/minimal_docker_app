# minimal_docker_app
Simple app with a complete easy-guide for docker
TODO: networks (docker<->docker, docker<->vps, docker<->world)

# DOCKER GUIDE
## PART 1 - INSTALLATION
* Installation:
In ubuntu 16.04:
    ```
    sudo apt-get update
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
    sudo apt-get update
    apt-cache policy docker-engine
    ```
    Output:
    ```
    docker-engine:
    Installed: (none)
    Candidate: 17.05.0~ce-0~ubuntu-xenial (version could change)
    ...
    ```
    Then...
    ```
    sudo apt-get install -y docker-engine
    sudo systemctl status docker
    ```
    Output:
    ```
    docker.service - Docker Application Container Engine
    Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
    Active: active (running) since Sun 2018-08-19 13:35:15 UTC; 24s ago
    ...
    ```
    After that...
    ```
    control+C
    sudo docker info
    ```
    Output:
    ```
    Containers: 0
    Running: 0
    Paused: 0
    Stopped: 0
    Images: 0
    Server Version: 17.05.0-ce
    ...
    ```

* Testing:

    ```
    sudo docker run hello-world
    ```
    Output:
    ```
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    9db2ca6ccae0: Pull complete
    Digest: sha256:4b8ff392a12ed9ea17784bd3c9a8b1fa3299cac44aca35a85c90c5e3c7afacdc
    Status: Downloaded newer image for hello-world:latest

    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    ...
    ```
    ```
    sudo docker image ls
    ```
    Output:
    ```
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    hello-world         latest              2cb0d9787c4d        5 weeks ago         1.85kB
    ```
    ```
    sudo docker container ls --all
    ```
    Output:
    ```
    CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
    5b71cee88939        hello-world         "/hello"            About a minute ago   Exited (0) About a minute ago                       relaxed_bhabha
    ```


* Cheatsheet (from docker docs):
    ```
    ## List Docker CLI commands
        docker
        docker container --help

    ## Display Docker version and info
        docker --version
        docker version
        docker info

    ## Execute Docker image
        docker run hello-world

    ## List Docker images
        docker image ls
        docker images

    ## List Docker containers (running, all, all in quiet mode)
        docker container ls
        docker container ls --all
        docker container ls -aq
    ```

## PART 2 - SETTING UP
* Creating a Dockerfile:

    **Dockerfile: (Set of rules/actions/configurations in a container/image)**
            
    ```Dockerfile
    # Use a Python runtime as a parent image
    FROM frolvlad/alpine-python3

    # Set metadata about the maintainer of the image
    LABEL maintainer="Urbano Gutierrez <urbano@fatwhale.io>"

    # Set the working directory to /app
    WORKDIR /app

    # Copy the current directory contents into the container at /app
    ADD . /app

    # Update the system
    RUN apk update && apk upgrade && \
        apk add --no-cache \
        bash \
        git \
        openssh \
        build-base \
        make \
        python3-dev

    # Install any needed packages specified in requirements.txt
    RUN pip install --upgrade pip
    RUN pip install -r requirements.txt

    # Run main.py when the container is ready
    CMD ["python", "main.py"]
    ```

* Building the container/image:

    *With our application inside a folder ex: (project_1)*

    *You have few ways to have this project here, clonning it from github, uploading using sftp or ftp ...*
    ```
    cd project_1
    ls project_1
    ```
    Output:
    ```
    Dockerfile  main.py  Readme.md  requirements.txt
    ```
    ```
    docker build -t atagfortheproject .
    ```
    Output:
    ```
    Sending build context to Docker daemon  5.632kB
    Step 1/7 : FROM frolvlad/alpine-python3
    latest: Pulling from frolvlad/alpine-python3
    8e3ba11ec2a2: Pull complete
    83d8aa72cb9b: Pull complete
    Digest: sha256:8d9f2a8e577acac8cc1f6633dbd7731fa764a14e6905e93d8deac2895fe0ceff
    Status: Downloaded newer image for frolvlad/alpine-python3:latest
    ---> a056c2d555fe
    Step 2/7 : LABEL maintainer "Urbano Gutierrez <@urbiGT>"
    ---> Running in 8bcccc02ca05
    ---> 98a0c6f5e85b
    Removing intermediate container 8bcccc02ca05
    Step 3/7 : WORKDIR /app
    ---> 38586ee4b707
    Removing intermediate container f8445b53b9cf
    Step 4/7 : ADD . ./app
    ---> 6f21c6071c75
    Removing intermediate container 0aaf3d89e959
    Step 5/7 : RUN apk update && apk upgrade &&     apk add --no-cache     bash     git     openssh     build-base     make     python3-dev
    ---> Running in 6a00f7e2c8ea
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
    ...
    Removing intermediate container 2c68a17cec27
    Step 8/8 : CMD python main.py
    ---> Running in 903ab59926bd
    ---> 6a51ac14aba4
    Removing intermediate container 903ab59926bd
    Successfully built 6a51ac14aba4
    Successfully tagged projectapp:latest
    ```

    *used projectapp as tag, numbers/ids changes*

* ---**OPTIONAL TO HAVE ACCESS FROM OTHER MACHINES**---

    * Log-in docker:
    
        *register on https://hub.docker.com/*

        *create a repository ex: test-app (set it as private)*

        ```
        sudo docker login
        ```
        Output:
        ```
        Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
        Username: your-username
        Password:
        Login Succeeded
        ```

    * Check the image ID:
        ```
        sudo docker images
        ```
        Output:
        ```
            REPOSITORY              TAG       IMAGE ID         CREATED           SIZE
            yourcontainername     latest    yourimageID     3 minutes ago     1.975 GB
            ...
        ```
        

    * Push image to docker:
        ```
        sudo docker tag yourimageID yourusername/testapp:yourversiontag
        sudo docker push yourusername/testapp
        ```
        Output:
        ```
            The push refers to a repository [docker.io/urbanon/testapp]
            874792b6ae85: Pushed
            471984be847f: Pushed
            b367ab4e7128: Pushed
            5a70acc82f16: Pushed
            af57e8fffa65: Pushed
            f4c48043d646: Mounted from frolvlad/alpine-python3
            73046094a9b8: Mounted from frolvlad/alpine-python3
            yourversiontag: digest: sha256:777bdec7f6d3f2c3d21301bc7c98d3c0c9d661d93b56daf0512721b9e5cc65bf size: 1787
        ```

        *used yourversiontag as tag, 6a51ac14aba4 as IMAGEID*

        *care, this uses a lot of bandwidth*

    * Download a image:

        *after using sudo docker login in another vps*

        ```
        sudo docker pull yourusername/yourappname:yourversiontag
        ```
        Output:

        ```
        yourversiontag: Pulling from urbanon/testapp
        Digest: sha256:777bdec7f6d3f2c3d21301bc7c98d3c0c9d661d93b56daf0512721b9e5cc65bf
        Status: Image is up to date for urbanon/testapp:yourversiontag
        ```

        *used yourversiontag as tag, testapp as app name, urbanon as account, same VPS (Status: Image is up to date... not downloaded)*

## PART 3 - RUNNING
* Run a image:
    ```
    sudo docker run urbanon/testapp:yourversiontag
    ```
    Output:

    `Heey, it should be working`