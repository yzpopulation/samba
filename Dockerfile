FROM alpine
# alpine:3.12

ENV PATH="/container/scripts:${PATH}"

COPY . /container/

RUN apk add --no-cache runit \
                       bash \
                       avahi \
                       samba \
 \
 && touch /var/lib/samba/registry.tdb /var/lib/samba/account_policy.tdb \
 \
 && sed -i 's/#enable-dbus=.*/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
 && rm -vf /etc/avahi/services/* \
 \
 && mkdir -p /external/avahi \
 && touch /external/avahi/not-mounted \
 && chmod 777 -R /container

VOLUME ["/shares"]

EXPOSE 139 445

HEALTHCHECK CMD ["sh","/container/scripts/docker-healthcheck.sh"]
ENTRYPOINT ["sh","/container/scripts/entrypoint.sh"]

CMD [ "runsvdir","-P", "/container/config/runit" ]
