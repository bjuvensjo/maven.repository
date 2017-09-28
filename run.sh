docker run -d -t -i -p 9090:8080 --rm --name maven.repository -v $(pwd)/repository_home:/var/repository_home bjuvensjo/maven.repository
