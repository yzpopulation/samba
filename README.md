Samba version 4.8.4 with Time Machine capabilities
Based on ubuntu:18.04

Known restrictions:
- Currently no Spotlight support (since Ubuntu 18.04 comes with libtracker-sparql-2.0-dev which is not yet supported by Samba)

Run container with Bash:
docker run -v /srv/Backups/backup:/srv/backup/timemachine -v $(pwd)/smb.conf:/etc/samba/smb.conf -v $(pwd)/private:/var/lib/samba/private -p137:137 -p138:138 -$

Run container:
docker run \
 -v /srv/Backups/backup:/srv/backup/timemachine \
 -v $(pwd)/smb.conf:/etc/samba/smb.conf \
 -v $(pwd)/private:/var/lib/samba/private \
 -v $(pwd)/passwd:/etc/passwd \
 -p137:137 -p138:138 -p139:139 -p445:445 -p5353:5353 \
 --name samba \
 -d \
 samba

Q&A:
Q: Why use Samba 4.8.4 instead of the latest release?
A: There is a bug in Samba version 4.8.5 (which is the latest release as of this writing) that prevents consistent Time Machine backups. Details: https://www.s$

Articles: 
https://www.reddit.com/r/homelab/comments/83vkaz/howto_make_time_machine_backups_on_a_samba/
https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
https://kirb.me/2018/03/24/using-samba-as-a-time-machine-network-server.html
