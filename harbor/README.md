# setup
1. Download harbor-offline-installer-*.tgz from harbor github
2. untar, update harbor.yml with harbor.yml.tmpl
3. Source install.sh
4. Login to harbor and change default passwd.
5. Create new project, usually with public access, so no need to provide credential.
6. #docker login IP
Note: Here better use IP instead of domain name like harbor.magedu.net.
Because if use domain name, then sometimes it can't pull via harbor.magedu.net, while login with IP is OK.
cat /root/.docker/config.json
Can use "echo $auth | base64 -d" to decode user name and passwd.

