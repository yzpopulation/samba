# Samba Version 4.11.2 with Time Machine capabilities
Based on ubuntu:18.10

Known restrictions:
- Currently no Spotlight support (since Ubuntu 18.10 comes with libtracker-sparql-2.0-dev which is not yet supported by Samba)

Build image: 
```bash
docker build . -t samba:4.11.2-ubuntu-18.10
```

Run container with Bash:
```bash
docker run -v /srv/Backups/backup:/srv/backup/timemachine -v /srv/samba/smb.conf:/etc/samba/smb.conf -v /srv/samba/private:/var/lib/samba/private -p137:137 -p138:138 -p139:139 -p445:445 -p5353:5353 samba:4.8.6-ubuntu-18.04
```

Run container:
```bash
docker run \
 -v /srv/Backups/backup:/srv/backup/timemachine \
 -v /srv:/srv/other \
 -v /srv/samba/smb.conf:/etc/samba/smb.conf \
 -v /srv/samba/private:/var/lib/samba/private \
 -v $(pwd)/passwd:/etc/passwd \
 -p137:137 -p138:138 -p139:139 -p445:445 -p5353:5353 \
 --name samba \
 -d \
 samba:4.11.2-ubuntu-18.10
 ```

Articles: 
- https://www.reddit.com/r/homelab/comments/83vkaz/howto_make_time_machine_backups_on_a_samba/
- https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
- https://kirb.me/2018/03/24/using-samba-as-a-time-machine-network-server.html
