FROM fedora

RUN dnf -y update && dnf clean all
RUN dnf -y install git gzip java java-devel tar && dnf clean all

ENV JAVA_HOME /usr/lib/jvm/java-openjdk

# Set installed Maven version
ENV MAVEN_VERSION 3.6.1

# Download and install Maven
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV M2_HOME /usr/share/maven
CMD ["mvn"]