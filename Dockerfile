FROM ubuntu:18.04
MAINTAINER Calin C., https://github.com/josebaez028
RUN apt-get update
#RUN apt-get install -y software-properties-common
#RUN apt-get install -y build-essential
#RUN apt-get install -y openssl libssl-dev libffi-dev
#RUN apt-get install -y net-tools mtr curl host socat
#RUN apt-get install -y iputils-arping iputils-ping iputils-tracepath
#RUN apt-get install -y iproute2
#RUN apt-get install -y iptraf-ng traceroute
#RUN apt-get install -y tcpdump
#RUN apt-get install -y iperf iperf3
#RUN apt-get install -y openssh-client telnet
#RUN apt-get install -y nano
#RUN apt-get install -y netcat
#RUN apt-get install -y socat
RUN apt-get install -y openssh-server
RUN apt-get install -y libpam-google-authenticator
RUN useradd -m -d /home/user1 -s /bin/bash user1
RUN echo 'user1:admin' | chpasswd
USER user1
RUN google-authenticator -t -d -f -r 3 -R 30 -W
RUN chmod 400 .google_authenticator

USER root
RUN echo '# Enable MFA using Google Authenticator PAM SSH Access\n\
auth required pam_google_authenticator.so nullok\n '\
>> /etc/pam.d/sshd

RUN echo '# Enable MFA using Google Authenticator PAM Local Console\n\
auth required pam_google_authenticator.so nullok\n '\
>> /etc/pam.d/login

RUN sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
RUN service ssh restart

RUN apt-get clean
VOLUME [ "/root" ]
WORKDIR [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
