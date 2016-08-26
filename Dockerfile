FROM ubuntu:16.04
ENV RUNTIME_PACKAGES="ruby openssh-server"
ENV BUILD_PACKAGES="ruby-dev gcc libssl-dev build-essential"
ENV UTIL_PACKAGES="vim git"

#ADDED SSH SERVICE AS DESCRIBED HERE: https://docs.docker.com/engine/examples/running_ssh_service/

RUN apt-get -y update && apt-get install -y $RUNTIME_PACKAGES $BUILD_PACKAGES $UTIL_PACKAGES 
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN gem install dotenv ably eventmachine logger json
RUN useradd -ms /bin/bash dev 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

