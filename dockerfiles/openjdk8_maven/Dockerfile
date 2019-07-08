FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y \
  git \
  curl

ENV JAVA_HOME /usr/local/openjdk-8

# Set installed Maven version
ENV MAVEN_VERSION 3.6.1

# Download and install Maven
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV M2_HOME /usr/share/maven
CMD ["mvn"]