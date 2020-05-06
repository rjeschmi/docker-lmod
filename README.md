
# Using the docker-compose here


You can use docker-compose to build a volume of the artifacts from the first container and then load that same volume in the other containers to test the same files elsewhere.

```
$ docker-compose run lmod-6
Creating volume "docker-lmod_software-vol" with default driver

[root@12f812e92fc0 Lmod-8.3.9]# cat /etc/redhat-release 
CentOS release 6.10 (Final)

$ docker-compose run lmod-6-in-7
[root@b7c375877162 /]# cat /etc/redhat-release 
CentOS Linux release 7.7.1908 (Core)

```
