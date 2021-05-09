FROM fedora:35

RUN dnf install -y samba

ADD createUsers.sh /etc/supervisor/createUsers.sh
ADD smb.conf /etc/samba/smb.conf
ADD smbd.service /etc/systemd/system/smbd.service

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
ADD systemd-tmpfiles-setup.override.conf /etc/systemd/system/systemd-tmpfiles-setup.service.d/override.conf
ADD create-users.service /etc/systemd/system/create-users.service
RUN systemctl enable smbd create-users

VOLUME [ "/sys/fs/cgroup" ]
RUN ["chmod","777","/srv"]
VOLUME ["/usr/local/samba/private/", "/srv"]
EXPOSE 445

CMD ["/usr/sbin/init"]
