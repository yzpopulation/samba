FROM ubuntu:19.10
RUN sed -i '/deb-src/s/^# //' /etc/apt/sources.list
RUN apt-get update \
 && apt-get install -y wget \
 && apt remove samba \
 && apt autoremove 
# && apt install -y build-essential avahi-daemon tracker libtracker-sparql-1.0-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy install acl attr autoconf bind9utils bison build-essential \
  debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev krb5-user \
  libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
  libcap-dev libcups2-dev libgnutls28-dev libgpgme-dev libjson-perl \
  libldap2-dev libncurses5-dev libpam0g-dev libparse-yapp-perl \
  libpopt-dev libreadline-dev nettle-dev perl perl-modules pkg-config \
  python-all-dev python-crypto python-dbg python-dev python-dnspython \
  python3-dnspython python-gpg python3-gpg python-markdown python3-markdown \
  python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils
ENV SAMBA_VERSION=4.12.5
RUN mkdir ~/build \
 && cd ~/build \
 && wget --content-disposition https://github.com/samba-team/samba/archive/samba-$SAMBA_VERSION.tar.gz
RUN cd ~/build \
 && tar xvfz samba-samba-$SAMBA_VERSION.tar.gz
RUN cd ~/build/samba-samba-$SAMBA_VERSION \
 && DEB_HOST_MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH) \
 && ./configure \
    --prefix=/usr --exec-prefix=/usr --sysconfdir=/etc \
    --localstatedir=/var --libdir=/usr/lib/$DEB_HOST_MULTIARCH \
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
