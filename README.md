# hygieia-docker

## Building Hygieia in Windows

### Requirements
 1. Install Docker for Windows
	 2. Docker engine version 17.09.0+ or greater is required
	 3. Run 'docker version' to see engine version
 2. Install Git for Windows

### Steps

Create a build container:

    cd build_hygieia
    checkout # Checkout code to c:\data\hyg
    build # Create livxtrm/hy_build build container
    
Get bash in the container and do the build:

    getbash
    # Following in bash within container
    cd /data/hygieia-core
    mvn install package
    cd /data/Hygieia
    mvn install package

After doing the above steps, you will have jars of the various components in c:\data\hyg\Hygieia\[component]\target\[component].jar

To create the docker images for each component:

    cd c:\data\hyg\Hygieia
    docker-compose build

## Building Hygieia on Linux
    
### Requirements
 1. Install docker-compose
	 2. Docker engine version 17.09.0+ or greater is required
	 3. Run 'docker version' to see engine version
 2. Install git

### Steps

Create a build container:

    cd build_hygieia
    ./checkout.sh # Checkout code to ./github
    ./build.sh # Create livxtrm/hy_build build container
    
Get bash in the container and do the build:

    ./getbash.sh
    # Following in bash within container
    cd /data/hygieia-core
    mvn install package
    cd /data/Hygieia
    mvn install package

After doing the above steps, you will have jars of the various components in ./github/Hygieia/[component]/target/[component].jar

To create the docker images for each component:

    cd build_hygieia/github/Hygieia
    docker-compose build

## Running Hygieia

First create "dummy" networks for gitlab and jenkins, as the docker-compose configuration for Hygieia is designed to connect to them:
   
    docker network create gitlab_default
    docker network create jenkins_default

Then start Hygieia
   
    cd docker-compose/hygieia
    docker-compose up -d

To start up Gitlab, Jenkins, and Hygieia and have all 3 connected:

First do the following if you already have Hygieia running by itself with the dummy networks as described above:
    
    cd docker-compose/hygieia
    docker-compose down
    docker network rm gitlab_default # if it exists
    docker network rm jenkins_default # if it exists

Then start Gitlab, Jenkins, and finally Hygieia:

    cd docker-compose/gitlab
    docker-compose up -d
    cd ../jenkins
    docker-compose up -d
    cd ../hygieia
    docker-compose up -d


