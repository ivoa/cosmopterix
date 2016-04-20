This container is based on the [Fedora](../fedora/23) base container, and uses the OS package manager to install
version 1.8.0 of the [OpenJDK](http://openjdk.java.net/) OpenJDK Runtime Environment.

````

    docker run \
        --rm \
        --tty \
        --interactive \
        cosmopterix/java \
        java -version

            openjdk version "1.8.0_77"
            OpenJDK Runtime Environment (build 1.8.0_77-b03)
            OpenJDK 64-Bit Server VM (build 25.77-b03, mixed mode)

````

