FROM openjdk:8-jdk

# update dpkg repositories
RUN apt-get update 

# install wget
RUN apt-get install -y wget

# Git
# RUN apt-get install -y git

# Maven
RUN wget --no-verbose -O /tmp/apache-maven-3.5.0.tar.gz http://apache.mirrors.spacedump.net/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
RUN echo "35c39251d2af99b6624d40d801f6ff02 /tmp/apache-maven-3.5.0.tar.gz" | md5sum -c
RUN tar xzf /tmp/apache-maven-3.5.0.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.0 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.0.tar.gz
ENV MAVEN_HOME /opt/maven

# Jetty
RUN wget --no-verbose -O /tmp/jetty-distribution-9.4.7.v20170914.tar.gz http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.7.v20170914/jetty-distribution-9.4.7.v20170914.tar.gz
RUN tar xzf /tmp/jetty-distribution-9.4.7.v20170914.tar.gz -C /opt/
RUN rm -f /tmp/jetty-distribution-9.4.7.v20170914.tar.gz
ENV JETTY_HOME /opt/jetty-distribution-9.4.7.v20170914

# Repository
COPY pom.xml /tmp/maven.repository/
COPY src /tmp/maven.repository/src/
# RUN cd /tmp/maven.repository
WORKDIR /tmp/maven.repository
RUN mvn -P docker package
RUN mv /tmp/maven.repository/target/maven.repository $JETTY_HOME/webapps/
RUN rm -rf /tmp/maven.repository

# Repository home directory is a volume, so it can be persisted and survive image upgrades
ENV REPOSITORY_HOME /var/repository_home
VOLUME $REPOSITORY_HOME

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "cd $JETTY_HOME; java -DrootPath=$REPOSITORY_HOME -DuseRootRelativePath=true -jar start.jar"]