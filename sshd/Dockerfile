FROM alpine:3.17

ARG USER=collector
ARG PASSWDAUTH=yes
ENV USER=$USER
ENV PASS=NO_PASS

RUN apk add --update --no-cache openssh

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf && \
    adduser -h /$USER -s /bin/sh -D $USER && \
    passwd -u $USER && \
    mkdir -p /$USER/.ssh && \
    chmod 0700 /$USER/.ssh && \
    ssh-keygen -A && \
    echo -e "PasswordAuthentication $PASSWDAUTH" >> /etc/ssh/sshd_config 

WORKDIR /$USER

EXPOSE 22

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
