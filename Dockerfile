FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get install acl attr autoconf bind9utils bison build-essential \
  debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev krb5-user \
  libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
  libcap-dev libcups2-dev libgnutls28-dev libgpgme-dev libjson-perl \
  libldap2-dev libncurses5-dev libpam0g-dev libparse-yapp-perl \
  libpopt-dev libreadline-dev nettle-dev perl perl-modules pkg-config \
  python-all-dev python-crypto python-dbg python-dev python-dnspython \
  python3-dnspython python-gpg python3-gpg python-markdown python3-markdown \
  python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils libkrb5-dev krb5-kdc wget tar -y

RUN wget https://download.samba.org/pub/samba/stable/samba-4.14.4.tar.gz -O samba.tar.gz \
&& tar xzf samba.tar.gz \
&& cd samba-4.14.4 \
&& ./configure \
--sbindir=/sbin/ \
--sysconfdir=/etc/samba/ \
--mandir=/usr/share/man/ \
&& make \
&& make install

COPY start.sh /usr/bin/
ENTRYPOINT ["/usr/bin/start.sh"]