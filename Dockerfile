FROM centos:8

COPY bootstrap.sh /bootstrap.sh
RUN sh /bootstrap.sh

ENV SAMBA_VERSION=4.13.0
RUN mkdir ~/build \
 && cd ~/build \
 && wget --content-disposition https://download.samba.org/pub/samba/stable/samba-$SAMBA_VERSION.tar.gz
RUN cd ~/build \
 && tar xvfz samba-$SAMBA_VERSION.tar.gz
RUN cd ~/build/samba-$SAMBA_VERSION \
 && ./configure \
    --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc \
    --localstatedir=/var \
    --with-privatedir=/var/lib/samba/private \
    --with-smbpasswd-file=/etc/samba/smbpasswd \
    --enable-fhs \
 && make -j$(nproc) \
 && make install 
#RUN systemctl daemon-reload \
# && systemctl enable {nmb,smb,winbind}.service \
# && systemctl start {nmb,smb,winbind}.service
COPY initunixusers /initunixusers
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["tail -F /var/log/samba/log*"]
# && DEB_HOST_MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH) \
# --libdir=/usr/lib/$DEB_HOST_MULTIARCH \
