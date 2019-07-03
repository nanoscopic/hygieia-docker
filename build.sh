#!/bin/bash
export CWD=$(pwd)
if [ ! -d tmp ]; then
    mkdir tmp
fi

if [ ! -d github ]; then
    mkdir github
fi

hash apt-get
if [ $? -eq 0 ]; then
    # We are on a Debian like OS; we can install with apt-get
    hash curl
    if [ $? -eq 1 ]; then
        sudo apt-get install curl
    fi
    hash unzip
    if [ $? -eq 1 ]; then
        sudo apt-get install unzip
    fi
fi

if [ ! -d github/hygieia ]; then
    if [ ! -f tmp/hygieia-master.zip ]; then
        curl -L -o tmp/hygieia-master.zip "https://github.com/Hygieia/Hygieia/archive/master.zip"
    fi
    unzip tmp/hygieia-master.zip -d github/hygieia
fi

if [ ! -d github/hygieia-core ]; then
    if [ ! -f tmp/hygieia-core-master.zip ]; then
        curl -L -o tmp/hygieia-core-master.zip "https://github.com/Hygieia/hygieia-core/archive/master.zip"
    fi
    unzip tmp/hygieia-core-master.zip -d github/hygieia-core
fi

docker images livxtrm/openjdk8_maven | grep "livxtrm/openjdk8_maven" > /dev/null
if [ $? -eq 1 ]; then
    echo "Creating build image"
    docker build -t livxtrm/openjdk8_maven dockerfiles/openjdk8_maven
fi

if [ ! -d tmp/m2repo ]; then
    mkdir tmp/m2repo
fi

if [ ! -d built ]; then
    mkdir built
fi

ls github/hygieia-core/hygieia-core-master/target/core* > /dev/null
if [ $? -ne 0 ]; then
    echo "Building hygieia core"
    docker run -it -v "$CWD/github:/github" -v "$CWD/tmp/m2repo:/root/.m2/repository" -v "$CWD/build_scripts:/build" livxtrm/openjdk8_maven /bin/sh /build/build_core.sh
fi
    
ls github/hygieia/Hygieia-master/api/target/api* > /dev/null
if [ $? -ne 0 ]; then
    echo "Building hygieia"
    docker run -it -v "$CWD/github:/github" -v "$CWD/tmp/m2repo:/root/.m2/repository" -v "$CWD/build_scripts:/build" livxtrm/openjdk8_maven /bin/sh /build/build_hygieia.sh
fi
    
if [ ! -d built/db ]; then
    mkdir "built/db"
    cp github/hygieia/Hygieia-master/db/* "built/db"
fi

if [ -e github/hygieia/Hygieia-master/UI/target/UI* ]; then
    if [ ! -d built/ui ]; then
        mkdir "built/ui"
        mkdir "built/ui/docker"
        #mkdir "built/ui/target"
        mkdir "built/ui/dist"
        #cp github/hygieia/Hygieia-master/UI/target/UI* built/ui/target
        cp github/hygieia/Hygieia-master/UI/docker/conf-builder.sh built/ui/docker
        cp github/hygieia/Hygieia-master/UI/docker/default.conf built/ui/docker
        cp github/hygieia/Hygieia-master/UI/Dockerfile built/ui
        cp -R github/hygieia/Hygieia-master/UI/dist/* built/ui/dist
    fi
fi

function copybuilt {
    src=github/hygieia/Hygieia-master/$1
    name=$2
    dest=built/$3
    if [ -f $src/target/$name*.jar ]; then
        if [ ! -d $dest ]; then
            echo Copying built files for $3
            mkdir $dest
            mkdir $dest/docker
            mkdir $dest/target
            cp $src/target/$name*.jar $dest/target
            cp $src/docker/properties-builder.sh $dest/docker
            cp $src/Dockerfile $dest
        fi
    fi
}

copybuilt api api api
copybuilt api-audit apiaudit api-audit
copybuilt collectors/artifact/artifactory artifactory-artifact collector-artifactory-artifact
copybuilt collectors/scm/bitbucket bitbucket-scm collector-bitbucket-scm
copybuilt collectors/scm/github github-scm collector-github-scm
copybuilt collectors/scm/github-graphql github-graphql-scm collector-github-graphql-scm
copybuilt collectors/scm/gitlab gitlab-scm collector-gitlab-scm
copybuilt collectors/build/jenkins jenkins-build collector-jenkins-build
copybuilt collectors/build/jenkins-codequality jenkins-codequality collector-jenkins-codequality-build
copybuilt collectors/build/jenkins-cucumber jenkins-cucumber collector-jenkins-cucumber-build
copybuilt collectors/build/sonar sonar-codequality collector-sonar-codequality
copybuilt collectors/feature/gitlab gitlab-feature collector-gitlab-feature
copybuilt collectors/feature/jira jira-feature collector-jira-feature
