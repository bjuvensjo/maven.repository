FROM maven:3.5-jdk-8-slim as maven

# Repository
COPY pom.xml /maven.repository/
COPY src /maven.repository/src/
WORKDIR /maven.repository
RUN mvn -P docker -Dmaven.repo.local=repo.local package

FROM jetty:9.4.7-jre8 as jetty
COPY --from=maven /maven.repository/target/*war $JETTY_BASE/webapps

# Repository home directory is a volume, so it can be persisted and survive image upgrades
ENV REPOSITORY_HOME /var/repository_home
VOLUME $REPOSITORY_HOME

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "cd $JETTY_BASE; java -DrootPath=$REPOSITORY_HOME -jar $JETTY_HOME/start.jar"]