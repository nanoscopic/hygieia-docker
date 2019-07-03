# hygieia-docker

## Building Hygieia in Windows

### Requirements

1. Install Docker for Windows
2. Docker engine version 17.09.0+ or greater is required
3. Run 'docker version' to see engine version

### Steps

1. Run the build.bat script
2. Wait a while

After doing the above steps, the needed output artifacts will be in the "built" directory

To create the docker images for each component:

    cd docker-compose\hygieia
    docker-compose build

## Building Hygieia on Linux
    
### Requirements

1. Install docker-compose
2. Docker engine version 17.09.0+ or greater is required
3. Run 'docker version' to see engine version

### Steps

1. Run the build.sh script
2. Wait a while

After doing the above steps, the needed output artifacts will be in the "built" directory

To create the docker images for each component:

    cd docker-compose\hygieia
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


