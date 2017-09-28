# maven.repository

A maven repository

* that supports namespacing artifacts, e.g. SNAPSHOTs, where a namespace typically is a branch name
* that supports configurable priority of namespaces

## Run ##

    docker run -d -t -i -p 9090:8080 --rm --name maven.repository -v $(pwd)/repository_home:/var/repository_home bjuvensjo/maven.repository

## Usage ##

Publish your maven artifacts to the repository_home directory in the following structure

    <namespace>/<standard maven repository structure>
    
For example

    develop/com/myorganisation/myartifact/1.0.0-SNAPSHOT
    feature/foo/com/myorganisation/myartifact/1.0.0-SNAPSHOT
    feature/bar/com/myorganisation/myartifact/1.0.0-SNAPSHOT
    
and configure your Maven settings.xml as in below examples.

### Example without priority ###

SNAPSHOT artifacts will be served from repository_home/develop.

    <repository>
        <id>snapshot</id>
        <url>http://localhost:9090/repository?refs=develop&amp;resource=</url>
        <layout>default</layout>
        <releases>
            <enabled>true</enabled>
            <updatePolicy>daily</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
        </releases>
        <snapshots>
            <enabled>true</enabled>
            <updatePolicy>always</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
        </snapshots>
    </repository>

### Example with priority ###

SNAPSHOT artifacts will be served from repository_home/feature/foo and only if not found there from repository_home/develop.

    <repository>
        <id>snapshot</id>
        <url>http://localhost:9090/repository?refs=feature/foo,develop&amp;resource=</url>
        <layout>default</layout>
        <releases>
            <enabled>true</enabled>
            <updatePolicy>daily</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
        </releases>
        <snapshots>
            <enabled>true</enabled>
            <updatePolicy>always</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
        </snapshots>
    </repository>
