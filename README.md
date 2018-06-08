

Project Title:
                             Multip App Container Image
Install and Configure Nginx as a Web Server and Reverse Proxy for Apache for Php applications using Dockerfile with Centos7 Base Image.
The setup is to have nginx out front serving static assets and then proxy to Apache/mod_php for PHP scripts. 
Apache and Nginx are two popular open source web servers often used with PHP. It can be useful to run both of them on the same virtual machine when hosting multiple websites which have varied requirements. The general solution for running two web servers on a single system is to either use multiple IP addresses or different port numbers.
The setup usually looks like this:
                  
 
Nginx listens on port 80 for all web traffic. If it gets a request for something that isn't static (like a .php file, or a RESTful URL pointing to a Ruby/Python/etc. app) it passes it along to Apache, which is listening on another port 8080(perhaps 8080 on the loopback interface).
Anything static (JS, CSS, HTML, image files, etc) nginx serves up on its own, never bothering Apache to spin up a process and do the job.
The only actual reason to use Apache to serve PHP (instead of Nginx and PHP-FPM) is if you're offering a shared-tenancy hosting service, where multiple independent customers are being served out of the same webserver host.  
The setup is to have nginx out front serving static assets and then proxy to Apache/mod_php for PHP scripts. 
If you want to use nginx and PHP then you have no choice but to use FastCGI as nginx doesnt have the equivalent of mod_php.
Why not just use nginx+FastCGI instead of nginx+apache+mod_php?
The LAMP stack (Linux, Apache, MySQL, and PHP) has been a complete web solution to developers for more than a decade.
Apache Drawbacks:
Apache falls short when it comes to serving plenty of static files. However, the latest version of Apache has resolved this issue considerably.  Moreover, Apache, having a process-based mechanism, is definitely a heavy memory web server.
Nginx Drawbacks:
Nginx can only be used with PHP-FPM, and that lacks support for .htaccess. This means a simple redirection can even be a technical issue. Moreover, while Nginx is undoubtedly fast in delivering static content, Apache still leads when it comes to PHP requests.
--------------------------------------------------------------------------------------------------------
Getting Started:
 Prerequisites: 
  Install Docker and Learn Docker Container Manipulation – Part 1
  https://www.tecmint.com/install-docker-and-learn-containers-in-centos-rhel-7-6/
  Deploy and Run Applications under Docker Containers – Part 2
  https://www.tecmint.com/install-run-and-delete-applications-inside-docker-containers/       

 Building a Docker Container(Image) :
Creating a Dockerfile to Automatically Build Nginx+Apache+mod_php Image.
Docker images can be automatically build form text files, named Dockerfiles. A   Docker file contains step-by-step ordered instructions or commands used to create and configure a Docker image.
A Docker file contains various instructions in order to build and configure a specific container based on your requirements. The following instructions are the most used, some of them being mandatory:
    FROM = Mandatory as first instruction in a Docker file. Instructs Docker to pull the base image from which you are building the new image. Use a tag to specify the exact image from which you are building:
Ex: FROM centos:7 ( https://hub.docker.com/_/centos/)
    MAINTAINER = Author of the build image
    RUN = This instruction can be used on multiple lines and runs any commands after Docker image has been created.
    CMD = Run any command when Docker image is started. Use only one CMD instruction in a Dockerfile.
    ENTRYPOINT = Same as CMD but used as the main command for the image.
    EXPOSE = Instructs the container to listen on network ports when running. The container ports are not reachable from the host by default.
    ENV = Set container environment variables.
    ADD = Copy resources (files, directories or files from URLs).
    COPY=The COPY instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.
Steps:
1. First, let’s create some kind of Dockerfile repositories in order to reuse files in future to create other images. Make an empty directory somewhere in /var partition where we will create the file with the instructions that will be used to build the newly Docker image.
 # mkdir -p /var/docker/centos/Dockerfiles
# touch /var/docker/centos/Dockerfiles/Dockerfile
2. Next, start editing the file with the following instructions:
      https://github.com/vemukku/CFR-Multi-Services-Dockerfile/blob/master/Dockerfile
3. Once created then we have to validate the Dockerfile 
https://www.fromlatest.io/#/
http://hadolint.lukasmartinelli.ch/
https://www.npmjs.com/package/validate-dockerfile

4. Build  Image using below command.
   Syntax: docker build [OPTIONS] PATH | URL | -
From text file:
# docker build -t centos7-multiapp  /var/docker/centos/Dockerfiles/Dockerfile
 If you are in same directory where Dockerfile exist then:
# docker build -t centos7-multiapp  Dockerfile
tag = centos7-multiapp  
From Git repositories:
# docker build -t centos7-multiapp  https://github.com/vemukku/CFR-Multi-Services-Dockerfile/blob/master/Dockerfile
  https://github.com/vemukku/CFR-Multi-Services-Dockerfile:Dockerfile
From Tar:
$ docker build http://server/context.tar.gz
$ docker build -f ctx/Dockerfile http://server/ctx.tar.gz
5. After the image has been created by Docker, you can list all available images and identify your image by issuing the following command:
# docker images
#docker ps
6. Run the Container :
Create a new container based on centos7-multiapp  . And before create new container, we can create new directory on the host machine.
mkdir -p /images
Now run the new container with command below:
$ docker run -d --name apachenginx  -v /vol1 -v /vol2  centos7-multiapp  
docker run -d -v /images:/var/www/nginx -p 80:80  -v /images:/var/www/apache  -p 8080:8080  --name  apachenginx centos7-multiapp  
$ docker run -t -i --mount type=bind,src=/data,dst=/data

$ docker run -d \
  -it \
  --name apachenginx \
  --mount type=bind,source="$(pwd)"/target,target=/app \
  --mount type=bind,source="$(pwd)"/target,target=/app2,readonly,bind-   propagation=rslave \
  nginx:latest

Now if you create /app/foo/, /app2/foo/ also exists.
Use $docker inspect apachenginx to verify that the bind mount was created correctly. Look for the Mounts section:
  Note:
    --name apachenginx centos7-multiapp  = We create a new container with the name 'centos7-multiapp  ', based on docker image 'centos7-multiapp' 
    -p 80:80 = apachenginx container running nginx on port 80 on the host machine.
 -p 8080:8080 = apachenginx container running apache on port 8080 on the host machine.
    -v /images:/var/www/nginx = /images directory on the host machine rewrite the /var/www/nginx directory on the container.
-v /images:/var/www/apache = /images directory on the host machine rewrite the /var/www/apache directory on the container.

Bind Volume:
 
--------------------------------------------------------------------------------------------------
    
